package ddr3

/**
 * DDR3 timing, geometry, and calibration parameters.
 *
 * Default configuration targets the Tang Primer 20K (GW2A-18C) running at
 * 303.75 MHz DDR3 clock (fclk) / 75.9375 MHz primary controller clock (pclk),
 * using DDR3-800 JEDEC cycle counts (tCK = 2.5ns conservative margin).
 */
case class Ddr3Config(
  rowWidth: Int       = 14,
  colWidth: Int       = 10,
  bankWidth: Int      = 3,
  isSimulation: Boolean = false,
  pclkHz: Int         = 75937500,
  refreshIntervalNs: Int = 7800
) {
  require(rowWidth >= 12 && rowWidth <= 16, s"Invalid rowWidth=$rowWidth")
  require(colWidth >= 8 && colWidth <= 12, s"Invalid colWidth=$colWidth")
  require(bankWidth == 3, s"DDR3 requires bankWidth=3, got $bankWidth")
  require(pclkHz > 0, s"pclkHz must be positive, got $pclkHz")

  /** Block address width (1 block = 128 bits = 16 bytes = 1 BL8 x16 burst). */
  def addrWidth: Int = rowWidth + colWidth + bankWidth

  // Timing constants in CK cycles (DDR3-800 conservative margin)
  val CAS    = 6
  val CWL    = 5
  val WR     = 6
  val MRD    = 8
  val RP     = 6
  val RCD    = 6
  val RC     = 20
  val MOD    = 12
  val RFC    = 64 // tRFC in CK cycles: 64 x 2.5ns = 160ns, covers 1Gb (110ns) and 2Gb (160ns).
                  // The auto-refresh state must wait RFC before the next ACT,
                  // otherwise the refreshed rows (incl. the row under test) get corrupted.
  val WLMRD  = 44
  val SERDES = 16

  /** 1 microsecond in pclk cycles (76 at 75.9375 MHz HW; 100 in 100 MHz sim). */
  val usec: Int = if (isSimulation) 100 else math.max(1, math.round(pclkHz / 1000000.0).toInt)

  /** Auto-refresh interval in pclk cycles (7.8 us = 592 cycles @ 75.94 MHz). */
  val refreshPeriod: Int =
    if (isSimulation) 200 else ((pclkHz.toLong * refreshIntervalNs) / 1000000000L).toInt

  // Iteration counts for calibration
  // HW requires 2 consecutive WL matches: a single-hit lock proved marginal on silicon.
  val wlevelCount = 2
  // Majority vote: strobes per wstep and hits needed for a verdict.
  val WL_VOTES = 4
  val WL_VOTE_TH = 2
  // Lock offset added to the count-complete wstep at lock time.
  val WL_LOCK_OFF = 0
  // Read-delay sweep range, RELATIVE taps around the DLL lock via DQS dynamic steppers.
  val dllSweepRange = 64
  // Anchor-base scan (outer loop around the DLL sweep, full-sweep mode only).
  val anchorScanStep = 2
  val anchorScanRange = if (isSimulation) 8 else 64
  val rcalibCount = if (isSimulation) 2 else 8
}

object Ddr3Config {
  /** Hardware configuration preset for Tang Primer 20K (75.9375 MHz pclk / 303.75 MHz DDR3). */
  def tangPrimer20k(
    rowWidth: Int  = 14,
    colWidth: Int  = 10,
    bankWidth: Int = 3,
    pclkHz: Int    = 75937500
  ): Ddr3Config = Ddr3Config(
    rowWidth = rowWidth,
    colWidth = colWidth,
    bankWidth = bankWidth,
    isSimulation = false,
    pclkHz = pclkHz
  )

  /** Fast-initialization simulation preset for Verilator / iverilog / formal. */
  def simulation(
    rowWidth: Int  = 14,
    colWidth: Int  = 10,
    bankWidth: Int = 3
  ): Ddr3Config = Ddr3Config(
    rowWidth = rowWidth,
    colWidth = colWidth,
    bankWidth = bankWidth,
    isSimulation = true
  )
}
