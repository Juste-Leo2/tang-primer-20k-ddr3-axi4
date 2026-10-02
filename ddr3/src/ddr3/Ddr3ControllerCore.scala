package ddr3

import spinal.core._
import spinal.lib._

/**
 * DDR3 timing and configuration parameters.
 * Default is DDR3-800 timing (tCK = 2.5ns, pclk = 100MHz).
 */
case class Ddr3Config(
  rowWidth: Int       = 14,
  colWidth: Int       = 10,
  bankWidth: Int      = 3,
  isSimulation: Boolean = false
) {
  def addrWidth: Int = rowWidth + colWidth + bankWidth

  // Timing constants in CK cycles (DDR3-800, tCK = 2.5ns)
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

  // Delays in pclk cycles
  val usec = 100 // 1 microsecond in 100 MHz pclk cycles

  // Iteration counts for calibration
  val wlevelCount = if (isSimulation) 2 else 1
  val rcalibCount = if (isSimulation) 2 else 8
}

object Ddr3State extends SpinalEnum {
  val RST_WAIT, CKE_WAIT, CONFIG, ZQCL, WRITE_LEVELING, READ_CALIB, IDLE, READ, WRITE, REFRESH = newElement()
}

case class Ddr3Req(config: Ddr3Config) extends Bundle {
  val write = Bool()
  val addr  = UInt(config.addrWidth bits)
  val wdata = Bits(128 bits)
  val wstrb = Bits(16 bits)
}

case class Ddr3Rsp() extends Bundle {
  val rdata = Bits(128 bits)
}

/**
 * DDR3 Controller Core logic:
 * - Initialization sequence (Reset, CKE, MRS MR0..MR3, ZQCL)
 * - Auto-calibration (Write Leveling + Read Calibration)
 * - 128-bit burst read and write
 * - Autonomous refresh timer (7.8 us periodic)
 */
class Ddr3ControllerCore(val config: Ddr3Config = Ddr3Config()) extends Component {
  val io = new Bundle {
    // User / Arbiter interface
    val req = slave Stream(Ddr3Req(config))
    val rsp = master Flow(Ddr3Rsp())

    // Autonomous refresh forced externally if needed, or status
    val init_done   = out Bool()
    val write_level_done = out Bool()
    val read_calib_done  = out Bool()
    val wstep       = out Bits(8 bits)
    val rclkpos     = out Bits(2 bits)
    val rclksel     = out Bits(3 bits)

    // Direct interface to GowinDdr3Phy
    val phy = new Bundle {
      val dlllock     = in Bool()
      val rst_lock_n  = in Bool()
      val rburst      = in Bits(2 bits)
      val dq_in       = in Vec(Bits(16 bits), 8)
      val dq_raw      = in Bits(16 bits)

      val dqs_hold    = out Bool()
      val wstep       = out Bits(8 bits)
      val rclkpos     = out Bits(2 bits)
      val rclksel     = out Bits(3 bits)
      val dqs_read    = out Bits(4 bits)
      val dq_out      = out Vec(Bits(16 bits), 8)
      val dq_oen      = out Bits(4 bits)
      val dqs_out     = out Bits(8 bits)
      val dqs_oen     = out Bits(4 bits)
      val dm_out      = out Bits(8 bits)

      val nRAS        = out Vec(Bool(), 4)
      val nCAS        = out Vec(Bool(), 4)
      val nWE         = out Vec(Bool(), 4)
      val A           = out Vec(Bits(config.rowWidth bits), 4)
      val BA          = out Vec(Bits(config.bankWidth bits), 4)
      val CKE         = out Bool()
      val resetn_delay = out Bool()
    }
  }

  // DDR3 Command definitions: {nRAS, nCAS, nWE}
  val CMD_SetModeReg   = B"3'b000"
  val CMD_AutoRefresh  = B"3'b001"
  val CMD_PreCharge    = B"3'b010"
  val CMD_BankActivate = B"3'b011"
  val CMD_Write        = B"3'b100"
  val CMD_Read         = B"3'b101"
  val CMD_ZQCL         = B"3'b110"
  val CMD_NOP          = B"3'b111"

  // Mode Register definitions (DDR3-800)
  val M_BL       = B"2'b01"    // BC4 or 8 on the fly
  val M_CAS      = B"4'b0100"  // 6 cycles
  val M_CWL      = B"3'b000"   // 5 cycles
  val M_WR       = B"3'b010"   // 6 cycles
  val M_DLLReset = True
  val M_RTT_NOM  = B"3'b000"   // Disabled
  val M_RTT_WR   = B"2'b01"    // 60 ohm dynamic ODT
  val M_DRIVE    = B"2'b00"    // low drive strength
  val M_AL       = B"2'b00"

