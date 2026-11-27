package ddr3

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

/**
 * AXI4 Slave to DDR3 Controller Request/Response Bridge (Pipelined Burst Edition).
 * Supports full AXI4 bursts (len 0..255) for 32-bit, 64-bit, and 128-bit AXI data widths
 * against the native 128-bit (16-bit DQ x BL8) DDR3 controller interface,
 * using 16-entry low-latency LUTRAM FIFOs, a registered io.req output slice, and
 * registered AXI R/B outputs. Pure digital logic - 100% Verilator simulatable.
 */
class Ddr3Axi4Bridge(val axiConfig: Axi4Config, val config: Ddr3Config = Ddr3Config()) extends Component {
  val io = new Bundle {
    val axi       = slave(Axi4(axiConfig))
    val init_done = in Bool()

    val req       = master Stream(Ddr3Req(config))
    val rsp       = slave Flow(Ddr3Rsp())
  }

  val dataWidth = axiConfig.dataWidth
  require(
    dataWidth == 32 || dataWidth == 64 || dataWidth == 128,
    s"Ddr3Axi4Bridge only supports 32-bit, 64-bit, or 128-bit AXI4, got $dataWidth"
  )

  val beatsPerWord = 128 / dataWidth // 4 (32b), 2 (64b), 1 (128b)
  val phaseBits    = log2Up(beatsPerWord)
  val strbWidth    = dataWidth / 8
  val is128Bit     = (beatsPerWord == 1)

  private def subWordPhase(addr: UInt): UInt = addr(3 downto 4 - phaseBits)

  val fifoDepth = 16
  val chunkTrig = 8

  // Registered request slice (s2m then m2s) puts pure FFs directly at controller input
  val outReq = Stream(Ddr3Req(config))
  outReq.s2mPipe().m2sPipe() <> io.req

  // =========================================================================
  // Shared Read/Write Transaction Arbitration (mutually exclusive bursts)
  // =========================================================================
  object BridgeMode extends SpinalEnum {
    val IDLE, READ, WRITE = newElement()
  }
  val mode = RegInit(BridgeMode.IDLE)

  // =========================================================================
  // Read Channel: Command Streamer -> Read FIFO -> Registered AXI R Skid
  // =========================================================================
  val rFifo         = new DistLowLatencyFifo(Bits(128 bits), fifoDepth)
  val rReqAddr      = Reg(UInt(axiConfig.addressWidth bits)) init(0)
  val rIncr         = RegInit(True)
  val rCmdLeft      = Reg(UInt(9 bits)) init(0)
  val rSlotsUsed    = Reg(UInt(5 bits)) init(0) // rFifo.occupancy + in-flight RSPs + stage
  val rIssuingChunk = RegInit(False)

  val rId           = Reg(UInt(axiConfig.idWidth bits)) init(0)
  val rBeatsLeft    = Reg(UInt(9 bits)) init(0)
  val rPhase        = if (is128Bit) null else Reg(UInt(phaseBits bits)) init(0)

  val rValidReg     = RegInit(False)
  val rOutData      = Reg(Bits(dataWidth bits)) init(0)
  val rLastReg      = RegInit(False)

  // Read FIFO push from controller RSP (guaranteed never to overflow by rSlotsUsed < fifoDepth)
  rFifo.io.push.valid   := (mode === BridgeMode.READ) && io.rsp.valid
  rFifo.io.push.payload := io.rsp.rdata

  // Registered AXI R output stage fed by rFifo.io.pop
  val rConsume = !rValidReg || io.axi.r.ready
  rFifo.io.pop.ready := False

  when(io.axi.r.ready && rValidReg) {
    rValidReg := False
    rLastReg  := False
  }

  when(mode === BridgeMode.READ && rBeatsLeft =/= 0 && rConsume && rFifo.io.pop.valid) {
    val nextBeats = rBeatsLeft - 1
    rBeatsLeft := nextBeats
    rValidReg  := True
    rLastReg   := (nextBeats === 0)

    if (is128Bit) {
      rOutData           := rFifo.io.pop.payload
      rFifo.io.pop.ready := True
    } else {
      val slices = rFifo.io.pop.payload.subdivideIn(beatsPerWord slices)
      rOutData := slices(rPhase)
      when(nextBeats === 0 || rPhase === (beatsPerWord - 1)) {
        rFifo.io.pop.ready := True
        rPhase             := 0
      } otherwise {
        rPhase := rPhase + 1
      }
    }
  }

