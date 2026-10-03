# TODO — Write-leveling : verrou première fenêtre + strobe (2e round)

Date : 03/10/2026 (nuit). État : simu 8/8 + unitaires verts + formel PASS sur
RTL eye-search ; HW : `W=FF/FC`, FAIL. Pas de commit en attente (tout est
local, à valider avant).

## Ce que la dernière simu a révélé (WL eye-search v1)

`SPINAL-OK W=f0`, sweep score=0 partout. Cause : l'eye-search v1 ré-arm (`first`
écrasé à chaque entrée) et verrouille le **milieu de la DERNIÈRE fenêtre**.
Or les matchs WL sont périodiques (le délai `wstep` couvre plusieurs périodes
DQS → fenêtres alias, ex. autour de `0xE1-0xFF` en plus de la vraie vers
`0x19-0x1A`). Middle calculé = `0xF0` = hors vraie fenêtre → writes faux →
sweep 0. Le milieu de la dernière fenêtre n'a aucun sens physique.

## Fix retenu (implémenté) : PREMIÈRE fenêtre, pas dernière

- `wlDone` : une fois la première fenêtre quittée (2 miss consécutifs), on
  gèle `first`/`last` (plus de ré-entrée). Fin de scan : milieu de la
  première fenêtre, sinon sentinelle `FF`.
- En simu : première fenêtre = `{0x19,0x1A}` (attendue) → milieu `0x19/0x1A`.
- Sur HW : première fenêtre ≈ zone `0A` (connue de l'ancien run).
- Risque résiduel : glitch précoce (2 matchs fortuits avant la vraie fenêtre)
  → middle fantôme. Si la simu verrouille un `W` bizarre (ex. `0x05`), c'est
  ça : passer alors en "fenêtre la plus proche du seed" (comparer
  `|first-seed`, registres `bestFirst/bestLast/bestDist`).

## Second suspect (inchangé, après) : strobe WL `0x55` vs baseline `0xAA`

Baseline `src/ddr3_controller.v:476` : `8'b1010_1010` (démarre LOW, préambule
conforme). Nous : `8'b0101_0101` (démarre HIGH, préambule violé, fronts
décalés d'un demi-cycle = 1,25 ns). Le Micron pardonne, le silicium mange la
moitié de sa marge → écho marginal possible (`W=FC` une fois sur quatre).
Si le HW échoue encore après le fix première-fenêtre : aligner le strobe.

## Accélérer la simu (sinon chaque itération = ~30 min)

- En `isSimulation` uniquement, scan WL par pas de 4 (64 itérations).
- Réduire le moniteur `DBG` par pclk de `tb_spinal.v`.
- VCD seulement sur demande. Timeout déjà à 1800 (`sim_ddr.py`).

## Revalidation puis flash

Simu Micron (`W` attendu ~`0x19`, `8/8`) → `mill ddr3.test` → formel BMC300
→ rebuild PnR + flash → UART (`W=` doit quitter `FF`, puis `C=8`, `PASS`).
