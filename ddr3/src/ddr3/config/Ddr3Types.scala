package ddr3

import spinal.core._
import spinal.lib._

/**
 * Physical DDR3 pin interface for Tang Primer 20K (Gowin GW2A-LV18PG256C8/I7).
 * Signal names match tang20k.cst constraint file.
 */
case class Ddr3Pins(rowWidth: Int = 14, bankWidth: Int = 3) extends Bundle with IMasterSlave {
  val DDR3_DQ     = inout(Analog(Bits(16 bits)))
  val DDR3_DQS    = inout(Analog(Bits(2 bits)))
  val DDR3_DM     = Bits(2 bits)
  val DDR3_A      = Bits(rowWidth bits)
  val DDR3_BA     = Bits(bankWidth bits)
  val DDR3_nRAS   = Bool()
  val DDR3_nCAS   = Bool()
  val DDR3_nWE    = Bool()
  val DDR3_nCS    = Bool()
  val DDR3_CK     = Bool()
  val DDR3_CKE    = Bool()
  val DDR3_nRESET = Bool()
  val DDR3_ODT    = Bool()

  override def asMaster(): Unit = {
    out(DDR3_DM, DDR3_A, DDR3_BA, DDR3_nRAS, DDR3_nCAS, DDR3_nWE, DDR3_nCS, DDR3_CK, DDR3_CKE, DDR3_nRESET, DDR3_ODT)
  }
}

object Ddr3State extends SpinalEnum {
  val RST_WAIT, CKE_WAIT, CONFIG, ZQCL, WRITE_LEVELING, READ_CALIB, IDLE, READ, WRITE, PRECHARGE, REFRESH = newElement()
}

/** Native 128-bit DDR3 controller request (1 BL8 x16 burst). */
case class Ddr3Req(config: Ddr3Config) extends Bundle {
  val write = Bool()
  val addr  = UInt(config.addrWidth bits)
  val wdata = Bits(128 bits)
  val wstrb = Bits(16 bits)
}

/** Native 128-bit DDR3 controller read response. */
case class Ddr3Rsp() extends Bundle {
  val rdata = Bits(128 bits)
}

/** Grouped initialization, calibration, and debug status outputs. */
case class Ddr3Status() extends Bundle {
  val init_done        = Bool()
  val write_level_done = Bool()
  val read_calib_done  = Bool()
  val wstep            = Bits(8 bits)
  val rclkpos          = Bits(2 bits)
  val rclksel          = Bits(3 bits)
  val best_rot         = UInt(3 bits)
  val best_score       = UInt(4 bits)
  val dbg_state        = Bits(4 bits)
}

/** Direct interface between Ddr3ControllerCore and GowinDdr3Phy. */
case class Ddr3CorePhyIo(config: Ddr3Config) extends Bundle {
  val dlllock      = in Bool()
  val rst_lock_n   = in Bool()
  val rburst       = in Bits(2 bits)
  val rvalid       = if (!config.isSimulation) (in Bits(2 bits)) else null
  val wpoint       = if (!config.isSimulation) (in Vec(Bits(3 bits), 2)) else null
  val rpoint       = if (!config.isSimulation) (in Vec(Bits(3 bits), 2)) else null
  val dq_in        = in Vec(Bits(16 bits), 8)
  val dq_raw       = in Bits(16 bits)

  val dqs_hold     = out Bool()
  val wstep        = out Bits(8 bits)
  val rloadn       = out Bool()
  val rmove        = out Bool()
  val rdir         = out Bool()
  val rclkpos      = out Bits(2 bits)
  val rclksel      = out Bits(3 bits)
  val dqs_read     = out Bits(4 bits)
  val dq_out       = out Vec(Bits(16 bits), 8)
  val dq_oen       = out Bits(4 bits)
  val dqs_out      = out Bits(8 bits)
  val dqs_oen      = out Bits(4 bits)
  val dm_out       = out Bits(8 bits)

  val nRAS         = out Vec(Bool(), 4)
  val nCAS         = out Vec(Bool(), 4)
  val nWE          = out Vec(Bool(), 4)
  val A            = out Vec(Bits(config.rowWidth bits), 4)
  val BA           = out Vec(Bits(config.bankWidth bits), 4)
  val CKE          = out Bool()
  val resetn_delay = out Bool()
  val wser_rst     = if (!config.isSimulation) (out Bool()) else null
}
