# t03c — transport à tout-forcé, sans WL ni RCALIB (MINIMALISTE)

## Question
Même question que t03/t03b (le 6 perd-il des données ?), avec TOUT fixé :
init JEDEC gardée (le Micron doit répondre), WL + RCALIB sautés, `WSTEP`
forcé à 19 (valeur lockée prouvée par t05), taps read forcés identiques.
Seul `DLLSTEP` diffère (23 vs 25). 2 runs : `t03c_23`, `t03c_25`.

## Protocole
1. Reset, attendre `state==4` (WRITE_LEVELING atteint = init JEDEC finie).
2. `force state=6(IDLE)` + `force rcalib_done=1` + `force training=0`
   + `force wstep_net=19` → attendre `init_done` → `release state`.
3. Taps identiques : `force rclkpos=0, rclksel=0`, reload + navigate
   `rstep` → 25 (vérifié).
4. 1 write + 1 read.

## Prédiction
- **KO à 23, OK à 25** → poison = `DLLSTEP` courant côté write
  (`DQSW90` 42 vs 44), pas un état training (sauté des deux côtés).
  v3 = re-ancer le DLL.
- **OK aux 2** → transport sain : le 6 est un artefact de scoring.
- **KO aux 2** → le tout-forcé est faux (Micron pas prêt ou FSM pas
  en état) : revoir le harnais (t03d).

## Portée assumée
Remplace t03b (même question, sans payer le WL). Init JEDEC ~1 µs +
mesures = le minimal absolu avec Micron. Minutes wall.

## Diagnostic 10/10 (v1)
Silence après "Jedec done" : `init_done` exige `wlevel_done`
(`Ddr3ControllerCore.scala:1548`) et on saute le WL → flag jamais levé.
v2 force aussi `wlevel_done=1` + heartbeat 1 µs + waits bornés avec FAIL
explicite (plus de `wait` aveugle).
