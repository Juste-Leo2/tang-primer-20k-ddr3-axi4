# Plan — capture read : cartographier puis corriger (03-10-26)

Document de plan. Rien n'est implémenté. Objectif : transformer le mystère HW
(`C=6`, 6/8 blocs) en un phénomène reproductible et mesurable, puis corriger sur
preuve.

## 1. Contexte et état

Base `main` (`deab069`) validée : TB `ALL TESTS PASSED`, unitaires 141/141,
formel `PASS`. silicium : `C=6`, memtest 6/8 blocs.

Ce que la cartographie du TB a établi (`tb-cartographie.md`) :

- La grille « 32 réglages » n'est pas une exploration fine de phase :
  `rclkpos` = décalage d'ouverture de fenêtre de capture en **pclk (10 ns)**,
  `rclksel` = multiplexeur de routage (8 combinaisons). 4 fenêtres grossières
  × 8 routages.
- Le dégradé de `C` suit `rclkpos` : `pos=0` → 8, `pos=1` → 8/6, `pos=2` → 6/4,
  `pos=3` → X. La fenêtre utile fait 5-10 ns, la granularité du knob 10 ns.
- `C=6` en HW signifie qu'**aucun** des 32 réglages n'atteint 8 : toute la grille
  est du côté épaulement de la courbe.
- Le TB ne teste **qu'un seul point** de l'espace (tap read, phase) :
  `force u_dut.phy.dll_1.STEP = 8'd25` fige l'axe fin, et les trois horloges
  sont générées dans un ratio fixe qui fige la phase.

Conclusion : il manque une dimension de couverture, pas une idée.

## 2. Question « Scala peut-il couvrir ça ? »

**Non, pas aujourd'hui.** Les harnais Scala instancient `Ddr3ControllerCore`
seul, sans PHY :

- `dq_in(i) := readData(...)` — un registre, pas le FIFO IDES
- `dq_raw` — un timer, pas l'écho physique
- pas de `GowinDdr3Phy`, pas de `DQS`, pas d'IDES8_MEM`, pas de ligne de retard

Donc l'axe `STEP` (tap dans la primitive Gowin) et la phase de capture
n'existent pas côté Scala ; `C` y vaut 8 par construction. C'est la raison
exacte pour laquelle le harness n'a pas vu le défaut.

**Pour les couvrir en Scala**, il faudrait écrire nous-mêmes le modèle de
capture (8 slots + `WPOINT` gray + `RPOINT` free-run + fenêtre `dqs_read`), puis
les balayages passent de ~40 min à ~1-2 min. Coût ~200 lignes, et on perd la
fidélité des modèles fournisseur. À garder comme option si la carte demande
beaucoup d'itérations.

## 3. Étape 1 — Paramétrer le TB — **FAIT**

**`simulation/tb_fast.v`** (copie de `tb_spinal.v`, 3 changements)

- `ddr3 #(.DEBUG(0))` : le modèle vendor documente « Set DEBUG = 0 to disable
  $display messages ». Les logs par beat disparaissent, la physique ne change pas.
- `+step=<0..255>` (plusarg) : tap de délai côté read, normalement forcé à 25.
  Le forçage devient une variable runtime → un seul build sert à toute la carte.
- `+phase=<ps>` (plusarg) : décalage permanent de pclk par rapport à ck/fclk,
  injecté par un offset one-shot dans la boucle d'horloges (pclk garde sa
  période nominale, seule sa phase bouge). Vérifié : 312 ps → +0.3 ns sur les
  timestamps DBG.
- `-DMAP_ONLY` : saute le memtest fonctionnel (C vient du sweep de calibration).
- Ligne de verdict `RESULT step=.. phase_ps=.. W=.. P=.. S=.. errors=..`.

**`simulation/sim_ddr.py`** : mode `--fast-tb` avec `--step`, `--phase`,
`--map-only`. `run()` accepte des plusargs et un nom de log.

### Porte de fidélité : **PASSÉE**

TB rapide (STEP=25, phase=0) contre TB Micron de référence :

- **82 lignes de mesure identiques** (les deux sweeps, `(pos, sel, score, rot)`)
- sweep-2 : `pos=0 sel=0 rot=6 score=8` des deux côtés
- memtest : 8 lectures identiques, `ALL TESTS PASSED`