  val MR0 = B"3'b000" ## False ## M_WR ## M_DLLReset ## False ## M_CAS(3 downto 1) ## False ## M_CAS(0) ## M_BL
  val MR1 = B"3'b001" ## B"3'b000" ## M_RTT_NOM(2) ## B"2'b00" ## M_RTT_NOM(1) ## M_DRIVE(1) ## M_AL ## M_RTT_NOM(0) ## M_DRIVE(0) ## False
  val MR2 = B"3'b010" ## B"7'b0000000" ## M_CWL ## B"3'b000"
  val MR2_RTT_WR = B"3'b010" ## B"2'b00" ## M_RTT_WR ## B"3'b000" ## M_CWL ## B"3'b000"
  val MR3 = B"3'b011" ## B"13'b0"

  // State registers
  val state        = RegInit(Ddr3State.RST_WAIT)
  val cycle        = Reg(UInt(5 bits)) init(0)
  val tick_counter = Reg(UInt(17 bits)) init(if (config.isSimulation) 1 else 60000)
  val tick         = RegInit(False)

  val resetn_delay = RegInit(False)
  val CKE          = RegInit(False)
  val busy         = RegInit(True)
  val data_ready   = RegInit(False)
  val init_done_latched = RegInit(False)

  val wlevel_done  = RegInit(False)
  val wlevel_cnt   = Reg(UInt(4 bits)) init(0)
  val wstep        = Reg(Bits(8 bits)) init(if (config.isSimulation) B"8'h18" else B"8'h00")

  val rcalib_done  = RegInit(False)
  val rcalib_cnt   = Reg(UInt(4 bits)) init(0)
  // SIM-only watchdog: counts calib misses so a never-locking sweep
  // cannot hang iverilog forever (wall-clock). HW path untouched.
  val rcalib_tries = Reg(UInt(6 bits)) init(0)
  val rclkpos      = Reg(Bits(2 bits)) init(if (config.isSimulation) B"2'd0" else B"2'd0")
  val rclksel      = Reg(Bits(3 bits)) init(if (config.isSimulation) B"3'd0" else B"3'd0")
  val rburst_seen  = Reg(Bits(2 bits)) init(0)
  val dqs_hold     = RegInit(False)

  // Data-eye training (option 2): a known pattern is written once to block 0
  // through the normal WRITE path, then the read sweep compares full 128-bit
  // data (not just RBURST strobe detect, which is blind to partial bursts).
  // NOTE: training clobbers block 0 (undefined at power-up per JEDEC; on a
  // re-reset previous contents of block 0 are lost — documented tradeoff).
  val trainPat  = B"128'h10071006100510041003100210011000" // 8 distinct beats
  val training  = RegInit(True)
  val trainDone = RegInit(False)
  // Latched copy of the 128-bit assembly, captured at the exact
  // functional data_ready cycle (RCD/4+10). The IDES read pointer
  // free-runs on FCLK, so a live compare one cycle later would sample a
  // different FIFO rotation than the functional path uses.
  val trainLatch = Reg(Bits(128 bits)) init(0)
  // Beat slices of the latched capture and of the expected pattern.
  val latchBeats = Vec(Bits(16 bits), 8)
  val patBeats = Vec(Bits(16 bits), 8)
  for (i <- 0 until 8) {
    latchBeats(i) := trainLatch(i * 16 + 15 downto i * 16)
    patBeats(i) := trainPat(i * 16 + 15 downto i * 16)
  }
  // Rotation search: the double-burst fill order is a deterministic rotation
  // of the 8 beats (sim measures rot=6 on most settings). Score all 8
  // rotations (X-hostile ===: stale/partial captures never match) and keep
  // the best. The locked rotation is applied to the functional readout, so
  // the design self-adapts instead of assuming a fixed assembly order.
  val rotScores = Vec(UInt(4 bits), 8)
  for (r <- 0 until 8) {
    var acc: UInt = U(0, 4 bits)
    for (i <- 0 until 8) {
      acc = acc + (latchBeats(i) === patBeats((i + r) % 8)).asUInt.resize(4)
    }
    rotScores(r) := acc
  }
  // Max over rotations, lowest index wins ties (deterministic).
  val rotScoreW = Vec(UInt(4 bits), 8)
  val rotIdxW = Vec(UInt(3 bits), 8)
  for (r <- 0 until 8) {
    if (r == 0) {
      rotScoreW(0) := rotScores(0)
      rotIdxW(0) := 0
    } else {
      val better = rotScores(r) > rotScoreW(r - 1)
      rotScoreW(r) := better ? rotScores(r) | rotScoreW(r - 1)
      rotIdxW(r) := better ? U(r, 3 bits) | rotIdxW(r - 1)
    }
  }
  val sweepScore = rotScoreW(7)
  val sweepRot = rotIdxW(7)
  val bestCnt = Reg(UInt(4 bits)) init(0)
  val bestPos = Reg(Bits(2 bits)) init(B"2'd0")
  val bestSel = Reg(Bits(3 bits)) init(B"3'd0")
  val bestRot = Reg(UInt(3 bits)) init(0)

