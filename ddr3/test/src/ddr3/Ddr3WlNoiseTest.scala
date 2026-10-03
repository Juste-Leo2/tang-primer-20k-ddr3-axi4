package ddr3

import org.scalatest.funsuite.AnyFunSuite
import spinal.core._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

/**
 * WL noise-model harness: validates the write-leveling search (vote,
 * debounce, warmup, lock offset) against silicon-like echo behavior.
 *
 * The deterministic harness (Ddr3TesterTopTest) answers every strobe,
 * which never happens on silicon (flickering echo, drift, dropouts,
 * startup remnant). Here the PHY emulation is driven by a seeded
 * hardware LFSR through 6 models:
 *  0. clean: every strobe answers (regression baseline, must lock 0x18)
 *  1. gauss: per-strobe hit probability ~ gaussian around trueW (jitter)
 *  2. dropout: random strobes forced miss (supply/DLL wobble)
 *  3. drift: trueW random-walks during the run (thermal drift)
 *  4. remnant: first strobes stuck-at-1 + background flips (init garbage)
 *  5. combined: gauss + dropout + drift + remnant at once (worst case)
 *
 * Writes are corrupted as a function of |wstep - trueW| (beats dropped),
 * so the sweep score ranks W candidates like on silicon. Assertions
 * cover calibration only (init_done, locked W near trueW, sweep score);
 * the memtest itself may fail by design under noise.
 */
object WlNoiseModel {
  val CLEAN    = 0
  val GAUSS    = 1
  val DROPOUT  = 2
  val DRIFT    = 3
  val REMNANT  = 4
  val COMBINED = 5
}

