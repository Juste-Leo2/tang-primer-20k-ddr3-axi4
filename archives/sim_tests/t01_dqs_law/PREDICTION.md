# t01 — loi du mover read (RLOADN/RMOVE/RDIR) + pas de retard

## Question
Le point "vrai-25" (ancre 23 + navigate mag=2, `rstep=0x19` au PROBE) vaut-il
réellement le point ancre 25 + mag 0 ? Autrement dit : le retard DQS ne
dépend-il QUE de `rstep_reg`, ou aussi de l'ancre `DLLSTEP` ?

## Prédiction (lue dans `prim_sim_tb.v`, à confirmer en sim)
- `del = 0.025` ns (timescale 1ns/1ps, `prim_sim_tb.v:17`) : **1 tap = 25 ps**.
- Chaîne : `dqsr90_dly_in[i] = #(0.025) dqsr90_dly_in[i-1]`,
  `DQSR90 = tap[rstep_reg]` (`:13856-13870`).
- Reload (niveau) : `RLOADN==0` → `rstep_reg <= DLLSTEP` (`:14191`).
- Step : front descendant RMOVE (`==0 && pre==1`), `RLOADN==1` :
  `RDIR==0` → +1, `RDIR==1` → −1 (`:14194-14204`). N slots à 1 = 1 seul pas.
- Saturation : `RFLAG==1` à (255,plus) / (0,minus), step bloqué (`:14175-14204).
- Donc : **rstep=25 depuis DLLSTEP=23 ≡ rstep=25 depuis DLLSTEP=25**,
  même registre, même tap, même retard (625 ps).

## Conclusions selon résultat
- **PASS** → le "vrai-25" est valide au niveau DQS ; le 6/8 vient d'ailleurs
  (état Micron/timing bursts, pipeline PCLK). Hypothèse "illusion" réfutée.
- **FAIL reload/step** → la navigation mag ne fait pas ce qu'on croit ;
  revoir `navigateLeft` + le fix v2 avant toute chose.
- **FAIL `del`** → le pas du modèle a changé ; revoir tous les calculs mag.

## Piège modèle trouvé par ce test (09/10)
`RFLAG` est calculé par `always @(rstep_reg)` : après un changement de `RDIR`
**sans** mouvement de `rstep`, `RFLAG` est stale. Aux bornes ça déborde
(0 −1 → 255) au lieu de saturer. Le RTL s'en sort car il pose `RDIR` avant le
reload et navigue loin des bornes — mais tout futur usage aux bornes doit
recharger après avoir posé `RDIR`. Verrouillé par A3b (ordre RTL) + A3c.

## Portée assumée
DUT = primitive DQS vendor seule (`DQS_MODE X4`, comme `hw/gen`), DLLSTEP
piloté par registre (= ce que le `force` d'ancre fait dans `tb_fast.v:152`).
Pas de DLL, pas de Micron, pas de read ouvert : on vérifie le registre
`rstep_reg` + `RFLAG`, pas le retard analogique (la chaîne est structurelle).
