package ddr3

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import spinal.lib.fsm._

/**
 * Autonomous DDR3 Memtest Engine & UART Reporter.
 * Supports 32-bit, 64-bit, and 128-bit AXI4 data widths:
 * - Single-block (128-bit) sanity check
 * - Bulk multi-beat AXI4 burst-write and burst-read with pattern verification
 * - Formatted status & error reporting to UART TX (115200 baud)
 * - LED status and heartbeat generation
 */
class Ddr3MemtestEngine(
  val axiConfig: Axi4Config,
  val testBursts: Int = 1024,
  val clkFreqHz: Int = 75937500,
  val baudRate: Int = 115200
) extends Component {
  val io = new Bundle {
    // AXI4 Master port connected to DDR3 AXI slave
    val axi = master(Axi4(axiConfig))

    // Hardware status signals from DDR3 controller
    val pll_lock         = in Bool()
    val init_done        = in Bool()
    val write_level_done = in Bool()
    val read_calib_done  = in Bool()
    val wstep            = in Bits(8 bits)
    val rclkpos          = in Bits(2 bits)
    val rclksel          = in Bits(3 bits)
    val best_rot         = in UInt(3 bits)
    val best_score       = in UInt(4 bits)
    val dbg_state        = in Bits(4 bits)

    // User outputs
    val uart_tx          = out Bool()
    val test_busy        = out Bool()
    val test_pass        = out Bool()
    val test_error       = out Bool()
    val heartbeat        = out Bool()
  }

  // --- 1. UART TX & Character Streaming ---
  val uart = new UartTx(clkFreqHz, baudRate)
  io.uart_tx := uart.io.txd

  val txStream = Stream(Bits(8 bits))
  uart.io.write << txStream

  // Helper to convert 4-bit nibble to ASCII (pure 16-entry LUT ROM, no comparator/adder chain)
  val hexAsciiRom = Vec("0123456789ABCDEF".map(c => B(c.toInt, 8 bits)))
  def nibbleToAscii(n: Bits): Bits = hexAsciiRom(n.resize(4).asUInt)

  // UART print queue / character generator (2-stage to keep printChar/CE and hex decode short)
  val nextPrintValid = Bool()
  val nextPrintChar  = Bits(8 bits)
  val nextUseNib     = Bool()
  val nextPrintNib   = Bits(4 bits)
  nextPrintValid := False
  nextPrintChar  := 0
  nextUseNib     := False
  nextPrintNib   := 0

  val stageValid  = RegNext(nextPrintValid) init(False)
  val stageChar   = RegNext(nextPrintChar) init(0)
  val stageUseNib = RegNext(nextUseNib) init(False)
  val stageNib    = RegNext(nextPrintNib) init(0)

  val printValid = RegInit(False)
  val printChar  = Reg(Bits(8 bits)) init(0)

  txStream.valid   := printValid
  txStream.payload := printChar

  when(txStream.fire) {
    printValid := False
  }
  when(stageValid) {
    printChar  := stageUseNib ? nibbleToAscii(stageNib) | stageChar
    printValid := True
  }
  val canPrint = !printValid && !stageValid

  // --- 2. Test Control Registers ---
  val passCount     = Reg(UInt(16 bits)) init(0)
  val errorReg      = RegInit(False)
  val passReg       = RegInit(False)
  val errAddr       = Reg(UInt(32 bits)) init(0)
  val errExpected   = Reg(Bits(64 bits)) init(0)
  val errActual     = Reg(Bits(64 bits)) init(0)
  val errActual1    = Reg(Bits(64 bits)) init(0) // 2nd 64-bit half (128b mode or 2nd single beat)

  io.test_error := errorReg
  io.test_pass  := passReg

  // Heartbeat counter (~2 Hz toggle at 75.94 MHz)
  val hbCounter = Reg(UInt(25 bits)) init(0)
  val hbReg     = RegInit(False)
  hbCounter := hbCounter + 1
  when(hbCounter === 0) {
    hbReg := !hbReg
  }
  io.heartbeat := hbReg

  val dataWidth = axiConfig.dataWidth
  require(dataWidth == 32 || dataWidth == 64 || dataWidth == 128, s"Unsupported AXI dataWidth: $dataWidth")
  val beatsPerBlock     = 128 / dataWidth // 4 (32b), 2 (64b), 1 (128b)
  val beatShift         = log2Up(beatsPerBlock)
  val bytesPerBeatShift = log2Up(dataWidth / 8)
  val is128Bit          = (beatsPerBlock == 1)

  // Default AXI Master outputs
  io.axi.aw.valid  := False
  io.axi.aw.addr   := 0
  io.axi.aw.len    := beatsPerBlock - 1 // 1 DDR3 128-bit block
  io.axi.aw.size   := bytesPerBeatShift
  io.axi.aw.burst  := 1 // INCR
  io.axi.aw.id     := 0
  io.axi.aw.region := 0
  io.axi.aw.lock   := 0
  io.axi.aw.cache  := 0
  io.axi.aw.qos    := 0
  io.axi.aw.prot   := 0

  val fullStrb    = B(axiConfig.bytePerWord bits, default -> True)
  io.axi.w.valid  := False
  io.axi.w.data   := 0
  io.axi.w.strb   := fullStrb
  io.axi.w.last   := False

  io.axi.b.ready  := True

  io.axi.ar.valid  := False
  io.axi.ar.addr   := 0
  io.axi.ar.len    := beatsPerBlock - 1
  io.axi.ar.size   := bytesPerBeatShift
  io.axi.ar.burst  := 1 // INCR
  io.axi.ar.id     := 0
  io.axi.ar.region := 0
  io.axi.ar.lock   := 0
  io.axi.ar.cache  := 0
  io.axi.ar.qos    := 0
  io.axi.ar.prot   := 0

  io.axi.r.ready  := False

  // Address and test pattern generators (max 64 blocks * 4 beats = 256 beats -> AWLEN=255 fits AXI4)
  val axiBurstBlocks = if (testBursts >= 64) 64 else testBursts
  val beatsPerBurst  = axiBurstBlocks * beatsPerBlock
  require(testBursts >= 1 && (testBursts % axiBurstBlocks) == 0, s"testBursts ($testBursts) must be a multiple of axiBurstBlocks ($axiBurstBlocks)")

  val burstIndex = Reg(UInt(log2Up(testBursts + 1) bits)) init(0)
  val beatIdx    = Reg(UInt(log2Up(beatsPerBurst + 1) bits)) init(0)
  val singleIdx  = Reg(UInt(Math.max(1, beatShift) bits)) init(0)
  val wrCycleCnt = Reg(UInt(32 bits)) init(0)
  val rdCycleCnt = Reg(UInt(32 bits)) init(0)
  val currentByteAddr = (burstIndex << 4).resize(32) // 16 bytes per block
  val beatBlockAddr   = currentByteAddr + ((beatIdx >> beatShift) << 4).resize(32)

  def makePattern0(addr: UInt): Bits = (addr.asBits ^ B(0x5AA55AA5, 32 bits)) ## (addr + 1).asBits
  def makePattern1(addr: UInt): Bits = (addr.asBits ^ B(0x12345678, 32 bits)) ## (addr + 2).asBits

  private def sliceWord(word128: Bits, idx: UInt): Bits =
    if (is128Bit) word128 else word128.subdivideIn(beatsPerBlock slices)(idx.resize(beatShift))

  private val singlePatBig = BigInt("FEDCBA98765432100123456789ABCDEF", 16)
  private val patchDataBig = BigInt("DEADBEEFCAFEBABE", 16)
  private val patchMaskInt = 0xA6 // tests DM[0]=1,DM[1]=0 on halfword 0 and DM[0]=0,DM[1]=1 on halfword 1
  private val patchedPatBig: BigInt = {
    val beatBytes = dataWidth / 8
    (0 until 16).foldLeft(BigInt(0)) { (acc, b) =>
      val origByte = (singlePatBig >> (b * 8)) & 0xFF
      val outByte =
        if (b >= 8 && (b - 8) < beatBytes && ((patchMaskInt >> (b - 8)) & 1) == 1) {
          (patchDataBig >> ((b - 8) * 8)) & 0xFF
        } else {
          origByte
        }
      acc | (outByte << (b * 8))
    }
  }
  val singlePat128  = B(singlePatBig, 128 bits)
  val patchedPat128 = B(patchedPatBig, 128 bits)
  val patchBeatData = B(patchDataBig, 64 bits).resize(dataWidth)
  val patchBeatStrb = B(patchMaskInt, 8 bits).resize(axiConfig.bytePerWord)

  // --- 3. Main Memtest FSM ---
  val passPrefix = Vec(
    B(0x5B, 8 bits), B(0x50, 8 bits), B(0x41, 8 bits), B(0x53, 8 bits),
    B(0x53, 8 bits), B(0x5D, 8 bits), B(0x20, 8 bits)
  ) // "[PASS] "
  val failPrefix = Vec(
    B(0x5B, 8 bits), B(0x46, 8 bits), B(0x41, 8 bits), B(0x49, 8 bits),
    B(0x4C, 8 bits), B(0x5D, 8 bits), B(0x20, 8 bits), B(0x41, 8 bits),
    B(0x3D, 8 bits)
  ) // "[FAIL] A="

  val fsm = new StateMachine {
    val sBootBanner: State    = new State
    val sWaitCalib: State     = new State
    val sPrintCalib: State    = new State
    val sPrintBanner: State   = new State
    val sSingleWriteAW: State = new State
    val sSingleWriteW: State  = new State
    val sSingleWriteB: State  = new State
    val sSingleReadAR: State  = new State
    val sSingleReadR: State   = new State
    val sPatchWriteAW: State  = new State
    val sPatchWriteW: State   = new State
    val sPatchWriteB: State   = new State
    val sPatchReadAR: State   = new State
    val sPatchReadR: State    = new State
    val sBulkWriteAW: State   = new State
    val sBulkWriteW: State    = new State
    val sBulkWriteB: State    = new State
    val sBulkReadAR: State    = new State
    val sBulkReadR: State     = new State
    val sReportPass: State    = new State
    val sReportFail: State    = new State
    val sLoopDelay: State     = new State

    setEntry(sBootBanner)

    io.test_busy := !isActive(sBootBanner) && !isActive(sWaitCalib) && !isActive(sLoopDelay)

    val msgIndex = Reg(UInt(7 bits)) init(0)
    val delayCounter = Reg(UInt(28 bits)) init(0)

    // Immediate Boot Banner on power up / reset release
    sBootBanner.whenIsActive {
      when(canPrint) {
        switch(msgIndex) {
          is(0)  { nextPrintChar := 0x0D; nextPrintValid := True; msgIndex := msgIndex + 1 } // \r
          is(1)  { nextPrintChar := 0x0A; nextPrintValid := True; msgIndex := msgIndex + 1 } // \n
          is(2)  { nextPrintChar := 0x5B; nextPrintValid := True; msgIndex := msgIndex + 1 } // [
          is(3)  { nextPrintChar := 0x42; nextPrintValid := True; msgIndex := msgIndex + 1 } // B
          is(4)  { nextPrintChar := 0x4F; nextPrintValid := True; msgIndex := msgIndex + 1 } // O
          is(5)  { nextPrintChar := 0x4F; nextPrintValid := True; msgIndex := msgIndex + 1 } // O
          is(6)  { nextPrintChar := 0x54; nextPrintValid := True; msgIndex := msgIndex + 1 } // T
          is(7)  { nextPrintChar := 0x5D; nextPrintValid := True; msgIndex := msgIndex + 1 } // ]
          is(8)  { nextPrintChar := 0x20; nextPrintValid := True; msgIndex := msgIndex + 1 } // ' '
          is(9)  { nextPrintChar := 0x44; nextPrintValid := True; msgIndex := msgIndex + 1 } // D
          is(10) { nextPrintChar := 0x44; nextPrintValid := True; msgIndex := msgIndex + 1 } // D
          is(11) { nextPrintChar := 0x52; nextPrintValid := True; msgIndex := msgIndex + 1 } // R
          is(12) { nextPrintChar := 0x33; nextPrintValid := True; msgIndex := msgIndex + 1 } // 3
          is(13) { nextPrintChar := 0x20; nextPrintValid := True; msgIndex := msgIndex + 1 } // ' '
          is(14) { nextPrintChar := 0x43; nextPrintValid := True; msgIndex := msgIndex + 1 } // C
          is(15) { nextPrintChar := 0x6F; nextPrintValid := True; msgIndex := msgIndex + 1 } // o
          is(16) { nextPrintChar := 0x72; nextPrintValid := True; msgIndex := msgIndex + 1 } // r
          is(17) { nextPrintChar := 0x65; nextPrintValid := True; msgIndex := msgIndex + 1 } // e
          is(18) { nextPrintChar := 0x0D; nextPrintValid := True; msgIndex := msgIndex + 1 } // \r
          is(19) { nextPrintChar := 0x0A; nextPrintValid := True; msgIndex := msgIndex + 1 } // \n
          default {
            msgIndex := 0
            delayCounter := 0
            goto(sWaitCalib)
          }
        }
      }
    }

    sWaitCalib.whenIsActive {
      when(io.pll_lock && io.init_done && io.write_level_done && io.read_calib_done) {
        msgIndex := 0
        goto(sPrintBanner)
      } otherwise {
        delayCounter := delayCounter + 1
        when(delayCounter === (clkFreqHz / 2)) {
          delayCounter := 0
          msgIndex := 0
          goto(sPrintCalib)
        }
      }
    }

    // Progress line while calibrating: "[CAL s=X W=HH]\r\n"
    sPrintCalib.whenIsActive {
      when(canPrint) {
        switch(msgIndex) {
          is(0)  { nextPrintChar := 0x5B; nextPrintValid := True; msgIndex := msgIndex + 1 } // [
          is(1)  { nextPrintChar := 0x43; nextPrintValid := True; msgIndex := msgIndex + 1 } // C
          is(2)  { nextPrintChar := 0x41; nextPrintValid := True; msgIndex := msgIndex + 1 } // A
          is(3)  { nextPrintChar := 0x4C; nextPrintValid := True; msgIndex := msgIndex + 1 } // L
          is(4)  { nextPrintChar := 0x20; nextPrintValid := True; msgIndex := msgIndex + 1 } // ' '
          is(5)  { nextPrintChar := 0x73; nextPrintValid := True; msgIndex := msgIndex + 1 } // s
          is(6)  { nextPrintChar := 0x3D; nextPrintValid := True; msgIndex := msgIndex + 1 } // =
          is(7)  { nextPrintChar := nibbleToAscii(io.dbg_state); nextPrintValid := True; msgIndex := msgIndex + 1 }
          is(8)  { nextPrintChar := 0x20; nextPrintValid := True; msgIndex := msgIndex + 1 } // ' '
          is(9)  { nextPrintChar := 0x57; nextPrintValid := True; msgIndex := msgIndex + 1 } // W
          is(10) { nextPrintChar := 0x3D; nextPrintValid := True; msgIndex := msgIndex + 1 } // =
          is(11) { nextPrintChar := nibbleToAscii(io.wstep(7 downto 4)); nextPrintValid := True; msgIndex := msgIndex + 1 }
          is(12) { nextPrintChar := nibbleToAscii(io.wstep(3 downto 0)); nextPrintValid := True; msgIndex := msgIndex + 1 }
          is(13) { nextPrintChar := 0x0D; nextPrintValid := True; msgIndex := msgIndex + 1 } // \r
          is(14) { nextPrintChar := 0x0A; nextPrintValid := True; msgIndex := msgIndex + 1 } // \n
          default {
            msgIndex := 0
            goto(sWaitCalib)
          }
        }
      }
    }

    // Banner message: "\r\n[DDR3-OK] W=" + wstep + " P=" + rclkpos + " S=" + rclksel + " R=" + best_rot + " C=" + best_score + "\r\n"
    sPrintBanner.whenIsActive {
      when(canPrint) {
        switch(msgIndex) {
          is(0)  { nextPrintChar := 0x0D; nextPrintValid := True; msgIndex := msgIndex + 1 } // \r
          is(1)  { nextPrintChar := 0x0A; nextPrintValid := True; msgIndex := msgIndex + 1 } // \n
          is(2)  { nextPrintChar := 0x5B; nextPrintValid := True; msgIndex := msgIndex + 1 } // [
          is(3)  { nextPrintChar := 0x44; nextPrintValid := True; msgIndex := msgIndex + 1 } // D
          is(4)  { nextPrintChar := 0x44; nextPrintValid := True; msgIndex := msgIndex + 1 } // D
          is(5)  { nextPrintChar := 0x52; nextPrintValid := True; msgIndex := msgIndex + 1 } // R
          is(6)  { nextPrintChar := 0x33; nextPrintValid := True; msgIndex := msgIndex + 1 } // 3
          is(7)  { nextPrintChar := 0x2D; nextPrintValid := True; msgIndex := msgIndex + 1 } // -
          is(8)  { nextPrintChar := 0x4F; nextPrintValid := True; msgIndex := msgIndex + 1 } // O
          is(9)  { nextPrintChar := 0x4B; nextPrintValid := True; msgIndex := msgIndex + 1 } // K
          is(10) { nextPrintChar := 0x5D; nextPrintValid := True; msgIndex := msgIndex + 1 } // ]
          is(11) { nextPrintChar := 0x20; nextPrintValid := True; msgIndex := msgIndex + 1 } // ' '
          is(12) { nextPrintChar := 0x57; nextPrintValid := True; msgIndex := msgIndex + 1 } // W
          is(13) { nextPrintChar := 0x3D; nextPrintValid := True; msgIndex := msgIndex + 1 } // =
          is(14) { nextPrintChar := nibbleToAscii(io.wstep(7 downto 4)); nextPrintValid := True; msgIndex := msgIndex + 1 }
          is(15) { nextPrintChar := nibbleToAscii(io.wstep(3 downto 0)); nextPrintValid := True; msgIndex := msgIndex + 1 }
          is(16) { nextPrintChar := 0x20; nextPrintValid := True; msgIndex := msgIndex + 1 } // ' '
          is(17) { nextPrintChar := 0x50; nextPrintValid := True; msgIndex := msgIndex + 1 } // P
          is(18) { nextPrintChar := 0x3D; nextPrintValid := True; msgIndex := msgIndex + 1 } // =
          is(19) { nextPrintChar := nibbleToAscii(io.rclkpos.asBits.resized); nextPrintValid := True; msgIndex := msgIndex + 1 }
          is(20) { nextPrintChar := 0x20; nextPrintValid := True; msgIndex := msgIndex + 1 } // ' '
          is(21) { nextPrintChar := 0x53; nextPrintValid := True; msgIndex := msgIndex + 1 } // S
          is(22) { nextPrintChar := 0x3D; nextPrintValid := True; msgIndex := msgIndex + 1 } // =
          is(23) { nextPrintChar := nibbleToAscii(io.rclksel.asBits.resized); nextPrintValid := True; msgIndex := msgIndex + 1 }
          is(24) { nextPrintChar := 0x20; nextPrintValid := True; msgIndex := msgIndex + 1 } // ' '
          is(25) { nextPrintChar := 0x52; nextPrintValid := True; msgIndex := msgIndex + 1 } // R
          is(26) { nextPrintChar := 0x3D; nextPrintValid := True; msgIndex := msgIndex + 1 } // =
          is(27) { nextPrintChar := nibbleToAscii(io.best_rot.asBits.resized); nextPrintValid := True; msgIndex := msgIndex + 1 }
          is(28) { nextPrintChar := 0x20; nextPrintValid := True; msgIndex := msgIndex + 1 } // ' '
          is(29) { nextPrintChar := 0x43; nextPrintValid := True; msgIndex := msgIndex + 1 } // C
          is(30) { nextPrintChar := 0x3D; nextPrintValid := True; msgIndex := msgIndex + 1 } // =
          is(31) { nextPrintChar := nibbleToAscii(io.best_score.asBits.resized); nextPrintValid := True; msgIndex := msgIndex + 1 }
          is(32) { nextPrintChar := 0x0D; nextPrintValid := True; msgIndex := msgIndex + 1 } // \r
          is(33) { nextPrintChar := 0x0A; nextPrintValid := True; msgIndex := msgIndex + 1 } // \n
          default {
            msgIndex := 0
            goto(sSingleWriteAW)
          }
        }
      }
    }

    // --- Phase 1: Single Block RW at 0x00000000 (1, 2, or 4 AXI beats) ---
    sSingleWriteAW.whenIsActive {
      io.axi.aw.valid := True
      io.axi.aw.addr  := 0
      when(io.axi.aw.ready) {
        singleIdx := 0
        goto(sSingleWriteW)
      }
    }

    sSingleWriteW.whenIsActive {
      io.axi.w.valid := True
      io.axi.w.strb  := fullStrb
      io.axi.w.data  := sliceWord(singlePat128, singleIdx)
      val isLast = if (is128Bit) True else (singleIdx === (beatsPerBlock - 1))
      io.axi.w.last  := isLast
      when(io.axi.w.ready) {
        when(isLast) {
          goto(sSingleWriteB)
        } otherwise {
          singleIdx := singleIdx + 1
        }
      }
    }

    sSingleWriteB.whenIsActive {
      when(io.axi.b.valid) {
        goto(sSingleReadAR)
      }
    }

    sSingleReadAR.whenIsActive {
      io.axi.ar.valid := True
      io.axi.ar.addr  := 0
      when(io.axi.ar.ready) {
        singleIdx := 0
        goto(sSingleReadR)
      }
    }

    def checkSingleBlockRead(expectedWord128: Bits)(onPass: => Unit): Unit = {
      io.axi.r.ready := True
      when(io.axi.r.valid) {
        val expBeat  = sliceWord(expectedWord128, singleIdx)
        val mismatch = io.axi.r.data =/= expBeat
        val isLast   = if (is128Bit) True else (singleIdx === (beatsPerBlock - 1))

        if (is128Bit) {
          when(mismatch) {
            errorReg    := True
            errAddr     := 0
            errExpected := expBeat(63 downto 0)
            errActual   := io.axi.r.data(63 downto 0)
            errActual1  := io.axi.r.data(127 downto 64)
            msgIndex    := 0
            goto(sReportFail)
          } otherwise {
            onPass
          }
        } else {
          when(errorReg && singleIdx === 1) {
            errActual1 := io.axi.r.data.resized
          }
          when(!errorReg && mismatch) {
            errorReg    := True
            errAddr     := (singleIdx << bytesPerBeatShift).resize(32)
            errExpected := expBeat.resized
            errActual   := io.axi.r.data.resized
          }
          when(isLast) {
            when(errorReg || mismatch) {
              msgIndex := 0
              goto(sReportFail)
            } otherwise {
              onPass
            }
          } otherwise {
            singleIdx := singleIdx + 1
          }
        }
      }
    }

    sSingleReadR.whenIsActive {
      checkSingleBlockRead(singlePat128) {
        if (is128Bit) {
          burstIndex := 0
          wrCycleCnt := 0
          rdCycleCnt := 0
          goto(sBulkWriteAW)
        } else {
          goto(sPatchWriteAW)
        }
      }
    }

    // --- Phase 1b (32b/64b): Unaligned 1-beat sub-word write + byte-mask (DDR3_DM) check ---
    if (!is128Bit) {
      sPatchWriteAW.whenIsActive {
        io.axi.aw.valid := True
        io.axi.aw.addr  := 8
        io.axi.aw.len   := 0
        when(io.axi.aw.ready) {
          goto(sPatchWriteW)
        }
      }

      sPatchWriteW.whenIsActive {
        io.axi.w.valid := True
        io.axi.w.data  := patchBeatData
        io.axi.w.strb  := patchBeatStrb
        io.axi.w.last  := True
        when(io.axi.w.ready) {
          goto(sPatchWriteB)
        }
      }

      sPatchWriteB.whenIsActive {
        when(io.axi.b.valid) {
          goto(sPatchReadAR)
        }
      }

      sPatchReadAR.whenIsActive {
        io.axi.ar.valid := True
        io.axi.ar.addr  := 0
        when(io.axi.ar.ready) {
          singleIdx := 0
          goto(sPatchReadR)
        }
      }

      sPatchReadR.whenIsActive {
        checkSingleBlockRead(patchedPat128) {
          burstIndex := 0
          wrCycleCnt := 0
          rdCycleCnt := 0
          goto(sBulkWriteAW)
        }
      }
    }

    // --- Phase 2: Bulk Multi-Beat AXI4 Bursts (+ cycle counters) ---
    sBulkWriteAW.whenIsActive {
      wrCycleCnt      := wrCycleCnt + 1
      io.axi.aw.valid := True
      io.axi.aw.addr  := currentByteAddr
      io.axi.aw.len   := beatsPerBurst - 1
      when(io.axi.aw.ready) {
        beatIdx := 0
        goto(sBulkWriteW)
      }
    }

    sBulkWriteW.whenIsActive {
      wrCycleCnt     := wrCycleCnt + 1
      val blockPat128 = makePattern1(beatBlockAddr) ## makePattern0(beatBlockAddr)
      io.axi.w.valid := True
      io.axi.w.data  := sliceWord(blockPat128, beatIdx)
      io.axi.w.strb  := fullStrb
      io.axi.w.last  := (beatIdx === beatsPerBurst - 1)
      when(io.axi.w.ready) {
        when(beatIdx === beatsPerBurst - 1) {
          goto(sBulkWriteB)
        } otherwise {
          beatIdx := beatIdx + 1
        }
      }
    }

    sBulkWriteB.whenIsActive {
      wrCycleCnt := wrCycleCnt + 1
      when(io.axi.b.valid) {
        when(burstIndex + axiBurstBlocks >= testBursts) {
          burstIndex := 0
          rdCycleCnt := 0
          goto(sBulkReadAR)
        } otherwise {
          burstIndex := burstIndex + axiBurstBlocks
          goto(sBulkWriteAW)
        }
      }
    }

    sBulkReadAR.whenIsActive {
      rdCycleCnt      := rdCycleCnt + 1
      io.axi.ar.valid := True
      io.axi.ar.addr  := currentByteAddr
      io.axi.ar.len   := beatsPerBurst - 1
      when(io.axi.ar.ready) {
        beatIdx := 0
        goto(sBulkReadR)
      }
    }

    sBulkReadR.whenIsActive {
      rdCycleCnt     := rdCycleCnt + 1
      io.axi.r.ready := True
      when(io.axi.r.valid) {
        val blockPat128 = makePattern1(beatBlockAddr) ## makePattern0(beatBlockAddr)
        val exp         = sliceWord(blockPat128, beatIdx)
        val mismatch    = (io.axi.r.data =/= exp)
        when(!errorReg && mismatch) {
          errorReg := True
          if (is128Bit) {
            errAddr     := beatBlockAddr
            errExpected := exp(63 downto 0)
            errActual   := io.axi.r.data(63 downto 0)
            errActual1  := io.axi.r.data(127 downto 64)
          } else {
            errAddr     := beatBlockAddr + (beatIdx(beatShift - 1 downto 0) << bytesPerBeatShift).resize(32)
            errExpected := exp.resized
            errActual   := io.axi.r.data.resized
          }
        }
        when(errorReg || mismatch) {
          msgIndex := 0
          goto(sReportFail)
        } otherwise {
          when(beatIdx === beatsPerBurst - 1) {
            when(burstIndex + axiBurstBlocks >= testBursts) {
              msgIndex := 0
              goto(sReportPass)
            } otherwise {
              burstIndex := burstIndex + axiBurstBlocks
              goto(sBulkReadAR)
            }
          } otherwise {
            beatIdx := beatIdx + 1
          }
        }
      }
    }

    // Report Pass: "[PASS] " + passCount + " W=" + wrCycleCnt + " R=" + rdCycleCnt + "\r\n"
    sReportPass.whenIsActive {
      passReg := True
      val passLits = Vec(
        passPrefix ++
        Seq.fill(4)(B(0, 8 bits)) ++
        Seq(B(0x20, 8 bits), B(0x57, 8 bits), B(0x3D, 8 bits)) ++
        Seq.fill(8)(B(0, 8 bits)) ++
        Seq(B(0x20, 8 bits), B(0x52, 8 bits), B(0x3D, 8 bits)) ++
        Seq.fill(8)(B(0, 8 bits)) ++
        Seq(B(0x0D, 8 bits), B(0x0A, 8 bits))
      )
      val passNibs = Vec(
        Seq.fill(7)(B(0, 4 bits)) ++
        (0 until 4).map(i => passCount((3 - i) * 4 + 3 downto (3 - i) * 4).asBits) ++
        Seq.fill(3)(B(0, 4 bits)) ++
        (0 until 8).map(i => wrCycleCnt((7 - i) * 4 + 3 downto (7 - i) * 4).asBits) ++
        Seq.fill(3)(B(0, 4 bits)) ++
        (0 until 8).map(i => rdCycleCnt((7 - i) * 4 + 3 downto (7 - i) * 4).asBits) ++
        Seq.fill(2)(B(0, 4 bits))
      )
      val passIsNib = Vec(
        (0 until 35).map(i => Bool((i >= 7 && i < 11) || (i >= 14 && i < 22) || (i >= 25 && i < 33)))
      )
      val idx = msgIndex.resize(6)
      when(canPrint) {
        when(msgIndex < 35) {
          nextPrintChar  := passLits(idx)
          nextPrintNib   := passNibs(idx)
          nextUseNib     := passIsNib(idx)
          nextPrintValid := True
          msgIndex       := msgIndex + 1
        } otherwise {
          passCount    := passCount + 1
          delayCounter := 0
          goto(sLoopDelay)
        }
      }
    }

    // Report Fail: "[FAIL] A=" + errAddr + " E=" + errExpected + " G=" + errActual + " H=" + errActual1 + "\r\n"
    sReportFail.whenIsActive {
      val failLits = Vec(
        failPrefix ++
        Seq.fill(8)(B(0, 8 bits)) ++
        Seq(B(0x20, 8 bits), B(0x45, 8 bits), B(0x3D, 8 bits)) ++
        Seq.fill(16)(B(0, 8 bits)) ++
        Seq(B(0x20, 8 bits), B(0x47, 8 bits), B(0x3D, 8 bits)) ++
        Seq.fill(16)(B(0, 8 bits)) ++
        Seq(B(0x20, 8 bits), B(0x48, 8 bits), B(0x3D, 8 bits)) ++
        Seq.fill(16)(B(0, 8 bits)) ++
        Seq(B(0x0D, 8 bits), B(0x0A, 8 bits))
      )
      val failNibs = Vec(
        Seq.fill(9)(B(0, 4 bits)) ++
        (0 until 8).map(i => errAddr((7 - i) * 4 + 3 downto (7 - i) * 4).asBits) ++
        Seq.fill(3)(B(0, 4 bits)) ++
        (0 until 16).map(i => errExpected((15 - i) * 4 + 3 downto (15 - i) * 4)) ++
        Seq.fill(3)(B(0, 4 bits)) ++
        (0 until 16).map(i => errActual((15 - i) * 4 + 3 downto (15 - i) * 4)) ++
        Seq.fill(3)(B(0, 4 bits)) ++
        (0 until 16).map(i => errActual1((15 - i) * 4 + 3 downto (15 - i) * 4)) ++
        Seq.fill(2)(B(0, 4 bits))
      )
      val failIsNib = Vec(
        (0 until 76).map(i => Bool(
          (i >= 9 && i < 17) || (i >= 20 && i < 36) || (i >= 39 && i < 55) || (i >= 58 && i < 74)
        ))
      )
      val idx = msgIndex.resize(7)
      when(canPrint) {
        when(msgIndex < 76) {
          nextPrintChar  := failLits(idx)
          nextPrintNib   := failNibs(idx)
          nextUseNib     := failIsNib(idx)
          nextPrintValid := True
          msgIndex       := msgIndex + 1
        }
      }
    }

    // Delay before next test loop (~10ms in hardware)
    sLoopDelay.whenIsActive {
      delayCounter := delayCounter + 1
      when(delayCounter === (clkFreqHz / 100)) {
        burstIndex := 0
        wrCycleCnt := 0
        rdCycleCnt := 0
        goto(sBulkWriteAW)
      }
    }
  }
}
