package ddr3

import spinal.core._
import spinal.lib._

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

    // Status and calibration outputs
    val init_done        = out Bool()
    val write_level_done = out Bool()
    val read_calib_done  = out Bool()
    val wstep            = out Bits(8 bits)
    val rclkpos          = out Bits(2 bits)
    val rclksel          = out Bits(3 bits)
    val best_rot         = out UInt(3 bits)
    val best_score       = out UInt(4 bits)
    val dbg_state        = out Bits(4 bits)

    // Direct interface to GowinDdr3Phy
    val phy = Ddr3CorePhyIo(config)
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
  val cycle        = Reg(UInt(7 bits)) init(0)
  val tick_counter = Reg(UInt(17 bits)) init(if (config.isSimulation) 1 else 60000)
  val tick         = RegInit(False)

  val resetn_delay = RegInit(False)
  val CKE          = RegInit(False)
  val busy         = RegInit(True)
  val data_ready   = RegInit(False)
  val init_done_latched = RegInit(False)

  // Open-page + burst-streaming state (functional traffic only; calibration stays closed-page)
  val rowOpen       = RegInit(False)
  val openBank      = Reg(Bits(config.bankWidth bits)) init(0)
  val openRow       = Reg(Bits(config.rowWidth bits)) init(0)
  val prechForReq   = RegInit(False)

  val wrStreamOpen  = RegInit(False)
  val wrHavePending = RegInit(False)
  val wrExtraCnt    = Reg(UInt(6 bits)) init(0)
  val wrCooldown    = Reg(UInt(4 bits)) init(0)
  val st1Valid      = RegInit(False)
  val st2Valid      = RegInit(False)
  val st3Valid      = RegInit(False)
  val st1Req        = Reg(Ddr3Req(config))
  val st2Req        = Reg(Ddr3Req(config))
  val st3Req        = Reg(Ddr3Req(config))

  val rdStreamOpen  = RegInit(False)
  val rdHavePending = RegInit(False)
  val rdExtraCnt    = Reg(UInt(6 bits)) init(0)
  val rdRspLeft     = Reg(UInt(6 bits)) init(0)

  val wlevel_done  = RegInit(False)
  val wlevel_cnt   = Reg(UInt(4 bits)) init(0)
  val wlevel_tries = Reg(UInt(9 bits)) init(0)
  val wlVoteN  = Reg(UInt(3 bits)) init(0)
  val wlVoteCnt = Reg(UInt(3 bits)) init(0)
  val wlVoteCnt0 = Reg(UInt(3 bits)) init(0)
  val wlVoteCnt1 = Reg(UInt(3 bits)) init(0)
  val wlLockedR = RegInit(False)
  val wlLockedStepR = Reg(Bits(8 bits)) init(0)
  val wstep        = Reg(Bits(8 bits)) init(if (config.isSimulation) B"8'h18" else B"8'h00")

  val rcalib_done  = RegInit(False)
  val rcalib_cnt   = Reg(UInt(4 bits)) init(0)
  // SIM-only watchdog: counts calib misses so a never-locking sweep
  // cannot hang iverilog forever (wall-clock). HW path untouched.
  // (10 bits: full sweeps with per-setting re-pin run ~1000 settled
  // iterations; 6 bits wrapped at 64 and made progress unreadable).
  val rcalib_tries = Reg(UInt(10 bits)) init(0)
  val rclkpos      = Reg(Bits(2 bits)) init(if (config.isSimulation) B"2'd0" else B"2'd0")
  val rclksel      = Reg(Bits(3 bits)) init(if (config.isSimulation) B"3'd0" else B"3'd0")
  val rburst_seen  = Reg(Bits(2 bits)) init(0)
  val dqs_hold     = RegInit(False)

  // Data-eye training (option 2): a known pattern is written once to block 0
  // through the normal WRITE path, then the read sweep compares full 128-bit
  // data (not just RBURST strobe detect, which is blind to partial bursts).
  // NOTE: training clobbers block 0 (undefined at power-up per JEDEC; on a
  // re-reset previous contents of block 0 are lost — documented tradeoff).
  val trainPat  = B"128'hA707A606A505A404A303A202A101A000" // 8 distinct beats (both byte lanes distinct)
  // Poison pattern (bitwise complement): written once to block 1 right after
  // the training write, so the sweep's first iteration cannot score on stale
  // self-captured training data (the always-open window self-captures every
  // write via DQSIN loopback). A missed window then latches poison (score 0,
  // correctly rejected) instead of stale training (score 8, false lock).
  val poisonPat = ~trainPat
  val training  = RegInit(True)
  val trainDone = RegInit(False)
  val needPoison = RegInit(False)
  val rotScorer = new Ddr3RotationScorer(trainPat)
  val wserRstCnt = if (!config.isSimulation) Reg(UInt(3 bits)) init(0) else null
  val wser_rst   = if (!config.isSimulation) RegInit(False) else null
  val sweepScore = rotScorer.sweepScore
  val sweepRot   = rotScorer.sweepRot
  val bestCnt = Reg(UInt(4 bits)) init(0)
  val bestPos = Reg(Bits(2 bits)) init(B"2'd0")
  val bestSel = Reg(Bits(3 bits)) init(B"3'd0")
  val bestRot = Reg(UInt(3 bits)) init(0)
  // Write-phase (DQ/DQS OSER TCLK) calibration, one-shot per boot (t21,
  // 10/2026): the DQ OSER re-takes FCLK data on DQSW270 = DLLSTEP+WSTEP
  // while DQS uses DQSW0 = WSTEP, so across DLL anchors the DQ burst slips
  // by an integer tCK (measured: S5/S23/S40 need +1 tCK advance, S25 needs
  // 0). wrAdv selects the advanced window (data 2 beats earlier, DM follows
  // the beats). Calibrated after WL/training by BIST write+read+score over
  // {0,+1} (ties and healthy cards stay on 0); the slip is
  // anchor-independent so one lock covers survey, sweep and functional.
  val wrMode        = Reg(UInt(2 bits)) init(0) // 0=norm, 1=dqAdv(-1tCK), 2=burstDly1(+1tCK), 3=burstDly2(+2tCK)
  val shiftCalDone  = RegInit(False)
  val tryMode       = Reg(UInt(2 bits)) init(0)
  val wCalDone      = RegInit(False)
  val wTry          = Reg(UInt(2 bits)) init(0)
  val wBase         = Reg(Bits(8 bits)) init(0)
  val bestWstep     = Reg(Bits(8 bits)) init(0)
  val best0         = Reg(UInt(4 bits)) init(0)
  val best0Pos      = Reg(Bits(2 bits)) init(B"2'd0")
  val best0Sel      = Reg(Bits(3 bits)) init(B"3'd0")
  val best0Rot      = Reg(UInt(3 bits)) init(0)
  val bestMode      = Reg(UInt(2 bits)) init(0)
  val bestWCnt      = Reg(UInt(4 bits)) init(0)
  val bestWPos      = Reg(Bits(2 bits)) init(B"2'd0")
  val bestWSel      = Reg(Bits(3 bits)) init(B"3'd0")
  val bestWRot      = Reg(UInt(3 bits)) init(0)
  val bestWMode     = Reg(UInt(2 bits)) init(0)

  // DLL read-delay sweep, RELATIVE to the DLL lock, via the DQS dynamic
  // steppers (RLOADN/RMOVE/RDIR). Measured facts
  // (doc/capture-map-observations.md): the read capture only works for ~2
  // taps of STEP out of 256, WSTEP has no influence at all, and the
  // pclk/FCLK phase has none either. So the phase the DLL provides is not
  // the phase the IDES FIFO wants, and the difference is unknowable a
  // priori -> sweep around the lock and keep the best. A fabric adder on
  // DLLSTEP would do the same job in sim, but the placer forbids it
  // (PR0015): the steppers are the vendor-intended dynamic path.
  //
  // The sweep covers (pos, side, mag) JOINTLY: the best `pos` moves with the
  // effective STEP, so sweeping steps at a frozen pos would stay on the
  // shoulder and top out at 6. Plus side mag 0..RANGE, then minus side mag
  // 1..RANGE (mag 0 measured once), pos innermost.
  //
  // Hardware pipeline warning (load-bearing): RMOVE steps register a fixed
  // 2 iterations later (fall-detect at the next case-12 + settle), so the
  // hardware permanently trails the enumeration by 2. The s0/s1/s2 shift
  // registers below mirror that lag: the SAVED triple is always the
  // CURRENTLY MEASURED one, never the programmed-next. Saving the
  // programmed value would lock the wrong offset silently -- do not
  // "simplify" this. RLOADN rule (also load-bearing): asserted (hold) from
  // the first anchor through functional traffic; re-tracking would silently
  // drop the winner.
  //
  // Runs after the POST-TRAINING (pos, sel) survey (pass 2): the sweep needs
  // trained DRAM contents to score against, and pass 1 runs pre-training
  // (all X by design). After the sweep, pass 3 re-surveys (pos, sel, rot)
  // at the winner and locks. The training data does not depend on either
  // axis (writes use WSTEP), so no re-write is needed between iterations.
  val dllSweepOn    = RegInit(False)
  val dllSweepDone  = RegInit(False)
  val bestCntDll    = Reg(UInt(4 bits)) init(0)
  // Set at sweep end: IDLE re-enters READ_CALIB for the confirming pass-3
  // survey at the winner, then locks.
  val needFinalSurvey = RegInit(False)
  // Sweep enumeration = programmed-next (s0side/s0mag). s1/s2 mirror it
  // with the hardware lag, so s2 always equals what is settled right now.
  // pos needs no pipeline (window applies next-iter, exactly-once, like the
  // survey): only (side, mag) ride the pipeline. Side False=plus (RDIR=0).
  val s0Side = RegInit(False)
  val s0Mag  = Reg(UInt(7 bits)) init(0)
  val s1Side = RegInit(False)
  val s1Mag  = Reg(UInt(7 bits)) init(0)
  val s2Side = RegInit(False)
  val s2Mag  = Reg(UInt(7 bits)) init(0)
  val bestSide      = RegInit(False)
  val bestMag       = Reg(UInt(7 bits)) init(0)
  // Anchor-base scan state (outer loop, full-sweep mode only). The pass-2
  // survey doubles as base +0 (tracked at the lock); further bases run held
  // (RLOADN high) after anchor+navigate. The best-surveyed base hosts the
  // DLL sweep. Ties keep the earliest base (plus side first).
  val scanOn         = RegInit(False)
  val scSide         = RegInit(False)
  val scMag          = Reg(UInt(7 bits)) init(0)
  val bestSurveyCnt  = Reg(UInt(4 bits)) init(0)
  val bestSurveySide = RegInit(False)
  val bestSurveyMag  = Reg(UInt(7 bits)) init(0)
  // Align machinery: anchorLeft counts RLOADN pulse slots (reload rstep
  // from the live DLL, then navigate); navigateLeft counts SLOTS to the
  // frozen target (from anchored 0, exact -- two slots per step: the DQS
  // steps on RMOVE *falling* edges, so consecutive True slots would merge
  // into a single step, VCD-proven: a 2-pulse navigate landed +1. Pulses
  // fire on odd counts). Scoring (and exit/exhaust
  // checks) happen ONLY when anchorLeft==0 and not aligning -- transient
  // hardware would mislabel measurements. Uniform rule, no exceptions.
  // (No settle counter: the s-pipeline overwrite at align-start (below)
  // re-primes the lag invariant, so s2 == hardware again by construction.)
  val anchorLeft = Reg(UInt(2 bits)) init(0)
  val aligning   = RegInit(False)
  val settleLeft = Reg(UInt(2 bits)) init(0)
  // Pin-per-setting: pinLeft counts HOLD re-pin slots after each mag-step
  // pulse (re-pin W/R pointers so every mag starts from the same gap;
  // scoring the transient would label history, not delay). Shifts the
  // s-pipeline like the arrival settle (s0 holds the post-step target).
  val pinLeft = Reg(UInt(2 bits)) init(0)
  // BIST write-then-read: bistReturn marks the is(0) that follows a
  // per-iteration refresh write (row closed by the write's auto-precharge).
  // That is(0) re-ACTs but preserves ALL pass state (tries, bests, sweep
  // flags, s-pipeline, transients); only a fresh pass entry runs the full
  // reset block below.
  val bistReturn = RegInit(False)
  // Window-scan (diag): TB-driven via hierarchical force (default 0 =
  // classic full sweep). Nonzero magN scans plus-side mags [mag0,mag0+magN).
  // Explicit default drivers: unset regs are elaboration ERRORS on some
  // backends (lesson learned). The TB force overrides when nonzero.
  val sweepMag0 = Reg(UInt(7 bits)) init(0)
  val sweepMagN = Reg(UInt(7 bits)) init(0)
  sweepMag0 := 0
  sweepMagN := 0
  val winEndRaw = sweepMag0 + sweepMagN // 8 bits
  val winEnd = (sweepMagN === 0 || winEndRaw > config.dllSweepRange) ? U(config.dllSweepRange, 7 bits) | winEndRaw(6 downto 0)
  // Window-done predicate (plus-side window fully measured). Shared by the
  // three touches below so the side-switch, the mag-step and the BIST
  // detour stay byte-identical apart from their gate: no reindent, no
  // rewrap of the proven paths (lesson learned).
  val winDoneNow = (sweepMagN =/= 0) && !s2Side && (s2Mag === winEnd)
  val applyArmed = RegInit(False)
  val navigateLeft = Reg(UInt(8 bits)) init(0)
  // Stepper outputs. rloadn has no reg: combinational rule at the io drive
  // (track pre-sweep, hold from first anchor, reload during anchorLeft).
  // rmove pulses single slots (cleared at every case-12 top); rdir stable
  // per side (set explicitly, redundantly, for reviewability).
  val rmove  = RegInit(False)
  val rdir   = RegInit(False)

  // Autonomous Refresh timer (every 7.8 us = 592 cycles @ 75.94MHz)
  // Sim uses a shorter period so iverilog runs cover several refreshes.
  val refreshPeriod = config.refreshPeriod
  val refresh_timer = Reg(UInt(11 bits)) init(0)
  val refresh_due   = RegInit(False)

  when(state === Ddr3State.IDLE || state === Ddr3State.READ || state === Ddr3State.WRITE || state === Ddr3State.PRECHARGE) {
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

  // Anchor machinery shared by the scan and sweep handoffs (uniform with
  // the side-switch/apply paths): overwrite the s-pipeline with the target,
  // restart pos, anchor (reload rstep from the live DLL) + navigate there,
  // loop back into the anchor slots. Positioning first, no BIST write: the
  // ENUM/survey loop-backs write before each scored measurement.
  def gotoBase(side: Bool, mag: UInt): Unit = {
    s0Side := side
    s0Mag := mag
    s1Side := side
    s1Mag := mag
    s2Side := side
    s2Mag := mag
    rclkpos := 0
    aligning := True
    anchorLeft := 2
    navigateLeft := mag << 1
    applyArmed := False
    cycle := config.RCD / 4
  }

  // Sweep handoff at a base: full-sweep inits (mirror of the survey-end
  // path) + anchor/navigate there. Even sel forced: with rclksel[0]=1 the
  // capture clock moves with the swept DQS and the sweep is provably futile.
  def startSweepAtBase(side: Bool, mag: UInt): Unit = {    dllSweepOn := True
    bestCntDll := 0
    bestSide := False
    bestMag := 0
    rcalib_tries := 0
    rclksel(0) := False
    gotoBase(side, mag)
  }

  // BIST rewrite detour (proven idiom, same as the survey/sweep ADVANCE):
  // refresh block 0 through the WRITE path (auto-precharge closes the row;
  // WRITE exit returns to is(0) which re-ACTs and, via bistReturn, preserves
  // all pass state). The written content follows the CURRENT wrAdv, so the
  // next scored slots measure the locked shift. Loops back via WRITE+is(0).
  def bistRewrite(): Unit = {
    reqReg.write := True
    reqReg.addr := 0
    reqReg.wdata := trainPat
    reqReg.wstrb := B"16'hFFFF"
    trainDone := True
    needPoison := False
    bistReturn := True
    state := Ddr3State.WRITE
    cycle := 0
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
  //
  // The pulse is ALSO asserted during WRITE: this keeps dqs_en permanently
  // open after init, which kills the history-dependent pre-arm edge.
  // dqs_en rising while DQSIN is Hi-Z makes DQSR90 go 0->X (a Verilog
  // posedge) that pre-loads wpt_q, so the preamble latches a bonus WPOINT
  // step (rotation 4); with dqs_en already open the preamble is consumed
  // silently (rotation 2). Whether dqs_en had decayed since the previous
  // access decided the rotation - VCD proven: reads 1-2 rot 4, reads 3+
  // rot 2. With the window held open across writes, dqs_en only ever rises
  // while DQSIN is driven (write strobe / read bursts), never 0->X, so
  // every capture runs un-pre-armed (rot 2), from calib to functional reads.
  // Side effect (harmless): the write strobe self-captures write data into
  // the FIFO via DQSIN loopback; the next read's HOLD reset + full double
  // burst overwrite every slot.
  val rdCyc = rclkpos.asUInt.resize(7) + config.RCD / 4
  val rotSplit = (bestRot =/= 0).asUInt.resize(7)
  val dqs_read = Reg(Bits(4 bits)) init(0)
  dqs_read := 0
  if (config.isSimulation) {
    when(state === Ddr3State.READ_CALIB &&
         (cycle === rdCyc || cycle === rdCyc + 1 || cycle === rdCyc + 2 || cycle === rdCyc + 3)) {
      dqs_read := B"4'b1111"
    }
    when(state === Ddr3State.READ &&
         (cycle >= rdCyc && cycle <= (rdCyc + 3 + rotSplit + rdExtraCnt.resize(7)))) {
      dqs_read := B"4'b1111"
    }
    when(state === Ddr3State.WRITE) {
      dqs_read := B"4'b1111"
    }
  } else {
    when(state === Ddr3State.READ_CALIB &&
         (cycle >= rdCyc && cycle <= rdCyc + 7 && cycle <= 10)) {
      dqs_read := B"4'b1111"
    }
    when(state === Ddr3State.READ &&
         (cycle >= rdCyc && cycle <= (rdCyc + 7 + rotSplit + rdExtraCnt.resize(7)) && cycle <= (U(10, 7 bits) + rotSplit + rdExtraCnt.resize(7)))) {
      dqs_read := B"4'b1111"
    }
  }

  // Open-page row decode on incoming request (never depends on io.req.valid)
  val inBlk     = io.req.addr
  val inRow     = inBlk(config.colWidth - 4 + config.rowWidth downto config.colWidth - 3).asBits
  val inBank    = inBlk(config.colWidth - 4 + config.rowWidth + config.bankWidth downto config.colWidth - 3 + config.rowWidth).asBits
  val inSameRow = (inBank === openBank) && (inRow === openRow)

  val canAcceptWrStream = (state === Ddr3State.WRITE) && !trainDone && wrStreamOpen && !refresh_due &&
                          (wrExtraCnt < 31) && (cycle >= config.RCD / 4) && io.req.write && inSameRow
  val canAcceptRdStream = (state === Ddr3State.READ) && rdStreamOpen && !refresh_due &&
                          (rdExtraCnt < 31) && (cycle >= config.RCD / 4 + 1) && !io.req.write && inSameRow

  // Ready to accept user requests in IDLE (no refresh due) or during same-row streaming
  val acceptReq = ((state === Ddr3State.IDLE) && !busy && !refresh_due) || canAcceptWrStream || canAcceptRdStream
  io.req.ready := acceptReq

  // Main FSM
  when(io.phy.rst_lock_n) {
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
    if (!config.isSimulation) { wser_rst := False }

    val fsmPaused = if (!config.isSimulation) (wserRstCnt =/= 0) else False
    if (!config.isSimulation) {
      when(wserRstCnt =/= 0) {
        wserRstCnt := wserRstCnt - 1
        wser_rst := (wserRstCnt > 2)
      }
    }
    when(!fsmPaused) {
    cycle := (cycle === 127) ? U(127, 7 bits) | (cycle + 1)
    tick := (tick_counter === 1)
    tick_counter := (tick_counter === 0) ? U(0, 17 bits) | (tick_counter - 1)

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
            wlVoteN := 0
            wlVoteCnt := 0
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
            // WL echo sample shared by the lock logic and the passive
            // instrumentation below (same node, no timing change).
            val wlMatch = io.phy.dq_raw(0) && io.phy.dq_raw(8)
            // Majority vote over WL_VOTES strobes per wstep: on silicon a
            // ~1ns echo sampled by a 10ns clock is jitter-dominated, so a
            // single sample flickers (HW showed sporadic n=02 locks at
            // varying W). Verdict needs WL_VOTE_TH hits out of WL_VOTES.
            // In sim (deterministic) verdicts equal raw samples.
            val wlVerdict = (wlVoteCnt + wlMatch.asUInt) >= config.WL_VOTE_TH
            when(wlVoteN === (config.WL_VOTES - 1)) {
              wlVoteN := 0
              wlVoteCnt := 0
              wlevel_tries := wlevel_tries + 1
            // Watchdog: after 2 full wstep turns with no lock, stop looping
            // and continue with a sentinel (W=FF on UART). A silent infinite
            // loop here bricks the board with zero diagnostics; the data-eye
            // sweep downstream scores low instead (visible C), and the UART
            // progress line shows where we are.
            when(wlevel_tries === 511) {
              wlevel_done := True
              wstep := B"8'hFF"
              setCmd(0, CMD_SetModeReg, MR1(15 downto 13), MR1(12 downto 0)) // exit write leveling
            } elsewhen(!wlVerdict) {
              wstep := (wstep.asUInt + 1).asBits
              wlevel_cnt := 0
              cycle := config.WLMRD / 4 - 1 // loop back
            } otherwise {
              wlevel_cnt := wlevel_cnt + 1
              // Warmup: never lock below wstep 8. The first strobes after
              // entering WL mode can sample stale DQ (HW locked W=00 with
              // n=02 on what looks like a startup remnant, not a window).
              // The scan still visits 0-7 (map stays complete), it just
              // cannot lock there.
              when(wlevel_cnt === config.wlevelCount - 1 && wstep.asUInt >= 8) {
                wlevel_done := True
                // Apply the lock offset (default 0 = lock where counted).
                wstep := (wstep.asUInt.resize(9).asSInt + S(config.WL_LOCK_OFF, 9 bits))(7 downto 0).asBits
                setCmd(0, CMD_SetModeReg, MR1(15 downto 13), MR1(12 downto 0)) // exit write leveling
              } otherwise {
                cycle := config.WLMRD / 4 - 1
              }
            }
          } otherwise {
              // Vote still open: accumulate this strobe, restrobe same wstep.
              when(wlMatch) {
                wlVoteCnt := wlVoteCnt + 1
              }
              wlVoteN := wlVoteN + 1
              cycle := config.WLMRD / 4 - 1 // loop back, no step
            }
          }
          is((config.WLMRD + config.MRD) / 4 + 6) {
            // Turn on dynamic ODT (MR2_RTT_WR)
            setCmd(0, CMD_SetModeReg, MR2_RTT_WR(15 downto 13), MR2_RTT_WR(12 downto 0))
          }
          is((config.WLMRD + config.MRD + config.MOD) / 4 + 6) {
            if (!config.isSimulation) { wserRstCnt := 5 }
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
            when(bistReturn) {
              // BIST-write return: the write's auto-precharge closed the row
              // and the ACT above re-opens it. All pass state (tries, bests,
              // sweep flags, s-pipeline, transients) SURVIVES -- the next
              // slots measure freshly-written data. Loops into the bursts
              // (no re-entry stall: this is not a pass entry).
              bistReturn := False
            } otherwise {
            when(training) {
              // Fresh boot (pass-1 entry): arm the one-shot write-shift
              // search. Later entries (pass 2/3) keep the locked shift:
              // re-arming there would silently drop the winner.
              shiftCalDone := False
              tryMode := 0
              wrMode := 0
              bestMode := 0
              wCalDone := False
              wTry := 0
              wBase := 0
              bestWstep := 0
              bestWCnt := 0
              bestWPos := 0
              bestWSel := 0
              bestWRot := 0
              bestWMode := 0
            }
            rcalib_cnt := 0
            rcalib_tries := 0
            bestCnt := 0
            bestPos := rclkpos
            bestSel := rclksel
            bestRot := 0
            dllSweepOn := False
            bestCntDll := 0
            s0Side := False
            s0Mag := 0
            s1Side := False
            s1Mag := 0
            s2Side := False
            s2Mag := 0
            bestSide := False
            bestMag := 0
            scanOn := False
            scSide := False
            scMag := 0
            bestSurveyCnt := 0
            bestSurveySide := False
            bestSurveyMag := 0
            anchorLeft := 0
            aligning := False
            settleLeft := 0
            pinLeft := 0
            applyArmed := False
            navigateLeft := 0
            // NOTE: rmove/rdir/rloadn deliberately NOT touched here. is(0)
            // runs at pass-3 entry too, where rstep must STAY at the winner
            // (RLOADN held). rloadn is combinational (auto-correct); rmove
            // idles low and rdir is stable -- leaving them alone is correct
            // in all passes.
            }
          }
          is(config.RCD / 4) {
            // Burst 1 of 2, BL8 without auto-precharge.
            setCmd(2, CMD_Read, B"3'b0", B"1'b1".resize(config.rowWidth) |<< 12)
            // NOTE: no dqs_hold here on purpose. Pinning HOLD every burst
            // resets WPOINT/RPOINT (reset_f) each iteration, so every
            // measurement reads the same stale (W-R) frame (training
            // residue) and the sweep scores history, not delay. Pin once
            // per pass at is(0) for a deterministic start, then free-run
            // (like functional reads): pointers track live bursts. The
            // per-mag-step re-pin lives in the ENUM pin branch (pinLeft),
            // not here: this slot IS a burst, HOLD is driven per-slot from
            // the measure case.
            rburst_seen := 0
          }
          is(config.RCD / 4 + 1) {
            // Burst 2 of 2 (tCCD = 4 tCK = 1 pclk), same address.
            setCmd(2, CMD_Read, B"3'b0", B"1'b1".resize(config.rowWidth) |<< 12)
          }
          is(if (config.isSimulation) (config.RCD / 4 + 10) else (config.RCD / 4 + 9)) {
            // Latch at the functional data_ready cycle (same RPOINT phase).
            rotScorer.trainLatch := (io.phy.dq_in(7) ## io.phy.dq_in(6) ## io.phy.dq_in(5) ## io.phy.dq_in(4) ##
                                     io.phy.dq_in(3) ## io.phy.dq_in(2) ## io.phy.dq_in(1) ## io.phy.dq_in(0))
          }
          is(config.RCD / 4 + 11) {
            // Pipeline stage 1: register 8x128b rotation popcounts.
            rotScorer.captureStage1()
          }
          is(config.RCD / 4 + 12) {
            // Pipeline stage 2: register 8-way max rotation score/index.
            rotScorer.captureStage2()
          }
          is(config.RCD / 4 + 13) {
            // $display is simulation-only: the formal backend lowers
            // report() to assert(1'b0), which would fail the proof.
            // Gated on settled (non-transient) slots only: anchor/navigate/
            // settle/pin slots loop back without scoring, so printing and
            // counting them would log unscored transients and inflate the
            // tries progress. The survey never sets transients, so its
            // tries===40 exit is unaffected.
            if (!GenerationFlags.formal) {
              when(!aligning && (anchorLeft === 0) && (settleLeft === 0) && (pinLeft === 0)) {
                report(L"RCALIB chk pos=$rclkpos sel=$rclksel seen=$rburst_seen score=$sweepScore rot=$sweepRot latch=${rotScorer.trainLatch} best=$bestCnt tries=$rcalib_tries")
              }
            }
            rcalib_cnt := 0
            when(!aligning && (anchorLeft === 0) && (settleLeft === 0) && (pinLeft === 0)) {
              rcalib_tries := rcalib_tries + 1
            }
            // Two phases on the same iteration slot. Phase 1 surveys the
            // 32-setting (pos, sel) read-window grid; phase 2 sweeps the DLL
            // STEP offset at the best setting found. Same proven per-iteration
            // flow (ACT / double burst / latch / score) for both, only the
            // axis that moves differs.
            // Phase 2 sweeps the read delay RELATIVE to the DLL lock with the
            // DQS dynamic steppers (see declarations). Same proven
            // per-iteration flow (ACT / double burst / latch / score) as the
            // survey; only the axis that moves differs. RLOADN/RMOVE/RDIR are
            // driven here (RLOADN combinationally at the io drive).
            // Scan positioning slots (scanOn, full-sweep mode only): the same
            // anchor/navigate/settle rhythm as the sweep transients, so every
            // base survey starts settled at its held base. The s-pipeline is
            // untouched (surveys don't use it; s0 alone steers RDIR via the
            // pulse below). pinLeft is excluded: only the sweep sets it, and
            // this block must not wait on a flag it never clears. The proven
            // sweep block below stays byte-identical.
            when(scanOn && (aligning || (anchorLeft =/= 0) || (settleLeft =/= 0))) {
              rmove := False // default; navigate pulses single slots below
              when(anchorLeft =/= 0) {
                // Anchor slot: RLOADN low (combinational) reloads rstep from
                // the live DLL. Loops (same stall precedent as the sweep).
                anchorLeft := anchorLeft - 1
                cycle := config.RCD / 4
              } otherwise {
                when(aligning) {
                  // Navigate: one isolated pulse per two slots toward the
                  // gotoBase target (the DQS steps on RMOVE falling edges).
                  // applyArmed is False throughout the scan, so RDIR follows
                  // s0Side directly (stable by construction, like the sweep
                  // side-switch).
                  when(navigateLeft =/= 0) {
                    rdir := s0Side
                    rmove := navigateLeft(0)
                    navigateLeft := navigateLeft - 1
                    cycle := config.RCD / 4
                  } otherwise {
                    // Arrived: hand off to settle (2 slots), exactly once.
                    settleLeft := 2
                    aligning := False
                    cycle := config.RCD / 4
                  }
                } otherwise {
                  // Settle countdown; the survey resumes next slot (s2
                  // alignment is a sweep-only concern).
                  settleLeft := settleLeft - 1
                  cycle := config.RCD / 4
                }
              }
            } elsewhen(dllSweepOn) {
              rmove := False // default; pulses set below (single-slot high)
              // busyMoving = transient hardware (anchor/navigate/settle/pin):
              // pause enumeration, freeze pos, skip scoring. The s-pipeline
              // would otherwise label measurements with the wrong
              // (pos, side, mag). Uniform rule, no exceptions.
              when(aligning || (anchorLeft =/= 0) || (settleLeft =/= 0) || (pinLeft =/= 0)) {
                when(anchorLeft =/= 0) {
                  // Anchor window: RLOADN low (combinational) reloads rstep
                  // from the live DLL. Nothing else moves. Loops like every
                  // sweep slot: falling through would exit to IDLE with no
                  // re-entry path (needFinalSurvey is clear) and stall
                  // calibration forever.
                  anchorLeft := anchorLeft - 1
                  cycle := config.RCD / 4
                } otherwise {
                  // Anchor done: navigating (aligning) or settling.
                  when(aligning) {
                    // Navigate: one isolated pulse per two slots toward the
                    // frozen target (s0 at side-switch, best at apply). RDIR
                    // set explicitly below (stable by construction, redundant
                    // on purpose).
                    when(navigateLeft =/= 0) {
                      rdir := Mux(applyArmed, bestSide, s0Side)
                      rmove := navigateLeft(0)
                      navigateLeft := navigateLeft - 1
                      cycle := config.RCD / 4
                    } otherwise {
                      // Arrived: hand off to settle (2 slots = the lag,
                      // exact). Guarded by aligning so it runs exactly once;
                      // the settle branch below owns the state afterwards.
                      settleLeft := 2
                      aligning := False
                      cycle := config.RCD / 4
                    }
                  } otherwise {
                    // Pin-per-setting: re-pin W/R pointers (HOLD) for 2
                    // slots after a mag-step pulse, then resume ENUM. The
                    // mag-step moved rstep; scoring the transient would
                    // label history, not delay. Unlike a freeze, the
                    // s-pipeline SHIFTS here (s0 holds the post-step
                    // target): after 2 shifts s2 == hardware again on
                    // resume, so the lag invariant survives the pin. pos
                    // frozen (pos0 measured on resume), no pulse (rmove
                    // idles False), RLOADN untouched (anchorLeft==0:
                    // position kept, no reload). Loops like every transient
                    // slot (same stall precedent as the anchor).
                    when(pinLeft =/= 0) {
                      dqs_hold := True
                      s1Side := s0Side
                      s1Mag := s0Mag
                      s2Side := s1Side
                      s2Mag := s1Mag
                      pinLeft := pinLeft - 1
                      cycle := config.RCD / 4
                    } otherwise {
                    // Settle: countdown + flush s-pipeline toward frozen s0
                    // (s0 holds, s1/s2 shift): after 2 shifts s2 == s0 ==
                    // hardware, aligned. Loops; only the applyArmed finish
                    // falls through to 13 -> IDLE (the proven exit).
                    settleLeft := settleLeft - 1
                    s1Side := s0Side
                    s1Mag := s0Mag
                    s2Side := s1Side
                    s2Mag := s1Mag
                    when(settleLeft === 1 && applyArmed) {
                      // FINISH: seed pass-3, flag, precharge, exit (falls to
                      // 13 -> IDLE, like the proven path). RLOADN untouched
                      // (HOLD rule): re-tracking would drop the winner.
                      rclkpos := bestPos
                      needFinalSurvey := True
                      dllSweepDone := True
                      dllSweepOn := False
                      applyArmed := False
                      if (!GenerationFlags.formal) {
                        report(L"RCALIB dll side=$bestSide mag=$bestMag pos=$bestPos score=$bestCntDll")
                      }
                      setCmd(0, CMD_PreCharge, B"3'b0", B"0".resized)
                    } otherwise {
                      cycle := config.RCD / 4
                    }
                    // Non-apply settle end: resume ENUM next slot (s2
                    // aligned, lockstep restored) via the loop-back above.
                    }
                  }
                }
              } otherwise {
                // Settle lives in the busyMoving branch above (it owns every
                // transient slot); here settleLeft === 0 by construction, so
                // the guard below is purely documentary and this is ENUM.
                when(settleLeft === 0) {
                  // ENUM: score + save the MEASURED triple (s2 side/mag +
                  // current pos). s2 = programmed-2-ago = hardware-settled
                  // now, by construction. pos needs no pipeline (window
                  // applies next-iter, exactly-once -- same as the survey).
                  when(sweepScore > bestCntDll) {
                    bestCntDll := sweepScore
                    bestMag := s2Mag
                    bestSide := s2Side
                    bestPos := rclkpos
                    bestSel := rclksel
                    bestRot := sweepRot
                  }
                  // EXIT on true perfection (measured, aligned, valid). The
                  // APPLY path below is shared with exhaustion (uniform).
                  when(bestCntDll === 8) {
                    aligning := True
                    anchorLeft := 2
                    navigateLeft := bestMag << 1
                    applyArmed := True
                    // Overwrite s-pipeline with best (uniform with the
                    // side-switch below): s2 == hardware again by
                    // construction once navigated.
                    s0Side := bestSide
                    s0Mag := bestMag
                    s1Side := bestSide
                    s1Mag := bestMag
                    s2Side := bestSide
                    s2Mag := bestMag
                    if (!GenerationFlags.formal) {
                      report(L"RCALIB dll side=$bestSide mag=$bestMag pos=$bestPos score=$bestCntDll")
                    }
                    // Loop into the anchor (same precedent as the sweep-start
                    // loop-back below): falling through would exit to IDLE
                    // with needFinalSurvey clear and stall calibration.
                    cycle := config.RCD / 4
                  } otherwise {
                    // EXHAUST when measured-complete: minus side, mag RANGE,
                    // pos 3. s0 may run 2 ahead (unmeasured tail, harmless,
                    // abandoned -- the trigger is on MEASURED, correct).
                    when(s2Side && (s2Mag === config.dllSweepRange) && (rclkpos === 3)) {
                      aligning := True
                      anchorLeft := 2
                      navigateLeft := bestMag << 1
                      applyArmed := True
                      // Same s-overwrite as exit (uniform single path).
                      s0Side := bestSide
                      s0Mag := bestMag
                      s1Side := bestSide
                      s1Mag := bestMag
                      s2Side := bestSide
                      s2Mag := bestMag
                      if (!GenerationFlags.formal) {
                        report(L"RCALIB dll side=$bestSide mag=$bestMag pos=$bestPos score=$bestCntDll")
                      }
                      // Loop into the anchor, like the exit path above.
                      cycle := config.RCD / 4
                    } otherwise {
                      // ADVANCE enumeration (s0 = programmed-next): pos+1
                      // (wraps naturally on 2 bits, same idiom as survey);
                      // on wrap, mag+1 same side (capped at RANGE: the s2
                      // trigger switches first, overrun self-corrects).
                      // RDIR follows s0side every slot (stable, explicit).
                      // Pulse rule (self-regulating, lag-bounded): step iff
                      // s0 differs from settled s2 -- exactly the mag-step
                      // iters, one pulse each, never runs away.
                      // ADVANCE enumeration: s-pipeline shifts FIRST (all reads
                      // below see pre-advance values -- registers, no
                      // forwarding, so order is free but grouped for clarity).
                      // s2 always equals what is settled right now.
                      s1Side := s0Side
                      s1Mag := s0Mag
                      s2Side := s1Side
                      s2Mag := s1Mag
                      rclkpos := (rclkpos.asUInt + 1).asBits
                      rdir := s0Side
                      when(rclkpos === 3) {
                        // Side-switch when measured-complete on plus (s2 +
                        // current pos, both pre-advance): fresh start at
                        // minus mag 1 (mag 0 measured once already).
                        // s-pipeline overwritten with the target (uniform
                        // with apply).
                        when(!s2Side && (s2Mag === config.dllSweepRange) && !winDoneNow) {
                          s0Side := True
                          s0Mag := 1
                          s1Side := True
                          s1Mag := 1
                          s2Side := True
                          s2Mag := 1
                          aligning := True
                          anchorLeft := 2
                          navigateLeft := 2
                          applyArmed := False
                          if (!GenerationFlags.formal) {
                            report(L"RCALIB dll side switch to minus")
                          }
                        } otherwise {
                          // Mag-step (capped at RANGE, suppressed at window end)
                          // + THE step pulse, atomic in this slot: exactly one
                          // pulse per step, never feedback-driven, so it cannot
                          // run away or double-fire. Arms the per-setting
                          // re-pin (2 HOLD slots, s shifts, scoring skipped):
                          // every mag restarts from gap-0, so frames stay
                          // comparable across the sweep.
                          when((s0Mag =/= config.dllSweepRange) && !winDoneNow) {
                            s0Mag := s0Mag + 1
                            rmove := True
                            pinLeft := 2
                          }
                        }
                      }
                      // Window-scan end (diag): last mag fully measured.
                      // Reports WINDOW and finishes like the survey lock (no
                      // apply/pass-3). No cycle override: falls through to
                      // 13 -> IDLE (MAP_ONLY build finishes, TB prints
                      // RESULT). The BIST detour below is skipped via its own
                      // gate; the side-switch and mag-step above suppressed
                      // themselves via winDoneNow.
                      when(winDoneNow) {
                        dllSweepOn := False
                        if (!GenerationFlags.formal) {
                          report(L"RCALIB window side=$bestSide mag=$bestMag pos=$bestPos rot=$bestRot score=$bestCntDll")
                        }
                        when(!training) {
                          rcalib_done := True
                        }
                        setCmd(0, CMD_PreCharge, B"3'b0", B"0".resized)
                      }
                      when(!winDoneNow) {
                      // BIST write-then-read: refresh block 0 through the
                      // proven WRITE path (auto-precharge closes the row;
                      // WRITE exit returns to is(0) which re-ACTs and, via
                      // bistReturn, preserves all pass state). Row is open
                      // here (reads never precharge). The next slots measure
                      // freshly-written data: immune to stale residue (H3).
                      reqReg.write := True
                      reqReg.addr := 0
                      reqReg.wdata := trainPat
                      reqReg.wstrb := B"16'hFFFF"
                      trainDone := True
                      needPoison := False
                      bistReturn := True
                      state := Ddr3State.WRITE
                      cycle := 0
                      }
                    }
                  }
                }
              }
            } otherwise {
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
              // Survey length covers the full 32-setting grid (plus margin).
              when(rcalib_tries === 40) {
                rclkpos := bestPos
                rclksel := bestSel
                // Grid done. Pass 1 (pre-training, all X by design): never sweep,
                // fall through to IDLE for the training/poison writes exactly
                // like the proven flow. Pass 2 (trained data): start the DLL
                // offset sweep. Pass 3 (offset already measured): finish.
                when(!training && !dllSweepDone) {
                  // (C) Write-shift prologue: one-shot {0,+1} search over full
                  // 40-try surveys (see decl comment). Peer of the scan chain
                  // below, mutually exclusive with it (A needs scanOn, B needs
                  // shiftCalDone). Every path loops back via a BIST rewrite,
                  // so the grid tail only runs once shiftCalDone. Scored
                  // iterations update bests by max only, so the extra return
                  // iteration is harmless.
                  when(!scanOn && !shiftCalDone) {
                    val maxTryMode = if (config.isSimulation) 1 else 3
                    when(bestCnt === 8 && (tryMode === 0 || !Bool(config.isSimulation))) {
                      shiftCalDone := True
                      if (!config.isSimulation) dllSweepDone := True
                      rcalib_tries := 40
                      bistRewrite()
                    } otherwise {
                      when(tryMode === 0 || bestCnt > best0) {
                        best0 := bestCnt
                        bestMode := wrMode
                        best0Pos := bestPos
                        best0Sel := bestSel
                        best0Rot := bestRot
                      }
                      when(tryMode < maxTryMode) {
                        val nextM = (tryMode + 1).resize(2)
                        tryMode := nextM
                        wrMode := nextM
                        rcalib_tries := 0
                        bestCnt := 0
                        bistRewrite()
                      } otherwise {
                        when(bestCnt <= best0) {
                          bestCnt := best0
                          bestPos := best0Pos
                          bestSel := best0Sel
                          bestRot := best0Rot
                          wrMode := bestMode
                        }
                        shiftCalDone := True
                        if (!config.isSimulation) dllSweepDone := True
                        rcalib_tries := 40
                        bistRewrite()
                      }
                    }
                  }
                  when(scanOn) {
                    // Anchor-base scan: record the finished base when strictly
                    // better (ties keep the earliest base), then move on.
                    when(bestCnt > bestSurveyCnt) {
                      bestSurveyCnt := bestCnt
                      bestSurveySide := scSide
                      bestSurveyMag := scMag
                    }
                    // Early exit: this base surveys a perfect 8 -- sweep here
                    // now, no further bases needed.
                    when(bestCnt === 8) {
                      if (!GenerationFlags.formal) {
                        report(L"RCALIB scan sweep at side=$scSide mag=$scMag score=$bestCnt")
                      }
                      scanOn := False
                      startSweepAtBase(scSide, scMag)
                    } otherwise {
                      // Advance the base grid: plus side STEP..RANGE, then
                      // minus side STEP..RANGE (mag 0 surveyed once, at plus).
                      when(!scSide && scMag + config.anchorScanStep <= U(config.anchorScanRange, 7 bits)) {
                        scMag := scMag + config.anchorScanStep
                        rcalib_tries := 0
                        bestCnt := 0
                        gotoBase(False, scMag + config.anchorScanStep)
                      } elsewhen(!scSide) {
                        scSide := True
                        scMag := U(config.anchorScanStep, 7 bits)
                        rcalib_tries := 0
                        bestCnt := 0
                        gotoBase(True, U(config.anchorScanStep, 7 bits))
                      } otherwise {
                        when(scMag + config.anchorScanStep <= U(config.anchorScanRange, 7 bits)) {
                          scMag := scMag + config.anchorScanStep
                          rcalib_tries := 0
                          bestCnt := 0
                          gotoBase(True, scMag + config.anchorScanStep)
                        } otherwise {
                          // Scan done: sweep at the best-surveyed base.
                          if (!GenerationFlags.formal) {
                            report(L"RCALIB scan done best side=$bestSurveySide mag=$bestSurveyMag score=$bestSurveyCnt")
                          }
                          scanOn := False
                          startSweepAtBase(bestSurveySide, bestSurveyMag)
                        }
                      }
                    }
                  } elsewhen(shiftCalDone) {
                  // Pass-2 survey doubles as scan base +0 (tracked at the
                  // live lock): record it.
                  bestSurveyCnt := bestCnt
                  bestSurveySide := False
                  bestSurveyMag := 0
                  // Force an EVEN sel during the sweep: with rclksel[0]=1 the
                  // capture clock (DQSW90) is delayed by DLLSTEP itself, so it
                  // moves together with the DQS being swept and the relative
                  // alignment never changes (sweep provably futile). With an
                  // even sel the clock (DQSW0, WSTEP-based) stays fixed while
                  // the DQS scans. Pass 3 re-surveys ALL sel afterwards, so
                  // the final lock stays free to pick an odd sel if best.
                  rclksel(0) := False
                  when(sweepMagN =/= 0) {
                    // Window entry: the sweep inits below are LOAD-BEARING,
                    // not cosmetic. The ENUM machinery (side-switch, mag-step,
                    // winDoneNow, BIST detour) lives under when(dllSweepOn);
                    // without dllSweepOn the window would run survey rounds
                    // forever and never report (regression caught 09/10: the
                    // refactor had hoisted these into the fast path only).
                    dllSweepOn := True
                    bestCntDll := 0
                    bestSide := False
                    bestMag := 0
                    rcalib_tries := 0
                    // Window entry continued (clone of the side-switch): overwrite the
                    // s-pipeline with mag0, restart pos, anchor + navigate
                    // mag0 pulses from 0. Loops into the anchor (transient,
                    // no BIST write here: positioning first; the ENUM
                    // loop-back writes before each measurement).
                    s0Side := False
                    s0Mag := sweepMag0
                    s1Side := False
                    s1Mag := sweepMag0
                    s2Side := False
                    s2Mag := sweepMag0
                    rclkpos := 0
                    aligning := True
                    anchorLeft := 2
                    navigateLeft := sweepMag0 << 1
                    applyArmed := False
                    if (!GenerationFlags.formal) {
                      report(L"RCALIB window start mag0=$sweepMag0 n=$sweepMagN")
                    }
                    cycle := config.RCD / 4
                  } otherwise {
                  // Full sweep (diag window off): a perfect survey at the
                  // lock takes today's fast path (byte-identical inits +
                  // BIST detour); otherwise scan further bases for a better
                  // survey (the sweep follows at the winner).
                  when(bestCnt === 8) {
                  dllSweepOn := True
                  bestCntDll := 0
                  bestSide := False
                  bestMag := 0
                  rcalib_tries := 0
                  // Loop back into the sweep via a BIST refresh first (row is
                  // open from the survey; the WRITE returns through is(0)
                  // which re-ACTs after the auto-precharge). Falling through
                  // to cycle 13 would exit to IDLE (the historical hand-off
                  // to the training write), and the sweep would never run.
                  reqReg.write := True
                  reqReg.addr := 0
                  reqReg.wdata := trainPat
                  reqReg.wstrb := B"16'hFFFF"
                  trainDone := True
                  needPoison := False
                  bistReturn := True
                  state := Ddr3State.WRITE
                  cycle := 0
                  } otherwise {
                  // Imperfect survey at the lock: scan further bases for a
                  // better survey (the sweep follows at the winner).
                  scanOn := True
                  scSide := False
                  scMag := U(config.anchorScanStep, 7 bits)
                  rcalib_tries := 0
                  bestCnt := 0
                  if (!GenerationFlags.formal) {
                    report(L"RCALIB scan start")
                  }
                  gotoBase(False, U(config.anchorScanStep, 7 bits))
                  }
                  }
                  }
                } otherwise {
                  dllSweepOn := False
                  if (!GenerationFlags.formal) {
                    report(L"RCALIB lock best pos=$bestPos sel=$bestSel rot=$bestRot score=$bestCnt")
                  }
                  // rcalib_done (hence init_done) only after the post-training
                  // sweep. Sweep-1 ends with training still pending: firing done
                  // there would let user traffic start mid-calibration (it
                  // would stall on !ready at best). Sweep-2 (training done)
                  // locks real.
                  when(!training) {
                    if (!config.isSimulation) {
                      when(bestCnt < 8 && wTry < 2) {
                        when(wTry === 0 || bestCnt > bestWCnt) {
                          bestWCnt := bestCnt
                          bestWstep := wstep
                          bestWPos := bestPos
                          bestWSel := bestSel
                          bestWRot := bestRot
                          bestWMode := wrMode
                        }
                        when(wTry === 0) {
                          wBase := wstep
                          wTry := 1
                          wstep := (wstep.asUInt - 6).asBits
                        } otherwise {
                          wTry := 2
                          wstep := (wBase.asUInt + 6).asBits
                        }
                        if (!config.isSimulation) { wserRstCnt := 5 }
                        dllSweepDone := False
                        scanOn := False
                        shiftCalDone := False
                        tryMode := 0
                        wrMode := 0
                        bestCnt := 0
                        rcalib_tries := 0
                        rclkpos := 0
                        rclksel := 0
                        bestRot := 0
                        bistRewrite()
                      } otherwise {
                        when(wTry === 2 && bestCnt < bestWCnt) {
                          bestCnt := bestWCnt
                          wstep := bestWstep
                          if (!config.isSimulation) { wserRstCnt := 5 }
                          rclkpos := bestWPos
                          rclksel := bestWSel
                          bestPos := bestWPos
                          bestSel := bestWSel
                          bestRot := bestWRot
                          wrMode := bestWMode
                        }
                        rcalib_done := True
                        setCmd(0, CMD_PreCharge, B"3'b0", B"0".resized)
                      }
                    } else {
                      rcalib_done := True
                      setCmd(0, CMD_PreCharge, B"3'b0", B"0".resized)
                    }
                  } otherwise {
                    setCmd(0, CMD_PreCharge, B"3'b0", B"0".resized)
                  }
                }
              } otherwise {
                // BIST refresh (survey grid points measure fresh data too,
                // same detour as the sweep ADVANCE above).
                reqReg.write := True
                reqReg.addr := 0
                reqReg.wdata := trainPat
                reqReg.wstrb := B"16'hFFFF"
                trainDone := True
                needPoison := False
                bistReturn := True
                state := Ddr3State.WRITE
                cycle := 0 // loop back via WRITE + is(0)
              }
            }
          }
          is(config.RCD / 4 + 13 + config.RP / 4) {
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
          needPoison := True
          reqReg.write := True
          reqReg.addr := 0
          reqReg.wdata := trainPat
          reqReg.wstrb := B"16'hFFFF"
          setCmd(0, CMD_BankActivate, B"3'b0", B"0".resized)
          state := Ddr3State.WRITE
          cycle := 1
          busy := True
        } elsewhen(needPoison) {
          // Poison write: block-1 complement pattern, same WRITE path.
          // Self-captures poison into the FIFO (window open) and raises
          // dqs_en cleanly (defined strobe, no 0->X pre-arm), so sweep-2
          // iteration 0 latches poison on a missed window (score 0) instead
          // of stale training (false 8). After: straight to the sweep.
          needPoison := False
          trainDone := True
          reqReg.write := True
          reqReg.addr := 1
          reqReg.wdata := poisonPat
          reqReg.wstrb := B"16'hFFFF"
          setCmd(0, CMD_BankActivate, B"3'b0", B"0".resized)
          state := Ddr3State.WRITE
          cycle := 1
          busy := True
        } elsewhen(refresh_due) {
          // Autonomous refresh (close open row first if needed)
          when(rowOpen) {
            setCmd(0, CMD_PreCharge, B"3'b0", B"16'h0400".resized) // A[10]=1: precharge all banks
            rowOpen     := False
            prechForReq := False
            state       := Ddr3State.PRECHARGE
            cycle       := 1
            busy        := True
          } otherwise {
            setCmd(0, CMD_AutoRefresh, B"3'b0", B"0".resized)
            state := Ddr3State.REFRESH
            cycle := 1
            busy  := True
            refresh_due := False
          }
        } elsewhen(needFinalSurvey) {
          // DLL sweep done: confirming pass-3 survey under the winning
          // offset. Re-ACTs the row at is(0), like every pass entry.
          needFinalSurvey := False
          state := Ddr3State.READ_CALIB
          cycle := 0
        } elsewhen(io.req.valid) {
          reqReg := io.req.payload
          val blockIdx = io.req.addr
          val row  = blockIdx(config.colWidth - 4 + config.rowWidth downto config.colWidth - 3).asBits
          val bank = blockIdx(config.colWidth - 4 + config.rowWidth + config.bankWidth downto config.colWidth - 3 + config.rowWidth).asBits
          val isRowHit = rowOpen && (bank === openBank) && (row === openRow)

          when(rowOpen && !isRowHit) {
            // Row miss: precharge current row, then ACTIVATE & run request
            setCmd(0, CMD_PreCharge, B"3'b0", B"16'h0400".resized)
            rowOpen     := False
            prechForReq := True
            state       := Ddr3State.PRECHARGE
            cycle       := 1
            busy        := True
          } otherwise {
            when(!rowOpen) {
              setCmd(0, CMD_BankActivate, bank, row.resized)
              rowOpen  := True
              openBank := bank
              openRow  := row
            }
            busy := True
            when(io.req.write) {
              wrStreamOpen  := True
              wrHavePending := False
              wrExtraCnt    := 0
              wrCooldown    := 0
              st1Valid      := False
              st2Valid      := False
              st3Valid      := False
              state         := Ddr3State.WRITE
              cycle         := (isRowHit ? U(config.RCD / 4, 7 bits) | U(1, 7 bits))
            } otherwise {
              dqs_hold      := True
              rdStreamOpen  := True
              rdHavePending := False
              rdExtraCnt    := 0
              rdRspLeft     := 1
              state         := Ddr3State.READ
              cycle         := (isRowHit ? U(config.RCD / 4, 7 bits) | U(1, 7 bits))
            }
          }
        }
      }

      is(Ddr3State.PRECHARGE) {
        // Wait tRP (6 tCK -> 2 pclk = 8 tCK between PRE and next ACT/REF)
        when(cycle === (config.RP + 3) / 4) {
          when(prechForReq) {
            prechForReq := False
            val blockIdx = reqReg.addr
            val row  = blockIdx(config.colWidth - 4 + config.rowWidth downto config.colWidth - 3).asBits
            val bank = blockIdx(config.colWidth - 4 + config.rowWidth + config.bankWidth downto config.colWidth - 3 + config.rowWidth).asBits
            setCmd(0, CMD_BankActivate, bank, row.resized)
            rowOpen  := True
            openBank := bank
            openRow  := row
            when(reqReg.write) {
              wrStreamOpen  := True
              wrHavePending := False
              wrExtraCnt    := 0
              wrCooldown    := 0
              st1Valid      := False
              st2Valid      := False
              st3Valid      := False
              state         := Ddr3State.WRITE
              cycle         := 1
            } otherwise {
              dqs_hold      := True
              rdStreamOpen  := True
              rdHavePending := False
              rdExtraCnt    := 0
              rdRspLeft     := 1
              state         := Ddr3State.READ
              cycle         := 1
            }
          } otherwise {
            setCmd(0, CMD_AutoRefresh, B"3'b0", B"0".resized)
            refresh_due := False
            state       := Ddr3State.REFRESH
            cycle       := 1
          }
        }
      }

      is(Ddr3State.READ) {
        // Double-burst-warmed streaming functional read (open-page, A[10]=0):
        // burst 1 warms up dqs_en/WPOINT, burst 2..2+rdExtraCnt stream 16B/pclk.
        val blockIdx = reqReg.addr
        val col  = (blockIdx(config.colWidth - 4 downto 0) @@ U"3'b000").asBits
        val bank = blockIdx(config.colWidth - 4 + config.rowWidth + config.bankWidth downto config.colWidth - 3 + config.rowWidth).asBits
        val readA = (col.resized | B"16'h1000".resized) // A[12]=1 (BL8), A[10]=0 (keep row open)

        when(cycle === config.RCD / 4) {
          setCmd(config.RCD % 4, CMD_Read, bank, readA)
        }

        when(cycle === config.RCD / 4 + 1 || rdHavePending) {
          setCmd(config.RCD % 4, CMD_Read, bank, readA)
        }

        val rdIncr = canAcceptRdStream && io.req.valid
        when(cycle >= config.RCD / 4 + 1) {
          when(rdIncr) {
            reqReg        := io.req.payload
            rdHavePending := True
            rdExtraCnt    := rdExtraCnt + 1
          } otherwise {
            rdHavePending := False
            rdStreamOpen  := False
          }
        } otherwise {
          rdHavePending := False
        }

        val baseReadyCyc = if (config.isSimulation) (config.RCD / 4 + 9) else (config.RCD / 4 + 8)
        val readyCyc     = baseReadyCyc + rotSplit
        val rdDecr = (cycle >= readyCyc) && (rdRspLeft =/= 0)
        data_ready := rdDecr
        rdRspLeft  := rdRspLeft + rdIncr.asUInt.resize(6) - rdDecr.asUInt.resize(6)

        when(!rdStreamOpen && !rdHavePending && (rdRspLeft === 0) && !data_ready && (cycle >= readyCyc + 2)) {
          busy  := False
          state := Ddr3State.IDLE
        }
      }

      is(Ddr3State.WRITE) {
        val blockIdx = reqReg.addr
        val col  = (blockIdx(config.colWidth - 4 downto 0) @@ U"3'b000").asBits
        val bank = blockIdx(config.colWidth - 4 + config.rowWidth + config.bankWidth downto config.colWidth - 3 + config.rowWidth).asBits

        def driveDm(r: Ddr3Req, halfWord: Int): Bool = !r.wstrb(halfWord * 2 + 1 downto halfWord * 2).orR

        when(trainDone) {
          // Calibration write path (closed-page with AutoPrecharge, unchanged)
          when(cycle === config.RCD / 4) {
            val writeA = (col.resized | B"16'h1400".resized) // A[12]=1 (BL8), A[10]=1 (AutoPrecharge)
            setCmd(config.RCD % 4, CMD_Write, bank, writeA)
          }

          // wrMode: 0=norm, 1=dqAdv(-1tCK), 2=burstDly1(+1tCK), 3=burstDly2(+2tCK)
          when(cycle === (config.RCD + config.CWL) / 4) {
            switch(wrMode) {
              is(0) {
                dqs_out := B"8'b0100_0000"
                dqs_oen := B"4'b0011"
                dq_oen  := B"4'b0111"
                dq_out(6) := 0
                dq_out(7) := reqReg.wdata(15 downto 0)
                dm_out(6) := True
                dm_out(7) := !reqReg.wstrb(1 downto 0).orR
              }
              is(1) {
                dqs_out := B"8'b0100_0000"
                dqs_oen := B"4'b0011"
                dq_oen  := B"4'b0011"
                dq_out(4) := B"16'h0"
                dq_out(5) := reqReg.wdata(15 downto 0)
                dq_out(6) := reqReg.wdata(31 downto 16)
                dq_out(7) := reqReg.wdata(47 downto 32)
                dm_out(4) := True
                dm_out(5) := !reqReg.wstrb(1 downto 0).orR
                dm_out(6) := !reqReg.wstrb(3 downto 2).orR
                dm_out(7) := !reqReg.wstrb(5 downto 4).orR
              }
              is(2) {
                // +1 tCK burst delay: preamble at D6=0, D7=0
                dqs_out := 0
                dqs_oen := B"4'b0111"
              }
              is(3) {
                // +2 tCK burst delay: idle in cycle 2
              }
            }
          }

          when(cycle === (config.RCD + config.CWL) / 4 + 1) {
            switch(wrMode) {
              is(0) {
                dqs_out := B"8'b0101_0101"
                dqs_oen := B"4'b0000"
                dq_oen  := B"4'b0000"
                dq_out(0) := reqReg.wdata(31 downto 16)
                dq_out(1) := reqReg.wdata(47 downto 32)
                dq_out(2) := reqReg.wdata(63 downto 48)
                dq_out(3) := reqReg.wdata(79 downto 64)
                dq_out(4) := reqReg.wdata(95 downto 80)
                dq_out(5) := reqReg.wdata(111 downto 96)
                dq_out(6) := reqReg.wdata(127 downto 112)
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
              is(1) {
                dqs_out := B"8'b0101_0101"
                dqs_oen := B"4'b0000"
                dq_oen  := B"4'b0000"
                dq_out(0) := reqReg.wdata(63 downto 48)
                dq_out(1) := reqReg.wdata(79 downto 64)
                dq_out(2) := reqReg.wdata(95 downto 80)
                dq_out(3) := reqReg.wdata(111 downto 96)
                dq_out(4) := reqReg.wdata(127 downto 112)
                dq_out(5) := B"16'h0"
                dq_out(6) := B"16'h0"
                dq_out(7) := 0
                dm_out(0) := !reqReg.wstrb(7 downto 6).orR
                dm_out(1) := !reqReg.wstrb(9 downto 8).orR
                dm_out(2) := !reqReg.wstrb(11 downto 10).orR
                dm_out(3) := !reqReg.wstrb(13 downto 12).orR
                dm_out(4) := !reqReg.wstrb(15 downto 14).orR
                dm_out(5) := True
                dm_out(6) := True
                dm_out(7) := True
              }
              is(2) {
                dqs_out := B"8'b0101_0101"
                dqs_oen := B"4'b0000"
                dq_oen  := B"4'b0000"
                dq_out(0) := 0
                dq_out(1) := reqReg.wdata(15 downto 0)
                dq_out(2) := reqReg.wdata(31 downto 16)
                dq_out(3) := reqReg.wdata(47 downto 32)
                dq_out(4) := reqReg.wdata(63 downto 48)
                dq_out(5) := reqReg.wdata(79 downto 64)
                dq_out(6) := reqReg.wdata(95 downto 80)
                dq_out(7) := reqReg.wdata(111 downto 96)
                dm_out(0) := True
                dm_out(1) := !reqReg.wstrb(1 downto 0).orR
                dm_out(2) := !reqReg.wstrb(3 downto 2).orR
                dm_out(3) := !reqReg.wstrb(5 downto 4).orR
                dm_out(4) := !reqReg.wstrb(7 downto 6).orR
                dm_out(5) := !reqReg.wstrb(9 downto 8).orR
                dm_out(6) := !reqReg.wstrb(11 downto 10).orR
                dm_out(7) := !reqReg.wstrb(13 downto 12).orR
              }
              is(3) {
                dqs_out := B"8'b0101_0100" // D0=0,D1=0 pre; D2=1,D3=0..D6=1,D7=0
                dqs_oen := B"4'b0000"
                dq_oen  := B"4'b0001"      // D2..D7 driven
                dq_out(2) := 0
                dq_out(3) := reqReg.wdata(15 downto 0)
                dq_out(4) := reqReg.wdata(31 downto 16)
                dq_out(5) := reqReg.wdata(47 downto 32)
                dq_out(6) := reqReg.wdata(63 downto 48)
                dq_out(7) := reqReg.wdata(79 downto 64)
                dm_out(2) := True
                dm_out(3) := !reqReg.wstrb(1 downto 0).orR
                dm_out(4) := !reqReg.wstrb(3 downto 2).orR
                dm_out(5) := !reqReg.wstrb(5 downto 4).orR
                dm_out(6) := !reqReg.wstrb(7 downto 6).orR
                dm_out(7) := !reqReg.wstrb(9 downto 8).orR
              }
            }
          }

          // Cycle 4: Postamble completion (held low) then all return to high-Z
          when(cycle === (config.RCD + config.CWL) / 4 + 2) {
            switch(wrMode) {
              is(0, 1) {
                dqs_out := 0
                dqs_oen := B"4'b1110"      // TX0=0 held low for 1/2 CK postamble
                dq_oen  := B"4'b1111"
              }
              is(2) {
                dqs_out := B"8'b0000_0001" // D0=1 (b7), D1=0, D2=0 postamble
                dqs_oen := B"4'b1100"
                dq_oen  := B"4'b1110"
                dq_out(0) := reqReg.wdata(127 downto 112)
                dq_out(1) := 0
                dm_out(0) := !reqReg.wstrb(15 downto 14).orR
                dm_out(1) := True
              }
              is(3) {
                dqs_out := B"8'b0000_0101" // D0=1,D1=0,D2=1,D3=0,D4=0,D5=0 postamble
                dqs_oen := B"4'b1000"
                dq_oen  := B"4'b1100"
                dq_out(0) := reqReg.wdata(95 downto 80)
                dq_out(1) := reqReg.wdata(111 downto 96)
                dq_out(2) := reqReg.wdata(127 downto 112)
                dq_out(3) := 0
                dm_out(0) := !reqReg.wstrb(11 downto 10).orR
                dm_out(1) := !reqReg.wstrb(13 downto 12).orR
                dm_out(2) := !reqReg.wstrb(15 downto 14).orR
                dm_out(3) := True
              }
            }
          }

          when(cycle === ((wrMode >= 2) ? U(32 / 4, 7 bits) | U(28 / 4, 7 bits))) {
            // Calib write done: training write -> back to IDLE for the
            // poison write; poison write -> to the sweep (re-ACTs the row).
            trainDone := False
            when(needPoison) {
              state := Ddr3State.IDLE
              cycle := 0
            } otherwise {
              state := Ddr3State.READ_CALIB
              cycle := 0
            }
          }
        } otherwise {
          // Functional open-page + back-to-back streaming WRITE (A[10]=0, tCCD = 1 pclk)
          val isFirstWr  = (cycle === config.RCD / 4)
          val issueWrCmd = isFirstWr || wrHavePending
          val wrAccept   = canAcceptWrStream && io.req.valid

          when(issueWrCmd) {
            val writeA = (col.resized | B"16'h1000".resized) // A[12]=1 (BL8), A[10]=0 (keep row open)
            setCmd(config.RCD % 4, CMD_Write, bank, writeA)
          }

          st1Valid := issueWrCmd
          when(issueWrCmd) { st1Req := reqReg }
          st2Valid := st1Valid
          st2Req   := st1Req
          st3Valid := st2Valid
          st3Req   := st2Req

          when(wrAccept) {
            reqReg        := io.req.payload
            wrHavePending := True
            wrExtraCnt    := wrExtraCnt + 1
          } otherwise {
            wrHavePending := False
            wrStreamOpen  := False
          }

          switch(wrMode) {
            is(0) {
              when(st1Valid && !st2Valid) {
                dqs_out := B"8'b0100_0000"
                dqs_oen := B"4'b0011"
                dq_oen  := B"4'b0111"
                dq_out(6) := 0
                dq_out(7) := st1Req.wdata(15 downto 0)
                dm_out(6) := True
                dm_out(7) := driveDm(st1Req, 0)
              } elsewhen(st2Valid) {
                dqs_out := B"8'b0101_0101"
                dqs_oen := B"4'b0000"
                dq_oen  := B"4'b0000"
                for (j <- 0 until 7) {
                  dq_out(j) := st2Req.wdata((j + 1) * 16 + 15 downto (j + 1) * 16)
                  dm_out(j) := driveDm(st2Req, j + 1)
                }
                when(st1Valid) {
                  dq_out(7) := st1Req.wdata(15 downto 0)
                  dm_out(7) := driveDm(st1Req, 0)
                } otherwise {
                  dq_out(7) := 0
                  dm_out(7) := True
                }
              } elsewhen(st3Valid) {
                dqs_out := 0
                dqs_oen := B"4'b1110"
                dq_oen  := B"4'b1111"
              }
            }
            is(1) {
              when(st1Valid && !st2Valid) {
                dqs_out := B"8'b0100_0000"
                dqs_oen := B"4'b0011"
                dq_oen  := B"4'b0011"
                dq_out(4) := 0
                dm_out(4) := True
                for (j <- 0 until 3) {
                  dq_out(5 + j) := st1Req.wdata(j * 16 + 15 downto j * 16)
                  dm_out(5 + j) := driveDm(st1Req, j)
                }
              } elsewhen(st2Valid) {
                dqs_out := B"8'b0101_0101"
                dqs_oen := B"4'b0000"
                dq_oen  := B"4'b0000"
                for (j <- 0 until 5) {
                  dq_out(j) := st2Req.wdata((j + 3) * 16 + 15 downto (j + 3) * 16)
                  dm_out(j) := driveDm(st2Req, j + 3)
                }
                when(st1Valid) {
                  for (j <- 0 until 3) {
                    dq_out(5 + j) := st1Req.wdata(j * 16 + 15 downto j * 16)
                    dm_out(5 + j) := driveDm(st1Req, j)
                  }
                } otherwise {
                  for (j <- 5 until 8) {
                    dq_out(j) := 0
                    dm_out(j) := True
                  }
                }
              } elsewhen(st3Valid) {
                dqs_out := 0
                dqs_oen := B"4'b1110"
                dq_oen  := B"4'b1111"
              }
            }
            is(2) {
              when(st1Valid && !st2Valid) {
                dqs_out := 0
                dqs_oen := B"4'b0111"
              } elsewhen(st2Valid && !st3Valid) {
                dqs_out := B"8'b0101_0101"
                dqs_oen := B"4'b0000"
                dq_oen  := B"4'b0000"
                dq_out(0) := 0
                dm_out(0) := True
                for (j <- 0 until 7) {
                  dq_out(j + 1) := st2Req.wdata(j * 16 + 15 downto j * 16)
                  dm_out(j + 1) := driveDm(st2Req, j)
                }
              } elsewhen(st3Valid && st2Valid) {
                dqs_out := B"8'b0101_0101"
                dqs_oen := B"4'b0000"
                dq_oen  := B"4'b0000"
                dq_out(0) := st3Req.wdata(127 downto 112)
                dm_out(0) := driveDm(st3Req, 7)
                for (j <- 0 until 7) {
                  dq_out(j + 1) := st2Req.wdata(j * 16 + 15 downto j * 16)
                  dm_out(j + 1) := driveDm(st2Req, j)
                }
              } elsewhen(st3Valid) {
                dqs_out := B"8'b0000_0001"
                dqs_oen := B"4'b1100"
                dq_oen  := B"4'b1110"
                dq_out(0) := st3Req.wdata(127 downto 112)
                dq_out(1) := 0
                dm_out(0) := driveDm(st3Req, 7)
                dm_out(1) := True
              }
            }
            is(3) {
              when(st2Valid && !st3Valid) {
                dqs_out := B"8'b0101_0100"
                dqs_oen := B"4'b0000"
                dq_oen  := B"4'b0001"
                dq_out(2) := 0
                dm_out(2) := True
                for (j <- 0 until 5) {
                  dq_out(3 + j) := st2Req.wdata(j * 16 + 15 downto j * 16)
                  dm_out(3 + j) := driveDm(st2Req, j)
                }
              } elsewhen(st3Valid && st2Valid) {
                dqs_out := B"8'b0101_0101"
                dqs_oen := B"4'b0000"
                dq_oen  := B"4'b0000"
                for (j <- 0 until 3) {
                  dq_out(j) := st3Req.wdata((j + 5) * 16 + 15 downto (j + 5) * 16)
                  dm_out(j) := driveDm(st3Req, j + 5)
                }
                for (j <- 0 until 5) {
                  dq_out(3 + j) := st2Req.wdata(j * 16 + 15 downto j * 16)
                  dm_out(3 + j) := driveDm(st2Req, j)
                }
              } elsewhen(st3Valid) {
                dqs_out := B"8'b0000_0101"
                dqs_oen := B"4'b1000"
                dq_oen  := B"4'b1100"
                for (j <- 0 until 3) {
                  dq_out(j) := st3Req.wdata((j + 5) * 16 + 15 downto (j + 5) * 16)
                  dm_out(j) := driveDm(st3Req, j + 5)
                }
                dq_out(3) := 0
                dm_out(3) := True
              }
            }
          }

          when(issueWrCmd) {
            wrCooldown := (wrMode >= 2) ? U(5, 4 bits) | U(4, 4 bits)
          } elsewhen(wrCooldown =/= 0) {
            wrCooldown := wrCooldown - 1
          }

          when(!issueWrCmd && !st1Valid && !st2Valid && !st3Valid && (wrCooldown === 0)) {
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
    wlevel_tries := 0
    wlVoteN := 0
    wlVoteCnt := 0
    wlVoteCnt0 := 0
    wlVoteCnt1 := 0
    wlLockedR := False
    wlLockedStepR := 0
    wlevel_done := False
    wstep := (if (config.isSimulation) B"8'h18" else B"8'h00")
    rcalib_cnt := 0
    rcalib_done := False
    rcalib_tries := 0
    dllSweepOn := False
    dllSweepDone := False
    bestCntDll := 0
    needFinalSurvey := False
    s0Side := False
    s0Mag := 0
    s1Side := False
    s1Mag := 0
    s2Side := False
    s2Mag := 0
    bestSide := False
    bestMag := 0
    anchorLeft := 0
    aligning := False
    settleLeft := 0
    applyArmed := False
    navigateLeft := 0
    bistReturn := False
    rmove := False
    rdir := False
    bestRot := 0
    wrMode := 0
    shiftCalDone := False
    tryMode := 0
    wCalDone := False
    wTry := 0
    wBase := 0
    bestWstep := 0
    best0 := 0
    best0Pos := B"2'd0"
    best0Sel := B"3'd0"
    best0Rot := 0
    bestMode := 0
    bestWCnt := 0
    bestWPos := 0
    bestWSel := 0
    bestWRot := 0
    bestWMode := 0
    rotScorer.resetScorer()
    training := True
    trainDone := False
    needPoison := False
    rclkpos := (if (config.isSimulation) B"2'd0" else B"2'd0")
    rclksel := (if (config.isSimulation) B"3'd0" else B"3'd0")
    init_done_latched := False
    rowOpen := False
    openBank := 0
    openRow := 0
    prechForReq := False
    wrStreamOpen := False
    wrHavePending := False
    wrExtraCnt := 0
    wrCooldown := 0
    st1Valid := False
    st2Valid := False
    st3Valid := False
    rdStreamOpen := False
    rdHavePending := False
    rdExtraCnt := 0
    rdRspLeft := 0
    rburst_seen := 0
    resetn_delay := False
    if (!config.isSimulation) {
      wserRstCnt := 0
      wser_rst := False
    }
    state := Ddr3State.RST_WAIT
  }

  // Feed read data out (128 bits), de-rotated by the locked training rotation.
  // When bestRot != 0, beats j < bestRot (newest FIFO slots 8-bestRot..7) arrive one pclk
  // earlier than beats j >= bestRot (oldest FIFO slots 0..7-bestRot) during streamed reads,
  // so we combine dqPrevVec (previous pclk) with live dqVec.
  val dqVec = Vec(io.phy.dq_in(0), io.phy.dq_in(1), io.phy.dq_in(2), io.phy.dq_in(3),
                  io.phy.dq_in(4), io.phy.dq_in(5), io.phy.dq_in(6), io.phy.dq_in(7))
  val dqPrevVec = Vec((0 until 8).map(j => RegNext(io.phy.dq_in(j)) init(0)))
  def derot(j: Int): UInt = (U(j, 4 bits) - bestRot.resize(4))(2 downto 0)
  val needRotSplit = (bestRot =/= 0)
  val rdataVec = Vec(Bits(16 bits), 8)
  for (j <- 0 until 8) {
    val slot = derot(j)
    rdataVec(j) := (needRotSplit && U(j, 3 bits) < bestRot) ? dqPrevVec(slot) | dqVec(slot)
  }
  io.rsp.valid := data_ready
  io.rsp.rdata := (rdataVec(7) ## rdataVec(6) ## rdataVec(5) ## rdataVec(4) ##
                   rdataVec(3) ## rdataVec(2) ## rdataVec(1) ## rdataVec(0))

  // Connect control ports to PHY
  io.phy.dqs_hold     := dqs_hold
  io.phy.wstep        := wstep
  // RLOADN rule (load-bearing, see sweep): track (low) before any sweep and
  // during anchor windows, hold (high) everywhere else -- from the first
  // anchor through functional traffic, so the winner is never dropped. The
  // anchor-base scan holds too (its surveys run at held bases).
  io.phy.rloadn := (if (config.isSimulation) ((dllSweepOn || dllSweepDone || scanOn) && (anchorLeft === 0)) else False)
  io.phy.rmove        := rmove
  io.phy.rdir         := rdir
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
  if (!config.isSimulation) {
    io.phy.wser_rst := wser_rst
  }

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
  io.best_rot         := bestRot
  io.best_score       := bestCnt
  io.dbg_state        := state.asBits

  Ddr3FormalProps.bind(this)
}
