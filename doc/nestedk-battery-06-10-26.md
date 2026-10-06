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

**REVERT APPLIQUE (post-batterie)** : tout le nested-K est sorti
(`kSkip`/`bestK`/`kreplayLeft`, cadence 32, `tries` 13→10). Gardés : pin,
free-run, hygiène logs, watchdogs 60k, `maxsw` map_capture (avec fallback
sans-K). Unitaires verts post-revert. Prochaine étape : micro-VCD
(comptage fronts DQSR90/burst + pointeurs au latch, S23-post-pin vs S25 ;
1 run, zéro RTL) qui tranchera entre contamination préambule (nb fronts
> 8) et violation setup/hold (rstep).

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

## 6. Hypothèses sans VCD (rangées, en attente de tranchement)

- **H1 — contamination préambule (gap-phase), favorite.** Bursts > 8 fronts
  DQSR90, FIFO = data + Hi-Z en roulement, phase RPOINT choisit la fenêtre :
  gap-0 sale (2 zéros), gap-évolué-S25 propre. Pour : zéros = X→0 (Hi-Z),
  S25-8 prouve la fenêtre propre, 52/52 déterministe. Contre : rien.
- **H2 — violation setup/hold (rstep), insuffisante seule.** Pour : slots
  fixes, STEP-dépendance. Contre : 88 taps sans 8 + mag+2≠S25-8.
  Combinée à H1, possible.
- **H3 — mem stale, intriquée à H1.** Pin reset pointeurs, pas mem ;
  contenu stale = f(historique) = f(STEP). Contre : WPOINT visite 0..7
  (reads réécrivent tout)... sauf fronts Hi-Z → retombe sur H1.
- **H4 — vrai knob gap jamais testé : la DURÉE de pin.** Nested-K variait
  l'évolution post-release, jamais la phase de release. Pin 1/2/3 slots →
  alignements releaseVs burst/FCLK différents → vraies phases de gap.
  Expérience ET fix potentiel (un 8 = cause + fix d'un coup, ~2x pin-only).
- **H5 — artefact modèle.** Faible : même signature HW (C≤6, résidu G).
- **H6 — fenêtre trop courte.** Morte : S25-8 prouve la fenêtre à 8.
- Tranchement : micro-VCD (fronts/burst + pointeurs au latch) décide
  H1 vs H2 en un run ; H4 se teste sans VCD.

## 7. Tri par l'observation S60 (1006 visible, 1 seul zéro)

- K=1..7 **identiques** (mag00/pos0 : rot 2, zéros {4,5} à chaque K) : K
  inerte confirmé au niveau frame, pas seulement score. (Note : à K=0 les
  slots survey portent side=0/mag=00/k=0 — champs sans sens hors sweep,
  contamination à filtrer dans les scripts : `tries` post-survey ou mag>0.)
- L'observation "STEP 60 voit 1006" **ne colle pas avec toutes** :
  - H1 pure / H4 pure : NON (gap-0 et release identiques → même dirt
    attendue ; observé 2 vs 1 zéro). Exigent un supplément rstep
    (perte/gain d'un front préambule selon le délai → H1+H2).
  - H2 pure : explique la STEP-dépendance mais contredit mag+2≠S25-8.
  - **H3 : explique directement** (contenu stale = f(historique) = f(STEP)).
  - H5 : non (7s dès mag 0, loin du rail).
- Bilan : l'observation favorise **H3 (ou H1+H2)**, défavorise H1/H4
  pures et H5. La micro-VCD reste l'arbitre (contenu stale vs fronts).
