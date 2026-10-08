# Observations — carte de capture STEP x phase (03-10-26)

Toutes les données de cette page viennent du TB rapide (`tb_fast.v`), validé
bit-pour-bit contre le TB Micron de référence (82 lignes de mesure identiques +
memtest identique). Voir `tb-cartographie.md` pour la structure et
`plan-capture-read-03-10-26.md` pour le plan.

## 1. Le résultat central

```
=== C (meilleur score du sweep) ===
step   ph0     ph312    ph625
0      6       6        6
16     6        -        -
20     6        -        -
22     6        -        -
24     6        -        -
25     8       8        8   <- seul point parfait (et 26)
26     8        -        -
28     6        -        -
30     6        -        -
34     6        -        -
40     6        -        -
48     6        -        -
64     6       6        6
128    6       6        6
192    2       2        2
255    0       0        0
```

Deux axes testés, deux résultats :

- **L'axe phase (pclk vs ck/fclk) est totalement neutre.** C est identique à
  0, 312 et 625 ps pour *tous* les STEP. L'hypothèse « dérive de phase
  pclk/FCLK », privilégiée depuis le 02-10, est **éliminée**. Le déterminisme du
  TB n'était donc pas un artefact de phase.
- **L'axe `STEP` est toute l'histoire**, et la fenêtre est très étroite :
  seuls STEP = 25 et 26 donnent C=8 ; 24 et 28 donnent 6.

## 2. Tables de réglage aux bords de la fenêtre

`pos` = décalage d'ouverture de la fenêtre de capture (pas de 10 ns),
`sel` = sélection de routage de l'horloge read. Valeur = score.

```
STEP=24 (max 6)              STEP=25 (max 8)
 pos0: x  x  x  x  x  x  x  x    pos0: 8  8  8  8  8  8  8  8
 pos1: x  x  x  x  x  x  6  6    pos1: 8  8  8  8  8  8  6  6
 pos2: x  x  6  6  6  6  4  4    pos2: 6  6  6  6  6  6  4  4
 pos3: x  x  x  x  x  x  x  x    pos3: x  x  x  x  x  x  x  x

STEP=26 (max 8)              STEP=28 (max 6)
 pos0: 8  8  8  8  8  8  8  8    pos0: x  x  x  x  x  x  x  x
 pos1: 8  8  8  8  8  8  8  6    pos1: x  x  x  x  x  x  x  6
 pos2: 6  5  6  6  6  6  6  4    pos2: x  x  x  x  x  6  x  4
 pos3: x  x  x  x  x  3  x  x    pos3: x  x  x  x  x  3  x  x
```

À lire :

- Quand la fenêtre est bonne, `pos=0` donne 8 pour **tous** les `sel` : la
  design est robuste *à l'intérieur* de la fenêtre.
- Hors fenêtre, `pos=0` ne capture **plus rien du tout** (X partout) et le
  maximum devient partiel (6, puis 4). Un décalage de 25-50 ps suffit à passer
  de « tout » à « rien » : le comportement est quasi bistable, pas graduel.
- La fenêtre de capture **glisse** avec STEP : le meilleur `pos` passe de 0 à 2.

## 3. L'hypothèse « horloge alignée sur le DQS » est réfutée

Le modèle vendor donne, avec des taps de 25 ps :

```
dqsw0_dly_in[0]  = fclk_in;          // PCLK
dqsr90_dly_in[0] = dqs_r_clean;      // DQS de la DRAM
DQSW0  = dqsw0_dly_in[WSTEP];        // clk_rd si rclksel[0]=0
DQSW90 = dqsw270_dly_in[wstep_reg];  // clk_rd si rclksel[0]=1, wstep_reg=DLLSTEP
```

Donc avec `sel[0]=1` l'horloge de capture serait retardée du **même** STEP que
le DQS, et le délai relatif serait nul quelle que soit la valeur —=config
« invariante à STEP ».

**Les données refusent cette prédiction** : les `sel` impaires (1, 3, 5, 7) ne
donnent 8 qu'aux STEP 25/26, exactement comme les `sel` paires. À STEP=24 et 28
aucun `sel` ne atteint 8. La piste « forcer `sel[0]=1` » est donc **abandonnée**.

## 4. Pourquoi 25 : deux constantes sans rapport qui se croisent

| constante | origine | valeur |
|---|---|---|
| `STEP` | `SIM dlllock=1, dllstep=25` chez nand2mario — raccourci de simulation (le modèle DLL met 33600 cycles à verrouiller) | 25 |
| `WSTEP` | **notre** write leveling : le RTL initialise `wstep = 0x18` en simulation, l'écho locke au verdict suivant | 0x19 = 25 |

Aucune des deux n'a été choisie en fonction de l'autre. Elles sont égales par
hasard. Et comme le delay relatif de la capture vaut `(WSTEP − STEP) × 25 ps`,
cette égalitéDONNE une capture parfaite.

Donc **`C=8` dans le TB n'est pas une propriété du design, c'est une coïncidence
entre deux constantes indépendantes.** C'est ce que la carte a permis de voir.

## 5. Conséquence pour le silicium

Sur HW :

- `wstep init = B"8'h00"` (pas 0x18 en simulation) → le lock écho donne WSTEP =
  0x0A sur la carte, sans lien avec `STEP` ;
- `STEP` est la sortie du **vrai DLL** : sa boucle ajuste le tap en continu pour
  aligner le DQS sur l'horloge, et il **dérive** avec la température/tension ;
- rien ne garantit `STEP == WSTEP`.

La carte predicts alors C=6 pour un STEP éloigné de WSTEP — ce qui est
exactement ce que la carte HW donne. **Le défaut HW est reproduit en simulation
et son axe identifié.** Et le fait que HW obtienne 6 (et non 0) dit que
l'alignement y est *partiellement* correct : le HW est près de la fenêtre, pas
loin en dehors.

## 6. Ce qu'il reste à trancher

`STEP` est une sortie de la primitive DLL (`module DLL (STEP, LOCK, ...)`),
déjà routée dans le design (elle alimente les DQS). La bring-out vers notre
logique est a priori possible : on peut donc **mesurer** STEP, et suivre sa
dérive.

Mais la fenêtre de ±2 taps (50 ps) ne laisse aucune marge pour un réglage
statique : il faut une **boucle**, pas une constante.

**Question ouverte, decisive :** est-ce que 25 est spécial, ou est-ce
l'égalité qui compte ? On n'a observé que `WSTEP = 25` (imposé par le modèle
Micron : l'écho locke à 0x19).

- Expérience : forcer `WSTEP = 100` et `STEP = 100`.
  - `C=8` → la règle est « `WSTEP == STEP` ». Correctif : **lier WSTEP à STEP**
    (lisible donc pilotable), petit changement RTL, et automatiquement suivi
    face à la dérive du DLL.
  - `C≠8` → la loi est plus subtile, il faut l'explorer autrement.

## 7. Piste de secours (si la loi s'avère plus complexe)

L'IDES expose `RBURST` (burst valide/complet) et `RVALID`. Les exploiter pour
détecter à l'exécution une capture mauvaise, et corriger `rclkpos`/`rclksel`
en boucle, rendrait le système auto-adaptatif sans avoir besoin de connaître la
loi algébrique — seulement sa signature observable.