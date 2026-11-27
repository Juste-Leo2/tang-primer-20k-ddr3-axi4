package ddr3

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

/**
 * Complete AXI4 DDR3 Controller for Tang Primer 20K.
 * Directly compatible with SpinalML DdrAdapter (extIo.ddrMaster) and general AXI4 hosts.
 *
 * Features:
 * - Supports 32-bit, 64-bit (default), and 128-bit AXI4 data widths
 * - Optional automatic clock-domain crossing (Axi4CC) when axiClockDomain is provided
 * - Assembles Ddr3Axi4Bridge + Ddr3Controller (FSM + GowinDdr3Phy)
 */
class Ddr3Axi4(
  val axiConfig: Axi4Config = Ddr3Axi4.defaultAxiConfig(),
  val config: Ddr3Config = Ddr3Config(),
  val axiClockDomain: Option[ClockDomain] = None
) extends Component {
  val io = new Bundle {
    // Clocking and resets from PLL
    val pclk    = in Bool()
    val fclk    = in Bool()
    val ck      = in Bool()
    val resetn  = in Bool()

    // AXI4 slave interface connected to host / accelerator master
    val axi     = slave(Axi4(axiConfig))

    // Status and calibration indicators
    val init_done        = out Bool()
    val write_level_done = out Bool()
    val read_calib_done  = out Bool()
    val wstep            = out Bits(8 bits)
    val rclkpos          = out Bits(2 bits)
    val rclksel          = out Bits(3 bits)
    val best_rot         = out UInt(3 bits)
    val best_score       = out UInt(4 bits)
    val dbg_state        = out Bits(4 bits)

    // Physical DDR3 memory pads (tang20k.cst constraints)
    val pad     = master(Ddr3Pins(config.rowWidth, config.bankWidth))
  }

  val coreDomain = ClockDomain(
    clock = io.pclk,
    reset = !io.resetn,
    config = ClockDomainConfig(resetKind = ASYNC, resetActiveLevel = HIGH)
  )

  val area = new ClockingArea(coreDomain) {
    val bridge = new Ddr3Axi4Bridge(axiConfig, config)
    val ctrl   = new Ddr3Controller(config)

    // Clocks
    ctrl.io.pclk   := io.pclk
    ctrl.io.fclk   := io.fclk
    ctrl.io.ck     := io.ck
    ctrl.io.resetn := io.resetn

    // Pads
    io.pad <> ctrl.io.pad

    // AXI slave (direct in coreDomain, or crossed via Axi4CC from axiClockDomain)
    axiClockDomain match {
      case None =>
        bridge.io.axi <> io.axi
      case Some(userCd) =>
        val cc = new Axi4CC(
          axiConfig  = axiConfig,
          inputCd    = userCd,
          outputCd   = coreDomain,
          arFifoSize = 8,
          awFifoSize = 8,
          rFifoSize  = 16,
          wFifoSize  = 16,
          bFifoSize  = 8
        )
        cc.io.input   <> io.axi
        bridge.io.axi <> cc.io.output
    }

    bridge.io.init_done := ctrl.io.init_done

    // Bridge <-> Controller
    ctrl.io.req <> bridge.io.req
    bridge.io.rsp <> ctrl.io.rsp

    // Status
    io.init_done        := ctrl.io.init_done
    io.write_level_done := ctrl.io.write_level_done
    io.read_calib_done  := ctrl.io.read_calib_done
    io.wstep            := ctrl.io.wstep
    io.rclkpos          := ctrl.io.rclkpos
    io.rclksel          := ctrl.io.rclksel
    io.best_rot         := ctrl.io.best_rot
    io.best_score       := ctrl.io.best_score
    io.dbg_state        := ctrl.io.dbg_state
  }
}

object Ddr3Axi4 {
  def defaultAxiConfig(
    dataWidth: Int    = 64,
    addressWidth: Int = 32,
    idWidth: Int      = 4
  ): Axi4Config = Axi4Config(
    addressWidth = addressWidth,
    dataWidth    = dataWidth,
    idWidth      = idWidth
  )
}
