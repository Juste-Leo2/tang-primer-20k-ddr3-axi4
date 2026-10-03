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

## 3. Étape 1 — Paramétrer le TB

**`simulation/tb_spinal.v`**

- `force u_dut.phy.dll_1.STEP = 8'd25` → constante `STEP_VAL` (défaut 25).
- Décalage de phase : offset permanent appliqué avant le toggle de `pclk` dans la
  boucle d'horloges (3 lignes, périodes nominales inchangées). `PHASE_OFF` en ps,
  défaut 0. Premier incrément suggéré : 312 ps (tck/8).
- `$display` unique en tête de log : `MAP step=<n> phase=<n>`.

**`simulation/sim_ddr.py`**

- Flags `--step <n>` et `--phase <ps>` vers `extra_defines`, plus un nom de
  sortie par run (`tb_spinal_s<n>_p<n>.vvp`) pour ne rien écraser.

## 4. Étape 2 — Rendre la carte affordable

Un run complet = ~40 min, donc une matrice est hors de portée. Deux voies, à
trancher :

**Voie A — mode carte dans le RTL (recommandée)**
`Ddr3Config(mapMode = true)`, `isSimulation` uniquement : sauter sweep-1
(il ne mesure rien — score X partout, vérifié) et limiter la grille à `pos=0`,
`sel=0..7`. Calibration ~4× plus courte, ~1-2 min par point.
*Contre-vérification obligatoire* : ce mode change le trafic, donc la phase. Un
point doit être re-mesuré en boot complet et son `C` doit correspondre, sinon la
carte est fausse.

**Voie B — runs complets**
Aucune modification RTL, fidélité maximale, mais ~40 min/point : 8 points ≈ 5h et
seulement 6-8 valeurs de `STEP` couvertes.

## 5. Étape 3 — Matrice et lecture

Grille grossière d'abord : `STEP ∈ {0, 25, 64, 128, 192, 255}` ×
`phase ∈ {0, 312, 625} ps` (18 points), puis densifier autour des transitions.
Un script boucle les runs, parse `RCALIB lock ... score=N`, sort `C(step, phase)`.

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