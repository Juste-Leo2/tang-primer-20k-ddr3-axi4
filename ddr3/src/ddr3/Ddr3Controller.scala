package ddr3

import spinal.core._
import spinal.lib._

/**
 * Complete DDR3 Controller for Gowin GW2A (Tang Primer 20K).
 * Integrates:
 * - Ddr3ControllerCore (FSM, Calibration, 128-bit Burst Engine, Refresh)
 * - GowinDdr3Phy (OSER8, IDES8_MEM, DQS, DLL primitives, IOBUFs)
 */
class Ddr3Controller(val config: Ddr3Config = Ddr3Config()) extends Component {
  val io = new Bundle {
    // Clocking and resets from PLL
    val pclk    = in Bool() // ~100 MHz primary clock
    val fclk    = in Bool() // ~400 MHz fast clock
    val ck      = in Bool() // 90-degree shifted fclk
    val resetn  = in Bool() // System reset (active low)

    // User / Arbiter interface (128-bit burst transactions)
    val req = slave Stream(Ddr3Req(config))
    val rsp = master Flow(Ddr3Rsp())

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
    val wlMap            = out Bits(256 bits)
    val wlFirst          = out Bits(8 bits)
    val wlLast           = out Bits(8 bits)
    val wlMatchN         = out Bits(8 bits)
    val brkScores        = out Bits(20 bits)

    // Physical DDR3 memory pads (matches tang20k.cst constraints)
    val pad = master(Ddr3Pins(config.rowWidth, config.bankWidth))
  }

  // 1. Instantiation of Controller Core within the primary clock domain
  val coreDomain = ClockDomain(
    clock = io.pclk,
    reset = !io.resetn,
    config = ClockDomainConfig(resetKind = ASYNC, resetActiveLevel = HIGH)
  )

  val coreArea = new ClockingArea(coreDomain) {
    val core = new Ddr3ControllerCore(config)
  }

  // 2. Instantiation of PHY Layer
  val phy = new GowinDdr3Phy(config.rowWidth, config.bankWidth)

  // Clock routing to PHY
  phy.io.pclk   := io.pclk
  phy.io.fclk   := io.fclk
  phy.io.ck     := io.ck
  phy.io.resetn := io.resetn

  // Connect Core <-> PHY
  phy.io.dqs_hold     := coreArea.core.io.phy.dqs_hold
  phy.io.wstep        := coreArea.core.io.phy.wstep
  phy.io.rclkpos      := coreArea.core.io.phy.rclkpos
  phy.io.rclksel      := coreArea.core.io.phy.rclksel
  phy.io.dqs_read     := coreArea.core.io.phy.dqs_read
  phy.io.dq_out       := coreArea.core.io.phy.dq_out
  phy.io.dq_oen       := coreArea.core.io.phy.dq_oen
  phy.io.dqs_out      := coreArea.core.io.phy.dqs_out
  phy.io.dqs_oen      := coreArea.core.io.phy.dqs_oen
  phy.io.dm_out       := coreArea.core.io.phy.dm_out
  phy.io.nRAS         := coreArea.core.io.phy.nRAS
  phy.io.nCAS         := coreArea.core.io.phy.nCAS
  phy.io.nWE          := coreArea.core.io.phy.nWE
  phy.io.A            := coreArea.core.io.phy.A
  phy.io.BA           := coreArea.core.io.phy.BA
  phy.io.CKE          := coreArea.core.io.phy.CKE
  phy.io.resetn_delay := coreArea.core.io.phy.resetn_delay

  coreArea.core.io.phy.dlllock    := phy.io.dlllock
  coreArea.core.io.phy.rst_lock_n := phy.io.rst_lock_n
  coreArea.core.io.phy.rburst     := phy.io.rburst
  coreArea.core.io.phy.dq_in      := phy.io.dq_in
  coreArea.core.io.phy.dq_raw     := phy.io.dq_raw

  // Connect Physical Pads
  io.pad <> phy.io.pad

  // Connect User Interface
  coreArea.core.io.req <> io.req
  io.rsp <> coreArea.core.io.rsp

  // Status indicators
  io.init_done        := coreArea.core.io.init_done
  io.write_level_done := coreArea.core.io.write_level_done
  io.read_calib_done  := coreArea.core.io.read_calib_done
  io.wstep            := coreArea.core.io.wstep
  io.rclkpos          := coreArea.core.io.rclkpos
  io.rclksel          := coreArea.core.io.rclksel
  io.best_rot         := coreArea.core.io.best_rot
  io.best_score       := coreArea.core.io.best_score
  io.dbg_state        := coreArea.core.io.dbg_state
  io.wlMap            := coreArea.core.io.wlMap
  io.wlFirst          := coreArea.core.io.wlFirst
  io.wlLast           := coreArea.core.io.wlLast
  io.wlMatchN         := coreArea.core.io.wlMatchN
  io.brkScores        := coreArea.core.io.brkScores
}
