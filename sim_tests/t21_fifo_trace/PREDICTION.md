# t21 — trace FIFO DQS/IDES8_MEM sur une itération (S23 vs S25)

## Question
Pourquoi les beats 1006/1007 (4e période DQS du burst) n'arrivent jamais
dans la fenêtre de 4 entrées lue par l'IDES hors STEP 25/26 ?
Trace au ps : fronts DQSR90 (écriture sur R-), WPOINT/wpt_q, RPOINT,
rd_q/sign_q/update_a, rd_en/dqs_en, D_en + slots capturés, contenu FIFO.

## Prédiction
- DQ (Micron, RANDOM_OUT_DELAY=0) et DQS transitent sur la grille CK
  (625 mod 1250 ps) ; FCLK sur 0 mod 1250 ps. DQSR90 = DQS + 25·STEP ps
  → à STEP 25 les fronts DQSR90 tombent PILE sur les fronts FCLK
  (26 : +25 ps, 23 : −50 ps). La différence S23/S25 vient d'une course
  d'ordonnancement entre domaine DQSR90 (wpt_q) et domaine FCLK
  (shift/sign_q/rd_q → départ RPOINT), pas de l'échantillonnage DQ.
- S23 : l'entrée qui devrait porter 6/7 est lue avant son écriture (ou
  contient X/stale) ; S25 : la fenêtre de 4 entrées couvre 0..7.

## Conclusions selon résultat
- Départ RPOINT décalé d'un bloc/FCLK entre S23 et S25 → le contrôleur
  doit cadrer la lecture autrement (latch, rotation, pointeur), fix Scala.
- Écritures FIFO identiques et seul le cadrage diffère → idem.
- Écritures différentes (entrée 6/7 jamais écrite à S23) → problème côté
  fenêtre dqs_en / READ (rclkpos/rclksel, durée dqs_read).

## Portée
2 runs (`t21_23`, `t21_25`), `+trt=1` (pos=0 sel=1, comparé à t20).
