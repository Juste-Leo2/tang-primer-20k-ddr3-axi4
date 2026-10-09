# t04 — fenêtre read à write fixé (DLL 25, RPOINT balayé en direct)

## Question
DUT : **contrôleur généré depuis le Scala** + Micron + prim_sim. Le read
seul explique-t-il 6 vs 8 ? Protocole : init naturelle à ancre 25 (write
sain), 1 write, puis balayage `RPOINT` 23–27 en pilotant le PHY **en
direct** (`force` RLOADN/RMOVE/RDIR sur les 2 lanes, FSM non touchée),
1 read par point.

## Prédiction
Readback OK sur une fenêtre autour de 25 (largeur = LA mesure qui manque),
KO en dehors. Points 23–27, `rstep_reg` vérifié avant chaque read.

## Conclusions selon résultat (T04 PASS = tableau complet obtenu,
les KO readback sont des données, pas un échec)
- **23–25 tous OK avec write sain** → le 6 de S23 ne vient PAS du read :
  poison côté write (établi à ancre 23) → v3 write-side (re-WL / WMOVE
  par base). Croiser avec t03.
- **KO à certains rstep** → cartographier la fenêtre, comparer au latch S23
  (`10031002100110000000000010051004`) : les 2 phases tombées sont-elles
  les bords de fenêtre ?
- **RPOINT non atteint / release KO** → le forçage direct ne marche pas :
  revoir le harnais (t04b).

## Portée assumée
1 seule init (25, fast path ~10 min) puis reads en secondes. `force` sur des
inputs drivés par le core, `release` après chaque point (idle post-init :
le core ne les touche plus). Gaps entre pulses (leçon t01).