  // Read chunk emission with hysteresis
  when(mode === BridgeMode.READ) {
    when(!rIssuingChunk) {
      when(rCmdLeft =/= 0 && (rSlotsUsed <= (fifoDepth - chunkTrig) || rCmdLeft <= (U(fifoDepth, 5 bits) - rSlotsUsed).resized)) {
        rIssuingChunk := True
      }
    } otherwise {
      when(rCmdLeft === 0 || rSlotsUsed >= (fifoDepth - 1)) {
        rIssuingChunk := False
      }
    }
  } otherwise {
    rIssuingChunk := False
  }

  val rdReqValid = (mode === BridgeMode.READ) && rIssuingChunk && (rCmdLeft =/= 0) && (rSlotsUsed < fifoDepth)

  // =========================================================================
  // Write Channel: AXI W Packer -> Write FIFO -> Controller Req -> AXI B
  // =========================================================================
  case class WrWord() extends Bundle {
    val data = Bits(128 bits)
    val strb = Bits(16 bits)
  }
  val wFifo        = new DistLowLatencyFifo(WrWord(), fifoDepth)
  val wReqAddr     = Reg(UInt(axiConfig.addressWidth bits)) init(0)
  val wIncr        = RegInit(True)
  val wId          = Reg(UInt(axiConfig.idWidth bits)) init(0)
  val wAsmData     = Reg(Bits(128 bits)) init(0)
  val wAsmStrb     = Reg(Bits(16 bits)) init(0)
  val wPhase       = if (is128Bit) null else Reg(UInt(phaseBits bits)) init(0)
  val wLastSeen    = RegInit(False)
  val wBValidReg   = RegInit(False)
  val wDraining    = RegInit(False)
  val wPendingBlks = Reg(UInt(9 bits)) init(0)
  val wStartThresh = if (is128Bit) 3 else 12

  // Pack incoming AXI W beats into 128-bit WrWords and push into wFifo
  io.axi.w.ready := (mode === BridgeMode.WRITE) && !wLastSeen && wFifo.io.push.ready

  wFifo.io.push.valid        := False
  wFifo.io.push.payload.data := 0
  wFifo.io.push.payload.strb := 0

  when((mode === BridgeMode.WRITE) && !wLastSeen && io.axi.w.valid && wFifo.io.push.ready) {
    if (is128Bit) {
      wFifo.io.push.valid        := True
      wFifo.io.push.payload.data := io.axi.w.payload.data.resized
      wFifo.io.push.payload.strb := io.axi.w.payload.strb.resized
      when(io.axi.w.payload.last) {
        wLastSeen := True
      }
    } else {
      val flushWord = (wPhase === (beatsPerWord - 1)) || io.axi.w.payload.last
      when(flushWord) {
        wFifo.io.push.valid := True
        for (i <- 0 until beatsPerWord) {
          val inSlot = (wPhase === i)
          wFifo.io.push.payload.data(i * dataWidth + dataWidth - 1 downto i * dataWidth) :=
            inSlot ? io.axi.w.payload.data(dataWidth - 1 downto 0) | wAsmData(i * dataWidth + dataWidth - 1 downto i * dataWidth)
          wFifo.io.push.payload.strb(i * strbWidth + strbWidth - 1 downto i * strbWidth) :=
            inSlot ? io.axi.w.payload.strb(strbWidth - 1 downto 0) | wAsmStrb(i * strbWidth + strbWidth - 1 downto i * strbWidth)
        }
        wAsmData := 0
        wAsmStrb := 0
        wPhase   := 0
        when(io.axi.w.payload.last) {
          wLastSeen := True
        }
      } otherwise {
        for (i <- 0 until beatsPerWord) {
          when(wPhase === i) {
            wAsmData(i * dataWidth + dataWidth - 1 downto i * dataWidth) := io.axi.w.payload.data(dataWidth - 1 downto 0)
            wAsmStrb(i * strbWidth + strbWidth - 1 downto i * strbWidth) := io.axi.w.payload.strb(strbWidth - 1 downto 0)
          }
        }
        wPhase := wPhase + 1
      }
    }
  }

  // Start draining wFifo to DDR3 when >= wStartThresh blocks buffered OR WLAST already received
  when(mode === BridgeMode.WRITE && !wBValidReg) {
    when(!wDraining) {
      when(wFifo.io.pop.valid && (wLastSeen || wFifo.io.occupancy >= wStartThresh)) {
        wDraining := True
      }
    } otherwise {
      when(!wFifo.io.pop.valid) {
        wDraining := False
      }
    }
  } otherwise {
    wDraining := False
  }

