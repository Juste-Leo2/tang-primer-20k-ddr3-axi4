# Matrice des shifts d'écriture DQ (t21 + window M0) — 13/10/2026

Proof-test `wrDqShift` (`Ddr3Config`, ±1 tCK = ±2 beats, `Ddr3Gen` Sim seul).
TB t21 **non modifié** (`sim_tests/t21_fifo_trace/tb_t21.v`, `+trt=1` pos0 sel1).
Réf shift 0 = runs t21 d'origine ([t21_resultats](t21_resultats.md)).

Format bus : `dq=V/kkk`, `V`=DQ12 (donnée valide), `kkk`=DQ[2:0] (indice beat).
Motif BIST = `0x1000+k`, beats `1000..1007`.

## 1. Tableau résumé (contenu DRAM lu sur le bus, 2 bursts BL8)

| shift | S23 bus (burst1 = burst2) | S23 | S25 bus (burst1 = burst2) | S25 |
|---|---|---|---|---|
| 0 (réf) | `X,X,1000..1005` (1006/1007 jamais écrits) | 6 | `1000..1007` complets | 8 |
| +1 (avance 2 beats) | `1000,X,1002..1007` (**b1 troué**) | 7 (best survey, incomplet) | `1002..1007,X,X` | 6 |
| −1 (retard 2 beats, contrôle) | `X,X[,X],1000..~1002` + dups (`latch=X`, score `x`) | ~4–5 | `1000..1005` + dups `0000` | 6 |

Critère d'acceptation « 8+8 bus-level » : **atteint après fix DM** (voir §5).
S23+1+DMfix = 8/8 (`score=8 latch` plein), S25 via shift 0 = 8/8.
Le shift entier compense exactement ±2 beats (miroirs S25 : +1 et −1
donnent tous deux 6, contenus opposés).

Matrice finale (13/10 au soir, DM fixé pour +1) :

| shift | S5 | S23 | S25 | S40 | S60 |
|---|---|---|---|---|---|
| 0 | 6 (`X,X,b0..b5`) | 6 | **8** | 6 | **7** (`b0..b6,X`) |
| +1 | **8** | **8** | **8** | **8** | 6 |
| −1 | — | ~4–5 | 6 | — | ~5 |

Auto-calib {0,+1} choisit : S5/S23/S40→+1 (8), S25→0 (8), S60→0 (7, extrême
improbable, dégradation gracieuse). −1 abandonné (jamais gagnant physiquement).

## 2. Détail par run (logs `sim_tests/gen/t21_*.log`, regen `wrDqShift=-1` SUCCESS 18h46)

### Écriture (auto-capture loopback DQSIN, ~3275–3290 ns)

