# t22 — auto-calib write-shift {0,+1} de bout en bout (S05/23/25/40/50/60)

## Question
La calibration runtime `wrAdv` (branche C, `Ddr3ControllerCore.scala`) verrouille-t-elle
le bon shift par step : +1 là où le slip DQ entier existe (S5/S23/S40), 0 là où
le contenu shift-0 est déjà 8/8 (S25), dégradation gracieuse aux extrêmes (S60→0/7) ?

## Protocole
Reprend le harnais t21 (`tb_t21.v`, init naturelle, ancre LOCK/STEP forcée) **sans
le `$finish` précoce** : trace l'itération `+trt=1` (bus-level, comme t21) puis
laisse tourner survey 40 tries → recherche {0,+1} → sweep/scan jusqu'à
`rcalib_done`. Verdict `T22 DONE` avec `wshift/score/pos/sel/rot`.

## Prédiction
- S5/S23/S40 : `wshift try +1` puis `wshift lock +1`, score final 8.
- S25 : `wshift lock 0 (fast)`, score final 8.
- S60 : `lock 0`, score final 7 (trou b7 structurel, documenté t21_shifts §6).
- S50 : inconnu, on prend la mesure (monotone attendu entre S40 et S60).

## Conclusions selon résultat
- Locks conformes + score 8 → auto-calib validée, brancher la suite (doc STATUS).
- `lock +1` mais score <8 → shift OK, résidu ailleurs (cf. t21_shifts §4, b1).
- Pas de ligne `wshift` → C jamais atteinte (survey, bras `shiftCalDone`, ou
  `tries==40` non frappé) : bug d'intégration, pas de spec.

## Portée
6 runs (`t22_05/23/25/40/50/60`), binaire unique `t22_auto.vvp`, `+trt=1`.
TB = copie conforme de t21 (diff : nom module, verdict `T22 DONE` sur
`rcalib_done`, watchdog 3 ms, noms VCD) ; bloc VCD `+vcd` conservé tel quel.
