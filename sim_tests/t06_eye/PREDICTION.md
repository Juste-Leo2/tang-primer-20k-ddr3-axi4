# t06 — œil read (DQS + IDES seuls, burst TB, secondes)

## Question
DUT : primitives vendor seules (DQS X4 + IDES8_MEM, `prim_sim_tb.v` — pas de
Scala à la source, comme t01/t02). L'œil de capture est-il IDENTIQUE à
translation près entre ancre 23 et ancre 25 ? Protocole : reload(S), RMOVE
±5 autour de S (gaps, leçon t01), 1 burst edge-aligned `1010` + 1 mesure
par point, 11 points par run, 2 runs (`t06_23`, `t06_25`).

## Prédiction
Courbes superposées à translation de 2 taps près (50 ps) : le DLLSTEP ne
fait que translater l'œil (sain, attendu — même registre, même tap t01).
Largeur d'œil identique.

## Conclusions selon résultat (T06 PASS = 11 mesures obtenues)
- **Translation pure** → read innocent, définitivement. Reste le write
  (t03b) puis le scoring. Le "vrai-25" est clos sous tous les angles DQS.
- **Formes différentes** → le DLLSTEP déforme l'œil par un autre chemin
  que `rstep_reg` : le chercher (DQSW ? pipeline PCLK ?).
- **Tout KO / tout OK** → burst ou seuils faux : revoir le harnais (t06b).

## Portée assumée
`dqs_en` forcé à 1 (pas de READ : on mesure la capture, pas l'ouverture).
Pattern `1010` : seules rotations `AA`/`55` passent → indifférent à
l'alignement WPOINT/RPOINT de départ. Burst dummy de chauffe (résidus
reset). `===` : un seul X → KO. Secondes wall par run.
