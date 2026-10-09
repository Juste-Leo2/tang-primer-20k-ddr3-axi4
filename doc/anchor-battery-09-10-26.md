# Batterie ancrage 09/10/2026 — conclusions : le survey décide, le point mesuré ne compte pas

Batteries A (densité) + B (hop d'ancre), 11 points, `jobs=4`, ~40 min mur.
Binaire unique `tb_fast.vvp` (MAP_ONLY + `+anchor_step`, `BUILD rc = 0`, pas
de rebuild entre les runs). En MAP_ONLY, `RESULT ... PASS` est vacueux :
seuls `WINDOW` / `dll side` / `maxsw` comptent.

## 1. Protocole

```powershell
python measure\mag_battery.py --steps 22,23,24,25,26,27,28 --mag0 0 --magn 1 --jobs 4
python measure\mag_battery.py --steps 23,25 --anchor-steps 25,23 --mag0 0,2 --magn 1 --jobs 4
```

Batterie B : `+anchor_step` re-force `dll_1.STEP` sur `posedge dllSweepOn`
(fin du survey) — le survey tourne à `step`, le sweep s'ancre à
`anchor_step` (`tb_fast.v:152,167-173`). Logs drivers :
`measure/battery_density.log`, `measure/battery_hop.log`.

## 2. Résultats

### A. Densité d'ancres (survey@STEP, mesure@STEP+0)

| STEP | 22 | 23 | 24 | 25 | 26 | 27 | 28 |
|---|---|---|---|---|---|---|---|
| maxsw / WINDOW | 6 | 6 | 6 | **8** | **8** | 6 | 6 |

(`tb_fast_s{22..28}_m0.log`, survey lock `rot=4 score=6` partout sauf 25/26
`rot=6 score=8` ; 25/26 sortent par perfection-exit `dll side=0 mag=00
score=8` + lock final 8, d'où `WINDOW ?` avec `maxsw=8`.)
Zone bonne = **exactement {25, 26}**, fronts raides (24→6, 27→6). 26
re-validé comme annoncé.

### B. Hop d'ancre (le discriminant)

| Run | Survey | Ancre sweep | Mesuré | Verdict |
|---|---|---|---|---|
| s23a25_m0 | @23 (6, rot4) | →25 | rstep 25 | **6** (`window side=0 mag=00 rot=0`) |
| s23a25_m2 | @23 | →25 | rstep 27 | **6** (`window side=0 mag=02 rot=4`) |
| s25a23_m0 | @25 (8, rot6) | →23 | rstep 23 | **8** (perfection-exit `dll side=0 mag=00`, lock final 8) |
| s25a23_m2 | @25 | →23 | rstep 25 | **8** (`dll side=0 mag=02`, lock final 8) |

### Preuve anti-race (le switch a bien pris)

`PROBE` dès `t=20319 ns` (slot suivant le switch, `RLOADN=0` pendant
l'ancre donc le reload échantillonne la nouvelle valeur) :
* s23a25_m0:4281+ : `rstep1=19` (= 25) en continu → mesuré à 25, score 6.
* s25a23_m0:4281+ : `rstep1=17` (= 23) en continu → mesuré à **23**, score 8.
`wstep=19` partout dans les deux runs (write tap identique).

## 3. Conclusions

1. **Le score est une fonction de l'histoire (survey), pas du point mesuré.**
   Le même `rstep 23` vaut 6 (survey@23) ou 8 (survey@25) ; le même `rstep
   25` vaut 6 (survey@23, ancres 23 ou 25) ou 8 (survey@25). Cas **B tranché** :
   re-ancrer sans re-survey ne sauve rien (s23a25 → 6) ; un bon survey sauve
   tout, même mesuré à un tap « mauvais » (s25a23 → 8 à rstep 23).
2. **`anchor-per-mag` seul est insuffisant.** Le fix doit inclure un
   **re-survey par base** (boucle externe = base + survey + sweep, pas base +
   sweep seul).
3. **Contrainte nouvelle sur H7 (phase write) :** après le switch, les BIST
   writes du sweep s25a23 sont en phase ancre-23 — et ça score quand même 8.
   Donc la phase d'écriture *courante* n'est pas le levier ; le poids est dans
   le training-write + les 40 lectures du survey (ou la trajectoire
   dqs_en/rotation qu'ils établissent : rot 4 vs 6 dès le survey lock).
4. **Design de fix affiné (bon marché) :** le survey prédit le sweep (jamais
   vu de survey-6 suivi d'un sweep-8, ni l'inverse, sur 11+ points). Donc
   boucle externe en deux temps : (i) scan *survey-only* grossier sur ~33
   bases (pas de 4 sur ±64, ~15 µs/base ≈ 0,5 ms), (ii) sweep complet aux 2–3
   meilleures bases + early-exit global au premier 8. Cartes saines : coût
   ~1× (base +0 d'abord). Le tout relatif au lock vivant (PVT-safe), steppers
   uniquement (PR0015).

## 4. Repro

Logs points : `simulation/tb_fast_s{22..28}_m0.log`,
`simulation/tb_fast_s23a25_m{0,2}.log`,
`simulation/tb_fast_s25a23_m{0,2}.log`.
Prochaines étapes : edit Scala (boucle externe + re-survey par base +
early-exit) → regen → unitaires → formel BMC + TB S25 en fond.
