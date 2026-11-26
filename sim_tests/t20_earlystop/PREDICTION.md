# t20 — arrêt précoce sur verdict survey (init naturelle, zéro force)

## Question
DUT : **contrôleur généré depuis le Scala** + Micron + prim_sim, init
NATURELLE (aucun force sauf ancre LOCK/STEP comme tb_fast). Le verdict
survey est-il connu sans finir scan/sweep/apply ? Moniteur : à chaque fin
de survey (`rcalib_tries` retombe ou `dllSweepOn` se lève), lire `bestCnt` :
8 → stop (validé), 6 → compter, 4 surveys à 6 → stop (confirmé).

## Prédiction
- `t20_25` : `best==8` dès `tries=001` → fast-pass au cycle près, stop en
  ~1–2 µs sim (dizaines de secondes wall). Verdict `T20 PASS best=8`.
- `t20_23` : `best` ne passe jamais à 8 (reste 6) → le fast-pass ne
  déclenche pas, le moniteur compte 4 surveys à 6 → stop en ~10 µs sim.
  Pas de scan complet (8 bases), pas de sweep, pas d'apply.
- `best<6` ou inattendu → on ne compte pas, on affiche et on continue
  (pas de faux verdict ; le watchdog borne).

## Conclusions selon résultat
- **25→8 immédiat, 23→6×4** → le moniteur est validé comme oracle rapide :
  tous les futurs runs "verdict" passent par lui, plus jamais de calib
  complète pour un score.
- **best illisible / jamais de terminal** → revoir les signaux du moniteur
  (t20b) : lire `bestCntDll`/`bestSurvey` au lieu de `bestCnt`.

## Portée assumée
2 runs (`t20_23`, `t20_25`). Heartbeat 1 µs (st, tries, best, scan, sweep)
= visibilité temps réel. Watchdog 300 ms sim + runner 3600 s.
Remplace t03/t04-init-complète pour toutes les questions "score".
