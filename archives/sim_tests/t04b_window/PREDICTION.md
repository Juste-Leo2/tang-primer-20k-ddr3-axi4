# t04b — fenêtre read à taps forcés, sans calib (MINIMALISTE)

## Question
Même question que t04 (le read seul explique-t-il 6 vs 8 ?), même
court-circuit que t03b (WL + IDLE forcé + taps), + balayage `RPOINT`
23–27 en direct et 1 read par point. Ancre 25 (write sain).

## Prédiction
Fenêtre OK autour de 25 (largeur = la mesure). Si la fenêtre couvre 23–27
entièrement → le read est innocent, croiser avec t03b (qui accuse le
write/DLLSTEP courant si KO à 23).

## Conclusions selon résultat (T04B PASS = tableau complet obtenu)
- **Fenêtre ⊇ [23,27]** → read innocent → le 6 S23 vient du write.
- **Fenêtre plus étroite** → comparer aux slots tombés du latch S23.
- **Court-circuit KO** (req jamais servies) → revoir le harnais (t04c).

## Portée assumée
Comme t03b + boucle 5 points (reprend `goto_rstep`). Minutes wall.
Valide aussi le court-circuit lui-même : s'il marche ici, il est réutilisable
pour tous les futurs tests transport.