  // Autonomous Refresh timer (every 7.8 us = 781 cycles @ 100MHz)
  // Sim uses a shorter period so iverilog runs cover several refreshes.
  val refreshPeriod = if (config.isSimulation) 200 else 780
  val refresh_timer = Reg(UInt(11 bits)) init(0)
  val refresh_due   = RegInit(False)

  when(state === Ddr3State.IDLE || state === Ddr3State.READ || state === Ddr3State.WRITE) {
    when(refresh_timer === refreshPeriod) {
      refresh_due := True
      refresh_timer := 0
    } otherwise {
      refresh_timer := refresh_timer + 1
    }
  }

  // Latch transaction request
  val reqReg = Reg(Ddr3Req(config))

  // Command & Address outputs to PHY
  val nRAS = Vec(Reg(Bool()) init(True), 4)
  val nCAS = Vec(Reg(Bool()) init(True), 4)
  val nWE  = Vec(Reg(Bool()) init(True), 4)
  val A    = Vec(Reg(Bits(config.rowWidth bits)) init(0), 4)
  val BA   = Vec(Reg(Bits(config.bankWidth bits)) init(0), 4)

  val dq_out  = Vec(Reg(Bits(16 bits)) init(0), 8)
  val dq_oen  = Reg(Bits(4 bits)) init(B"4'b1111")
  val dqs_out = Reg(Bits(8 bits)) init(0)
  val dqs_oen = Reg(Bits(4 bits)) init(B"4'b1111")
  val dm_out  = Reg(Bits(8 bits)) init(B"8'b1111_1111")

  // Helper function to set command on a specific sub-cycle
  def setCmd(subcycle: Int, cmd: Bits, baVal: Bits, aVal: Bits): Unit = {
    nRAS(subcycle) := cmd(2)
    nCAS(subcycle) := cmd(1)
    nWE(subcycle)  := cmd(0)
    BA(subcycle)   := baVal.resized
    A(subcycle)    := aVal.resized
  }

  // Monitor rburst strobe
  when(io.phy.rburst(0)) { rburst_seen(0) := True }
  when(io.phy.rburst(1)) { rburst_seen(1) := True }

  // Generate dqs_read pulse, 4 pclk wide: the rd pipeline (divide-by-4
  // serializers) turns N pclk of dqs_read into ~N*10 ns of rd_en. A
  // double-burst read spans burst1-start to burst2-end (~30 ns), so the
  // window must stay open across BOTH bursts for WPOINT to accumulate all
  // 8 FIFO slots. A 2-cycle pulse covered burst 1 only (VCD-proven:
  // rd_en drained at burst-1 end, dqs_en closed on its trailing edge,
  // burst 2 arrived with the window shut). Same start, longer tail.
  val rdCyc = rclkpos.asUInt.resize(5) + config.RCD / 4 + 1
  val dqs_read = Reg(Bits(4 bits)) init(0)
  dqs_read := 0
  when((state === Ddr3State.READ || state === Ddr3State.READ_CALIB) &&
       (cycle === rdCyc || cycle === rdCyc + 1 || cycle === rdCyc + 2 || cycle === rdCyc + 3)) {
    dqs_read := B"4'b1111"
  }

  // Ready to accept user requests only when in IDLE and no refresh due
  val acceptReq = (state === Ddr3State.IDLE) && !busy && !refresh_due
  io.req.ready := acceptReq

