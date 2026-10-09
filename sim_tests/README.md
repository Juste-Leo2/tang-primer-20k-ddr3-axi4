# sim_tests — mini-TB isolés (loi physique, pièges modèle, FSM)

Un test = un dossier `tNN_nom/` = un `PREDICTION.md` + un `tb_tNN.v` squelette.
Le `.v` ne contient QUE : horloges, instanciation (modèles vendor ou Verilog
généré depuis le Scala), `force`, `$display` de mesures. **Jamais de logique
DUT ni de logique de test en Verilog main** : le DUT vient du Scala
(`hw/gen/` ou `ProbeGen`), la matrice/prédiction/verdict vient du runner.

## Règles

- `PREDICTION.md` (question, prédiction chiffrée, conclusions selon résultat)
  écrit AVANT le premier run. Non négociable.
- Un seul build `iverilog -o` à la fois (`run.py` sérialise ; piège
  `use_island` si 2 builds concurrents vers le même `.vvp`).
- `run.py` via powershell (`python sim_tests/run.py ...`), jamais en natif
  (binaires `.exe` Windows). Il met `oss/bin+lib` au PATH lui-même.
- `gen/` = Verilog/logs de build jetables, gitignoré, jamais commité.

## Index des tests

| # | Dossier | Question / utilité | Prio | Statut |
|---|---------|--------------------|------|--------|
| 1 | t01_dqs_law | Loi DQS read : reload/stepping/rstep, pas 25ps. Tranche "vrai-25 illusoire ?" | ★★★ | vert 09/10 (vrai-25 valide au DQS ; piège RFLAG stale trouvé) |
| 2 | t02_dqsw_law | Loi DQS write : `wstep_init = DLLSTEP+WSTEP` (X4), saturé 255 | ★★★ | à faire |
| 3 | t03_write_anchor | Write→readback à RPOINT fixe, ancre training 23 vs 25 : poison côté write ? | ★★★ | à faire |
| 4 | t04_read_rpoint | Read à DLL fixe, RPOINT 23 vs 25 : le read seul explique 6 vs 8 ? | ★★★ | à faire |
| 5 | t05_wl_anchor | WL complet à STEP 23 vs 25 : le WL dépend-il de l'ancre ? | ★★ | à faire |
| 6 | t06_latch_phase | Reproduire le latch 6 vs 8 en isolé : quelles phases tombent ? | ★★ | à faire |
| 7 | t07_rmove_gap | 1 front descendant RMOVE = 1 pas, gap obligatoire (piège :14194) | ★★ | à faire |
| 8 | t08_rloadn_live | RLOADN recharge depuis le DLL vivant (base PVT-safe) | ★★ | à faire |
| 9 | t09_hold_wpoint | HOLD reset WPOINT ; WPOINT avance sur fronts DQSR90 | ★ | à faire |
| 10 | t10_dqs_en | Fermeture `dqs_en` au 1er negedge DQS après `rd_en=0` | ★ | à faire |
| 11 | t11_rclksel | `[2]`=+1CK, `[0]/[1]`=changement d'horloge (pas de micro-pas) | ★ | à faire |
| 12 | t12_rpoint_free | RPOINT en roue libre (jamais de comparaison absolue) | ★ | à faire |
| 13 | t13_survey_fsm | Survey FSM vs DQS bouchon Scala (test Scala, pas ici) | ★★ | à faire |
| 14 | t14_sweep_fsm | Sweep + side-switch + early-exit premier 8 (Scala) | ★★ | à faire |
| 15 | t15_scan_fsm | Scan par base : visite + handoff (Scala) | ★★ | à faire |
| 16 | t16_window_entry | `dllSweepOn` + 5 inits à l'entrée fenêtre (non-régression 09/10, Scala) | ★★ | à faire |
| 17 | t17_apply_lock | Pass-3 / apply / lock final (Scala) | ★ | à faire |
| 18 | t18_fast_path | Fast path best==8 → BIST direct (Scala) | ★ | à faire |

(13–18 : SpinalSim pur dans `ddr3/test/`, listés ici pour l'index. 16 protège le
fix window du 09/10 : entrée fenêtre sans `dllSweepOn` = boucle survey infinie.)
