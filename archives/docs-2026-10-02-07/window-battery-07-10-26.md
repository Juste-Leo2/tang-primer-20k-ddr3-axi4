# Batterie window-scan (STEP × mag 0-70) : pas de 8 hors ancre-25 — 07-10-26

## 0. Avertissement de lecture (important)

- Runs en build **MAP_ONLY** (pas de memtest) : `RESULT ... errors=0 PASS`
  est **vacueux** (S23/S40/S60 affichent PASS avec un lock 6/7 !).
  Seuls comptent : lignes **`WINDOW`** (best de tranche) et **`maxsw`**.
- `P=` dans RESULT = `rclkpos` résiduel (pas de lock en diag) : P=1 normal.
- Champs `side/mag/k` sans sens hors sweep (survey) ; best=window-start =
  ex æquo conservant le premier (comparateur strict), pas un signal.

## 1. Matrice (maxsw par tranche de 10 mags, BIST+frais partout)

| STEP | m0 | m10 | m20 | m30 | m40 | m50 | m60 | WINDOW |
|---|---|---|---|---|---|---|---|---|
| 23 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | W6@start, rot 0/4 alternés |
| 25 | 8* | 8* | 8* | 8* | 8* | 8* | 8* | *exit +0 (pas WINDOW) : œil à mag0, lock rot6/8, PASS réel |
| 40 | 6 | 6 | 6 | 6 | 6 | 6 | 6 | W6@start, idem S23 |
| 60 | 7 | 7 | 7 | 7 | 7 | 7 | 7 | W7@start, rot 2/6 alternés |

- **Aucun 8 hors ancre-25** sur 28 fenêtres (mags 0-70 × 4 STEPs).
- S25 : toutes les fenêtres exitent à mag0 (ancre=8) → pas d'info au-delà,
  contrôle rig OK.
- Dirt = f(STEP) uniquement : 23/40 → 6 (2 zéros), 60 → 7 (1 zéro,
  toujours le slot-1007), 25 → 8. Ni le mag ni K ne changent rien.

## 2. Verdict mécanisme (H1 favorisée, H3 rétrogradée, H2 morte)

- BIST-frais + pin + 70 mags : toujours pas de 8 hors ancre → **H3 seule
  (stale) est morte** : le frais ne suffit pas.
- Même rstep absolu, scores différents (mag+2=6 vs ancre-25=8) → **H2
  (sampling) morte** : même phase d'échantillonnage donnerait même latch.
- Reste **H1 (préambule-dans-FIFO + gap choisit la fenêtre)** qui explique
  tout : déterminisme gap-0, STEP-dépendance (alignement préambule au
  release), impuissance du BIST (Hi-Z par burst, pas stale), chance S25
  (gap évolué = fenêtre propre), rot alternée avec mag (fenêtre fixe,
  contenu roulant).
- **H4 (durée de pin) TOUJOURS NON TESTÉE** : seul knob gap côté
  contrôleur jamais exploré (nested-K variait le post-release, pas la
  phase de release).

## 3. Propositions (ordre)

1. **Pin-duration sweep (H4)** : pin 1/2/3/4 slots par mag (~même coût
   qu'une batterie window). Décisif : un 8 = cause + fix d'un coup
   (sélection de phase de release qui évite le préambule).
2. **VCD comptage fronts/burst** (1 run) : nomme le préambule (nb fronts,
   positions) — arbitre H1, guide (3).
3. **3-4 bursts/itération** (~10 lignes) : glisse la fenêtre au-delà du
   préambule si la dynamique élastique le permet (la VCD le dira).
4. **Fenêtres minus** : couverture ( relapse RDIR), si (1) donne un signal.
5. **Full runs de validation** : seulement quand un 8 apparaît (lock +
   RESULT réel + memtest).

## 4. Robustesse / commit

- **Garder** : BIST (hygiène + S25/S26 meilleurs), pin (déterminisme),
  window-scan + `mag_battery.py` + `analyze_window.py` (infra diag,
  28 points ≈ 40 min), chk gaté, watchdogs 3M (test-only).
- **Resté reverté** : nested-K. Rien à reverter de cette batterie.
- Prochain commit : pin-duration (H4) si signal, sinon VCD d'abord.