  val wrReqValid = (mode === BridgeMode.WRITE) && wDraining && wFifo.io.pop.valid
  wFifo.io.pop.ready := (mode === BridgeMode.WRITE) && wDraining && outReq.ready

  // =========================================================================
  // Shared outReq Mux & AXI AR / AW / R / B Handshakes
  // =========================================================================
  outReq.valid := rdReqValid || wrReqValid
  outReq.write := (mode === BridgeMode.WRITE)
  outReq.addr  := ((mode === BridgeMode.WRITE) ? (wReqAddr >> 4) | (rReqAddr >> 4)).resized
  outReq.wdata := wFifo.io.pop.payload.data
  outReq.wstrb := wFifo.io.pop.payload.strb

  io.axi.ar.ready := (mode === BridgeMode.IDLE) && io.init_done && !io.axi.aw.valid
  io.axi.aw.ready := (mode === BridgeMode.IDLE) && io.init_done

  io.axi.r.valid        := rValidReg
  io.axi.r.payload.data := rOutData
  io.axi.r.payload.id   := rId
  io.axi.r.payload.resp := B"2'b00"
  io.axi.r.payload.last := rLastReg

  io.axi.b.valid        := wBValidReg
  io.axi.b.payload.id   := wId
  io.axi.b.payload.resp := B"2'b00"

  // Track rSlotsUsed and wPendingBlks accurately across concurrent push/pop
  val rdSlotInc = rdReqValid && outReq.ready
  val rdSlotDec = rFifo.io.pop.fire
  rSlotsUsed := rSlotsUsed + rdSlotInc.asUInt.resize(5) - rdSlotDec.asUInt.resize(5)

  val wBlkInc = wFifo.io.push.fire
  val wBlkDec = wrReqValid && outReq.ready
  wPendingBlks := wPendingBlks + wBlkInc.asUInt.resize(9) - wBlkDec.asUInt.resize(9)

  when(rdReqValid && outReq.ready) {
    rCmdLeft := rCmdLeft - 1
    when(rIncr) {
      rReqAddr := rReqAddr + 16
    }
  }

  when(wrReqValid && outReq.ready) {
    when(wIncr) {
      wReqAddr := wReqAddr + 16
    }
  }

  // Main Bridge Control
  switch(mode) {
    is(BridgeMode.IDLE) {
      when(io.axi.aw.valid && io.axi.aw.ready) {
        wReqAddr   := io.axi.aw.payload.addr
        wIncr      := (io.axi.aw.payload.burst =/= B"2'b00")
        wId        := io.axi.aw.payload.id
        if (!is128Bit) {
          wPhase   := subWordPhase(io.axi.aw.payload.addr)
        }
        wAsmData   := 0
        wAsmStrb   := 0
        wLastSeen  := False
        wBValidReg := False
        wDraining  := False
        mode       := BridgeMode.WRITE
      } elsewhen(io.axi.ar.valid && io.axi.ar.ready) {
        val totalBeats = io.axi.ar.payload.len.resize(9) + 1
        val totalBlocks = if (is128Bit) {
          totalBeats
        } else {
          val initPhase = subWordPhase(io.axi.ar.payload.addr)
          rPhase := initPhase
          ((initPhase.resize(9) + totalBeats + (beatsPerWord - 1)) >> phaseBits).resize(9)
        }
        rReqAddr      := io.axi.ar.payload.addr
        rIncr         := (io.axi.ar.payload.burst =/= B"2'b00")
        rId           := io.axi.ar.payload.id
        rBeatsLeft    := totalBeats
        rCmdLeft      := totalBlocks
        rIssuingChunk := False
        mode          := BridgeMode.READ
      }
    }

    is(BridgeMode.READ) {
      when(rBeatsLeft === 0 && !rValidReg && rCmdLeft === 0 && rSlotsUsed === 0) {
        mode := BridgeMode.IDLE
      }
    }

    is(BridgeMode.WRITE) {
      when(wLastSeen && (wPendingBlks === 0) && !wBValidReg) {
        wBValidReg := True
      }
      when(wBValidReg && io.axi.b.ready) {
        wBValidReg := False
        mode       := BridgeMode.IDLE
      }
    }
  }
}