| shift | S23 premier front utile | S25 premier front utile |
|---|---|---|
| 0 | R− 3279.3 `0` (préambule), R+ 3280.6 `000` (2 beats late) | `001/010…` à l'heure |
| +1 | R− 3275.6 `z`, R+ 3278.1 `000`, R− 3279.3 `001` (à l'heure, séquence `000..111` propre) | avance de 2 (sur-compense) |
| −1 | R− 3275.6 `z`, R+ 3278.1 `z`, R− 3279.3 `0/000` (2 beats PLUS tard) | R+ 3278.1 `000`, R− 3279.4 `0/000` (traîne) |

### Lecture (bursts ~3360–3380 ns, paires par période DQS)

- S23 −1 : `(x,x),(000,000),(000,001),(010,011)` ×2 → à peine 4 beats distincts ;
  `M` : `xxxx,1000/0000,1010/1011,1000/1001…`, `latch=X` (t21 sans
  `ZERO_STALE_SLOTS` : 1 slot X veto tout, `NOTE … score=x best=0 tries=001`).
- S25 −1 : `(000,000),(000,001),(010,011),(100,101)` ×2 → `1000..1005` ;
  `NOTE … score=6 rot=4 latch=10031002100110000000100010051004 best=0 tries=001`.
- S23 +1 (run précédent) : `(000,x),(010,011),(100,101),(110,111)` ×2 → 7.
- S25 +1 (run précédent) : `(010,011),(100,101),(110,111),(x,x)` ×2 → 6.

## 3. Window M0 (`tb_fast`, `+mag0=0 +magN=1`, shift+1, runs tués à pos2sel3/40)

`simulation/tb_fast_s23_m0.log` : `tries=010 pos2sel1 score=5 best=7`,
`tries=011 pos2sel2 score=6 latch=1007..1002 best=7`.
`simulation/tb_fast_s25_m0.log` : `tries=010 score=6 best=6`, `tries=011 score=4 best=6`.

Les beats manquants **bougent avec (pos,sel)** (sel1: `{b1,b6,b7}`+zéros ;
sel2: `{b0,b1}`) → pas une simple rotation d'un contenu fixe : la fenêtre de
capture (`dqs_read` suit `pos` via `rdCyc`) rejoue après le fix entier.

## 4. Lecture du résidu b1 (S23+1)

Le +1 tCK est un multiple entier de la période DQS : il ne change **pas** la phase
relative DQ/DQS. b1 sort sur D6 = pile sur le 1er front montant DQS (slot
nouvellement drivé, `dq_oen` TX2/TX3 tout juste ouverts au cycle préambule).
Suspects : enable OEN tardif sur D6 (b1 sort Hi-Z au front → DRAM stocke X),
ou violation tDS/tDH pile sur la transition b0→b1.
Discriminant : VCD write-side S23+1 (DQ/DM/`dq_oen`/DQS au ps autour de D6),
ou vérification que le contenu DRAM = 8/8 et que seule la capture perd b1.

## 6. Steps 40/60 à shift 0 (bitstream `wrDqShift=0`, TB `t21step.vvp`, 13/10)

- S40 = même contenu que S23 (`X,X,b0..b5`, 6) → même type (slip entier, candidat +1).
- S60 (`sim_tests/gen/t21_s0_60.log`, `NOTE … latch=100510041003100210011000xxxx1006`)
  : `{b0..b6}` + X en queue (b7 manquant) = **7, nouveau type** (tête propre).
  Mêmes entrées FIFO : `1000/1001,1010/1011,1110/xxxx…`.
- Conséquence : {-1,0,+1} ne couvre S60 que si le trou b7 **bouge** avec le shift
  (victime de phase sur front fixe → +1 met le postambule dessous → 8/8 possible).
  Sinon (b7 structurellement non stocké), aucun shift entier ne donne 8 → 2e mécanisme
  (queue/postambule/DM) à traiter. Mesures S60×{+1} (et S40×{+1} contrôle) requises
  avant de figer la spec auto-calib.
- S40+1 (`t21_p1_40.log`) : `score=8 latch=8 beats` → **8/8**, slip validé 2e step.
- S60+1 (`t21_p1_60.log`) : `latch={b1..b7}+X` + résidu burst1 → vrai contenu
  `[b2..b7,X,X]` = 6 (miroir S25+1 exact). Trou b7 **structurel** : +1 fait 7→6.
  → +2 écarté (aucun slip 2 tCK observé, fenêtre à étendre). Reste : matrice −1/60
  (prédit ~5) puis VCD queue S60-shift0 (b7/postambule vs derniers fronts).
- S60−1 (`t21_m1_60.log`) : `latch={b0..b4}+0000+X` → ~5, prédiction confirmée.
  Matrice monotone : +1/0/−1 = avance/neutre/retard, jamais d'inversion.
  +2 définitivement écarté (prédit 4 à S60 : trou en queue, avancer perd la tête).
  S60-like = improbable sur PHY réel (équiv. STEP extrême, hors lock nominal) :
  {-1,0,+1} couvre la zone nominale à 8, extrêmes à 7 (dégradation gracieuse).

## 5. État du code (à revert avant le vrai fix)

- `ddr3/src/ddr3/Ddr3ControllerCore.scala` : param `Ddr3Config.wrDqShift`, mapping
  WRITE par branches (`+1` : b0 sur D5, `dq_oen=0011`, DM suit ; `−1` : retard
  in-fenêtre, b7 perdu ; `0` : bit-identique), P13 formel gaté par
  `if (wrDqShift == 0)`.
- `ddr3/src/ddr3/Ddr3Gen.scala` : Sim figé à `wrDqShift = 0` (runs steps 23/40/60).
