# t05 — write leveling seul à ancre 23 vs 25 (court, stop après `wlevel_done`)

## Question
DUT : **contrôleur généré depuis le Scala** + Micron + prim_sim (mêmes
sources que t03). Le `WSTEP` locké par le WL naturel dépend-il de l'ancre ?
Comportement jamais isolé : les logs précédents suggèrent `wstep=0x19` (25)
aux deux ancres, à confirmer proprement.

## Prédiction
`wstep=0x19` aux deux ancres (le Micron impose la fenêtre d'écho, pas le
DLL). Si différent → le WL lui-même est contaminé par l'ancre, et c'est lui
qu'il faut re-jouer par base en v3, pas le training.

## Conclusions selon résultat
- **Même WSTEP aux 2** → WL hors de cause ; le poison est après (training
  writes, scoring, pipeline). Verrouille le comportement en prime.
- **WSTEP différent** → suspect n°1 trouvé : t05b (re-WL par base) à écrire.

## Résultat 09/10 (v1, heartbeat 1 µs)
`t05_23` et `t05_25` : `wstep=0x19` aux deux → **WL hors de cause**.
v2 : `wait` direct sur `wlevel_done` + watchdog (fini les 4 cycles RCALIB
parasites avec latch en X du heartbeat).
## Résultat 09/10 (v2)
`t05_23` + `t05_25` : `wstep=0x19` aux deux, zéro ligne RCALIB. **WL
définitivement hors de cause, convention v2 (wait direct + watchdog)
validée** pour tous les futurs tests courts.

## Portée assumée
Stop après `wlevel_done` (~3–4 µs sim = minutes wall). Pas de calib read,
pas de transport. Verdict `T05 PASS wstep=..` = mesure obtenue ; la
comparaison 23 vs 25 est l'analyse (humaine). 2 runs : `t05_23`, `t05_25`.
