# Batterie nested-K (7 STEPs) : l'axe-K ne fait rien — 06-10-26

## 1. Résultats (runs partiels FAIL + S25/S26 complets)

| STEP | RESULT | slots | scores | maxsw | lock | exit | dirt |
|---|---|---|---|---|---|---|---|
| 20 | FAIL (partiel, mags 0-19) | 1519 | 0:49 1:111 2:607 4:13 6:743 | 6, tous K | rot4/6 | épuisement | 2 zéros |
| 23 | FAIL (partiel, mags 0-19) | 1520 | 0:49 1:135 2:583 4:13 6:744 | 6, tous K | rot4/6 | épuisement | 2 zéros |
| 25 | **PASS** err=0 | 125 | 8:42 | 8 | rot6/8 | **+0 précoce** | 0 |
| 26 | **PASS** err=0 | 125 | 8:50 | 8 | rot6/8 | **+0 précoce** | 0 |
| 40 | FAIL (partiel, mags 0-19) | 1519 | 0:41 1:271 2:445 4:6 6:756 | 6, tous K | rot4/6 | épuisement | 2 zéros |
| 60 | FAIL (partiel, mags 0-19) | 1519 | 7:743 (+résidu) | **7, tous K** | rot6/7 | épuisement | **1 zéro** |
| 64 | FAIL (partiel, mags 0-19) | 1519 | 7:744 (+résidu) | **7, tous K** | rot6/7 | épuisement | **1 zéro** |

Prédictions : 25→+0 ✓, 26→-1 ~ (PASS mais exit +0, pas -1), 23→+2 ✗,
20→+5 ✗, 40→-15 ✗, 60→-4 ~ (le plus proche : des 7 partout, lock 7).

Scripts : `simulation/analyze_nestedk.py` (résumé + max par (side,K)),
`simulation/map_capture.py` (reporte `maxsw@side/mag/k` par point).

## 2. Verdict central : l'axe-K est réfuté par les données

- Max score **identique pour K=0..7** sur chaque mag couvert (361 combos
  (side,mag,K) à S23 : max 6 partout ; S60 : max 7 partout).
- Cause du flop (vue après coup) : le pin est **identique à chaque mag**
  (2 slots, même timing de boucle) → l'alignement de release est identique
  → la trajectoire de gap post-pin est identique → les 8 groupes K
  mesurent la **même phase de gap**. K n'est pas une variable libre, c'est
  une fonction du timing fixe. Le design ne pouvait pas marcher.
- Le gap est constant par run (suivi élastique WPOINT/RPOINT, prouvé par
  lecture du modèle DQS : après HOLD, `RPOINT=RD_PNTR` puis suivi) : ni le
  free-run ni le pin (ni K) ne l'explorent. Aucun design jusqu'ici n'a
  exploré le gap.

## 3. Ce que la batterie prouve quand même (dirt STEP-dépendante)

- Autopsie latches : les beats manquants sont **toujours des `0000`**
  (104/104 à S23 : 2 zéros adjacents pos LSB {2}+{1ou3} ; 60/60 à S60 :
  1 zéro pos LSB impaire). Scorer innocent (8 rotations testées),
  pas de poison (complément, nonzero), pas de rotation.
- `0000` = garde `ZERO_STALE_SLOTS` (X→0) : bits échantillonnés en Hi-Z /
  violés / jamais écrits. Compte de zéros : 2 (20/23/40), 1 (60/64),
  0 (25/26) — **dépend du STEP** (historique pré-pin → contenu stale de
  la mem, que le pin ne reset pas : il reset les pointeurs, pas la mem),
  **indépendant de K et du mag**.
- S25/S26 : exit +0 en 7 slots de sweep, lock rot6 score8, 42-50 slots à 8.
  Le 8 existe (ancre + gap évolué-7-iters), le sweep ne le retrouve jamais
  (ni en rstep ±64, ni en K 0..7).

## 4. Recommandation fix (robustesse : revert ciblé, pas total)

**GARDER** (prouvé utile, HW-safe) :
- Free-run HOLD (Patch 1, committé) : les mesures suivent les bursts
  (3 mots figés → 20 qui évoluent), miroir du fonctionnel.
- Pin-par-palier (`pinLeft`) : 52/52 déterministe, +50 % iters (~0.2 ms HW,
  négligeable), socle de déterminisme pour tout futur axe-gap.
- Hygiène `chk`/`tries` gatés `!busyMoving` (sim-only, logs lisibles).
- Watchdogs tests 12k→60k (marge, zéro impact HW).

**REVERTER** (réfuté + coûteux) :
- Tout le nested-K : `kSkip`/`bestK`/`kreplayLeft`, cadence 32 iters/mag,
  `tries` 13→10 bits. Motif : K n'explore rien (données §2) et multiplie
  le temps sim par ~8 pour zéro bénéfice. Restaure des sims rapides.
- Le settle-par-palier reste reverté (décision antérieure confirmée).

**NE PAS coder de fix aveugle ensuite.** L'étape décisive est une
micro-analyse **VCD** (1 run, zéro RTL) : compter les fronts DQSR90 par
burst + relever WPOINT/RPOINT au latch, S23-post-pin vs S25. Ça tranche
entre contamination préambule (nb fronts > 8) et violation
setup/hold (rstep), et désigne le vrai fix (qui n'est ni rstep ni K).

## 5. Leçons méthodo (batterie)

- **Binaire périmé** : la 1re batterie a tourné sur `tb_fast.vvp` du 05-10
  (pré-nested-K). Check avant chaque batterie : date vvp vs `hw/gen` +
  présence des champs `side=/k=` dans les 1res lignes de log.
- `map_capture` skippe les logs avec RESULT : supprimer `tb_fast_s*.log`
  avant relance (code intact, seuls les fichiers).
- Pas de stop prématuré sur les runs décisifs (l'œil peut être au mag 60+,
  côté minus, jamais visité avant le full run).
- VCD = build-time (`NO_VCD` par défaut) : la batterie ne dumpe rien,
  reste légère. Ne builder `--vcd` que pour la micro-analyse §4.