Donc le chemin de capture vendor est intact : la carte peut être produite avec
le TB rapide.

## 4. Vitesse mesurée

| | durée |
|---|---|
| TB rapide (complet, calibration + memtest) | **721 s** (12 min) |
| TB Micron de référence | 13065 s mesurés, mais sur machine chargée ; ~15 min en conditions propres |

`DEBUG=0` ne gagne que ~1.2× par rapport à un TB lent non chargé : le coût est
dans les checks JEDEC du modèle, pas dans sa verbosité. Deux conséquences :

- **Pas besoin d'un DRAM léger** (le plan initial) ni d'un modèle de capture
  Scala : la piste « paralléliser au lieu d'optimiser » est meilleure — un
  processuOS par point, 20 cœurs disponibles.
- La carte se fait en 2 vagues d'environ 12 min pour 18 points.

**`simulation/map_capture.py`** : lance les points en parallèle (un `vvp` par
point, `+step`/`+phase` en plusargs), collecte C / rot / W et affiche une table.

## 4 bis. Ce que le modèle vendor dit de l'axe `STEP`

Lecture de `prim_sim_tb.v` (primitive `DQS`) :

```
dqsw0_dly_in[0]  = fclk_in;          // chaîne write/read = horloge interne
dqsr90_dly_in[0] = dqs_r_clean;      // chaîne read  = DQS venant de la DRAM
DQSW0  = dqsw0_dly_in[WSTEP];        // clk_rd si rclksel[0]=0
DQSW90 = dqsw270_dly_in[wstep_reg];  // clk_rd si rclksel[0]=1, wstep_reg=DLLSTEP
wpt_q  avance sur posedge DQSR90     // WPOINT suit le DQS retardé de DLLSTEP
```

Donc, avec des taps de 25 ps :

- le DQS vu par le FIFO est retardé de `STEP` taps ;
- l'horloge de capture est retardée de `WSTEP` taps (`sel[0]=0`) ou de `STEP`
  taps (`sel[0]=1`) ;
- **le délai relatif vaut `(WSTEP − STEP) × 25 ps`**, soit jusqu'à ~6.4 ns en
  balayant STEP de 0 à 255 avec `WSTEP=25` — plus de deux périodes CK.

Deux conséquences utiles :

1. `STEP` est bien l'axe de phase fin que la grille actuelle n'atteint pas.
2. **`sel[0]=1` annule le délai relatif** (clock et DQS retardés du même
   `STEP`) : cette configuration serait invariante à `STEP`. Si la carte le
   confirme, c'est une piste de correctif triviale — choisir la source d'horloge
   de capture alignée sur le DQS.

## 6. Étape 4 — Décision, dictée par la carte

| Résultat | Lecture | Correctif |
|---|---|---|
| `STEP` domine | l'axe fin du read est le knob manquant | piloter le tap IDES — question architecture Gowin (accès en user logic ?) |
| la phase domine | knobs trop grossiers | `rclkpos` signé (offsets négatifs), élargir `rclksel`, fenêtre `dqs_read` plus large |
| `C=8` partout | le mécanisme HW est autre (SI, DLL réel, taps réels) | le TB ne peut pas être l'oracle → expériences HW directes |

## 7. Étape 5 — Correctif et porte de régression

Implémentation du correctif retenu, puis exigence : **`C=8` sur toute la
matrice `STEP × phase`**, pas sur un point. C'est la porte qui manquait.

## 8. Conséquences pour le reste

- `WL_LOCK_OFF = -1` : ajustement empirique sur 2 points HW, à travers `C`,
  un instrument qu'on sait peu fiable. Il ne bouge pas avant que `C` soit
  fiable ; ensuite il sera à re-fitter proprement (et le bracketing, déjà écrit
  et testé unitaire, redevient utile).
- Le bracketing reste parké sur `wl-bracketing` jusqu'à ce que `C` soit fiable.

## 9. Hors périmètre

SDC, double-front d'échantillonnage, refresh auto, re-fit de `-1`, modèle de
capture Scala — tous suspendus jusqu'à la carte.

## 10. Documents liés

- `tb-cartographie.md` — cartographie du TB et table des 32 réglages.
- `read-capture-analyse.md` — capture partielle, hypothèses et zones d'effet.
- `audit-wl.md` — état des travaux, commandes de validation.
- `chip-timing-compare.md` — marges JEDEC du chip réel.