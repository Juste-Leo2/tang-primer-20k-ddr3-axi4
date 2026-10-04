# Le décalage K — analyse et tentative (03-10-26)

Suite directe de `capture-map-observations.md`. Question au centre : **pourquoi la
capture read ne fonctionne-t-elle que pour 2 taps de `STEP` sur 256 ?**

## 1. Rappel de la configuration simulée (fidèle au HW)

Vérifié dans le Verilog généré : `DQS #(.DQS_MODE("X4"))` — le TB rapide
simule bien la même configuration que la puce. Et `DLL.CLKIN = fclk`.

En mode X4 (`prim_sim_tb.v`, primitive `DQS`) :

```
fclk_in     = fclk_hold            = FCLK gatille par HOLD
fclk_fifo   = FCLK                 (pointeur de lecture du FIFO, libre)
DQSR90      = dqsr90_dly_in[rstep_reg]   (DQS de la DRAM retarde de STEP)
clk_rd      = DQSW0 ou DQSW90      (selection par rclksel[0])
```

- **pointeur d'ecriture** du FIFO : cadence par le DQS retarde de `STEP`
- **pointeur de lecture** du FIFO : libre sur `FCLK`
- **le DLL aligne le DQS sur `FCLK`** (son CLKIN) et produit `STEP`

## 2. Les deux experiences qui cadrent le probleme

### (a) La phase pclk/FCLK n'a aucun effet
`C` identique à phase = 0 / 312 / 625 ps pour tous les STEP. Hypothese « derive
de phase » eliminee.

### (b) WSTEP n'a aucun effet, STEP décide seul
Cartographie complete (`tb_fast_s{step}_p0_w{wl}.log`) :

| STEP | WSTEP | C | verdict |
|---|---|---|---|
| 25 | 25 (defaut) | **8** | PASS |
| 25 | 40 (force) | **8** | PASS |
| 26 | 25 | **8** | PASS |
| 40 | 25 | 6 | FAIL |
| 40 | 40 (force) | 6 | FAIL |
| 24 / 28 | 25 | 6 | FAIL |

**L'hypothese « WSTEP == STEP » est refutee, et meme son inverse.** Le tap
d'ecriture n'intervient pas dans la capture read : seul `STEP` compte, avec une
fenetre de 2 taps (~50 ps).

Consequence : mesurer `WSTEP` ne peut pas servir a compensate quoi que ce soit.
Et « caler WSTEP sur STEP » (piste serieusement envisagee) est une impasse.

## 3. La lecture qui reste coherente avec tout

Le DLL fournit une phase qui aligne le DQS sur `FCLK`. Le FIFO, lui, veut que
cette phase presente une **marge** : son pointeur de lecture doit suivre le
pointeur d'ecriture avec une avance suffisante, sinon la requete de transfert
(`shift` / `ren`) ne voit jamais les 8 slotsNevides.

Donc l'alignement utile = **alignement du DLL + une constante**. Le DLL ne
connait que le premier terme ; le second, nous seuls pouvons l'ajouter.

Et contrairement a WSTEP, nous 控制ons l'injection : `GowinDdr3Phy.scala:98`

```scala
u_dqs.io.DLLSTEP := dllstep          // peut devenir dllstep + K
```

## 4. Ce que K doit etre : mesure, pas constante

Un `K` code en dur serait une deuxieme constante magique, pire que la premiere
puisqu'elle devrait suivre une derive (temperature, tension, PLL). La bonne
forme est un **axe de balayage** ajoute a la calibration existante, qui trouve
`rclkpos`/`rclksel` : le controleur mesure, garde le meilleur, et se recale tout
seul — y compris si le DLL bouge apres le boot.

Deux etapes, dans cet ordre :

1. **Mesurer** la fenetre : forcer `dllstep = STEP + K` depuis le TB (aucun
   changement RTL requis, c'est exactement le noeud que le RTL modifierait) et
   balayer K. But : verifier que l'offset deplace bien la fenetre, et mesurer
   sa largeur et son centre.
2. **Implementer** l'offset dans le RTL (registre `dllStepOff` dans le core,
   port vers le PHY, `DLLSTEP := dllstep + off`) et le faire explorer par la
   calibration comme les autres axes.

## 5. Test en cours (mesure, etape 1)

`STEP` force a 40 (le DLL atterrit ailleurs que dans le cas favorable du TB) et
`K` balaye. Prediction si l'hypothese du §3 est bonne : il existe un `K` pour
lequel `C` redevient 8.

| K | STEP effectif | C attendu |
|---|---|---|
| 0 | 40 | 6 (connu) |
| ... | 40 + K | ? |
| K0 | 40 + K0 | **8** si l'hypothese tient |

Point d'attention : le centre de la fenetre pourrait ne pas etre exactement
l'alignement du DLL (K0 != 0). C'est justement ce que la mesure doit dire — et si
K0 != 0, c'est la preuve directe qu'il existe un terme constant manquant, donc
que l'offset est la bonne piste architecturale.

### 5 bis. Ce que ce test apporte — et ce qu'il n'apporte pas

Une objection legitime : `STEP=40 + K=-15` redonne `STEP=25`, un cas deja connu
bon. Le run est donc **circulaire** : il ne prouve rien de neuf sur K.

Ce qui apporte la preuve n'est pas de forcer K depuis le TB, mais de **confier
la recherche au controleur** : il ne connait pas la reponse, il essaie les
offsets, et doit trouver la fenetre lui-meme. C'est ca qui est lance (§6).

## 6. Implementation : l'offset devient un axe de calibration

