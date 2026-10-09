# t02 — loi du mover write (WLOADN/WMOVE/WDIR) + init `DLLSTEP+WSTEP`

## Question
DUT : primitive DQS vendor seule (`DQS_MODE X4`, comme `hw/gen`).
Le retard write suit-il `wstep_init = min(DLLSTEP+WSTEP, 255)`, avec
`wstep_reg` qui suit en direct (`WLOADN=0` permanent dans le PHY) ?
Et `DQSW0` (= tap[`WSTEP`]) vs `DQSW90` (= tap[`wstep_reg`]) : deux horloges
distinctes ?

## Prédiction (lue dans `prim_sim_tb.v`, à confirmer en sim)
- `always @(DLLSTEP or WSTEP)` : X1 → `wstep_init <= DLLSTEP` ;
  X4 → `wstep_init <= min(DLLSTEP+WSTEP, 255)` (`:13818-13830`).
- `WLOADN==0` → `wstep_reg <= wstep_init` (niveau, miroir RLOADN, `:13834`).
- Front descendant WMOVE + `WLOADN==1` : `WDIR==0` → +1, `==1` → −1,
  mêmes gardes `WFLAG` (`:13837-13850`). `WFLAG==1` à (255,plus)/(0,minus).
- Retards (`:13867-13869`, pas 25 ps comme t01) :
  `DQSW0 = tap[WSTEP]`, `DQSW90 = tap[wstep_reg]`, `DQSW270 = ~DQSW90`.
- Cas pair23 : DLLSTEP=23 + WSTEP net 27 → `wstep_reg`=50 (comme TB-25)
  mais `DQSW0`=27 (vs 25). Le WLOVR bouge les DEUX horloges write.

## Conclusions selon résultat
- **PASS** → loi write verrouillée ; l'écart pair23/TB-25 sur `DQSW0`
  (27 vs 25, 50 ps) devient un suspect chiffré pour t03.
- **FAIL** → revoir la compréhension du write avant t03.

## Portée assumée
Pas de DLL, pas de Micron, pas de burst : registres + flags uniquement.
Le stepping WMOVE détaillé (gaps) appartient à t07.
