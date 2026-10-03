package ddr3

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import spinal.lib.fsm._

/**
 * Autonomous DDR3 Memtest Engine & UART Reporter.
 * 
 * Verifies DDR3 operations through native AXI4 bursts:
 * - Single-word sanity check
 * - Bulk burst-write and burst-read with pseudo-random pattern verification
 * - Formatted status & error reporting to UART TX (115200 baud)
 * - LED status and heartbeat generation
 */
class Ddr3MemtestEngine(
  val axiConfig: Axi4Config,
  val testBursts: Int = 1024,
  val clkFreqHz: Int = 99560000,
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
    val wlMap            = in Bits(256 bits)
    val wlFirst          = in Bits(8 bits)
    val wlLast           = in Bits(8 bits)
    val wlMatchN         = in Bits(8 bits)

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

  // Helper to convert 4-bit nibble to ASCII
  def nibbleToAscii(n: Bits): Bits = {
    val u = n.resize(4).asUInt.resize(8)
    val res = Bits(8 bits)
    when(u < 10) {
      res := (u + U(0x30, 8 bits)).asBits
    } otherwise {
      res := (u + U(0x37, 8 bits)).asBits
    }
    res
  }

  // UART print queue / character generator
  val printValid = RegInit(False)
  val printChar  = Reg(Bits(8 bits)) init(0)
  val printBusy  = RegInit(False)

  txStream.valid   := printValid
  txStream.payload := printChar

  when(txStream.fire) {
    printValid := False
  }

  // --- 2. Test Control Registers ---
  val passCount     = Reg(UInt(16 bits)) init(0)
  val errorReg      = RegInit(False)
  val passReg       = RegInit(False)
  val errAddr       = Reg(UInt(32 bits)) init(0)
  val errExpected   = Reg(Bits(64 bits)) init(0)
  val errActual     = Reg(Bits(64 bits)) init(0)
  val errActual1    = Reg(Bits(64 bits)) init(0) // 2nd beat (distinguishes dead path vs shifted window)

  io.test_error := errorReg
  io.test_pass  := passReg

  // Heartbeat counter (~2 Hz toggle at 100 MHz)
  val hbCounter = Reg(UInt(25 bits)) init(0)
  val hbReg     = RegInit(False)
  hbCounter := hbCounter + 1
  when(hbCounter === 0) {
    hbReg := !hbReg
  }
  io.heartbeat := hbReg

  // Default AXI Master outputs
  io.axi.aw.valid := False
  io.axi.aw.addr  := 0
  io.axi.aw.len   := 1 // 2 beats of 64-bit = 128-bit DDR3 burst
  io.axi.aw.size  := 3 // 8 bytes
  io.axi.aw.burst := 1 // INCR
  io.axi.aw.id    := 0
  // Tie off unused sidebands (was undriven -> 30+ synth warnings, float risk)
  io.axi.aw.region := 0
  io.axi.aw.lock   := 0
  io.axi.aw.cache  := 0
  io.axi.aw.qos    := 0
  io.axi.aw.prot   := 0

  io.axi.w.valid  := False
  io.axi.w.data   := 0
  io.axi.w.strb   := 0xFF
  io.axi.w.last   := False

  io.axi.b.ready  := True

  io.axi.ar.valid := False
  io.axi.ar.addr  := 0
  io.axi.ar.len   := 1 // 2 beats
  io.axi.ar.size  := 3 // 8 bytes
  io.axi.ar.burst := 1 // INCR
  io.axi.ar.id    := 0
  io.axi.ar.region := 0
  io.axi.ar.lock   := 0
  io.axi.ar.cache  := 0
  io.axi.ar.qos    := 0
  io.axi.ar.prot   := 0

  io.axi.r.ready  := False

  // Address and test pattern generators
  val burstIndex = Reg(UInt(log2Up(testBursts + 1) bits)) init(0)
  val currentByteAddr = (burstIndex << 4).resize(32) // 16 bytes per burst

  def makePattern0(addr: UInt): Bits = {
    (addr.asBits ^ B(0x5AA55AA5, 32 bits)) ## (addr + 1).asBits
  }
  def makePattern1(addr: UInt): Bits = {
    (addr.asBits ^ B(0x12345678, 32 bits)) ## (addr + 2).asBits
  }

  // --- 3. Main Memtest FSM ---
  // WL match-map as 64 printable nibbles (MSB first), latched statically.
  val wlMapNib = Vec(Bits(4 bits), 64)
  for (i <- 0 until 64) wlMapNib(i) := io.wlMap(i * 4 + 3 downto i * 4)

  val fsm = new StateMachine {
    val sBootBanner: State    = new State
    val sWaitCalib: State     = new State
    val sPrintCalib: State    = new State
    val sPrintBanner: State   = new State
    val sPrintWlmap: State    = new State
    val sSingleWriteAW: State = new State
    val sSingleWriteW0: State = new State
    val sSingleWriteW1: State = new State
    val sSingleWriteB: State  = new State
    val sSingleReadAR: State  = new State
    val sSingleReadR0: State  = new State
    val sSingleReadR1: State  = new State
    val sBulkWriteAW: State   = new State
    val sBulkWriteW0: State   = new State
    val sBulkWriteW1: State   = new State
    val sBulkWriteB: State    = new State
    val sBulkReadAR: State    = new State
    val sBulkReadR0: State    = new State
    val sBulkReadR1: State    = new State
    val sReportPass: State    = new State
    val sReportFail: State    = new State
    val sLoopDelay: State     = new State

    setEntry(sBootBanner)

    io.test_busy := !isActive(sBootBanner) && !isActive(sWaitCalib) && !isActive(sLoopDelay)

    val msgIndex = Reg(UInt(7 bits)) init(0)
    val delayCounter = Reg(UInt(28 bits)) init(0)

    // Immediate Boot Banner on power up / reset release
    sBootBanner.whenIsActive {
      when(!printValid) {
        switch(msgIndex) {
          is(0)  { printChar := 0x0D; printValid := True; msgIndex := msgIndex + 1 } // \r
          is(1)  { printChar := 0x0A; printValid := True; msgIndex := msgIndex + 1 } // \n
          is(2)  { printChar := 0x5B; printValid := True; msgIndex := msgIndex + 1 } // [
          is(3)  { printChar := 0x42; printValid := True; msgIndex := msgIndex + 1 } // B
          is(4)  { printChar := 0x4F; printValid := True; msgIndex := msgIndex + 1 } // O
          is(5)  { printChar := 0x4F; printValid := True; msgIndex := msgIndex + 1 } // O
          is(6)  { printChar := 0x54; printValid := True; msgIndex := msgIndex + 1 } // T
          is(7)  { printChar := 0x5D; printValid := True; msgIndex := msgIndex + 1 } // ]
          is(8)  { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(9)  { printChar := 0x44; printValid := True; msgIndex := msgIndex + 1 } // D
          is(10) { printChar := 0x44; printValid := True; msgIndex := msgIndex + 1 } // D
          is(11) { printChar := 0x52; printValid := True; msgIndex := msgIndex + 1 } // R
          is(12) { printChar := 0x33; printValid := True; msgIndex := msgIndex + 1 } // 3
          is(13) { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(14) { printChar := 0x43; printValid := True; msgIndex := msgIndex + 1 } // C
          is(15) { printChar := 0x6F; printValid := True; msgIndex := msgIndex + 1 } // o
          is(16) { printChar := 0x72; printValid := True; msgIndex := msgIndex + 1 } // r
          is(17) { printChar := 0x65; printValid := True; msgIndex := msgIndex + 1 } // e
          is(18) { printChar := 0x0D; printValid := True; msgIndex := msgIndex + 1 } // \r
          is(19) { printChar := 0x0A; printValid := True; msgIndex := msgIndex + 1 } // \n
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
        // Every ~500ms, print a progress line instead of a bare dot, so a
        // stuck calibration tells us WHERE it is stuck (controller state +
        // write-leveling taps). Format: "[CAL s=X W=HH]\r\n".
        delayCounter := delayCounter + 1
        when(delayCounter === (clkFreqHz / 2)) {
          delayCounter := 0
          msgIndex := 0
          goto(sPrintCalib)
        }
      }
    }

    // Progress line while calibrating: "[CAL s=X W=HH]\r\n" (X = controller
    // state 0-9, HH = write-leveling taps; W=FF means the WL watchdog fired).
    sPrintCalib.whenIsActive {
      when(!printValid) {
        switch(msgIndex) {
          is(0)  { printChar := 0x5B; printValid := True; msgIndex := msgIndex + 1 } // [
          is(1)  { printChar := 0x43; printValid := True; msgIndex := msgIndex + 1 } // C
          is(2)  { printChar := 0x41; printValid := True; msgIndex := msgIndex + 1 } // A
          is(3)  { printChar := 0x4C; printValid := True; msgIndex := msgIndex + 1 } // L
          is(4)  { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(5)  { printChar := 0x73; printValid := True; msgIndex := msgIndex + 1 } // s
          is(6)  { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(7)  { printChar := nibbleToAscii(io.dbg_state); printValid := True; msgIndex := msgIndex + 1 }
          is(8)  { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(9)  { printChar := 0x57; printValid := True; msgIndex := msgIndex + 1 } // W
          is(10) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(11) { printChar := nibbleToAscii(io.wstep(7 downto 4)); printValid := True; msgIndex := msgIndex + 1 }
          is(12) { printChar := nibbleToAscii(io.wstep(3 downto 0)); printValid := True; msgIndex := msgIndex + 1 }
          is(13) { printChar := 0x0D; printValid := True; msgIndex := msgIndex + 1 } // \r
          is(14) { printChar := 0x0A; printValid := True; msgIndex := msgIndex + 1 } // \n
          default {
            msgIndex := 0
            goto(sWaitCalib)
          }
        }
      }
    }

    // Banner message: "\r\n[DDR3-OK] W=" + wstep + " P=" + rclkpos + " S=" + rclksel + " R=" + best_rot + " C=" + best_score + "\r\n"
    sPrintBanner.whenIsActive {
      when(!printValid) {
        switch(msgIndex) {
          is(0)  { printChar := 0x0D; printValid := True; msgIndex := msgIndex + 1 } // \r
          is(1)  { printChar := 0x0A; printValid := True; msgIndex := msgIndex + 1 } // \n
          is(2)  { printChar := 0x5B; printValid := True; msgIndex := msgIndex + 1 } // [
          is(3)  { printChar := 0x44; printValid := True; msgIndex := msgIndex + 1 } // D
          is(4)  { printChar := 0x44; printValid := True; msgIndex := msgIndex + 1 } // D
          is(5)  { printChar := 0x52; printValid := True; msgIndex := msgIndex + 1 } // R
          is(6)  { printChar := 0x33; printValid := True; msgIndex := msgIndex + 1 } // 3
          is(7)  { printChar := 0x2D; printValid := True; msgIndex := msgIndex + 1 } // -
          is(8)  { printChar := 0x4F; printValid := True; msgIndex := msgIndex + 1 } // O
          is(9)  { printChar := 0x4B; printValid := True; msgIndex := msgIndex + 1 } // K
          is(10) { printChar := 0x5D; printValid := True; msgIndex := msgIndex + 1 } // ]
          is(11) { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(12) { printChar := 0x57; printValid := True; msgIndex := msgIndex + 1 } // W
          is(13) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(14) { printChar := nibbleToAscii(io.wstep(7 downto 4)); printValid := True; msgIndex := msgIndex + 1 }
          is(15) { printChar := nibbleToAscii(io.wstep(3 downto 0)); printValid := True; msgIndex := msgIndex + 1 }
          is(16) { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(17) { printChar := 0x50; printValid := True; msgIndex := msgIndex + 1 } // P
          is(18) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(19) { printChar := nibbleToAscii(io.rclkpos.asBits.resized); printValid := True; msgIndex := msgIndex + 1 }
          is(20) { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(21) { printChar := 0x53; printValid := True; msgIndex := msgIndex + 1 } // S
          is(22) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(23) { printChar := nibbleToAscii(io.rclksel.asBits.resized); printValid := True; msgIndex := msgIndex + 1 }
          is(24) { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(25) { printChar := 0x52; printValid := True; msgIndex := msgIndex + 1 } // R
          is(26) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(27) { printChar := nibbleToAscii(io.best_rot.asBits.resized); printValid := True; msgIndex := msgIndex + 1 }
          is(28) { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(29) { printChar := 0x43; printValid := True; msgIndex := msgIndex + 1 } // C
          is(30) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(31) { printChar := nibbleToAscii(io.best_score.asBits.resized); printValid := True; msgIndex := msgIndex + 1 }
          is(32) { printChar := 0x0D; printValid := True; msgIndex := msgIndex + 1 } // \r
          is(33) { printChar := 0x0A; printValid := True; msgIndex := msgIndex + 1 } // \n
          default {
            msgIndex := 0
            goto(sPrintWlmap)
          }
        }
      }
    }

    // WL match-map dump for HW debug: "\r\n[WLMAP f=HH l=HH n=HH
    // m=<64 hex>]\r\n" (map bit k = echo match at wstep k, MSB first).
    // Printed once after the banner, before the memtest starts.
    sPrintWlmap.whenIsActive {
      when(!printValid) {
        switch(msgIndex) {
          is(0)  { printChar := 0x0D; printValid := True; msgIndex := msgIndex + 1 } // \r
          is(1)  { printChar := 0x0A; printValid := True; msgIndex := msgIndex + 1 } // \n
          is(2)  { printChar := 0x5B; printValid := True; msgIndex := msgIndex + 1 } // [
          is(3)  { printChar := 0x57; printValid := True; msgIndex := msgIndex + 1 } // W
          is(4)  { printChar := 0x4C; printValid := True; msgIndex := msgIndex + 1 } // L
          is(5)  { printChar := 0x4D; printValid := True; msgIndex := msgIndex + 1 } // M
          is(6)  { printChar := 0x41; printValid := True; msgIndex := msgIndex + 1 } // A
          is(7)  { printChar := 0x50; printValid := True; msgIndex := msgIndex + 1 } // P
          is(8)  { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(9)  { printChar := 0x66; printValid := True; msgIndex := msgIndex + 1 } // f
          is(10) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(11) { printChar := nibbleToAscii(io.wlFirst(7 downto 4)); printValid := True; msgIndex := msgIndex + 1 }
          is(12) { printChar := nibbleToAscii(io.wlFirst(3 downto 0)); printValid := True; msgIndex := msgIndex + 1 }
          is(13) { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(14) { printChar := 0x6C; printValid := True; msgIndex := msgIndex + 1 } // l
          is(15) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(16) { printChar := nibbleToAscii(io.wlLast(7 downto 4)); printValid := True; msgIndex := msgIndex + 1 }
          is(17) { printChar := nibbleToAscii(io.wlLast(3 downto 0)); printValid := True; msgIndex := msgIndex + 1 }
          is(18) { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(19) { printChar := 0x6E; printValid := True; msgIndex := msgIndex + 1 } // n
          is(20) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(21) { printChar := nibbleToAscii(io.wlMatchN(7 downto 4)); printValid := True; msgIndex := msgIndex + 1 }
          is(22) { printChar := nibbleToAscii(io.wlMatchN(3 downto 0)); printValid := True; msgIndex := msgIndex + 1 }
          is(23) { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(24) { printChar := 0x6D; printValid := True; msgIndex := msgIndex + 1 } // m
          is(25) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(90) { printChar := 0x0D; printValid := True; msgIndex := msgIndex + 1 } // \r
          is(91) { printChar := 0x0A; printValid := True; msgIndex := 0; goto(sSingleWriteAW) } // \n
          default {
            // Map nibbles MSB first: msgIndex 26 -> bits 255..252, ... 89 -> bits 3..0.
            printChar := nibbleToAscii(wlMapNib(U(63, 6 bits) - (msgIndex - 26).resize(6))); printValid := True; msgIndex := msgIndex + 1
          }
        }
      }
    }

    // --- Phase 1: Single Burst RW at 0x00000000 ---
    sSingleWriteAW.whenIsActive {
      io.axi.aw.valid := True
      io.axi.aw.addr  := 0
      when(io.axi.aw.ready) {
        goto(sSingleWriteW0)
      }
    }

    sSingleWriteW0.whenIsActive {
      io.axi.w.valid := True
      io.axi.w.data  := B"64'h0123456789ABCDEF"
      io.axi.w.strb  := 0xFF
      io.axi.w.last  := False
      when(io.axi.w.ready) {
        goto(sSingleWriteW1)
      }
    }

    sSingleWriteW1.whenIsActive {
      io.axi.w.valid := True
      io.axi.w.data  := B"64'hFEDCBA9876543210"
      io.axi.w.strb  := 0xFF
      io.axi.w.last  := True
      when(io.axi.w.ready) {
        goto(sSingleWriteB)
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
        goto(sSingleReadR0)
      }
    }

    sSingleReadR0.whenIsActive {
      io.axi.r.ready := True
      when(io.axi.r.valid) {
        when(!errorReg && (io.axi.r.data =/= B"64'h0123456789ABCDEF")) {
          errorReg    := True
          errAddr     := 0
          errExpected := B"64'h0123456789ABCDEF"
          errActual   := io.axi.r.data
        }
        goto(sSingleReadR1)
      }
    }

    sSingleReadR1.whenIsActive {
      io.axi.r.ready := True
      when(io.axi.r.valid) {
        when(errorReg) {
          errActual1 := io.axi.r.data // beat0 already failed: still record beat1 for debug
        }
        when(!errorReg && (io.axi.r.data =/= B"64'hFEDCBA9876543210")) {
          errorReg    := True
          errAddr     := 8
          errExpected := B"64'hFEDCBA9876543210"
          errActual   := io.axi.r.data
        }
        when(errorReg || (io.axi.r.data =/= B"64'hFEDCBA9876543210")) {
          msgIndex := 0
          goto(sReportFail)
        } otherwise {
          burstIndex := 0
          goto(sBulkWriteAW)
        }
      }
    }

    // --- Phase 2: Bulk Bursts ---
    sBulkWriteAW.whenIsActive {
      io.axi.aw.valid := True
      io.axi.aw.addr  := currentByteAddr
      when(io.axi.aw.ready) {
        goto(sBulkWriteW0)
      }
    }

    sBulkWriteW0.whenIsActive {
      io.axi.w.valid := True
      io.axi.w.data  := makePattern0(currentByteAddr)
      io.axi.w.strb  := 0xFF
      io.axi.w.last  := False
      when(io.axi.w.ready) {
        goto(sBulkWriteW1)
      }
    }

    sBulkWriteW1.whenIsActive {
      io.axi.w.valid := True
      io.axi.w.data  := makePattern1(currentByteAddr)
      io.axi.w.strb  := 0xFF
      io.axi.w.last  := True
      when(io.axi.w.ready) {
        goto(sBulkWriteB)
      }
    }

    sBulkWriteB.whenIsActive {
      when(io.axi.b.valid) {
        when(burstIndex === testBursts - 1) {
          burstIndex := 0
          goto(sBulkReadAR)
        } otherwise {
          burstIndex := burstIndex + 1
          goto(sBulkWriteAW)
        }
      }
    }

    sBulkReadAR.whenIsActive {
      io.axi.ar.valid := True
      io.axi.ar.addr  := currentByteAddr
      when(io.axi.ar.ready) {
        goto(sBulkReadR0)
      }
    }

    sBulkReadR0.whenIsActive {
      io.axi.r.ready := True
      when(io.axi.r.valid) {
        val exp0 = makePattern0(currentByteAddr)
        when(!errorReg && (io.axi.r.data =/= exp0)) {
          errorReg    := True
          errAddr     := currentByteAddr
          errExpected := exp0
          errActual   := io.axi.r.data
        }
        goto(sBulkReadR1)
      }
    }

    sBulkReadR1.whenIsActive {
      io.axi.r.ready := True
      when(io.axi.r.valid) {
        val exp1 = makePattern1(currentByteAddr)
        when(!errorReg && (io.axi.r.data =/= exp1)) {
          errorReg    := True
          errAddr     := currentByteAddr + 8
          errExpected := exp1
          errActual   := io.axi.r.data
        }
        when(errorReg || (io.axi.r.data =/= exp1)) {
          msgIndex := 0
          goto(sReportFail)
        } otherwise {
          when(burstIndex === testBursts - 1) {
            msgIndex := 0
            goto(sReportPass)
          } otherwise {
            burstIndex := burstIndex + 1
            goto(sBulkReadAR)
          }
        }
      }
    }

    // Report Pass: "[PASS] Loop " + passCount + "\r\n"
    sReportPass.whenIsActive {
      passReg := True
      when(!printValid) {
        switch(msgIndex) {
          is(0)  { printChar := 0x5B; printValid := True; msgIndex := msgIndex + 1 } // [
          is(1)  { printChar := 0x50; printValid := True; msgIndex := msgIndex + 1 } // P
          is(2)  { printChar := 0x41; printValid := True; msgIndex := msgIndex + 1 } // A
          is(3)  { printChar := 0x53; printValid := True; msgIndex := msgIndex + 1 } // S
          is(4)  { printChar := 0x53; printValid := True; msgIndex := msgIndex + 1 } // S
          is(5)  { printChar := 0x5D; printValid := True; msgIndex := msgIndex + 1 } // ]
          is(6)  { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(7)  { printChar := nibbleToAscii(passCount(15 downto 12).asBits); printValid := True; msgIndex := msgIndex + 1 }
          is(8)  { printChar := nibbleToAscii(passCount(11 downto 8).asBits);  printValid := True; msgIndex := msgIndex + 1 }
          is(9)  { printChar := nibbleToAscii(passCount(7 downto 4).asBits);   printValid := True; msgIndex := msgIndex + 1 }
          is(10) { printChar := nibbleToAscii(passCount(3 downto 0).asBits);   printValid := True; msgIndex := msgIndex + 1 }
          is(11) { printChar := 0x0D; printValid := True; msgIndex := msgIndex + 1 } // \r
          is(12) { printChar := 0x0A; printValid := True; msgIndex := msgIndex + 1 } // \n
          default {
            passCount := passCount + 1
            delayCounter := 0
            goto(sLoopDelay)
          }
        }
      }
    }

    // Report Fail: "[FAIL] A=" + errAddr + " E=" + errExpected + " G=" + errActual + " H=" + errActual1 + "\r\n"
    sReportFail.whenIsActive {
      when(!printValid) {
        switch(msgIndex) {
          is(0)  { printChar := 0x5B; printValid := True; msgIndex := msgIndex + 1 } // [
          is(1)  { printChar := 0x46; printValid := True; msgIndex := msgIndex + 1 } // F
          is(2)  { printChar := 0x41; printValid := True; msgIndex := msgIndex + 1 } // A
          is(3)  { printChar := 0x49; printValid := True; msgIndex := msgIndex + 1 } // I
          is(4)  { printChar := 0x4C; printValid := True; msgIndex := msgIndex + 1 } // L
          is(5)  { printChar := 0x5D; printValid := True; msgIndex := msgIndex + 1 } // ]
          is(6)  { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(7)  { printChar := 0x41; printValid := True; msgIndex := msgIndex + 1 } // A
          is(8)  { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(9)  { printChar := nibbleToAscii(errAddr(31 downto 28).asBits); printValid := True; msgIndex := msgIndex + 1 }
          is(10) { printChar := nibbleToAscii(errAddr(27 downto 24).asBits); printValid := True; msgIndex := msgIndex + 1 }
          is(11) { printChar := nibbleToAscii(errAddr(23 downto 20).asBits); printValid := True; msgIndex := msgIndex + 1 }
          is(12) { printChar := nibbleToAscii(errAddr(19 downto 16).asBits); printValid := True; msgIndex := msgIndex + 1 }
          is(13) { printChar := nibbleToAscii(errAddr(15 downto 12).asBits); printValid := True; msgIndex := msgIndex + 1 }
          is(14) { printChar := nibbleToAscii(errAddr(11 downto 8).asBits);  printValid := True; msgIndex := msgIndex + 1 }
          is(15) { printChar := nibbleToAscii(errAddr(7 downto 4).asBits);   printValid := True; msgIndex := msgIndex + 1 }
          is(16) { printChar := nibbleToAscii(errAddr(3 downto 0).asBits);   printValid := True; msgIndex := msgIndex + 1 }
          is(17) { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(18) { printChar := 0x45; printValid := True; msgIndex := msgIndex + 1 } // E
          is(19) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(20) { printChar := nibbleToAscii(errExpected(63 downto 60)); printValid := True; msgIndex := msgIndex + 1 }
          is(21) { printChar := nibbleToAscii(errExpected(59 downto 56)); printValid := True; msgIndex := msgIndex + 1 }
          is(22) { printChar := nibbleToAscii(errExpected(55 downto 52)); printValid := True; msgIndex := msgIndex + 1 }
          is(23) { printChar := nibbleToAscii(errExpected(51 downto 48)); printValid := True; msgIndex := msgIndex + 1 }
          is(24) { printChar := nibbleToAscii(errExpected(47 downto 44)); printValid := True; msgIndex := msgIndex + 1 }
          is(25) { printChar := nibbleToAscii(errExpected(43 downto 40)); printValid := True; msgIndex := msgIndex + 1 }
          is(26) { printChar := nibbleToAscii(errExpected(39 downto 36)); printValid := True; msgIndex := msgIndex + 1 }
          is(27) { printChar := nibbleToAscii(errExpected(35 downto 32)); printValid := True; msgIndex := msgIndex + 1 }
          is(28) { printChar := nibbleToAscii(errExpected(31 downto 28)); printValid := True; msgIndex := msgIndex + 1 }
          is(29) { printChar := nibbleToAscii(errExpected(27 downto 24)); printValid := True; msgIndex := msgIndex + 1 }
          is(30) { printChar := nibbleToAscii(errExpected(23 downto 20)); printValid := True; msgIndex := msgIndex + 1 }
          is(31) { printChar := nibbleToAscii(errExpected(19 downto 16)); printValid := True; msgIndex := msgIndex + 1 }
          is(32) { printChar := nibbleToAscii(errExpected(15 downto 12)); printValid := True; msgIndex := msgIndex + 1 }
          is(33) { printChar := nibbleToAscii(errExpected(11 downto 8));  printValid := True; msgIndex := msgIndex + 1 }
          is(34) { printChar := nibbleToAscii(errExpected(7 downto 4));   printValid := True; msgIndex := msgIndex + 1 }
          is(35) { printChar := nibbleToAscii(errExpected(3 downto 0));   printValid := True; msgIndex := msgIndex + 1 }
          is(36) { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(37) { printChar := 0x47; printValid := True; msgIndex := msgIndex + 1 } // G
          is(38) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(39) { printChar := nibbleToAscii(errActual(63 downto 60)); printValid := True; msgIndex := msgIndex + 1 }
          is(40) { printChar := nibbleToAscii(errActual(59 downto 56)); printValid := True; msgIndex := msgIndex + 1 }
          is(41) { printChar := nibbleToAscii(errActual(55 downto 52)); printValid := True; msgIndex := msgIndex + 1 }
          is(42) { printChar := nibbleToAscii(errActual(51 downto 48)); printValid := True; msgIndex := msgIndex + 1 }
          is(43) { printChar := nibbleToAscii(errActual(47 downto 44)); printValid := True; msgIndex := msgIndex + 1 }
          is(44) { printChar := nibbleToAscii(errActual(43 downto 40)); printValid := True; msgIndex := msgIndex + 1 }
          is(45) { printChar := nibbleToAscii(errActual(39 downto 36)); printValid := True; msgIndex := msgIndex + 1 }
          is(46) { printChar := nibbleToAscii(errActual(35 downto 32)); printValid := True; msgIndex := msgIndex + 1 }
          is(47) { printChar := nibbleToAscii(errActual(31 downto 28)); printValid := True; msgIndex := msgIndex + 1 }
          is(48) { printChar := nibbleToAscii(errActual(27 downto 24)); printValid := True; msgIndex := msgIndex + 1 }
          is(49) { printChar := nibbleToAscii(errActual(23 downto 20)); printValid := True; msgIndex := msgIndex + 1 }
          is(50) { printChar := nibbleToAscii(errActual(19 downto 16)); printValid := True; msgIndex := msgIndex + 1 }
          is(51) { printChar := nibbleToAscii(errActual(15 downto 12)); printValid := True; msgIndex := msgIndex + 1 }
          is(52) { printChar := nibbleToAscii(errActual(11 downto 8));  printValid := True; msgIndex := msgIndex + 1 }
          is(53) { printChar := nibbleToAscii(errActual(7 downto 4));   printValid := True; msgIndex := msgIndex + 1 }
          is(54) { printChar := nibbleToAscii(errActual(3 downto 0));   printValid := True; msgIndex := msgIndex + 1 }
          is(55) { printChar := 0x20; printValid := True; msgIndex := msgIndex + 1 } // ' '
          is(56) { printChar := 0x48; printValid := True; msgIndex := msgIndex + 1 } // H
          is(57) { printChar := 0x3D; printValid := True; msgIndex := msgIndex + 1 } // =
          is(58) { printChar := nibbleToAscii(errActual1(63 downto 60)); printValid := True; msgIndex := msgIndex + 1 }
          is(59) { printChar := nibbleToAscii(errActual1(59 downto 56)); printValid := True; msgIndex := msgIndex + 1 }
          is(60) { printChar := nibbleToAscii(errActual1(55 downto 52)); printValid := True; msgIndex := msgIndex + 1 }
          is(61) { printChar := nibbleToAscii(errActual1(51 downto 48)); printValid := True; msgIndex := msgIndex + 1 }
          is(62) { printChar := nibbleToAscii(errActual1(47 downto 44)); printValid := True; msgIndex := msgIndex + 1 }
          is(63) { printChar := nibbleToAscii(errActual1(43 downto 40)); printValid := True; msgIndex := msgIndex + 1 }
          is(64) { printChar := nibbleToAscii(errActual1(39 downto 36)); printValid := True; msgIndex := msgIndex + 1 }
          is(65) { printChar := nibbleToAscii(errActual1(35 downto 32)); printValid := True; msgIndex := msgIndex + 1 }
          is(66) { printChar := nibbleToAscii(errActual1(31 downto 28)); printValid := True; msgIndex := msgIndex + 1 }
          is(67) { printChar := nibbleToAscii(errActual1(27 downto 24)); printValid := True; msgIndex := msgIndex + 1 }
          is(68) { printChar := nibbleToAscii(errActual1(23 downto 20)); printValid := True; msgIndex := msgIndex + 1 }
          is(69) { printChar := nibbleToAscii(errActual1(19 downto 16)); printValid := True; msgIndex := msgIndex + 1 }
          is(70) { printChar := nibbleToAscii(errActual1(15 downto 12)); printValid := True; msgIndex := msgIndex + 1 }
          is(71) { printChar := nibbleToAscii(errActual1(11 downto 8));  printValid := True; msgIndex := msgIndex + 1 }
          is(72) { printChar := nibbleToAscii(errActual1(7 downto 4));   printValid := True; msgIndex := msgIndex + 1 }
          is(73) { printChar := nibbleToAscii(errActual1(3 downto 0));   printValid := True; msgIndex := msgIndex + 1 }
          is(74) { printChar := 0x0D; printValid := True; msgIndex := msgIndex + 1 } // \r
          is(75) { printChar := 0x0A; printValid := True; msgIndex := msgIndex + 1 } // \n
          default {
            // Stay in error state
          }
        }
      }
    }

    // Delay before next test loop (e.g. ~10ms in hardware, shorter in sim)
    sLoopDelay.whenIsActive {
      delayCounter := delayCounter + 1
      when(delayCounter === (clkFreqHz / 100)) { // 10ms
        burstIndex := 0
        goto(sBulkWriteAW)
      }
    }
  }
}