Pas une constante : un axe de balayage, comme `rclkpos`/`rclksel`.

```scala
// GowinDdr3Phy.scala
val dllstepOff = (dllstep.asUInt.resize(9) + io.dll_step_off.asUInt.resize(9))(7 downto 0).asBits
u_dqs.io.DLLSTEP := dllstepOff
```

`Ddr3ControllerCore` ajoute une seconde phase dans `READ_CALIB`, apres le survey
de la grille 32 reglages : elle balaie **(pos, offset)** conjointement — un seul
compteur 10 bits enumere les 4 x 256 = 1024 combinaisons — et garde le meilleur
score. Le training n'est pas reecrit entre les iterations (les ecritures ne
dependent pas de l'offset), donc la mesure reste constante d'une iteration a
l'autre : c'est ce qui manquait au bracketing.

**Early exit sur 8/8.** 8 beats corrects est le maximum physique, inutile de
poursuivre. Cas favorable : arret a la premiere iteration. Cas defavorable
(fenetre a l'offset 241) : les 1024.

### Pourquoi (pos, offset) et pas offset seul

Mesure : le meilleur `pos` depend de l'`STEP` effectif (pos=0 quand la capture
est alignee, pos=2 quand elle ne l'est pas). Un balayage de l'offset fige sur le
`pos` choisi par la phase precedente resterait sur l'epaulement et plafonnerait
a 6 — le mecanisme serait bon, la strategie de recherche mauvaise.

Cout : 1024 iterations x 14 pclk ~ 14 us par passe, x2 passes, sur un boot
dej~1 ms : **+3 %**, et c'est du one-shot. Cote simulation, c'est 7x plus
d'iterations, donc des runs de ~1 h 30 au lieu de 12 min — d'ou l'exigence
d'early exit.

### Pourquoi les chances sont meilleures que pour le bracketing

| | bracketing (parké) | offset DLL |
|---|---|---|
| Ce qui change entre mesures | **le trafic** (training + poison réécrits) | rien (lecture seule) |
| Mesure répétable | non (8,8,6,6,4,4) | oui (41-iteration surveys stables) |
| Cible atteignable | inconnue | **garantie** par la carte (offset 241 -> 25) |
| Optimum peut se cacher | oui (mesure pert urbee) | non (grille 2D complete) |

## 7. Deux modes d'echec des runs 40/64/0 (04-10-26) et correctifs

Les 3 runs (base forcee, RTL passe-3) ont tous echoue pareil en surface
(41/41/1024/41 exacts, epuisement `tries=3ff`, meilleur score 6, lock 6,
8 erreurs fonctionnelles, zero erreur protocole) mais pour deux causes
distinctes :

### (a) Sweep gele sur `sel` impair : futile par construction (s40, s64)

La passe-2 a verrouille `bestSel=7` (impair, premier 6 rencontre). Le sweep
gelait ce `sel`. Or primitive DQS (`prim_sim_tb.v:13849`) :

```
RCLKSEL[0]=0 -> clk_rd = DQSW0   (horloge WSTEP, FIXE pendant le sweep)
RCLKSEL[0]=1 -> clk_rd = ~DQSW270 (suit DLLSTEP : wstep_reg = DLLSTEP+WSTEP)
```

En `sel` impair, l'horloge de capture bouge ensemble avec le DQS balaye :
l'alignement relatif est constant, le sweep ne peut rien trouver.
Correctif RTL : forcer `rclksel(0) := False` au demarrage du sweep
(source `DQSW0` fixe pendant la mesure). La passe-3 re-surveye tous les
`sel` derriere, donc le lock final reste libre (y compris impair).

### (b) Cas STEP=0 : trou d'ecriture sim, artefact documente (pas un bug RTL)

`s0` gelait pourtant `sel=6` (pair, sweep valide en theorie) et balayait
toute la plage sans jamais trouver 8 — y compris `(off=25, pos=0)` qui
aurait du reproduire la reference. Cause : `s0` est le seul run avec des
rafales `tDH/tDS violation by 0.0 ns` a ~8087/8168 ns = exactement la
fenetre training+poison. Le strobe d'ecriture (`TCLK=clk_dqsw270`, qui suit
DLLSTEP) est marginal a `STEP=0` force : le modele Micron empoisonne les
bits ecrits, le motif de reference est endommage, et aucun offset de
lecture ne peut le ressusciter (plafond a 6, zeros en fonctionnel car
`dq_in` jamais mis a jour). Smoke/s40/s64 : zero violation (que les 128
warnings benigns de baseline) — training propre.

Consequences :
- La carte STEP historique mesure `(qualite d'ecriture x capture read)`
  confondus, pas la capture seule. La fenetre {25,26} est (au moins en
  partie) la fenetre *d'ecriture*.
- `STEP=0` force est un artefact sim (strobe dans un trou) sans regime HW
  equivalent : sur silicium les ecritures fonctionnent (6/8 blocs au
  memtest HW). Pas de correctif prevu ; `s0` reste temoin d'artefact.
- La preuve du mecanisme se joue sur bases a training propre : 25 (connu),
  40/64 (connus propres), 10/60 (a confirmer via `tDH/tDS` en debut de
  run). Offsets predits : 40->241, 64->217, 10->15, 60->221, 25->0.

## 8. Documents lies

- `capture-map-observations.md` — carte STEP x phase, tables de reglage.
- `tb-cartographie.md` — structure du TB, ce que mesurent `C`, `rot`, `W`.
- `plan-capture-read-03-10-26.md` — plan d'origine, porte de fidelite, outillage.