class Ddr3WlNoiseHarness(val axiConfig: Axi4Config, val config: Ddr3Config,
                         val testBursts: Int, val seed: Int, val model: Int,
                         val trueW0: Int) extends Component {
  val io = new Bundle {
    val uart_tx   = out Bool()
    val test_pass = out Bool()
    val test_err  = out Bool()
    val init_done = out Bool()
    val wstep     = out Bits(8 bits)
    val best_score = out UInt(4 bits)
    val trueW     = out Bits(8 bits)
  }

  val bridge = new Ddr3Axi4Bridge(axiConfig, config)
  val core   = new Ddr3ControllerCore(config)
  // Fast UART for sim (divider = 4), like Ddr3TesterSimHarness
  val engine = new Ddr3MemtestEngine(axiConfig, testBursts, clkFreqHz = 40000, baudRate = 10000)

  engine.io.axi       <> bridge.io.axi
  bridge.io.init_done := core.io.init_done
  core.io.req         <> bridge.io.req
  bridge.io.rsp       <> core.io.rsp

  engine.io.pll_lock         := True
  engine.io.init_done        := core.io.init_done
  engine.io.write_level_done := core.io.write_level_done
  engine.io.read_calib_done  := core.io.read_calib_done
  engine.io.wstep            := core.io.wstep
  engine.io.rclkpos          := core.io.rclkpos
  engine.io.rclksel          := core.io.rclksel
  engine.io.best_rot         := core.io.best_rot
  engine.io.best_score       := core.io.best_score
  engine.io.dbg_state        := core.io.dbg_state
  engine.io.wlMap            := core.io.wlMap
  engine.io.wlFirst          := core.io.wlFirst
  engine.io.wlLast           := core.io.wlLast
  engine.io.wlMatchN         := core.io.wlMatchN

  io.uart_tx    := engine.io.uart_tx
  io.test_pass  := engine.io.test_pass
  io.test_err   := engine.io.test_error
  io.init_done  := core.io.init_done
  io.wstep      := core.io.wstep
  io.best_score := core.io.best_score

  core.io.phy.dlllock    := True
  core.io.phy.rst_lock_n := True
  core.io.phy.rburst := (core.io.phy.dqs_read === 0x0F) ? B"2'b11" | B"2'b00"

  // --- Seeded LFSR noise source (reproducible per test) ---
  val lfsr = Reg(Bits(16 bits)) init(seed & 0xFFFF)
  lfsr := (lfsr(15) ^ lfsr(13) ^ lfsr(12) ^ lfsr(10)) ## lfsr(15 downto 1)
  val rnd8 = lfsr(7 downto 0).asUInt  // uniform 0..255, fresh each cycle

  // --- Drift: trueW random-walks slowly (thermal), simple saturating walk ---
  val trueW = Reg(UInt(8 bits)) init(trueW0 & 0xFF)
  io.trueW := trueW.asBits
  val driftCnt = Reg(UInt(12 bits)) init(0)
  driftCnt := driftCnt + 1 // always driven (free-run; walk gated below)
  val doDrift = (model == WlNoiseModel.DRIFT || model == WlNoiseModel.COMBINED)
  if (doDrift) {
    when(driftCnt === 4095) {
      driftCnt := 0
      // step +1 / -1 / 0 from LFSR bits, clamped to [8, 240]
      when(lfsr(14) && !lfsr(13) && trueW < 240) { trueW := trueW + 1 }
      when(!lfsr(14) && lfsr(13) && trueW > 8) { trueW := trueW - 1 }
    }
  }

  // --- Echo hit probability vs distance (gaussian-ish, stepwise) ---
  // All models except CLEAN use a window around the (possibly drifting)
  // trueW; CLEAN answers every strobe (regression baseline).
  val w = core.io.wstep.asUInt
  val dist = Mux(w > trueW, (w - trueW), (trueW - w))
  // prob x/256 of answering this strobe (clean: always)
  val hitProb = UInt(8 bits)
  if (model == WlNoiseModel.CLEAN) {
    hitProb := 255
  } else {
    hitProb := 5
    when(dist <= 3) { hitProb := 51 }    // ~0.2
    when(dist <= 2) { hitProb := 128 }   // ~0.5
    when(dist <= 1) { hitProb := 204 }   // ~0.8
    when(dist === 0) { hitProb := 242 }  // ~0.95
  }

  // --- WL strobe detect + response window ---
  val strobe = (core.io.phy.dqs_out === 0xAA || core.io.phy.dqs_out === 0x55)
  val wlTimer = Reg(UInt(4 bits)) init(0)
  val echoHit = RegInit(False)
  val strobeCnt = Reg(UInt(10 bits)) init(0)
  // Per-strobe hit draw, pure combinational (Scala ifs on the elab-time
  // model constant compose structure; no rebinding inside Spinal whens).
  var hit: Bool = rnd8 < hitProb
  if (model == WlNoiseModel.DROPOUT || model == WlNoiseModel.COMBINED) {
    // dropout: force miss (supply/DLL wobble), ~19% of strobes
    hit = hit && !(lfsr(15 downto 12).asUInt < 3)
  }
  if (model == WlNoiseModel.REMNANT || model == WlNoiseModel.COMBINED) {
    // remnant: first strobes stuck-at-1, plus ~6% background glitches
    hit = hit || (strobeCnt < 3) || (lfsr(11 downto 8).asUInt < 1)
  }
  when(strobe) {
    wlTimer := 12
    strobeCnt := strobeCnt + 1
    echoHit := hit
  } elsewhen(wlTimer > 0) {
    wlTimer := wlTimer - 1
  }
  core.io.phy.dq_raw := (wlTimer > 0 && echoHit) ? B"16'h0101" | B"16'h0000"

  // --- W-dependent write corruption (beats dropped when far from trueW) ---
  // dist 0-1: clean; 2-3: 1 beat; 4-5: 2 beats; >= 6: 4 beats.
  val drop = UInt(4 bits)
  drop := 0
  when(dist >= 2 && dist <= 3) { drop := 1 }
  when(dist >= 4 && dist <= 5) { drop := 2 }
  when(dist >= 6) { drop := 4 }
  val mem = Mem(Bits(128 bits), 64)
  val wdata = core.io.req.payload.wdata
  val stored = Bits(128 bits)
  for (b <- 0 until 8) {
    stored(b * 16 + 15 downto b * 16) := (U(b, 4 bits) < drop) ? B(0, 16 bits) | wdata(b * 16 + 15 downto b * 16)
  }
  when(core.io.req.fire && core.io.req.payload.write) {
    mem.write(core.io.req.payload.addr(5 downto 0), stored)
  }
  val readData = Reg(Bits(128 bits)) init(0)
  when(core.io.req.fire && !core.io.req.payload.write) {
    readData := mem.readAsync(core.io.req.payload.addr(5 downto 0))
  }
  // Sweep reads go through the core's internal training path (not
  // core.io.req), so emulate the DRAM training content here: the sweep
  // reads trainPat corrupted by the live W distance, exactly what a real
  // DRAM would hold after the W-dependent training writes. Otherwise the
  // sweep would always score 0 and no W could ever be ranked.
  // NOTE: cross-hierarchy reads of core.state/trainPat are illegal, so we
  // use the exposed dbg_state port and a copy of the pattern literal
  // (must match Ddr3ControllerCore.trainPat; the strict C==8 clean test
  // will catch any skew).
  val sweeping = core.io.dbg_state === Ddr3State.READ_CALIB.asBits
  val trainPatRef = B"128'h10071006100510041003100210011000"
  val sweepWord = Bits(128 bits)
  for (b <- 0 until 8) {
    sweepWord(b * 16 + 15 downto b * 16) := (U(b, 4 bits) < drop) ? B(0, 16 bits) | trainPatRef(b * 16 + 15 downto b * 16)
  }
  for (i <- 0 until 8) {
    core.io.phy.dq_in(i) := sweeping ? sweepWord(i * 16 + 15 downto i * 16) | readData(i * 16 + 15 downto i * 16)
  }
}

