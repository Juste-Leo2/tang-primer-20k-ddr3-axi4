# Plan de suite calib read (C=6) — 08-10-26

État de l'arbre : socle pin=2 + BIST + window-scan + HOLD-free-run,
CoreTest vert, regen OK. Idle et H4 testés-négatifs et REVERTÉS.

## 1. Garder / revertern (verdict commit)

GARDER (robustesse ou diag, sim-only ou prouvé) :
- BIST write-then-read + `bistReturn` (hygiène, S25/S26 meilleurs).
- Pin-par-palier `pinLeft=2` (déterminisme 52/52).
- Window-scan (`sweepMag0/N`, `winEnd`, `mag_battery.py`, `analyze_window.py`).
- Micro-fenêtre VCD + PROBE dans `tb_fast.v` (indispensable au diag).
- `chk`/`tries` gatés, watchdogs tests 3M (test-only).
- Tous les scripts `simulation/analyze_*.py`, `audit_burst.py`,
  `full_state.py`, `edge_dump.py`, `odt_level.py`, `wpoint_cover.py`,
  `var_diff.py`, `burst_by_state.py`, `detector_state.py`, `find_state.py`,
  `margin_dq.py` + docs (`vcd-h1` §6 = état complet).
- `mag_battery.py` round-robin + Ctrl+C propre (UX, résultats inchangés).

REVERTÉ (négatif, ne pas committer) : idle pré-mesure (S23 toujours 6),
H4 pin-cyclage 1-4 (mags 0-9 max 6, S25 contrôle 8). Déjà sortis de
l'arbre. Ne pas rouvrir : nested-K, settle-par-palier, 3-4 bursts.

## 2. Le seul fait inexpliqué

`S23-mag2-pos0` (rstep 25, PROBE+VCD) échantillonne Hi-Z aux 1ers fronts
(DQ turn-on +1 tCK) → latch 6 ; `S25-mag0-pos0` (rstep 25) échantillonne
drivé → 8. Historique-200ns ps-identique (commandes), contenu bon (6/8),
ODT constant, WSTEP 0x19 partout, HOLD/gap-0 partout, sim déterministe
(`RANDOM_OUT_DELAY=0`, pas de RNG), même binaire (5447 vars identiques).

## 3. Expériences suivantes (ordre, commandes PowerShell)

Pré-requis commun (binaire courant = socle pin=2, regen déjà fait) :
`python simulation/sim_ddr.py --fast-tb --map-only`

- **(b) S23 mag2 direct (~3 min). LE discriminant.**
  `.\tools\oss-cad-suite\bin\vvp.exe simulation/tb_fast.vvp +step=23 +mag0=2 +magN=1 > simulation/tb_fast_s23_m2.log 2>&1`
  Lecture : `Select-String "WINDOW|RCALIB dll" simulation/tb_fast_s23_m2.log`
  Si 8 → ce sont les mags 0/1 qui empoisonnent (longueur d'historique).
  Si 6 → plus profond (survey@23 ou persistance modèle).
- **(c) S23+K2 mag0 (~3 min). Décomposition (STEP,K).**
  `...\vvp.exe simulation/tb_fast.vvp +step=23 +k=2 +mag0=0 +magN=1 > simulation/tb_fast_s23k2_m0.log 2>&1`
  (eff 25, survey@25, mesure@25). Si 8 → la décomposition compte.
  Si 6 → même rstep+survey ne suffit pas.
- **(a) Eye-map 22,24 (~10 min). Largeur de l'œil.**
  `Remove-Item simulation/tb_fast_s*.log; python simulation/mag_battery.py --steps 22,24 --mag0 0 --magn 3 --jobs 2`
- **(E2) Run sans-pin (1 regen, implémentation ci-dessous, ~15 min).**
  Si 8 → le pin est le saboteur. Sinon exonoré.
- **(E1, backup cher) Re-run 2 fenêtres VCD sur binaire courant**
  (rebuild `--vcd`, `+vcdwinlen=2500000`, ~25 min) : uniquement si (b)(c)
  contredisent tout (doute résiduel artefact).

## 4. Design E2 sans-pin (si (b) pointe l'historique)

Au mag-step : ne plus armer `pinLeft` (commenter `pinLeft := 2`), garder
pulse + shift-s existants. L'invariant s2==HW tient sans pin sur le
chemin ENUM (le shift d'ADVANCE suffit ; seul le tout premier mag après
l'entrée fenêtre garde 1 iter de décalage, acceptable en diag). Valider :
CoreTest seul (~20 s), regen, rebuild TB, batterie S23 7 tranches + S25
contrôle. Si 8 quelque part → cause + direction du fix (release phase /
suppression du pin) ;-inspired la passe apply ensuite.

## 5. Notes HW-side (si la sim s'avère artefact)

Le C=6 silicium + résidu G subsistent quel que soit l'issue sim. Candidats
non testés côté HW : phase PCB réelle (préambule marginal à 400 MHz),
`dqs_read`/RPOINT framing (fenêtre READ trop précoce — la VCD montre
RPOINT en roue libre, le latch attrape une phase fixe), offset WL
(`WL_LOCK_OFF`, knob `+wl` testable en sim : `+wl=24/26` sur S23).
Ne pas mélanger les chantiers : trancher (b)(c) d'abord.

## 6. Leçons process (ne pas répéter)

- Auditer la VCD ENTIÈRE (jamais de `head` sur les bursts).
- Vérifier le binaire (date vvp vs `hw/gen` + champs du log) avant chaque
  batterie ; `Remove-Item simulation/tb_fast_s*.log` avant relance.
- RPOINT est en roue libre : ne jamais comparer ses valeurs absolues.
- `win*.log` en UTF-16 (convertir avant grep) ; `$dumpfile` relatif au CWD.
- Un fix sans signal en batterie = revert immédiat, doc du négatif.
