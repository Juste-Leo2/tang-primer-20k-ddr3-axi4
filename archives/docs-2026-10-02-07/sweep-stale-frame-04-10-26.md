# Sweep RMOVE : mesures decouplees du delai (cadres residuels) - 04-10-26

## 1. Constat

- S25 (`STEP=25`) : `RESULT PASS errors=0`, exit precoce `+0`, lock `rot=6 score=8`.
- S23 (`STEP=23`) : `RESULT FAIL errors=8`, epuisement (best `(plus,0)=6`),
  lock passe-3 `rot=4 score=6`. Meme training (`W=19`), meme modele, meme RTL.
- Prediction violee : 23 -> `+2` attendu (oeil de 25 a 2 taps), jamais trouve.

## 2. Preuves sonde (mecanisme innocent)

Sonde TB `PROBE` (`tb_fast.v`, `TEMP-PROBE-REMOVE-AFTER-DIAG`) :
`RLOADN/RMOVE/RDIR/rstep1/rstep2` puis film `RPOINT/WPOINT/rd_en/dqs_en/HOLD`.

- Anchor OK des le reset : `rstep=0x17=23` (S23) / `0x19=25` (S25) a 9.3 ns
  (front `X->0` de RLOADN recharge `DLLSTEP`).
- S23 : montee `17h -> 57h` (23 -> 87, 48 echantillons/mag pile),
  puis redescente minus jusqu'au **rail 0** (protection `RFLAG` du modele,
  correct). 88 taps visites, 2 DQS au pas, `RDIR=0` puis `1`, reloads
  d'anchor OK. Le pulse et le navigate marchent au Tac-O-Tac.
- S25 : `rstep` fige a `19h`, `RMOVE=0` partout (exit avant le 1er wrap,
  `bestMag=0` -> 0 pulse navigate). S25 n'a JAMAIS teste un pulse :
  son PASS = anchor == reponse, pas preuve du sweep.

## 3. Preuves latch (capture gelee)

`simulation/compare_runs.py` (S25 vs S23) + comptage direct :

- S23 : ~600 slots sweep, **3 mots distincts** sur pos=0 (2 variantes
  training-rot + zeros), max 6 partout, **zero slot a 8** — alors que le
  hardware est passe par 25 (profil `perpos` identique sur 10 segments).
- S25 : mot-a-8 fige (`n8=23` en survey-2, exit en 7 slots).
- `rstep` bouge, les scores ne bougent pas : la mesure ne suit pas le delai.

## 4. Preuves pointeurs (machinerie saine)

Stats full-run (S25 : n=2146, S23 : n=8446) quasi identiques au facteur
d'echelle pres :

- `RPOINT {0,2,4,6}`, `WPOINT {0..7}`, 2 DQS trackes, `HOLD` qui retombe
  par iteration, `dqs_en=1` en rafale. Ni freeze, ni divergence, ni rail.
- Conclusion : les compteurs vivent ; c'est la **relation (W-R) au moment
  du latch**, heritee de l'historique pre-sweep (`rstep` 23 vs 25 pendant
  WL/training/surveys -> gaps differents -> cadres residuels differents :
  mot-a-6 vs mot-a-8), qui ne bouge plus pendant le sweep. Le sweep mesure
  un cadre statique.

## 5. Parallele HW (meme signature, pas un artefact sim)

26 resets : `C` plafonne a 6 (jamais 8), `FAIL G=H=01AB45EF...` constant
quel que soit `C` (2/4/6), `WLMAP` stable (`f=0A l=0A n=02`), 1 boot aux
moities melees (capture marginale). `G` = residu training : le delai
verrouille est "stale-tuned" (bon mecaniquement, mauvais point). Meme
maladie qu'en sim -> fix discipline de mesure (RTL, profite aux deux),
pas axe du sweep.

## 6. Ecartes (avec preuve)

- Pulses perdus : NON (sonde, §2). RDIR inverse : NON (modele `0=plus`,
  concorde). Largeurs regs : NON (`anchorLeft` 2 bits, `navigateLeft`
  7 bits). Loop-backs : NON (deja corriges, calib termine).
- WPOINT-guard : reverti, dormant, retire (`5743900` inverse).
- Lanes 6-7 : symptome du cadre gele, pas bug de lanes.
- Variance WL/training : NON (`W=19` des deux cotes).
- Toolchain sim (v12/v14, timeouts, doublons) : pieges de lancement
  rencontres et resolus, sans lien avec le FAIL.

## 7. Plan

- **Phase 1 - clore le diag** : micro-fenetre VCD sur S23 autour d'un
  mag-step cote plus (passage `18h->19h` = point-equivalent-S25) :
  `DQSR90, WPOINT/RPOINT, Q, trainLatch, rstep`. Voir quel cadre est
  latche et pourquoi il ne suit pas. 1 run (~25 min).
- **Phase 2 - fix** : resync pointeurs par mesure (candidat n°1 :
  discipline `HOLD`/`dqs_hold` — `reset_f = reset|HOLD` reset `WPOINT`
  + `RPOINT`, tenu pendant les rafales calib). Prouver : S23 vert avec
  latches qui evoluent + exit au vrai oeil.
- **Phase 3 - validation** : S25 vert, unitaires 12/12, formel local,
  docs, retrait sonde TEMP-PROBE, `compare_runs.py` conserve,
  commit (user), PNR autre PC, check UART HW.

## 8. TODOs lies (apres fix)

- UART : cabler `bestSide/bestMag` (+ score) dans le banner `[DDR3-OK]`
  (aveugle sur le winner auj.).
- TB : retirer le bloc `TEMP-PROBE-REMOVE-AFTER-DIAG` de `tb_fast.v`.
- Timeout `sim_ddr.py run()` : supprime (`None`) le 04-10-26 (tuait les
  sims longues saines) — ne pas reintroduire sans marge.

## 9. Documents lies

- `dll-offset-K.md` §7 (s0, sel impair), §9 (lecon WPOINT-guard).
- `audit-wl.md` (commandes, verdicts, §4 `WL_LOCK_OFF=-1` garde).
- `capture-map-observations.md`, `tb-cartographie.md`.
- Logs : `simulation/tb_fast_s25_p0_w-1_k0.log` (PASS),
  `simulation/tb_fast_s23_p0_w-1_k0.log` (+ `.bak`), `unit_all.log` (12/12).