  // Main FSM
  when(io.phy.rst_lock_n) {
    cycle := (cycle === 31) ? U(31, 5 bits) | (cycle + 1)
    tick := (tick_counter === 1)
    tick_counter := (tick_counter === 0) ? U(0, 17 bits) | (tick_counter - 1)

    // Defaults every cycle
    for (i <- 0 until 4) {
      nRAS(i) := True
      nCAS(i) := True
      nWE(i)  := True
      A(i)    := 0
      BA(i)   := 0
    }
    dm_out  := B"8'b1111_1111"
    dqs_oen := B"4'b1111"
    dq_oen  := B"4'b1111"
    dqs_out := 0
    dqs_hold := False

    switch(state) {
      is(Ddr3State.RST_WAIT) {
        when(tick) {
          resetn_delay := True
          tick_counter := (if (config.isSimulation) U(19, 17 bits) else U(500 * config.usec + 20, 17 bits))
          state := Ddr3State.CKE_WAIT
        }
      }

      is(Ddr3State.CKE_WAIT) {
        when(tick_counter === 15) {
          CKE := True
        }
        when(tick) {
          state := Ddr3State.CONFIG
          cycle := 0
        }
      }

      is(Ddr3State.CONFIG) {
        switch(cycle) {
          is(0) {
            setCmd(0, CMD_SetModeReg, MR2(15 downto 13), MR2(12 downto 0))
          }
          is(config.MRD / 4) { // cycle 2
            setCmd(0, CMD_SetModeReg, MR3(15 downto 13), MR3(12 downto 0))
          }
          is(config.MRD / 2) { // cycle 4
            setCmd(0, CMD_SetModeReg, MR1(15 downto 13), MR1(12 downto 0))
          }
          is(config.MRD * 3 / 4) { // cycle 6
            setCmd(0, CMD_SetModeReg, MR0(15 downto 13), MR0(12 downto 0))
          }
          is(config.MRD * 3 / 4 + config.MOD / 4 + 1) { // cycle 10
            // ZQCL (long calibration): BA=0, A[10]=1. CAUTION: bit 10, not bit 0!
            setCmd(0, CMD_ZQCL, B"3'b0", (B"1'b1".resize(config.rowWidth) |<< 10))
            // Wait tZQinit (512 CK for sg25). Sim uses a realistic wait so the
            // Micron model completes init (else every read errors + $stop spam).
            tick_counter := (if (config.isSimulation) U(130, 17 bits) else U(514, 17 bits))
            state := Ddr3State.ZQCL
          }
        }
      }

      is(Ddr3State.ZQCL) {
        when(tick) {
          state := Ddr3State.WRITE_LEVELING
          cycle := 0
        }
      }

      is(Ddr3State.WRITE_LEVELING) {
        switch(cycle) {
          is(0) {
            // Enter write leveling mode: MR1[7] = 1, RTT_NOM = 60 ohm
            val mr1_wlevel = MR1 | B"16'h0084"
            setCmd(0, CMD_SetModeReg, mr1_wlevel(15 downto 13), mr1_wlevel(12 downto 0))
            wlevel_cnt := 0
          }
          is(config.WLMRD / 4 - 1, config.WLMRD / 4 + 1, config.WLMRD / 4 + 2,
             config.WLMRD / 4 + 3, config.WLMRD / 4 + 4, config.WLMRD / 4 + 5) {
            dqs_out := 0
            dqs_oen := 0
          }
          is(config.WLMRD / 4) {
            dqs_out := B"8'b0101_0101" // Test strobe pulse (D0=1, D1=0, D2=1, D3=0...)
            dqs_oen := 0
          }
          is(config.WLMRD / 4 + 6) {
            dqs_out := 0
            dqs_oen := 0
            when(!io.phy.dq_raw(0) || !io.phy.dq_raw(8)) {
              wstep := (wstep.asUInt + 1).asBits
              wlevel_cnt := 0
              cycle := config.WLMRD / 4 - 1 // loop back
            } otherwise {
              wlevel_cnt := wlevel_cnt + 1
              when(wlevel_cnt === config.wlevelCount - 1) {
                wlevel_done := True
                setCmd(0, CMD_SetModeReg, MR1(15 downto 13), MR1(12 downto 0)) // exit write leveling
              } otherwise {
                cycle := config.WLMRD / 4 - 1
              }
            }
          }
          is((config.WLMRD + config.MRD) / 4 + 6) {
            // Turn on dynamic ODT (MR2_RTT_WR)
            setCmd(0, CMD_SetModeReg, MR2_RTT_WR(15 downto 13), MR2_RTT_WR(12 downto 0))
          }
          is((config.WLMRD + config.MRD + config.MOD) / 4 + 6) {
            state := Ddr3State.READ_CALIB
            cycle := 0
          }
        }
      }

      is(Ddr3State.READ_CALIB) {
        // Double-burst capture: ONE BL8 burst only fills ~5 of the 8 IDES
        // FIFO slots (WPOINT follows DQS edges: preamble + 4 periods), while
        // the read side taps 8 slots. The 2nd back-to-back burst fills the
        // complementary gray slots (burst1 {1,3,2,6,7} + burst2 {5,4,0,1,3}),
        // so a single sample after burst2 sees 8 fresh beats. The row stays
        // open across sweep iterations (no auto-precharge); precharged once
        // at lock. dqs_en stays open across both bursts (no trailing DQS
        // edge closes it), which is exactly what lets WPOINT accumulate.
        // NOTE: RBURST strobe-detect is NOT used as a lock gate: with
        // dqs_en stuck open it cannot pulse on later bursts. The full
        // 128-bit data compare is the only lock criterion.
        switch(cycle) {
          is(0) {
            setCmd(0, CMD_BankActivate, B"3'b0", B"0".resized)
            dqs_hold := True // deterministic W/R start for the sweep
            rcalib_cnt := 0
            rcalib_tries := 0
            bestCnt := 0
            bestPos := rclkpos
            bestSel := rclksel
            bestRot := 0
          }
          is(config.RCD / 4) {
            // Burst 1 of 2, BL8 without auto-precharge.
            setCmd(2, CMD_Read, B"3'b0", B"1'b1".resize(config.rowWidth) |<< 12)
            dqs_hold := True // deterministic W/R start each iteration
            rburst_seen := 0
          }
          is(config.RCD / 4 + 1) {
            // Burst 2 of 2 (tCCD = 4 tCK = 1 pclk), same address.
            setCmd(2, CMD_Read, B"3'b0", B"1'b1".resize(config.rowWidth) |<< 12)
          }
          is(config.RCD / 4 + 10) {
            // Latch at the functional data_ready cycle (same RPOINT phase).
            trainLatch := (io.phy.dq_in(7) ## io.phy.dq_in(6) ## io.phy.dq_in(5) ## io.phy.dq_in(4) ##
                           io.phy.dq_in(3) ## io.phy.dq_in(2) ## io.phy.dq_in(1) ## io.phy.dq_in(0))
          }
          is(config.RCD / 4 + 11) {
            // $display is simulation-only: the formal backend lowers
            // report() to assert(1'b0), which would fail the proof.
            if (!GenerationFlags.formal) {
              report(L"RCALIB chk pos=$rclkpos sel=$rclksel seen=$rburst_seen score=$sweepScore rot=$sweepRot latch=$trainLatch best=$bestCnt tries=$rcalib_tries")
            }
            // Best-of-sweep eye search: strictly better rotation-corrected
            // beat score (0..8). No early stop: one full survey, then lock
            // the best setting AND its rotation.
            when(sweepScore > bestCnt) {
              bestCnt := sweepScore
              bestPos := rclkpos
              bestSel := rclksel
              bestRot := sweepRot
            }
            rclksel := (rclksel.asUInt + 1).asBits
            when(rclksel === 7) {
              rclkpos := (rclkpos.asUInt + 1).asBits
            }
            rcalib_cnt := 0
            rcalib_tries := rcalib_tries + 1
            // Survey length covers the full 32-setting grid (plus margin):
            // lock best, precharge, continue to functional tests.
            when(rcalib_tries === 40) {
              if (!GenerationFlags.formal) {
                report(L"RCALIB lock best pos=$bestPos sel=$bestSel rot=$bestRot score=$bestCnt")
              }
              rclkpos := bestPos
              rclksel := bestSel
              rcalib_done := True
              setCmd(0, CMD_PreCharge, B"3'b0", B"0".resized)
            } otherwise {
              cycle := config.RCD / 4 // loop back
            }
          }
          is(config.RCD / 4 + 11 + config.RP / 4) {
            busy  := False
            state := Ddr3State.IDLE
          }
        }
      }

      is(Ddr3State.IDLE) {
        when(training) {
          // Training write: preload block-0 pattern req, reuse the WRITE
          // path (with auto-precharge: row closed after, re-ACTed by calib).
          training := False
          trainDone := True
          reqReg.write := True
          reqReg.addr := 0
          reqReg.wdata := trainPat
          reqReg.wstrb := B"16'hFFFF"
          setCmd(0, CMD_BankActivate, B"3'b0", B"0".resized)
          state := Ddr3State.WRITE
          cycle := 1
          busy := True
        } elsewhen(refresh_due) {
          // Autonomous refresh
          setCmd(0, CMD_AutoRefresh, B"3'b0", B"0".resized)
          state := Ddr3State.REFRESH
          cycle := 1
          busy  := True
          refresh_due := False
        } elsewhen(io.req.valid) {
          reqReg := io.req.payload
          val blockIdx = io.req.addr
          val col  = (blockIdx(config.colWidth - 4 downto 0) @@ U"3'b000").asBits
          val row  = blockIdx(config.colWidth - 4 + config.rowWidth downto config.colWidth - 3).asBits
          val bank = blockIdx(config.colWidth - 4 + config.rowWidth + config.bankWidth downto config.colWidth - 3 + config.rowWidth).asBits

          setCmd(0, CMD_BankActivate, bank, row.resized)
          state := io.req.write ? Ddr3State.WRITE | Ddr3State.READ
          cycle := 1
          busy  := True
          when(!io.req.write) {
            dqs_hold := True
          }
        }
      }

      is(Ddr3State.READ) {
        // Double-burst functional read (mirrors READ_CALIB): two back-to-back
        // BL8 reads WITHOUT auto-precharge so the row stays open for burst 2,
        // then explicit PRECHARGE. Burst 2 fills the FIFO slots burst 1
        // missed; data_ready samples 8 fresh beats.
        val blockIdx = reqReg.addr
        val col  = (blockIdx(config.colWidth - 4 downto 0) @@ U"3'b000").asBits
        val bank = blockIdx(config.colWidth - 4 + config.rowWidth + config.bankWidth downto config.colWidth - 3 + config.rowWidth).asBits

        when(cycle === config.RCD / 4) {
          val readA = (col.resized | B"16'h1000".resized) // A[12]=1 (BL8), A[10]=0 (no AP)
          setCmd(config.RCD % 4, CMD_Read, bank, readA)
          dqs_hold := True
        }

        when(cycle === config.RCD / 4 + 1) {
          val readA2 = (col.resized | B"16'h1000".resized) // 2nd burst, tCCD = 1 pclk
          setCmd(config.RCD % 4, CMD_Read, bank, readA2)
        }

        when(cycle === config.RCD / 4 + 10) {
          data_ready := True
        }

        when(cycle === config.RCD / 4 + 11) {
          data_ready := False
          setCmd(0, CMD_PreCharge, B"3'b0", B"0".resized)
        }

        when(cycle === config.RCD / 4 + 11 + config.RP / 4) {
          busy  := False
          state := Ddr3State.IDLE
        }
      }

      is(Ddr3State.WRITE) {
        val blockIdx = reqReg.addr
        val col  = (blockIdx(config.colWidth - 4 downto 0) @@ U"3'b000").asBits
        val bank = blockIdx(config.colWidth - 4 + config.rowWidth + config.bankWidth downto config.colWidth - 3 + config.rowWidth).asBits

        when(cycle === config.RCD / 4) {
          val writeA = (col.resized | B"16'h1400".resized) // A[12]=1 (BL8), A[10]=1 (AutoPrecharge)
          setCmd(config.RCD % 4, CMD_Write, bank, writeA)
        }

        // Cycle 2: Subcycle 2 (CK 10) = Preamble; Subcycle 3 (CK 11) = Beat 0
        when(cycle === (config.RCD + config.CWL) / 4) {
          dqs_out := B"8'b0100_0000" // D4=0, D5=0 (preamble low); D6=1, D7=0 (Beat 0)
          dqs_oen := B"4'b0011"      // TX2=0, TX3=0 enabled; TX0=1, TX1=1 disabled
          dq_oen  := B"4'b0111"      // TX3=0 enabled; TX0..2=1 disabled

          dq_out(6) := 0
          dq_out(7) := reqReg.wdata(15 downto 0)   // Beat 0

          dm_out(6) := True
          dm_out(7) := !reqReg.wstrb(1 downto 0).orR
        }

        // Cycle 3: Subcycles 0..2 (CK 12..14) = Beats 1..6; Subcycle 3 (CK 15) = Beat 7 + Postamble
        when(cycle === (config.RCD + config.CWL) / 4 + 1) {
          dqs_out := B"8'b0101_0101" // D0..D6 toggle for Beats 1..7; D7=0 postamble
          dqs_oen := B"4'b0000"      // All TX enabled
          dq_oen  := B"4'b0000"      // All TX enabled

          dq_out(0) := reqReg.wdata(31 downto 16)  // Beat 1
          dq_out(1) := reqReg.wdata(47 downto 32)  // Beat 2
          dq_out(2) := reqReg.wdata(63 downto 48)  // Beat 3
          dq_out(3) := reqReg.wdata(79 downto 64)  // Beat 4
          dq_out(4) := reqReg.wdata(95 downto 80)  // Beat 5
          dq_out(5) := reqReg.wdata(111 downto 96) // Beat 6
          dq_out(6) := reqReg.wdata(127 downto 112)// Beat 7
          dq_out(7) := 0

          dm_out(0) := !reqReg.wstrb(3 downto 2).orR
          dm_out(1) := !reqReg.wstrb(5 downto 4).orR
          dm_out(2) := !reqReg.wstrb(7 downto 6).orR
          dm_out(3) := !reqReg.wstrb(9 downto 8).orR
          dm_out(4) := !reqReg.wstrb(11 downto 10).orR
          dm_out(5) := !reqReg.wstrb(13 downto 12).orR
          dm_out(6) := !reqReg.wstrb(15 downto 14).orR
          dm_out(7) := True
        }

        // Cycle 4: Postamble completion (held low) then all return to high-Z
        when(cycle === (config.RCD + config.CWL) / 4 + 2) {
          dqs_out := 0
          dqs_oen := B"4'b1110"      // TX0=0 held low for 1/2 CK postamble
          dq_oen  := B"4'b1111"
        }

        when(cycle === 28 / 4) {
          when(trainDone) {
            // Training write done: back to calib (re-ACTs the row).
            trainDone := False
            state := Ddr3State.READ_CALIB
            cycle := 0
          } otherwise {
            busy  := False
            state := Ddr3State.IDLE
          }
        }
      }

      is(Ddr3State.REFRESH) {
        // Wait full tRFC (not just tRC): the next ACT too early corrupts DRAM contents.
        when(cycle === config.RFC / 4) {
          busy  := False
          state := Ddr3State.IDLE
        }
      }
    }
  } otherwise {
    // Reset condition: park ALL bus-driving regs (OEN high = Hi-Z) so no
    // stale drive persists across a reset. Same values as the per-cycle
    // defaults: zero functional change, but provably clean.
    busy := True
    data_ready := False
    CKE := False
    for (i <- 0 until 4) {
      nRAS(i) := True
      nCAS(i) := True
      nWE(i)  := True
    }
    dq_oen := B"4'b1111"
    dqs_oen := B"4'b1111"
    dqs_out := 0
    dm_out := B"8'b1111_1111"
    for (i <- 0 until 8) {
      dq_out(i) := 0
    }
    dqs_read := 0
    dqs_hold := False
    tick_counter := (if (config.isSimulation) U(1, 17 bits) else U(60000, 17 bits))
    tick := False
    cycle := 0
    wlevel_cnt := 0
    wlevel_done := False
    wstep := (if (config.isSimulation) B"8'h18" else B"8'h00")
    rcalib_cnt := 0
    rcalib_done := False
    rcalib_tries := 0
    bestRot := 0
    training := True
    trainDone := False
    trainLatch := 0
    rclkpos := (if (config.isSimulation) B"2'd0" else B"2'd0")
    rclksel := (if (config.isSimulation) B"3'd0" else B"3'd0")
    init_done_latched := False
    rburst_seen := 0
    resetn_delay := False
    state := Ddr3State.RST_WAIT
  }

  // Feed read data out (128 bits), de-rotated by the locked training
  // rotation: beat j comes from slot (j - bestRot) mod 8.
  val dqVec = Vec(io.phy.dq_in(0), io.phy.dq_in(1), io.phy.dq_in(2), io.phy.dq_in(3),
                  io.phy.dq_in(4), io.phy.dq_in(5), io.phy.dq_in(6), io.phy.dq_in(7))
  def derot(j: Int): UInt = (U(j, 4 bits) - bestRot.resize(4))(2 downto 0)
  val rdataVec = Vec(Bits(16 bits), 8)
  for (j <- 0 until 8) {
    rdataVec(j) := dqVec(derot(j))
  }
  io.rsp.valid := data_ready
  io.rsp.rdata := (rdataVec(7) ## rdataVec(6) ## rdataVec(5) ## rdataVec(4) ##
                   rdataVec(3) ## rdataVec(2) ## rdataVec(1) ## rdataVec(0))

  // Connect control ports to PHY
  io.phy.dqs_hold     := dqs_hold
  io.phy.wstep        := wstep
  io.phy.rclkpos      := rclkpos
  io.phy.rclksel      := rclksel
  io.phy.dqs_read     := dqs_read
  io.phy.dq_out       := dq_out
  io.phy.dq_oen       := dq_oen
  io.phy.dqs_out      := dqs_out
  io.phy.dqs_oen      := dqs_oen
  io.phy.dm_out       := dm_out
  io.phy.nRAS         := nRAS
  io.phy.nCAS         := nCAS
  io.phy.nWE          := nWE
  io.phy.A            := A
  io.phy.BA           := BA
  io.phy.CKE          := CKE
  io.phy.resetn_delay := resetn_delay

  // Status outputs. The set condition is gated by both resets: Spinal emits
  // the domain reset first in the always block, so an unguarded set would
  // override a coincident reset (formal P5 caught exactly this).
  when(io.phy.rst_lock_n && !ClockDomain.current.isResetActive && !busy && (state === Ddr3State.IDLE) && wlevel_done && rcalib_done) {
    init_done_latched := True
  }
  io.init_done        := init_done_latched
  io.write_level_done := wlevel_done
  io.read_calib_done  := rcalib_done
  io.wstep            := wstep
  io.rclkpos          := rclkpos
  io.rclksel          := rclksel

  // Formal properties (SymbiYosys). Only elaborated under the formal
  // backend: zero impact on Ddr3Gen Verilog output.
  // pastValidAfterReset() excludes the X-valued reset-entry cycles so the
  // solver only sees defined states.
  if (GenerationFlags.formal) {
    import spinal.core.formal._
    when(pastValidAfterReset()) {
    // P1: accept exactly in IDLE, idle, no refresh pending
    assert(io.req.ready === (state === Ddr3State.IDLE && !busy && !refresh_due))
    // P2: response handshake mirrors data_ready
    assert(io.rsp.valid === data_ready)
    // P3: 128-bit assembly wiring with locked de-rotation
    // (slice j == dq_in((j - bestRot) mod 8)).
    for (j <- 0 until 8) {
      assert(io.rsp.rdata(j * 16 + 15 downto j * 16) === dqVec(derot(j)).asBits)
    }
    // P4: data_ready implies busy (cleared together)
    assert(!data_ready || busy)
    // P5: init_done implies both calibrations done
    assert(!io.init_done || (wlevel_done && rcalib_done))
    // P6: DQS read strobe is all lanes or nothing
    assert(io.phy.dqs_read === B"4'b0000" || io.phy.dqs_read === B"4'b1111")
    // P7: functional READs carry BL8 (A12) WITHOUT auto-precharge (A10=0):
    // double-burst capture keeps the row open for burst 2, closed by an
    // explicit PRECHARGE after. WRITE keeps BL8 + auto-precharge.
    // setCmd fires at cycle RCD/4 (+1 for burst 2) on subcycle RCD%4:
    // visible next cycle.
    when(state === Ddr3State.READ && cycle === config.RCD / 4 + 1) {
      assert(A(config.RCD % 4)(12) && !A(config.RCD % 4)(10))
    }
    when(state === Ddr3State.READ && cycle === config.RCD / 4 + 2) {
      assert(A(config.RCD % 4)(12) && !A(config.RCD % 4)(10))
    }
    when(state === Ddr3State.WRITE && cycle === config.RCD / 4 + 1) {
      assert(A(config.RCD % 4)(12) && A(config.RCD % 4)(10))
    }
    // P9: no DQ/DQS bus contention outside write drive windows.
    // dq_out/dqs_out assignments at cycle c are observable at c+1.
    val wc = (config.RCD + config.CWL) / 4
    when(!(state === Ddr3State.WRITE && (cycle === wc + 1 || cycle === wc + 2))) {
      assert(dq_oen === B"4'b1111")
    }
    // NB: WRITE_LEVELING drives DQS (test strobe) by design: excluded.
    when(!(state === Ddr3State.WRITE_LEVELING) && !(state === Ddr3State.WRITE && (cycle === wc + 1 || cycle === wc + 2 || cycle === wc + 3))) {
      assert(dqs_oen === B"4'b1111")
    }
    // P10: mode-register program order MR2 -> MR3 -> MR1 -> MR0.
    when(state === Ddr3State.CONFIG && cycle === 1) {
      assert(BA(0) === MR2(15 downto 13) && A(0) === MR2(12 downto 0).resized)
    }
    when(state === Ddr3State.CONFIG && cycle === config.MRD / 4 + 1) {
      assert(BA(0) === MR3(15 downto 13) && A(0) === MR3(12 downto 0).resized)
    }
    when(state === Ddr3State.CONFIG && cycle === config.MRD / 2 + 1) {
      assert(BA(0) === MR1(15 downto 13) && A(0) === MR1(12 downto 0).resized)
    }
    when(state === Ddr3State.CONFIG && cycle === config.MRD * 3 / 4 + 1) {
      assert(BA(0) === MR0(15 downto 13) && A(0) === MR0(12 downto 0).resized)
    }
    // P11: ZQ long calibration has A10 set.
    when(state === Ddr3State.ZQCL && cycle === config.MRD * 3 / 4 + config.MOD / 4 + 2) {
      assert(A(0)(10))
    }
    // P12: data_ready only inside READ.
    assert(!data_ready || state === Ddr3State.READ)
    // P13: write datapath mapping (beats + DM vs wstrb), observable next cycle.
    when(state === Ddr3State.WRITE && cycle === wc + 1) {
      assert(dq_out(7) === reqReg.wdata(15 downto 0))
      assert(dq_out(6) === 0)
      assert(dm_out(7) === !reqReg.wstrb(1 downto 0).orR)
      assert(dm_out(6))
    }
    when(state === Ddr3State.WRITE && cycle === wc + 2) {
      assert(dq_out(0) === reqReg.wdata(31 downto 16))
      assert(dq_out(1) === reqReg.wdata(47 downto 32))
      assert(dq_out(2) === reqReg.wdata(63 downto 48))
      assert(dq_out(3) === reqReg.wdata(79 downto 64))
      assert(dq_out(4) === reqReg.wdata(95 downto 80))
      assert(dq_out(5) === reqReg.wdata(111 downto 96))
      assert(dq_out(6) === reqReg.wdata(127 downto 112))
      assert(dq_out(7) === 0)
      assert(dm_out(0) === !reqReg.wstrb(3 downto 2).orR)
      assert(dm_out(1) === !reqReg.wstrb(5 downto 4).orR)
      assert(dm_out(2) === !reqReg.wstrb(7 downto 6).orR)
      assert(dm_out(3) === !reqReg.wstrb(9 downto 8).orR)
      assert(dm_out(4) === !reqReg.wstrb(11 downto 10).orR)
      assert(dm_out(5) === !reqReg.wstrb(13 downto 12).orR)
      assert(dm_out(6) === !reqReg.wstrb(15 downto 14).orR)
      assert(dm_out(7))
    }
    // P14: ACT bank/row coherence between activate and R/W commands.
    val reqBank = reqReg.addr(config.colWidth - 4 + config.rowWidth + config.bankWidth downto config.colWidth - 3 + config.rowWidth).asBits
    val reqRow = reqReg.addr(config.colWidth - 4 + config.rowWidth downto config.colWidth - 3).asBits
    when((state === Ddr3State.READ || state === Ddr3State.WRITE) && cycle === 1) {
      assert(BA(0) === reqBank && A(0).asBits === reqRow.resized)
    }
    when((state === Ddr3State.READ || state === Ddr3State.WRITE) && cycle === config.RCD / 4 + 1) {
      assert(BA(config.RCD % 4) === reqBank)
    }
    when(state === Ddr3State.READ && cycle === config.RCD / 4 + 2) {
      assert(BA(config.RCD % 4) === reqBank)
    }
    // Reachability sanity
    cover(state === Ddr3State.CONFIG)
    cover(io.req.fire)
    }
  }
}
