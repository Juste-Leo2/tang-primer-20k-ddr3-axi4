# Current state + next steps — 128-bit DDR3 controller (08/10/2026)

Consolidation of the 16 archived docs (`archives/docs-2026-10-02-07/`, see its
`README.md` for the index). Background reference: `doc/design.md`. Main
sources: `plan-suite-08-10-26`, `window-battery-07-10-26`,
`vcd-h1-07-10-26` (incl. §6 fresh re-verification, 08/10),
`nestedk-battery-06-10-26`, `calib-hold-stale-05-10-26`,
`bug-02-10-26-18h20`, `HANDOFF` (WSL rules moved to `AGENTS.md`).

## 1. Goal

128-bit BL8 DDR3 controller in SpinalHDL for the Tang Primer 20K (GW2A-18C),
then `row14/2048Mb` + 128-bit `Ddr3Axi4` for AI. **The controller does not
work as-is**: calibration locks a false 6/8 (C=6) both in sim and on silicon.

## 2. Current RTL base (validated, keep)

- Double-burst (2 READs tCCD apart, no AP + explicit PRE, calib +
  functional), `dqs_read` 4 pclk, training latch on the `data_ready` cycle,
  per-iteration `HOLD`, gate on score only, sweep over all **8 rotations**
  (`bestRot`, ties → lowest index), de-rotated `rsp`.
- `dqs_read` also asserted on WRITE → `dqs_en` never falls back after init →
  no spurious `0→X` edge → stable rotation calib→functional (sim rot = 6).
- BIST write-then-read + `bistReturn`, per-step pin `pinLeft=2`
  (determinism), window-scan (`sweepMag0/N`, `winEnd`), VCD micro-window +
  PROBE in `tb_fast.v`, gated `chk`/`tries`, 3M watchdogs (test-only).
- SIM/HW seed: `(0,0)`. Formal BMC300 on final RTL: engine proved **300/300
  steps, zero assertion failures** — but sby's own 1200 s timeout fired during
  finalization (`status: TIMEOUT 8 0`, Spinal `SymbiYosys failure`, mill FAILED).
  Not a proof failure: fix = `.withTimeout(1200→3600)` in `Ddr3FormalTest.scala`
  (done, wide margin: the engine needs ~1600 s wall); clean PASS re-run pending (~30 min).
- Bugs 1–2 formally proven and fixed: reset Hi-Z parking (P9),
  `init_done`+`rburst_seen` cleared on reset + anti-reset guard (P5).
- Anti-regression battery (08/10): Verilog regen OK, unit tests 7/7 OK,
  formal BMC + TB step-25 control run launched (see §6).

## 3. The one unexplained fact

`S23-mag2-pos0` (rstep 25) samples **Hi-Z on the first edges** (DQ turn-on
+1 tCK) → score 6; `S25-mag0-pos0` (rstep 25) samples driven data → 8.
Identical 200 ns pre-history (proven), good content (6/8), constant ODT,
WSTEP 0x19 everywhere, HOLD/gap-0 everywhere, deterministic sim, same binary
(5447 identical `$var`s). VCD: BL8 bursts = 9 transitions / 4 posedges;
`xIdx=[0,4]` at S23, zero `x` at S25; identical detectors and lanes; model
granularity 25 ps/unit. DQ turn-on delayed by exactly 2.5 ns (1 tCK) on the
S23 side (`edge_dump.py`); DQSIN identical to within an edge, `cas/ras/we/cs`
identical to the ps over 200 ns.

## 4. Hypotheses — everything tried so far (all failed so far)

