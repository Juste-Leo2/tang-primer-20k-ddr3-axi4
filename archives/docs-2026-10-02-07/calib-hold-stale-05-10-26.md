# Calibration : mesures figees sur residu training (discipline HOLD) - 05-10-26

## 1. Observations (S23 FAIL vs S25 PASS, meme training W=19)

- Sonde TB (`PROBE`) : `rstep` 0x17 -> 0x57 puis rail 0 (88 taps, 2 DQS,
  2 directions, reloads anchor OK). Mecanisme RMOVE sain.
- `compare_runs.py` : 88 taps x 4 pos, max 6 partout, **zero slot a 8** ;
  3 mots distincts sur ~600 iters (2 variantes training-rot + zeros).
- S25 (rstep fige 25) : 8. Meme training, meme RTL, meme modele.
- VCD + GTKWave (14.1-14.8 us) : `trainLatch` varie avec `rclkpos` a
  `rstep` constant ; `WPOINT/RPOINT` rembobinent par burst ; passage
  `19h->1Ah` dans un slot a zeros (transient CDC, benin).
- Pointeurs full-run S25 ~= S23 (memes distributions) : machinerie saine.
- HW (26 resets) : `C` plafonne a 6, `FAIL G=H` residu training constant
  quel que soit `C`, `WLMAP` stable. Meme signature, pas un artefact sim.

## 2. Mecanisme : `dqs_hold` par iteration fige les pointeurs

- `Ddr3ControllerCore.scala:434` : `dqs_hold := False` par defaut.
- Asserts : `is(0)` (604), **chaque burst de chaque iteration calib**
  (635/640), premier burst fonctionnel (976/993).
- `HOLD=1` => `reset_f=1` (modele) => `WPOINT<=0` + `RPOINT` au reset
  **pendant les rafales**. La phy cable `WADDR/RADDR` sur ces sorties.
- Ecritures (training, `HOLD=0`) : derniers a balayer tous les slots.
- Lectures calib : slot 0 re-ecrit (courant), mais `RPOINT` lit les
  slots 2/4+ (avance gaps/`rqen`), **jamais reecrits depuis le training**
  => latch = mot training residuel, constant. Poison jamais observe
  (slot 0 saute). `rstep` bouge dans le vide.
- Residu S25 (ecrit a rstep=25) = mot-a-8 (chance) ; S23 (rstep=23) =
  mot-a-6. Scores qui varient en `pos` = meme mot fige, `rot` differente.
- Fonctionnel : pin **une fois** (1er burst) puis free-run => frais.
  D'ou : fonctionnel OK, calib gele. Meme discipline sur silicium
  (pointeurs HW) => meme maladie HW.

## 3. Ecartes (definitive)

- Pulses/anchor/RDIR/largeurs/loop-backs : prouves OK (sonde).
- Variance WL/training (`W=19` partout), lanes 6-7 (symptome),
  toolchain sim, WPOINT-guard (retire), timeouts.
- Sweep RMOVE : enumeration saine (88 taps effectifs) ; le bug est la
  **discipline de mesure**, pas l'axe. vendor EYE SCAN valide la methode ;
  `ICLK=DQSR90` pilote bien la capture (phy:213) ; RDIR/edges conformes
  (apicula + UG).

## 4. Fix applique (Patch 1, committe) + suites

- HOLD libere pendant les bursts (free-run, miroir du fonctionnel) :
  S25 vert, mesures qui evoluent (3 mots figes -> 20).
- Settle-par-pallier (sans re-pin) essaye puis **reverte** : triplets
  avance+settle sans convergence (60 triplets, 59/60 tout-a-6), cout
  +50 % iters pour zero benefice mesure.
- **Pin-par-palier** (`pinLeft`, 2 slots HOLD + shift s-pipeline, scoring
  skippe) : post-pin pos0 52/52 deterministe a 6 (pas 8). Autopsie :
  scorer innocent (8 rotations testees), 2 beats manquants = **zeros
  adjacents** (`0000` x104/104, positions LSB {2}+{1ou3}). Mag +2
  (= rstep 25) score 6 alors que S25-ancre fait 8 => variable = **gap
  (W-R)**, pas rstep. Le pin explore un seul gap (gap-0, sale) ; le
  free-run ne l'explore pas non plus (suivi elastique). Piste : axe-gap
  (duree de pin) si le full-sweep ne trouve pas de 8.
- Hygiene logs : `chk`/`tries` gates sur `!busyMoving`, `rcalib_tries`
  6 -> 10 bits (wrap). Unitaires verts (`unit_pinleft2.log`).
- **Nested-K** (axe-gap) : `kSkip` 8 groupes free-run par mag (32 iters),
  `bestK` + replay `kreplayLeft` avant passe-3, `chk` enrichi
  (`side/mag/k/bestK`), `tries` 13 bits, watchdogs tests 12k->60k,
  `map_capture` reporte `maxsw@side/mag/k`. Unitaires verts.
  Batterie : 7 STEPs en parallele via `map_capture.py --jobs`
  (lancee par user, logs `tb_fast_s{step}_p{phase}.log`).
- Preuve attendue : **full S23** (plus 0-64 + minus + passe-3, sans stop
  premature) ; si max <= 6 partout -> redesign axe-gap.

Miroir du fonctionnel : pinner **une fois par passe** (`is(0)`, garder
604), **liberer pendant les bursts** (635/640 : premiere iteration
seulement ou retrait). Garder le poison (transients post-pin).
- Timeout-neutre : meme enumeration, meme nombre d'iters (seuls les
  scores changent ; mocks plats => memes chemins).
- Preuve attendue : S23 vert avec latches qui evoluent + exit au vrai
  oeil ; S25 vert (plus rapide) ; 12/12 ; formel local (props HOLD?).
- Fichiers : `ddr3/src/ddr3/Ddr3ControllerCore.scala` (2 lignes),
  regen `hw/gen`, re-sim. AUCUN changement TB/modele requis.

## 5. TODOs lies (apres fix)

- UART : `bestSide/bestMag` (+ score) dans `[DDR3-OK]`.
- TB : retirer `TEMP-PROBE-REMOVE-AFTER-DIAG` (`tb_fast.v:203`).
- Scripts : `compare_runs.py`, `/tmp/opencode/correlate.py` (jetable).
- VCD 3.5 Go (`simulation/tb_fast.vcd`) : supprimer apres diag.
- Commit (user), PNR autre PC, check UART HW.

## 6. Lies

- `doc/sweep-stale-frame-04-10-26.md` (phases 1-3, preuves sonde/latch).
- `doc/dll-offset-K.md` §7 (s0, sel impair), §9 (WPOINT-guard).
- `doc/audit-wl.md` (commandes, `WL_LOCK_OFF=-1` garde).
- Logs : `tb_fast_s25_p0_w-1_k0.log` (PASS), `tb_fast_s23_p0_w-1_k0.log`
  (+ `.bak`), `unit_all.log` (12/12).
