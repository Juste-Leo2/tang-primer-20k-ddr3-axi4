package ddr3

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

/**
 * AXI4 Slave to DDR3 Controller Request/Response Bridge (Multi-Outstanding Burst Edition).
 * Supports up to 8 pending AXI4 AR/AW bursts (32-bit, 64-bit, or 128-bit AXI data widths)
 * against the native 128-bit (16-bit DQ x BL8) DDR3 controller interface.
 *
 * Architecture:
 *  - Unified chronological cmdQueue (depth 8) preserves strict global AXI4 ordering (RAW/WAR/WAW safe).
 *  - Decoupled W Packer accepts pipelined AXI W beats into 16-entry LUTRAM wFifo ahead of execution.
 *  - Controller Sequencer drains consecutive cmdQueue entries back-to-back into outReq.s2mPipe().m2sPipe(),
 *    keeping the DDR3 Open-Page row active across queued same-row bursts.
 *  - Unconditional rsp -> rFifo (depth 16) + rRespQueue (depth 8) -> registered AXI R skid stage,
 *    allowing read responses to drain concurrently while subsequent writes or reads execute.
 *  - Pure digital LUTRAM + FF logic, 100% Verilator simulatable, Fmax >= 75.94 MHz on Gowin GW2A-18.
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

  val beatsPerWord   = 128 / dataWidth // 4 (32b), 2 (64b), 1 (128b)
  val phaseBits      = log2Up(beatsPerWord)
  val strbWidth      = dataWidth / 8
  val is128Bit       = (beatsPerWord == 1)
  val maxOutstanding = 8

  private def subWordPhase(addr: UInt): UInt = addr(3 downto 4 - phaseBits)

  val fifoDepth = 16
  val chunkTrig = 8

  // Registered request slice (s2m then m2s) puts pure FFs directly at controller input
  val outReq = Stream(Ddr3Req(config))
  outReq.s2mPipe().m2sPipe() <> io.req

  // =========================================================================
  // 1. Unified Chronological Command Queue (AW + AR, depth = 8)
  // =========================================================================
  case class CmdEntry() extends Bundle {
    val isWrite     = Bool()
    val addr        = UInt(axiConfig.addressWidth bits)
    val totalBlocks = UInt(9 bits)
    val incr        = Bool()
  }
  val cmdQueue = new DistLowLatencyFifo(CmdEntry(), maxOutstanding)

  // Metadata FIFOs decoupled from command execution
  case class RRespEntry() extends Bundle {
    val totalBeats = UInt(9 bits)
    val initPhase  = (!is128Bit) generate UInt(phaseBits bits)
    val id         = UInt(axiConfig.idWidth bits)
  }
  val rRespQueue = new DistLowLatencyFifo(RRespEntry(), maxOutstanding)
  val bIdQueue   = new DistLowLatencyFifo(UInt(axiConfig.idWidth bits), maxOutstanding)

  // =========================================================================
  // 2. Read Response Pipeline: Controller rsp -> rFifo -> Registered AXI R
  // =========================================================================
  val rFifo      = new DistLowLatencyFifo(Bits(128 bits), fifoDepth)
  val rSlotsUsed = Reg(UInt(5 bits)) init(0) // rFifo.occupancy + in-flight RSPs + stage

  val rActive    = RegInit(False)
  val rId        = Reg(UInt(axiConfig.idWidth bits)) init(0)
  val rBeatsLeft = Reg(UInt(9 bits)) init(0)
  val rPhase     = if (is128Bit) null else Reg(UInt(phaseBits bits)) init(0)

  val rValidReg  = RegInit(False)
  val rOutData   = Reg(Bits(dataWidth bits)) init(0)
  val rOutId     = Reg(UInt(axiConfig.idWidth bits)) init(0)
  val rLastReg   = RegInit(False)

  // Unconditional push from controller RSP: subsequent WR bursts may already run while RSPs return
  rFifo.io.push.valid   := io.rsp.valid
  rFifo.io.push.payload := io.rsp.rdata

  val rConsume = !rValidReg || io.axi.r.ready
  rFifo.io.pop.ready      := False
  rRespQueue.io.pop.ready := False

  when(io.axi.r.ready && rValidReg) {
    rValidReg := False
    rLastReg  := False
  }

  when(rActive) {
    when(rBeatsLeft =/= 0 && rConsume && rFifo.io.pop.valid) {
      val nextBeats = rBeatsLeft - 1
      rValidReg := True
      rOutId    := rId
      rLastReg  := (nextBeats === 0)

      if (is128Bit) {
        rOutData           := rFifo.io.pop.payload
        rFifo.io.pop.ready := True
      } else {
        val slices = rFifo.io.pop.payload.subdivideIn(beatsPerWord slices)
        rOutData := slices(rPhase)
        when(nextBeats === 0 || rPhase === (beatsPerWord - 1)) {
          rFifo.io.pop.ready := True
        }
      }

      when(nextBeats === 0) {
        // Immediately chain next queued read burst with zero bubble if already present
        when(rRespQueue.io.pop.valid) {
          rRespQueue.io.pop.ready := True
          rBeatsLeft := rRespQueue.io.pop.payload.totalBeats
          rId        := rRespQueue.io.pop.payload.id
          if (!is128Bit) {
            rPhase := rRespQueue.io.pop.payload.initPhase
          }
          rActive := True
        } otherwise {
          rBeatsLeft := 0
          if (!is128Bit) {
            rPhase := 0
          }
          rActive := False
        }
      } otherwise {
        rBeatsLeft := nextBeats
        if (!is128Bit) {
          rPhase := (rPhase === (beatsPerWord - 1)) ? U(0, phaseBits bits) | (rPhase + 1)
        }
      }
    }
  } elsewhen(rRespQueue.io.pop.valid) {
    rRespQueue.io.pop.ready := True
    rBeatsLeft := rRespQueue.io.pop.payload.totalBeats
    rId        := rRespQueue.io.pop.payload.id
    if (!is128Bit) {
      rPhase := rRespQueue.io.pop.payload.initPhase
    }
    rActive := True
  }

  // =========================================================================
  // 3. Decoupled AXI W Packer -> 16-entry LUTRAM wFifo
  // =========================================================================
  case class WrWord() extends Bundle {
    val data        = Bits(128 bits)
    val strb        = Bits(16 bits)
    val lastOfBurst = Bool()
  }
  val wFifo            = new DistLowLatencyFifo(WrWord(), fifoDepth)
  val wCompletedBursts = Reg(UInt(5 bits)) init(0)
  val wStartThresh     = if (is128Bit) 3 else 12

  val wPackQueue = if (is128Bit) null else new DistLowLatencyFifo(UInt(phaseBits bits), maxOutstanding)
  val wPackCredits = if (is128Bit) Reg(UInt(4 bits)) init(0) else null
  val wPackActive  = if (is128Bit) null else RegInit(False)
  val wAsmData     = if (is128Bit) null else Reg(Bits(128 bits)) init(0)
  val wAsmStrb     = if (is128Bit) null else Reg(Bits(16 bits)) init(0)
  val wPhase       = if (is128Bit) null else Reg(UInt(phaseBits bits)) init(0)

  if (is128Bit) {
    io.axi.w.ready                    := (wPackCredits =/= 0) && wFifo.io.push.ready
    wFifo.io.push.valid               := (wPackCredits =/= 0) && io.axi.w.valid
    wFifo.io.push.payload.data        := io.axi.w.payload.data.resized
    wFifo.io.push.payload.strb        := io.axi.w.payload.strb.resized
    wFifo.io.push.payload.lastOfBurst := io.axi.w.payload.last
  } else {
    wPackQueue.io.push.valid   := False
    wPackQueue.io.push.payload := 0
    wPackQueue.io.pop.ready    := False

    io.axi.w.ready := wPackActive && wFifo.io.push.ready

    val wFlushWord = (wPhase === (beatsPerWord - 1)) || io.axi.w.payload.last
    wFifo.io.push.valid               := wPackActive && io.axi.w.valid && wFlushWord
    wFifo.io.push.payload.lastOfBurst := io.axi.w.payload.last
    for (i <- 0 until beatsPerWord) {
      val inSlot = (wPhase === i)
      wFifo.io.push.payload.data(i * dataWidth + dataWidth - 1 downto i * dataWidth) :=
        inSlot ? io.axi.w.payload.data(dataWidth - 1 downto 0) | wAsmData(i * dataWidth + dataWidth - 1 downto i * dataWidth)
      wFifo.io.push.payload.strb(i * strbWidth + strbWidth - 1 downto i * strbWidth) :=
        inSlot ? io.axi.w.payload.strb(strbWidth - 1 downto 0) | wAsmStrb(i * strbWidth + strbWidth - 1 downto i * strbWidth)
    }

    when(wPackActive) {
      when(io.axi.w.fire) {
        when(wFlushWord) {
          wAsmData := 0
          wAsmStrb := 0
          when(io.axi.w.payload.last) {
            when(wPackQueue.io.pop.valid) {
              wPackQueue.io.pop.ready := True
              wPhase                  := wPackQueue.io.pop.payload
              wPackActive             := True
            } otherwise {
              wPhase      := 0
              wPackActive := False
            }
          } otherwise {
            wPhase := 0
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
    } elsewhen(wPackQueue.io.pop.valid) {
      wPackQueue.io.pop.ready := True
      wPhase                  := wPackQueue.io.pop.payload
      wAsmData                := 0
      wAsmStrb                := 0
      wPackActive             := True
    }
  }

  // =========================================================================
  // 4. Sequencer: cmdQueue Head -> DDR3 outReq + AXI B Completion Tracking
  // =========================================================================
  val seqLoaded     = RegInit(False)
  val seqWrite      = RegInit(False)
  val seqAddr       = Reg(UInt(axiConfig.addressWidth bits)) init(0)
  val seqBlocksLeft = Reg(UInt(9 bits)) init(0)
  val seqIncr       = RegInit(True)
  val rIssuingChunk = RegInit(False)
  val wDraining     = RegInit(False)

  val rdReqValid = seqLoaded && !seqWrite && rIssuingChunk && (seqBlocksLeft =/= 0) && (rSlotsUsed < fifoDepth)
  val wrReqValid = seqLoaded &&  seqWrite && wDraining     && wFifo.io.pop.valid
  val rdReqFire  = rdReqValid && outReq.ready
  val wrReqFire  = wrReqValid && outReq.ready

  wFifo.io.pop.ready    := seqLoaded && seqWrite && wDraining && outReq.ready
  cmdQueue.io.pop.ready := False

  // Track slots and completed write bursts in wFifo
  val rdSlotInc = rdReqFire
  val rdSlotDec = rFifo.io.pop.fire
  rSlotsUsed := rSlotsUsed + rdSlotInc.asUInt.resize(5) - rdSlotDec.asUInt.resize(5)

  val wBurstDonePush = wFifo.io.push.fire && wFifo.io.push.payload.lastOfBurst
  val wBurstDonePop  = wrReqFire && wFifo.io.pop.payload.lastOfBurst
  wCompletedBursts := wCompletedBursts + wBurstDonePush.asUInt.resize(5) - wBurstDonePop.asUInt.resize(5)

  // Read hysteresis control when executing a READ burst
  when(seqLoaded && !seqWrite) {
    when(!rIssuingChunk) {
      when(seqBlocksLeft =/= 0 && (rSlotsUsed <= (fifoDepth - chunkTrig) || seqBlocksLeft <= (U(fifoDepth, 5 bits) - rSlotsUsed).resized)) {
        rIssuingChunk := True
      }
    } elsewhen((rSlotsUsed >= fifoDepth) || (rSlotsUsed === (fifoDepth - 1) && rdReqFire)) {
      rIssuingChunk := False
    }
  } otherwise {
    rIssuingChunk := False
  }

  // Write drain start control when executing a WRITE burst
  when(seqLoaded && seqWrite) {
    when(!wDraining) {
      when(wFifo.io.pop.valid && (wCompletedBursts =/= 0 || wFifo.io.occupancy >= wStartThresh)) {
        wDraining := True
      }
    } elsewhen(!wFifo.io.pop.valid) {
      wDraining := False
    }
  } otherwise {
    wDraining := False
  }

  private def loadNextCmdFromQueue(): Unit = {
    when(cmdQueue.io.pop.valid) {
      val nxt = cmdQueue.io.pop.payload
      cmdQueue.io.pop.ready := True
      seqWrite              := nxt.isWrite
      seqAddr               := nxt.addr
      seqBlocksLeft         := nxt.totalBlocks
      seqIncr               := nxt.incr
      seqLoaded             := True
      wDraining             := False
      when(!nxt.isWrite &&
           (rSlotsUsed <= (fifoDepth - chunkTrig) ||
            nxt.totalBlocks <= (U(fifoDepth - 1, 5 bits) - rSlotsUsed).resized)) {
        rIssuingChunk := True
      } otherwise {
        rIssuingChunk := False
      }
    } otherwise {
      seqLoaded     := False
      rIssuingChunk := False
      wDraining     := False
    }
  }

  when(!seqLoaded) {
    when(cmdQueue.io.pop.valid) {
      val nxt = cmdQueue.io.pop.payload
      cmdQueue.io.pop.ready := True
      seqWrite              := nxt.isWrite
      seqAddr               := nxt.addr
      seqBlocksLeft         := nxt.totalBlocks
      seqIncr               := nxt.incr
      seqLoaded             := True
      wDraining             := False
      when(!nxt.isWrite &&
           (rSlotsUsed <= (fifoDepth - chunkTrig) ||
            nxt.totalBlocks <= (U(fifoDepth, 5 bits) - rSlotsUsed).resized)) {
        rIssuingChunk := True
      } otherwise {
        rIssuingChunk := False
      }
    }
  } elsewhen(!seqWrite) {
    when(rdReqFire) {
      val nextBlocks = seqBlocksLeft - 1
      when(seqIncr) {
        seqAddr := seqAddr + 16
      }
      when(nextBlocks === 0) {
        loadNextCmdFromQueue()
      } otherwise {
        seqBlocksLeft := nextBlocks
      }
    }
  } otherwise {
    when(wrReqFire) {
      when(seqIncr) {
        seqAddr := seqAddr + 16
      }
      when(wFifo.io.pop.payload.lastOfBurst) {
        loadNextCmdFromQueue()
      }
    }
  }

  // =========================================================================
  // 5. AXI AR / AW Acceptance & Registered AXI R / B Responses
  // =========================================================================
  val canAcceptCmd = io.init_done && cmdQueue.io.push.ready
  val canAcceptWr  = canAcceptCmd && bIdQueue.io.push.ready && (if (is128Bit) True else wPackQueue.io.push.ready)
  val canAcceptRd  = canAcceptCmd && rRespQueue.io.push.ready

  io.axi.aw.ready := canAcceptWr
  io.axi.ar.ready := canAcceptRd && !(io.axi.aw.valid && canAcceptWr)

  cmdQueue.io.push.valid               := False
  cmdQueue.io.push.payload.isWrite     := False
  cmdQueue.io.push.payload.addr        := 0
  cmdQueue.io.push.payload.totalBlocks := 0
  cmdQueue.io.push.payload.incr        := True

  rRespQueue.io.push.valid              := False
  rRespQueue.io.push.payload.totalBeats := 0
  rRespQueue.io.push.payload.id         := 0
  if (!is128Bit) {
    rRespQueue.io.push.payload.initPhase := 0
  }

  bIdQueue.io.push.valid   := False
  bIdQueue.io.push.payload := 0

  val awFire = io.axi.aw.fire
  val arFire = io.axi.ar.fire

  when(awFire) {
    cmdQueue.io.push.valid               := True
    cmdQueue.io.push.payload.isWrite     := True
    cmdQueue.io.push.payload.addr        := io.axi.aw.payload.addr
    cmdQueue.io.push.payload.totalBlocks := 0
    cmdQueue.io.push.payload.incr        := (io.axi.aw.payload.burst =/= B"2'b00")

    bIdQueue.io.push.valid   := True
    bIdQueue.io.push.payload := io.axi.aw.payload.id

    if (!is128Bit) {
      val initWPhase = subWordPhase(io.axi.aw.payload.addr)
      when(!wPackActive && !wPackQueue.io.pop.valid) {
        wPackActive := True
        wPhase      := initWPhase
        wAsmData    := 0
        wAsmStrb    := 0
      } otherwise {
        wPackQueue.io.push.valid   := True
        wPackQueue.io.push.payload := initWPhase
      }
    }
  } elsewhen(arFire) {
    val totalBeats = io.axi.ar.payload.len.resize(9) + 1
    val totalBlocks = if (is128Bit) {
      totalBeats
    } else {
      val initPhase = subWordPhase(io.axi.ar.payload.addr)
      ((initPhase.resize(9) + totalBeats + (beatsPerWord - 1)) >> phaseBits).resize(9)
    }

    cmdQueue.io.push.valid               := True
    cmdQueue.io.push.payload.isWrite     := False
    cmdQueue.io.push.payload.addr        := io.axi.ar.payload.addr
    cmdQueue.io.push.payload.totalBlocks := totalBlocks
    cmdQueue.io.push.payload.incr        := (io.axi.ar.payload.burst =/= B"2'b00")

    rRespQueue.io.push.valid              := True
    rRespQueue.io.push.payload.totalBeats := totalBeats
    rRespQueue.io.push.payload.id         := io.axi.ar.payload.id
    if (!is128Bit) {
      rRespQueue.io.push.payload.initPhase := subWordPhase(io.axi.ar.payload.addr)
    }
  }

  if (is128Bit) {
    val wLastFire = io.axi.w.fire && io.axi.w.payload.last
    wPackCredits := wPackCredits + awFire.asUInt.resize(4) - wLastFire.asUInt.resize(4)
  }

  // Registered AXI B Output Stage
  val bDoneCount = Reg(UInt(4 bits)) init(0)
  val bValidReg  = RegInit(False)
  val bIdReg     = Reg(UInt(axiConfig.idWidth bits)) init(0)
  val bConsume   = !bValidReg || io.axi.b.ready
  val bIssue     = bConsume && (bDoneCount =/= 0) && bIdQueue.io.pop.valid

  bIdQueue.io.pop.ready := bIssue
  when(io.axi.b.ready && bValidReg) {
    bValidReg := False
  }
  when(bIssue) {
    bValidReg := True
    bIdReg    := bIdQueue.io.pop.payload
  }
  bDoneCount := bDoneCount + wBurstDonePop.asUInt.resize(4) - bIssue.asUInt.resize(4)

  // Shared outReq Mux & AXI R/B Wires
  outReq.valid := rdReqValid || wrReqValid
  outReq.write := seqWrite
  outReq.addr  := (seqAddr >> 4).resized
  outReq.wdata := wFifo.io.pop.payload.data
  outReq.wstrb := wFifo.io.pop.payload.strb

  io.axi.r.valid        := rValidReg
  io.axi.r.payload.data := rOutData
  io.axi.r.payload.id   := rOutId
  io.axi.r.payload.resp := B"2'b00"
  io.axi.r.payload.last := rLastReg

  io.axi.b.valid        := bValidReg
  io.axi.b.payload.id   := bIdReg
  io.axi.b.payload.resp := B"2'b00"
}
