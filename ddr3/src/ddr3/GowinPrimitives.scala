package ddr3

import spinal.core._

/**
 * Gowin GW2A hardware primitives for DDR3 memory controller.
 * Directly corresponds to Gowin primitives used in ddr3_controller.v:
 * - DLL: Phase delay line for calibration
 * - DQS: Dynamic DQS strobe delay and read/write pointer manager
 * - OSER8_MEM: 8:1 Output SerDes with memory clocking
 * - IDES8_MEM: 1:8 Input DeSerDes with DQS FIFO
 * - OSER8: 8:1 Output SerDes for command and address lines
 * - IOBUF: Bidirectional I/O buffer for DQ and DQS
 * - Gowin_rPLL: PLL generating 400 MHz (fclk), 400 MHz 90-deg (ck), 100 MHz (pclk)
 */

class DLL extends BlackBox {
  addGeneric("SCAL_EN", "true")
  addGeneric("CODESCAL", "101") // 68-degree phase shift for DDR3-800

  val io = new Bundle {
    val CLKIN    = in Bool()
    val RESET    = in Bool()
    val STOP     = in Bool()
    val UPDNCNTL = in Bool()
    val STEP     = out Bits(8 bits)
    val LOCK     = out Bool()
  }
  noIoPrefix()
}

class DQS extends BlackBox {
  addGeneric("DQS_MODE", "X4")
  addGeneric("HWL", "false")

  val io = new Bundle {
    val FCLK     = in Bool()
    val PCLK     = in Bool()
    val DQSIN    = in Bool()
    val RESET    = in Bool()
    val HOLD     = in Bool()
    val RLOADN   = in Bool()
    val WLOADN   = in Bool()
    val RMOVE    = in Bool()
    val WMOVE    = in Bool()
    val DLLSTEP  = in Bits(8 bits)
    val WSTEP    = in Bits(8 bits)
    val RCLKSEL  = in Bits(3 bits)
    val READ     = in Bits(4 bits)
    val DQSR90   = out Bool()
    val WPOINT   = out Bits(3 bits)
    val RPOINT   = out Bits(3 bits)
    val DQSW0    = out Bool()
    val DQSW270  = out Bool()
    val RBURST   = out Bool()
  }
  noIoPrefix()
}

class OSER8_MEM(tclkSource: String = "DEFAULT") extends BlackBox {
  if (tclkSource != "DEFAULT") {
    addGeneric("TCLK_SOURCE", tclkSource)
  }

  val io = new Bundle {
    val D0    = in Bool()
    val D1    = in Bool()
    val D2    = in Bool()
    val D3    = in Bool()
    val D4    = in Bool()
    val D5    = in Bool()
    val D6    = in Bool()
    val D7    = in Bool()
    val TX0   = in Bool()
    val TX1   = in Bool()
    val TX2   = in Bool()
    val TX3   = in Bool()
    val FCLK  = in Bool()
    val PCLK  = in Bool()
    val TCLK  = in Bool()
    val RESET = in Bool()
    val Q0    = out Bool()
    val Q1    = out Bool()
  }
  noIoPrefix()
}

class IDES8_MEM extends BlackBox {
  val io = new Bundle {
    val D     = in Bool()
    val ICLK  = in Bool()
    val FCLK  = in Bool()
    val PCLK  = in Bool()
    val CALIB = in Bool()
    val RESET = in Bool()
    val WADDR = in Bits(3 bits)
    val RADDR = in Bits(3 bits)
    val Q0    = out Bool()
    val Q1    = out Bool()
    val Q2    = out Bool()
    val Q3    = out Bool()
    val Q4    = out Bool()
    val Q5    = out Bool()
    val Q6    = out Bool()
    val Q7    = out Bool()
  }
  noIoPrefix()
}

class OSER8 extends BlackBox {
  val io = new Bundle {
    val D0    = in Bool()
    val D1    = in Bool()
    val D2    = in Bool()
    val D3    = in Bool()
    val D4    = in Bool()
    val D5    = in Bool()
    val D6    = in Bool()
    val D7    = in Bool()
    val TX0   = in Bool() default(False)
    val TX1   = in Bool() default(False)
    val TX2   = in Bool() default(False)
    val TX3   = in Bool() default(False)
    val FCLK  = in Bool()
    val PCLK  = in Bool()
    val RESET = in Bool()
    val Q0    = out Bool()
    val Q1    = out Bool()
  }
  noIoPrefix()
}

class IOBUF extends BlackBox {
  val io = new Bundle {
    val I   = in Bool()
    val OEN = in Bool()
    val O   = out Bool()
    val IO  = inout(Analog(Bool()))
  }
  noIoPrefix()
}

class Gowin_rPLL extends BlackBox {
  val io = new Bundle {
    val clkin   = in Bool()
    val clkout  = out Bool() // fclk ~400 MHz
    val clkoutp = out Bool() // ck 90-degree shifted
    val clkoutd = out Bool() // pclk ~100 MHz
    val lock    = out Bool()
  }
  noIoPrefix()
}
