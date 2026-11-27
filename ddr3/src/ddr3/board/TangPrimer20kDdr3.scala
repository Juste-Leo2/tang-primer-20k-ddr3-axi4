package ddr3

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

/**
 * Plug-and-play DDR3 AXI4 subsystem for Tang Primer 20K (Gowin GW2A-LV18PG256C8/I7).
 *
 * Includes:
 * - Gowin_rPLL (27 MHz oscillator -> 303.75 MHz DDR3 clock + 90-deg CK + 75.9375 MHz system pclk)
 * - Autonomous 65535-cycle Power-On-Reset counter gated with PLL lock and sys_resetn
 * - Ddr3Axi4 controller supporting 32, 64 (default), or 128-bit AXI4 + optional Axi4CC CDC
 *
 * User logic can either run inside `controllerClockDomain` (clk_out / rstn_out) or supply
 * its own `axiClockDomain = Some(myClockDomain)` for automatic AXI4 clock-domain crossing.
 */
class TangPrimer20kDdr3(
  val axiConfig: Axi4Config = Ddr3Axi4.defaultAxiConfig(),
  val config: Ddr3Config = Ddr3Config.tangPrimer20k(),
  val axiClockDomain: Option[ClockDomain] = None
) extends Component {
  val io = new Bundle {
    // Board inputs (27 MHz crystal + active-low reset button)
    val sys_clk    = in Bool()
    val sys_resetn = in Bool()

    // Ready-to-use system clock, active-low reset, and grouped status
    val clk_out    = out Bool()
    val rstn_out   = out Bool()
    val pll_lock   = out Bool()
    val init_done  = out Bool()
    val status     = out(Ddr3Status())

    // AXI4 slave port (in controllerClockDomain by default, or axiClockDomain when set)
    val axi        = slave(Axi4(axiConfig))

    // Physical DDR3 pins (matches tang20k.cst)
    val pad        = master(Ddr3Pins(config.rowWidth, config.bankWidth))
  }

  // 1. Gowin rPLL
  val pll = new Gowin_rPLL()
  pll.io.clkin := io.sys_clk

  val fclk    = pll.io.clkout   // ~303.75 MHz fast DDR clock
  val ck      = pll.io.clkoutp  // ~303.75 MHz 90-degree clock
  val pclk    = pll.io.clkoutd  // ~75.9375 MHz primary controller clock
  val pllLock = pll.io.lock

  // 2. Autonomous Power-On-Reset (POR) counter in pclk domain
  val porDomain = ClockDomain(
    clock  = pclk,
    config = ClockDomainConfig(resetKind = BOOT)
  )
  val porDone = porDomain {
    val cnt = Reg(UInt(16 bits)) init(0)
    when(pllLock && cnt =/= 65535) {
      cnt := cnt + 1
    } elsewhen(!pllLock) {
      cnt := 0
    }
    cnt === 65535
  }

  val globalResetn = io.sys_resetn & porDone

  io.clk_out  := pclk
  io.rstn_out := globalResetn
  io.pll_lock := pllLock

  /** ClockDomain ready to wrap host logic synchronous with the DDR3 controller (75.94 MHz). */
  val controllerClockDomain = ClockDomain(
    clock  = pclk,
    reset  = !globalResetn,
    config = ClockDomainConfig(resetKind = ASYNC, resetActiveLevel = HIGH)
  )

  // 3. AXI4 DDR3 Controller
  val ddr3 = new Ddr3Axi4(axiConfig, config, axiClockDomain)
  ddr3.io.pclk   := pclk
  ddr3.io.fclk   := fclk
  ddr3.io.ck     := ck
  ddr3.io.resetn := globalResetn

  ddr3.io.axi <> io.axi
  io.pad      <> ddr3.io.pad

  io.init_done               := ddr3.io.init_done
  io.status.init_done        := ddr3.io.init_done
  io.status.write_level_done := ddr3.io.write_level_done
  io.status.read_calib_done  := ddr3.io.read_calib_done
  io.status.wstep            := ddr3.io.wstep
  io.status.rclkpos          := ddr3.io.rclkpos
  io.status.rclksel          := ddr3.io.rclksel
  io.status.best_rot         := ddr3.io.best_rot
  io.status.best_score       := ddr3.io.best_score
  io.status.dbg_state        := ddr3.io.dbg_state
}

object TangPrimer20kDdr3 {
  def apply(
    dataWidth: Int = 64,
    addressWidth: Int = 32,
    idWidth: Int = 4,
    axiClockDomain: Option[ClockDomain] = None,
    config: Ddr3Config = Ddr3Config.tangPrimer20k()
  ): TangPrimer20kDdr3 = {
    new TangPrimer20kDdr3(
      axiConfig = Ddr3Axi4.defaultAxiConfig(dataWidth, addressWidth, idWidth),
      config = config,
      axiClockDomain = axiClockDomain
    )
  }
}
