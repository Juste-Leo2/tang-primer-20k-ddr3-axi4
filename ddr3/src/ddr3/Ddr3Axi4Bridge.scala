package ddr3

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

/**
 * AXI4 Slave to DDR3 Controller Request/Response Bridge (Pipelined Burst Edition).
 * Supports full AXI4 bursts (len 0..255) for both 64-bit and 128-bit AXI data widths,
 * using 16-entry low-latency FIFOs, registered io.req output slice (.stage()) for timing
 * closure, and registered AXI R outputs.
 * Pure digital logic - 100% simulatable with Verilator.
 */
class Ddr3Axi4Bridge(val axiConfig: Axi4Config, val config: Ddr3Config = Ddr3Config()) extends Component {
  val io = new Bundle {
    val axi       = slave(Axi4(axiConfig))
    val init_done = in Bool()

    val req       = master Stream(Ddr3Req(config))
    val rsp       = slave Flow(Ddr3Rsp())
  }

  val is64Bit  = axiConfig.dataWidth == 64
  val is128Bit = axiConfig.dataWidth == 128
  require(is64Bit || is128Bit, s"Ddr3Axi4Bridge only supports 64-bit or 128-bit AXI4, got ${axiConfig.dataWidth}")

  val fifoDepth = 16
  val chunkTrig = 8

  // Registered request output slice decouples bridge FIFO/address paths from core row-hit comparator
  val outReq = Stream(Ddr3Req(config))
  outReq.stage() <> io.req

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
  val rFifo         = new StreamFifoLowLatency(Bits(128 bits), fifoDepth)
  val rReqAddr      = Reg(UInt(axiConfig.addressWidth bits)) init(0)
  val rIncr         = RegInit(True)
  val rCmdLeft      = Reg(UInt(9 bits)) init(0)
  val rSlotsUsed    = Reg(UInt(5 bits)) init(0) // rFifo.occupancy + in-flight RSPs + stage
  val rIssuingChunk = RegInit(False)

  val rId           = Reg(UInt(axiConfig.idWidth bits)) init(0)
  val rBeatsLeft    = Reg(UInt(9 bits)) init(0)
  val rPhase64      = RegInit(False)

  val rValidReg     = RegInit(False)
  val rOutData      = Reg(Bits(axiConfig.dataWidth bits)) init(0)
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
      when(!rPhase64) {
        rOutData := rFifo.io.pop.payload(63 downto 0)
        when(nextBeats === 0) {
          rFifo.io.pop.ready := True
          rPhase64           := False
        } otherwise {
          rPhase64 := True
        }
      } otherwise {
        rOutData           := rFifo.io.pop.payload(127 downto 64)
        rFifo.io.pop.ready := True
        rPhase64           := False
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
  val wFifo        = new StreamFifoLowLatency(WrWord(), fifoDepth)
  val wReqAddr     = Reg(UInt(axiConfig.addressWidth bits)) init(0)
  val wIncr        = RegInit(True)
  val wId          = Reg(UInt(axiConfig.idWidth bits)) init(0)
  val wAsmData     = Reg(Bits(128 bits)) init(0)
  val wAsmStrb     = Reg(Bits(16 bits)) init(0)
  val wPhase64     = RegInit(False)
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
      when(!wPhase64) {
        when(io.axi.w.payload.last) {
          wFifo.io.push.valid        := True
          wFifo.io.push.payload.data := B(0, 64 bits) ## io.axi.w.payload.data(63 downto 0)
          wFifo.io.push.payload.strb := B(0, 8 bits)  ## io.axi.w.payload.strb(7 downto 0)
          wLastSeen                  := True
        } otherwise {
          wAsmData(63 downto 0)   := io.axi.w.payload.data(63 downto 0)
          wAsmStrb(7 downto 0)   := io.axi.w.payload.strb(7 downto 0)
          wAsmData(127 downto 64) := 0
          wAsmStrb(15 downto 8)  := 0
          wPhase64                := True
        }
      } otherwise {
        wFifo.io.push.valid        := True
        wFifo.io.push.payload.data := io.axi.w.payload.data(63 downto 0) ## wAsmData(63 downto 0)
        wFifo.io.push.payload.strb := io.axi.w.payload.strb(7 downto 0)  ## wAsmStrb(7 downto 0)
        wPhase64                   := False
        when(io.axi.w.payload.last) {
          wLastSeen := True
        }
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
        wPhase64   := io.axi.aw.payload.addr(3) && Bool(is64Bit)
        wAsmData   := 0
        wAsmStrb   := 0
        wLastSeen  := False
        wBValidReg := False
        wDraining  := False
        mode       := BridgeMode.WRITE
      } elsewhen(io.axi.ar.valid && io.axi.ar.ready) {
        val totalBeats = (io.axi.ar.payload.len.resize(9) + 1)
        val totalBlocks = if (is128Bit) {
          totalBeats
        } else {
          ((io.axi.ar.payload.addr(3).asUInt.resize(9) + totalBeats + 1) >> 1).resize(9)
        }
        rReqAddr      := io.axi.ar.payload.addr
        rIncr         := (io.axi.ar.payload.burst =/= B"2'b00")
        rId           := io.axi.ar.payload.id
        rBeatsLeft    := totalBeats
        rCmdLeft      := totalBlocks
        rPhase64      := io.axi.ar.payload.addr(3) && Bool(is64Bit)
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
