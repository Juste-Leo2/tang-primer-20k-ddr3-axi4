# t03b — transport à taps identiques, ancre 23 vs 25 (MINIMALISTE)

## Question
DUT : **contrôleur généré depuis le Scala** + Micron + prim_sim. Même
question que t03 (le 6 perd-il des données ?), mais court-circuité :
WL naturel (~3 µs) puis sortie de RCALIB forcée, taps read FORCÉS
IDENTIQUES aux deux ancres. Seule différence résiduelle : `DLLSTEP`
(23 vs 25) via l'ancre forcée en continu.

## Protocole (court-circuit assumé, documenté)
1. WL naturel → `wlevel_done` (vrai `WSTEP`, t05 : 19 aux deux).
2. `force state=6(IDLE)` + `force rcalib_done=1` + `force training=0`
   → attendre `init_done` → `release state` (garder les 2 autres forcés :
   la FSM reste en IDLE et sert les req normalement).
3. Taps read identiques : `force rclkpos=0, rclksel=0` (lock S25),
   reload + navigate `rstep` → 25 aux deux ancres (vérifié).
4. 1 write + 1 read. 2 runs : `t03b_23`, `t03b_25`.

## Prédiction
- **KO à 23, OK à 25** → avec TOUT le read identique, seul le write
  diffère (`DQSW90` = 42 vs 44, 50 ps ; `DQSW0` = 19 vs 19) → le poison
  est le `DLLSTEP` courant côté write, PAS un état training. v3 = re-ancer
  le DLL (pas re-train !). Résultat énorme.
- **OK aux 2** → le transport est sain aux deux ancres avec ces taps :
  le 6 est un artefact de scoring (taps du survey mal choisis, pas de
  données perdues). Croiser avec t04b.
- **KO aux 2** → le court-circuit lui-même est faux (FSM pas en état de
  servir) : revoir le harnais, pas la physique.

## Portée assumée
Pas de survey/sweep/scan (sautés), pas de training writes (sautés des deux
côtés). Quelques µs sim = minutes wall (dont build iverilog ~1 min).
