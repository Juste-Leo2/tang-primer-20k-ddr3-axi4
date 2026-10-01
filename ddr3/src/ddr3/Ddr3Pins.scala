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
