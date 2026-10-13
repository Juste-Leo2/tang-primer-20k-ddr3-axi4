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

Oui pour la correction, non pour l'idée. Le côté écriture avait déjà été soupçonné, mais aucune correction côté écriture n'a jamais été essayée.

**Ce qui existait déjà :**
- **H7** (« l'ancre déplace la phase d'écriture en X4 ») est listée « Open, constrained » dans `STATUS_AND_NEXT.md`. Elle a été écartée en partie par le run s25a23 : survey à 25, puis écritures BIST à la phase 23, et ça donne 8 quand même.
- **`dll-offset-K.md`** (archives) avait vu qu'à STEP=0 forcé, l'écriture devient marginale (violations tDS/tDH) et plafonne à 6. Mais c'était vu comme un cas extrême, pas comme la cause générale.
- **t03 / t03b / t03c** étaient prévus exactement pour départager « KO à 23, OK à 25 = l'écriture est en cause ». Je n'ai trouvé aucun résultat écrit dans leurs `PREDICTION.md`, donc je ne peux pas dire ce qu'ils ont donné.
- **t05** a montré que le write leveling donne le même WSTEP (0x19) aux deux ancres. Mais le WL n'aligne que le DQS, pas les DQ.

**Ce qui est nouveau avec t21 :**
- **Une preuve directe sur le bus.** À S23, la DRAM renvoie X, X, 1000…1005 : la mémoire contient le motif décalé de 1 tCK. Le « DQ turn-on +1 tCK » de la section 3 de `STATUS_AND_NEXT.md` avait été lu comme un problème de lecture (préambule, Hi-Z, H1). C'est en fait le contenu écrit.
- **La cause du décalage est visible.** L'auto-capture de la BIST write montre qu'à S23 les DQ sortent 2 beats en retard sur notre DQS, alors que les fronts DQS tombent aux mêmes instants qu'à S25.

**Différence avec toutes les solutions testées avant :** elles agissaient toutes sur la lecture. Ça couvre rstep, la boucle pos/sel, les ancres et le scan, le re-survey, le pin, HOLD, les doubles bursts, la rotation, la normalisation d'idle. Si la mémoire contient X, X, 0…5, aucun réglage de lecture ne peut faire mieux que 6, ce qui explique pourquoi tout plafonnait. La piste nouvelle est une calibration de l'alignement DQ/DQS à l'écriture, par exemple décaler `dq_out`/`dq_oen`/`dm_out` d'un sous-cycle et valider par relecture BIST. Elle n'a jamais été implémentée.

**Ce qui reste à vérifier avant de coder :** le résultat s25a23 contredit en partie cette explication. Si la phase d'écriture suivait simplement STEP, les écritures à 23 après le changement d'ancre auraient dû stocker le motif décalé, et le score n'aurait pas pu atteindre 8. Il faut lire le modèle `OSER8_MEM` (`prim_sim_tb.v:3587`) pour voir s'il garde un état interne fixé lors des premières écritures. Ça expliquerait à la fois s25a23 et « l'historique décide ». Si ce n'est pas le cas, l'explication est incomplète.