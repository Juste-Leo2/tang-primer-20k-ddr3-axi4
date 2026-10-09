# t03 — transport de données réel à ancre 23 vs 25 (le discriminant)

## Question
DUT : **contrôleur généré depuis le Scala** (`hw/gen/Ddr3ControllerSim.v`,
donc 100% Scala à la source) + Micron + prim_sim. Harnais = mini-tb_spinal
(clocks, forces, 2 paires write/read). Le score 6 correspond-il à de VRAIES
pertes de données, ou à un scoring BIST pessimiste ?

## Prédiction
Inconnue — c'est ce test qui doit répondre (2 runs : `t03_23`, `t03_25`) :
- **readback OK aux 2 ancres** → le 6 est un artefact de scoring (phases
  pessimistes, données intactes). Conséquence : un lock à 6 reste
  fonctionnel ; la priorité devient le scoring, pas le transport. Et ça
  rapproche du critère HW.
- **readback KO à 23, OK à 25** → le poison training corrompt réellement le
  transport → v3 = re-train / re-WL par base (ou write-side), et t04/t05
  pour localiser (read seul ? WL seul ?).
- **readback KO aux 2** → problème transport générique, pas l'ancre.

## Portée assumée
Runs naturels (ancre = step, pas de hop, pas de WLOVR) : à 25 fast path 8,
à 23 scan complet puis 6. Le RPOINT mesuré est celui locké par la calib.
Timeout 3600 s (le scan 23 est long). Harnais repris de `tb_spinal.v`
(tasks dowrite/doread) — harnais, pas DUT.
