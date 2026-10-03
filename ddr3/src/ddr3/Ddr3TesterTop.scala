package ddr3

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

/**
 * Top-level hardware test module for Tang Primer 20K (Gowin GW2A-LV18PG256C8/I7).
 * 
 * Directly synthesizable by Gowin EDA:
 * - Gowin_rPLL: 27 MHz -> 398.25 MHz (fclk, ck 90-deg) and 99.56 MHz (pclk)
 * - Ddr3Axi4: Native SpinalHDL DDR3 controller with AXI4 slave bridge
 * - Ddr3MemtestEngine: Continuous burst write/read test & UART reporter
 * - Tang 20K Pinout & Active-Low LEDs matching tang20k.cst
 */
class Ddr3TesterTop(
  val axiConfig: Axi4Config = Axi4Config(addressWidth = 32, dataWidth = 64, idWidth = 4),
  val ddrConfig: Ddr3Config = Ddr3Config(),
  val testBursts: Int = 1024
) extends Component {
  noIoPrefix()

  val io = new Bundle {
    // Board clocks & buttons
    val sys_clk    = in Bool()
    val sys_resetn = in Bool()

    // LEDs (active-low)
    val led        = out Bits(8 bits)
    val led2       = out Bits(8 bits)

    // Serial console (115200 baud)
    val uart_txp   = out Bool()

    // Physical DDR3 memory pads (tang20k.cst)
    val DDR3_DQ     = inout(Analog(Bits(16 bits)))
    val DDR3_DQS    = inout(Analog(Bits(2 bits)))
    val DDR3_DM     = out Bits(2 bits)
    val DDR3_A      = out Bits(ddrConfig.rowWidth bits)
    val DDR3_BA     = out Bits(ddrConfig.bankWidth bits)
    val DDR3_nRAS   = out Bool()
    val DDR3_nCAS   = out Bool()
    val DDR3_nWE    = out Bool()
    val DDR3_nCS    = out Bool()
    val DDR3_CK     = out Bool()
    val DDR3_CKE    = out Bool()
    val DDR3_nRESET = out Bool()
    val DDR3_ODT    = out Bool()
  }

  // --- 1. Gowin rPLL Instance ---
  val pll = new Gowin_rPLL()
  pll.io.clkin := io.sys_clk

  val fclk     = pll.io.clkout   // 398.25 MHz fast clock
  val ck       = pll.io.clkoutp  // 398.25 MHz 90-degree clock
  val pclk     = pll.io.clkoutd  // 99.56 MHz primary core clock
  val pll_lock = pll.io.lock

  // Autonomous Power-On-Reset (POR) counter in pclk domain
  val pllDomain = ClockDomain(
    clock = pclk,
    config = ClockDomainConfig(resetKind = BOOT)
  )
  val porDone = pllDomain {
    val cnt = Reg(UInt(16 bits)) init(0)
    when(pll_lock && cnt =/= 65535) {
      cnt := cnt + 1
    } elsewhen(!pll_lock) {
      cnt := 0
    }
    cnt === 65535
  }

  // Safe global reset: active-low, released when PLL is locked and POR counter expires,
  // and re-asserted if user presses S1 (io.sys_resetn goes low).
  val globalResetn = io.sys_resetn & porDone

  // --- 2. Clock Domain for Core & Tester ---
  val coreDomain = ClockDomain(
    clock = pclk,
    reset = !globalResetn,
    config = ClockDomainConfig(resetKind = ASYNC, resetActiveLevel = HIGH)
  )

  val coreArea = new ClockingArea(coreDomain) {
    // AXI4 DDR3 Controller
    val ddr3 = new Ddr3Axi4(axiConfig, ddrConfig)
    ddr3.io.pclk   := pclk
    ddr3.io.fclk   := fclk
    ddr3.io.ck     := ck
    ddr3.io.resetn := globalResetn

    // Connect pads
    io.DDR3_DQ     <> ddr3.io.pad.DDR3_DQ
    io.DDR3_DQS    <> ddr3.io.pad.DDR3_DQS
    io.DDR3_DM     := ddr3.io.pad.DDR3_DM
    io.DDR3_A      := ddr3.io.pad.DDR3_A
    io.DDR3_BA     := ddr3.io.pad.DDR3_BA
    io.DDR3_nRAS   := ddr3.io.pad.DDR3_nRAS
    io.DDR3_nCAS   := ddr3.io.pad.DDR3_nCAS
    io.DDR3_nWE    := ddr3.io.pad.DDR3_nWE
    io.DDR3_nCS    := ddr3.io.pad.DDR3_nCS
    io.DDR3_CK     := ddr3.io.pad.DDR3_CK
    io.DDR3_CKE    := ddr3.io.pad.DDR3_CKE
    io.DDR3_nRESET := ddr3.io.pad.DDR3_nRESET
    io.DDR3_ODT    := ddr3.io.pad.DDR3_ODT

    // Autonomous Memtest & UART engine
    val engine = new Ddr3MemtestEngine(axiConfig, testBursts)
    engine.io.axi <> ddr3.io.axi

    engine.io.pll_lock         := pll_lock
    engine.io.init_done        := ddr3.io.init_done
    engine.io.write_level_done := ddr3.io.write_level_done
    engine.io.read_calib_done  := ddr3.io.read_calib_done
    engine.io.wstep            := ddr3.io.wstep
    engine.io.rclkpos          := ddr3.io.rclkpos
    engine.io.rclksel          := ddr3.io.rclksel
    engine.io.best_rot         := ddr3.io.best_rot
    engine.io.best_score       := ddr3.io.best_score
    engine.io.dbg_state        := ddr3.io.dbg_state
    engine.io.wlMap            := ddr3.io.wlMap
    engine.io.wlFirst          := ddr3.io.wlFirst
    engine.io.wlLast           := ddr3.io.wlLast
    engine.io.wlMatchN         := ddr3.io.wlMatchN
    engine.io.brkScores        := ddr3.io.brkScores

    io.uart_txp := engine.io.uart_tx

    // Drive LEDs (active-low on Tang Primer 20K)
    io.led(0) := !pll_lock
    io.led(1) := !ddr3.io.init_done
    io.led(2) := !ddr3.io.write_level_done
    io.led(3) := !ddr3.io.read_calib_done
    io.led(4) := !engine.io.heartbeat
    io.led(5) := !engine.io.test_busy
    io.led(6) := !engine.io.test_error
    io.led(7) := !engine.io.test_pass

    // Second LED bank displays write leveling delay taps
    io.led2   := ~ddr3.io.wstep
  }
}
