package ddr3

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

/**
 * Top-level hardware test module for Tang Primer 20K (Gowin GW2A-LV18PG256C8/I7).
 * Demonstrates plug-and-play instantiation using TangPrimer20kDdr3 (PLL + POR + Ddr3Axi4)
 * wired to Ddr3MemtestEngine + UART console + active-low board LEDs (tang20k.cst).
 */
class Ddr3TesterTop(
  val axiConfig: Axi4Config = Ddr3Axi4.defaultAxiConfig(),
  val ddrConfig: Ddr3Config = Ddr3Config.tangPrimer20k(),
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

  // 1. Plug-and-play DDR3 subsystem (Gowin_rPLL + POR + Ddr3Axi4)
  val ddr3 = new TangPrimer20kDdr3(axiConfig, ddrConfig)
  ddr3.io.sys_clk    := io.sys_clk
  ddr3.io.sys_resetn := io.sys_resetn

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

  // 2. Host application running in TangPrimer20kDdr3's controllerClockDomain
  val hostArea = new ClockingArea(ddr3.controllerClockDomain) {
    val engine = new Ddr3MemtestEngine(axiConfig, testBursts, clkFreqHz = ddrConfig.pclkHz)
    engine.io.axi <> ddr3.io.axi

    engine.io.pll_lock         := ddr3.io.pll_lock
    engine.io.init_done        := ddr3.io.status.init_done
    engine.io.write_level_done := ddr3.io.status.write_level_done
    engine.io.read_calib_done  := ddr3.io.status.read_calib_done
    engine.io.wstep            := ddr3.io.status.wstep
    engine.io.rclkpos          := ddr3.io.status.rclkpos
    engine.io.rclksel          := ddr3.io.status.rclksel
    engine.io.best_rot         := ddr3.io.status.best_rot
    engine.io.best_score       := ddr3.io.status.best_score
    engine.io.dbg_state        := ddr3.io.status.dbg_state

    io.uart_txp := engine.io.uart_tx

    // Drive LEDs (active-low on Tang Primer 20K)
    io.led(0) := !ddr3.io.pll_lock
    io.led(1) := !ddr3.io.status.init_done
    io.led(2) := !ddr3.io.status.write_level_done
    io.led(3) := !ddr3.io.status.read_calib_done
    io.led(4) := !engine.io.heartbeat
    io.led(5) := !engine.io.test_busy
    io.led(6) := !engine.io.test_error
    io.led(7) := !engine.io.test_pass

    // Second LED bank displays write leveling delay taps
    io.led2   := ~ddr3.io.status.wstep
  }
}