| # | Hypothesis | Verdict |
|---|---|---|
| H1 | Preamble-in-FIFO (+ gap picks the window) | **Favored, corrected**: what survives is preamble → 1st edge samples Hi-Z → `0000` slots (X→0). The "gap picks the window" link has **no support left** (gap-0 everywhere, and any 8-deep window covers all 8 cells anyway: score = 8 − #xx-cells, independent of RPOINT) |
| H2 | Sampling / setup-hold phase (rstep) | **Insufficient alone: CONFIRMED**. Early "H2 dead" verdict was premature, then restored: at the exact same delay (25), S23 still latches `x` — sampling alone can't explain it; the threshold moves with history (~50 ps razor edge) |
| H3 | Stale memory (training residue) | **Dead alone, PROVEN**: BIST is address-correct (writes `addr=0` = calib reads col 0). The HOLD-freezes-pointers mechanism stays proven as a contributor |
| H4 | Pin duration (release phase) | **TESTED NEGATIVE** (battery 16:27, H4 binary verified): S23 mags 0–9, pinLens 1–4 → max 6, no 8. S25 control intact at 8. H4 dead |
| H5 | Model artifact | Weak: same signature on HW (C≤6, residue G) |
| H6 | Window too short | Dead: S25 reaching 8 proves the window can do 8 |
| — | Nested-K axis (post-release offset) | **Refuted** (identical max for K=0..7 — the pin timing made all K groups measure the same gap phase). Reverted |
| — | Pre-measure idle normalization | **TESTED NEGATIVE, REVERTED**: S23 still 6 everywhere, S25 still 8. The write→read turnaround hypothesis died with it |
| — | Settle-per-step | Reverted (earlier decision, confirmed) |
| — | 3–4 bursts/iteration | Ruled out (past failure + rolling-dirty model: more bursts = same dirty fraction) |
| — | Misc | Ruled out by data: start gap, WSTEP, RNG (`RANDOM_OUT_DELAY=0`, deterministic), RPOINT, lanes, detectors, mux runt, BIST address, corrupted content (6/8 good + `xx`=Hi-Z, not wrong-data), binary skew, ODT, turnaround |

Also noted (minor, not priority): M3 — only lane0 Hi-Z at the 1st edge
(`first2D=x0`); M4 — RPOINT free-runs, sampling it at an arbitrary offset
proves nothing; M5 — isolated `n=4` clusters (single BL8s); M1 — the VCDs
already covered the decisive point, missed by truncated analysis (lesson:
always audit the WHOLE VCD). M2 (S23-pos3 score 0) is normal (window aside
on the pos axis).

Window-scan battery: no 8 outside the anchor-25 over 28 windows
(mags 0–70 × STEPs 23/25/40/60); S25 control OK; dirt = f(STEP): 23/40 → 6
(2 zeros), 60 → 7 (1 zero, slot-1007), 25 → 8.
HW: `[DDR3-OK] W=0A P=2 S=0`, `[FAIL]` with stale training beats → false 8/8
lock on training-write auto-capture; fix = poison-write block 1 +
`R=r C=c` banner, `rcalib_done`/`init_done` after sweep-2. Flash on the
other PC pending.

## 5. Next steps (in order)

Prerequisite: `python simulation/sim_ddr.py --fast-tb --map-only`
(current binary = pin=2 base).

1. **(b) Direct S23 mag2 window (~3 min). THE discriminant.**
   `vvp.exe simulation/tb_fast.vvp +step=23 +mag0=2 +magN=1`
   If 8 → mags 0/1 poison it (history length). If 6 → deeper (survey@23…).
   **DONE 09/10: 6** (`tb_fast_s23_m2.log`: `window side=0 mag=02 score=6
   rot=4`). Mags 0/1 innocent — not history length. → deeper.
2. **(c) S23+K2 mag0 (~3 min). (STEP,K) decomposition.**
   `+step=23 +k=2 +mag0=0 +magN=1` (eff 25, survey@25, measure@25).
   **DONE 09/10: 8** (`tb_fast_s23_m0.log`: `dll side=0 mag=00 score=8`,
   final lock 8). Same measured rstep 25 as (b), opposite verdict →
   **anchor+survey decide, not the endpoint**. Retest 09/10 reproduces:
   survey@25 scores 8 from tries=00a (`latch=10071006…`, full pattern).
3. **(a) 22/24 eye-map (~10 min).** `measure/mag_battery.py --steps 22,24
   --mag0 0 --magn 3 --jobs 2` (after `Remove-Item simulation/tb_fast_s*.log`).
4. **(E2) No-pin run** (comment out `pinLeft := 2`, keep pulse+shift; CoreTest,
   regen, TB rebuild, S23 7-slice battery + S25 control). If 8 → the pin is
   the saboteur.
5. **(E1, expensive backup) Re-run 2 VCD windows** on current binary (`--vcd`,
   `+vcdwinlen=2500000`, ~25 min) only if (b)(c) contradict everything.
6. HW-side candidates if sim turns out to be artifact: real PCB phase,
   `dqs_read`/RPOINT framing, WL offset (`+wl=24/26` on S23). Don't mix
   workstreams: settle (b)(c) first.

Process lessons: audit the WHOLE VCD; verify the binary before every battery;
RPOINT free-runs (never compare absolute values); `win*.log` are UTF-16; a
fix with no battery signal = immediate revert + doc.

## 6. Fix retenu (09/10, NON VALIDÉ) : boucle externe d'ancre

Good anchors connus : **25** (prouvé : test C + retest, survey@25 à 8 dès
`tries=00a`, latch plein) et **26** (signalé session précédente,
re-validation prévue batterie A). Mauvais : 23, 40 (→6), 60 (→7).

Design : boucle externe sur ~5 bases relatives au lock vivant
(`{0,+16,-16,+32,-32}`, paramétrable `anchorBases`/`anchorHopStep` dans
`Ddr3Config`), boucle interne = survey(40) + sweep mag±64 existants, rejoués
par base (couvre survey-empoisonné ET chemin-d'arrivée, encore confondus).
Early-exit global sur premier vrai 8, bases ordonnées dès +0 (cartes saines :
coût ~1×, comportement actuel préservé). Contraintes : steppers uniquement
(PR0015, pas d'adder sur DLLSTEP) ; `WLOADN=0` tenu donc le write suit
l'ancre en X4 (BIST cohérents par construction) ; re-run formel BMC requis.
Coût HW ≈ 1–2 ms ; coût sim ≈ 1 h/base → valider sur subsets uniquement.

Batteries sim recommandées (build MAP_ONLY actuel réutilisable : TB déjà
rebuildé avec `+anchor_step`, `BUILD rc=0`, ne pas rebuild entre les runs) :
- A. Densité d'ancres (~30 min, jobs=2) :
  `python measure/mag_battery.py --steps 22,23,24,25,26,27,28 --mag0 0 --magn 1 --jobs 2`
  → largeur de la zone bonne (25–26 isolés ? continuité ?), contrôle S25,
  re-validation 26.
- B. Discriminant hop (~20 min, jobs=2) :
  `python measure/mag_battery.py --steps 23,25 --anchor-steps 25,23 --mag0 0,2 --magn 1 --jobs 2`
  → s23a25 (survey23/ancre25/mesure25) + miroir s25a23, + 2 contrôles bonus
  (mesure 23 et 27). Si s23a25 → 8 : l'ancre décide (cas A) ; si 6 : le
  survey empoisonne l'aval (cas B).
Total ≈ 50 min mur. Ensuite seulement : edit Scala → regen → unitaires →
formel BMC + TB S25 en fond (batterie anti-régression du 08/10).
