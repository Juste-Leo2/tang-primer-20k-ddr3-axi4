# Résultats t21 (traces FIFO S23 vs S25) — 13/10/2026

Source : `sim_tests/gen/t21_23.log`, `sim_tests/gen/t21_25.log`, itération `tries=1` (pos0, sel1).

Format des traces : `dq=V/kkk`. `V` vaut DQ12 et marque une donnée valide, `kkk` vaut DQ[2:0] et donne l'indice du beat. Exemple : `1/101` = 0x1005.

## Verdict : l'analyse précédente (`try_explaination.md`) est réfutée sur le point clé

Le côté lecture (FIFO IDES, WPOINT/RPOINT) **n'est pas fautif**. La FIFO recopie fidèlement ce qui est sur le bus. **C'est le bus DQ lui-même qui diffère entre S23 et S25, à cause de l'ÉCRITURE.**

## 1. Lecture : le bus DQ diffère déjà au niveau de la DRAM

On regarde ce que vaut DQ à chaque front DQSR90, pour les deux bursts de lecture (vers 3360–3380 ns).

| Période DQS | S25 | S23 |
|---|---|---|
| 1 | 000 / 001 | **x / x** |
| 2 | 010 / 011 | 000 / 001 |
| 3 | 100 / 101 | 010 / 011 |
| 4 | 110 / 111 | 100 / 101 |
| burst 2 (périodes 5 à 8) | identique au burst 1 | identique au burst 1 |

- À S23, la DRAM renvoie **X, X, 1000, …, 1005**. Les beats 1006/1007 ne passent **jamais** sur le bus.
- Le contenu de la FIFO (ligne `M`) est cohérent avec ce bus dans les deux cas. À S25, les entrées en ordre gray portent 01, 23, 45, 67. À S23, on y trouve X, 01, 23, 45.
- Conclusion : la DRAM contient le motif **décalé de 2 beats (1 tCK)**. Le maximum de 6 vient de là : 8 beats − 2 X.

## 2. Écriture : DQ est en retard de 1 tCK sur DQS à S23

C'est l'auto-capture de la BIST write via le loopback DQSIN, vers 3275–3290 ns. Les fronts DQS de notre écriture tombent aux mêmes instants dans les deux runs.

| Front ≈ | S25 | S23 |
|---|---|---|
| R- 3279.3 | 001 | 0 (préambule, `dq_out(6)=0`) |
| R+ 3280.6 | 010 | **000** |
| R- 3286.8 | 111 | 101 |
| R+ 3288.1 | 0 | 110 |
| R- 3289.3 | Z | 111 |

À S23, les données DQ écrites arrivent **2 beats plus tard** par rapport à notre DQS. La DRAM, qui échantillonne sur DQS, stocke donc `Z/0, Z/0, 1000..1005`.

## 3. Cause probable (déduite du modèle DQS déjà lu, à confirmer dans OSER8_MEM)

- **DQ** (et DM) sortent par un `OSER8_MEM` cadencé sur `TCLK = DQSW270`. En mode X4, `wstep_init = DLLSTEP + WSTEP` quand `WLOADN=0` (`prim_sim_tb.v:13824-13835,13868`). **La phase d'écriture des DQ dépend donc du STEP de lecture.**
- **DQS** sort par un `OSER8_MEM` cadencé sur `DQSW0 = dly[WSTEP]`, qui **ne dépend pas** de DLLSTEP (`prim_sim_tb.v:13867`).
- Avec WSTEP=0x18, le retard de DQSW270 vaut (STEP+24)×25 ps :

  | STEP | Retard DQSW270 | Position par rapport au front FCLK (demi-période 1250 ps) |
  |---|---|---|
  | 25 | 1225 ps | 25 ps avant |
  | 26 | 1250 ps | pile dessus |
  | 23 | 1175 ps | plus loin avant |
  | 24 | 1200 ps | plus loin avant |
  | 27 | 1275 ps | après |

  La zone {25, 26} serait donc le seul endroit où l'OSER8_MEM des DQ reprend la donnée FCLK sur le **même** cycle que l'OSER8_MEM du DQS. Ailleurs, il la reprend avec ±1 tCK de décalage.
- Cela explique aussi « le survey décide / l'historique décide » et l'hypothèse H7 (doc STATUS §4). Si l'OSER garde un état interne établi pendant les premières écritures, alors s25a23 reste bon même quand on mesure à 23.
- **À vérifier** : lire le modèle `OSER8_MEM` (`prim_sim_tb.v:3587`), en particulier comment TCLK reprend la donnée et s'il garde un état interne qui crée de l'historique.

## 4. Conséquences pour le fix Scala (rien d'implémenté)

- Les pistes « latch sur 2 captures » et « HOLD sur 2 cycles » sont **abandonnées** : aucun cadrage de lecture ne peut retrouver 1006/1007, puisque ces beats ne sont pas en mémoire.
- Il faut une **calibration d'écriture des données**, pas seulement le write leveling. Le WL actuel n'aligne que DQS (chemin DQSW0) et ne voit pas le chemin DQ (DQSW270 = DLLSTEP+WSTEP). Deux options :
  1. Décaler les données dans les slots `dq_out` / `dq_oen` / `dm_out` de ±1 sous-cycle (2 beats) dans l'état WRITE. On teste les décalages {−1, 0, +1} par BIST write puis read, et on garde celui qui donne 8.
  2. Ou ajuster WSTEP / la phase d'écriture pour écarter le front DQSW270 de la zone de course avec FCLK. C'est plus fragile sur HW, où DLLSTEP dépend du PVT.
- Cohérent avec le HW (C≤6) : sur la carte aussi, DLLSTEP+WSTEP ≠ la valeur « magique ».

## 5. Divers

- La coïncidence DQSR90/FCLK à STEP 25 (§2 de l'ancienne note) est réelle, mais elle n'a **aucun effet visible** côté FIFO dans ces traces.