class Ddr3WlNoiseTest extends AnyFunSuite {
  val axi64Config = Axi4Config(addressWidth = 32, dataWidth = 64, idWidth = 4)

  def runCase(name: String, model: Int, seed: Int, trueW0: Int,
              expW: Int, tolW: Int, minScore: Int): Unit = {
    test(name) {
      val simConfig = SimConfig // no waves: speed for multi-seed runs
      simConfig.compile(new Ddr3WlNoiseHarness(axi64Config, Ddr3Config(isSimulation = true), 4, seed, model, trueW0)).doSim { dut =>
        dut.clockDomain.forkStimulus(period = 10)
        dut.clockDomain.waitSamplingWhere(120000)(dut.io.init_done.toBoolean)
        assert(dut.io.init_done.toBoolean, "init_done never asserted (calibration did not terminate)")
        val w = dut.io.wstep.toInt
        val s = dut.io.best_score.toInt
        val t = dut.io.trueW.toInt
        // expW < 0: assert against the final (possibly drifted) trueW
        val ref = if (expW < 0) t else expW
        println(s"[NOISE] model=$model seed=$seed trueW=$t lockedW=$w score=$s")
        assert(scala.math.abs(w - ref) <= tolW, s"locked W=$w too far from expected $ref (tol $tolW)")
        assert(s >= minScore, s"sweep score=$s below minimum $minScore")
      }
    }
  }

  // 0. clean: deterministic answer every strobe -> lock at sim seed 0x18
  //    minus WL_LOCK_OFF(-1) = 0x17, score 8
  runCase("WL noise model 0 (clean baseline)", WlNoiseModel.CLEAN, 0x1234, 0x18, 0x17, 0, 8)
  // 1. gauss around 0x20 (lock lands ~first-verdict-1)
  runCase("WL noise model 1 (gaussian flicker)", WlNoiseModel.GAUSS, 0x5678, 0x20, 0x1F, 4, 6)
  // 2. dropout around 0x20 (terminates, stays near)
  runCase("WL noise model 2 (dropouts)", WlNoiseModel.DROPOUT, 0x9ABC, 0x20, 0x1F, 4, 5)
  // 3. drift from 0x20 (score stays maximal, W follows the walk loosely)
  runCase("WL noise model 3 (thermal drift)", WlNoiseModel.DRIFT, 0xDEF0, 0x20, -1, 6, 6)
  // 4. remnant: stuck-at-1 startup + glitches must not lock early;
  // lands near 0x20 (sim seed is 0x18 so the <8 warmup gate itself is
  // HW-only and not covered here; this covers debounce + escape)
  runCase("WL noise model 4 (startup remnant)", WlNoiseModel.REMNANT, 0x1357, 0x20, 0x1F, 4, 6)
  // 5. combined worst case: terminates, no false-0 lock, usable score
  runCase("WL noise model 5 (combined)", WlNoiseModel.COMBINED, 0x2468, 0x20, 0x1F, 8, 4)
}
