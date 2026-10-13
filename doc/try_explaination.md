# Analyse : pourquoi 1006/1007 manquent hors STEP 25/26 (12/10/2026)

État : **analyse seulement, aucun changement Scala**. Des traces ont été générées mais pas encore lues (voir §6).

## 1. Ce que dit le latch (t20_23 vs t20_25)

Chaque entrée de la FIFO IDES8_MEM contient **une paire de beats** (Dd0 = front montant, Dd1 = front descendant). Une capture PCLK lit donc 4 entrées, soit 8 beats.

| Run | Ordre de lecture (ancienne → récente) | Lecture |
|---|---|---|
| S25 pos0 sel1 | 67, 01, 23, 45 | 4 entrées consécutives, toutes bonnes → 8 |
| S23 pos0 sel1 | 45, **X**, 01, 23 | l'entrée de 67 contient **X** (DQ échantillonné pendant le Hi-Z) |
| S23 pos1 sel6 | 01, 23, 45, **45** | l'entrée de 67 contient une **ancienne** paire 45 |

→ Le bus porte bien 1006/1007. C'est **l'entrée FIFO de la paire 6/7** qui est lue avant d'être écrite, ou qui a été écrite au mauvais moment. Le problème vient donc du **cadrage FIFO, côté écriture/lecture (WPOINT vs RPOINT)**, pas d'une donnée absente sur le bus.

## 2. La coïncidence qui explique {25, 26}

- Micron (`RANDOM_OUT_DELAY=0`) : DQ et DQS changent exactement sur la grille CK, à 625 ps près modulo 1250 ps (`ddr3_vanilla.v:1974-1978`, délai = tCH).
- Les fronts de FCLK tombent à 0 ps modulo 1250 ps (`tb_t20.v:102-112`).
- DQSR90 = DQSIN & dqs_en, retardé de 25 ps × rstep (`prim_sim_tb.v:13862,13870`).
- Conséquence : à **STEP 25, chaque front DQSR90 tombe pile sur un front FCLK**. À 26 il arrive 25 ps après, à 24 il arrive 25 ps avant, à 23 50 ps avant.
- Pour STEP 23 à 27, l'échantillonnage des DQ se fait en plein milieu de l'œil, donc l'œil n'est pas en cause (cela rejoint H2 « insuffisant »).
- La zone bonne {25, 26} correspond exactement aux cas « front DQSR90 simultané avec FCLK ou juste après ». Je soupçonne donc une **course entre le domaine DQSR90 et le domaine FCLK dans le modèle DQS**.

## 3. Mécanisme FIFO du modèle DQS (X4, `prim_sim_tb.v:14211-14415`)

- `wpt_q` avance sur le **front montant** de DQSR90. L'écriture IDES se fait sur le **front descendant**, dans `WPOINT` (l'ancienne valeur), puis `WPOINT := wpt_q`. Le « non-vide » (`wpt_q != rpt`) est donc signalé **une demi-période DQS avant** que l'entrée soit réellement écrite.
- Ce test « non-vide » passe par des latches de niveau sur FCLK (`shift_0` quand FCLK est bas, `shift_1` quand FCLK est haut). Il démarre ensuite `rd_q`, et ce démarrage est quantifié par `update_a`, une fois toutes les 4 FCLK. RPOINT avance alors par blocs de 4.
- Ce passage de domaine est asynchrone. Si `wpt_q` change au même pas de temps qu'un front FCLK (STEP 25), ou 25 à 50 ps plus tôt, RPOINT démarre à un instant différent. La fenêtre de 4 entrées se décale alors d'une entrée, et l'entrée 6/7 est lue trop tôt (X ou valeur périmée).
- HOLD remet à zéro `wpt`, `rpt`, `sign_q` et `rd_q`, mais **pas** `cnt0_up`/`cnt1_up` (la phase de `update_a`), ni le compteur `D_en` de l'IDES. Le cadrage par 4 est donc fixé par le reset, pas par chaque lecture.
- Cela colle avec la doc existante : « le survey décide » et « le seuil bouge avec l'historique (~50 ps) ».

## 4. Baseline nand2mario (`src/ddr3_controller.v`)

- En SIM, la valeur est codée en dur : `assign dllstep = 8'd25` (l.616). **La baseline n'a jamais été simulée à un autre step.**
- Elle n'utilise qu'un seul mot de 16 bits : `dout = dq_in[4]`, avec le commentaire « somehow in simulation data is here ». Elle n'a donc jamais eu besoin des 8 beats cadrés.
- En HW : `CODESCAL "101"` donne un DLL à 68°, pas 90°.
- La lecture fonctionnelle de la baseline met HOLD sur **2 cycles** (IDLE + cycle READ RCD/4, commentaire « setup violation »). La calib Spinal ne met HOLD qu'au cycle is(0).

## 5. Pistes de correction Scala (non implémentées)

1. **Latch sur 2 captures PCLK consécutives** (RCD/4+10 et +11, donc 16 slots), puis recherche de 8 beats consécutifs à cheval sur les deux. On verrouille un offset de slot (0..15) au lieu d'une rotation modulo 8, et on fait de même en lecture fonctionnelle. Le score ne dépend alors plus d'un décalage de ±1 entrée du départ de RPOINT. **À vérifier d'abord avec t21** : la paire 6/7 doit apparaître dans la capture suivante.
2. **HOLD sur 2 cycles**, comme la baseline (is(0) + cycle du burst 1), pour recaler `wpt`/`rpt` plus près du burst.
3. **Test de confirmation de l'artefact** (côté TB, pas DUT) : ajouter un retard carte de quelques centaines de ps sur DQ/DQS. Si la zone bonne se déplace de retard/25 steps, la course de domaine est confirmée et 25/26 sont un artefact d'alignement.

## 6. Ce qui a été fait / reste à faire

- Créé : [tb_t21.v](file:///i:/tang-primer-20k-ddr3-axi4/sim_tests/t21_fifo_trace/tb_t21.v) + [PREDICTION.md](file:///i:/tang-primer-20k-ddr3-axi4/sim_tests/t21_fifo_trace/PREDICTION.md), et les entrées `t21_23`/`t21_25` dans `tests.py`. C'est une trace au ps de l'itération `tries=1` : lignes `F` (FCLK), `R+`/`R-` (DQSR90), `I` (DQSIN), `C` (capture IDES), `M` (contenu FIFO au latch).
- Les deux runs se sont terminés sur `T21 DONE`. Les logs sont dans `sim_tests/gen/t21_23.log` et `t21_25.log`, **pas encore analysés**.
- Le runner affiche « ECHEC » uniquement parce que le verdict `DONE` ne contient pas `PASS` (cosmétique).
- Prochaine étape : comparer les lignes `M` et `C` entre S23 et S25. Il faut voir quelle entrée porte 6/7 et à quel front FCLK RPOINT démarre par rapport au premier `R+`.

## 7. Divers relevé

- `tb_t20.v` contient `` `define sg125 `` alors que le runner passe `-D sg25`. C'est **sg125 (DDR3-1600) qui l'emporte**. Sans effet avec `RANDOM_OUT_DELAY=0`, mais c'est la source des warnings tWLS.
- Le port `io_pad_DDR3_A` fait 14 bits, mais le TB fournit 13 bits (padding).
