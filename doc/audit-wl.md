# Audit WL — état, commandes, suite (2026-10-03)

## 1. Commandes Windows (depuis `I:\tang-primer-20k-ddr3-axi4`, via powershell)

Tout passe par `powershell.exe` (binaires Windows). Un seul job `mill` à la fois.
Lancer détaché avec `Start-Process ... -RedirectStandardOutput <fichier>.log`,
tuer avec `taskkill /F /IM vvp.exe` (simu) ou `/IM java.exe` (mill, tue aussi le daemon).

```powershell
# Regen Verilog (après chaque modif RTL scala)
cmd /c 'mill.bat -i ddr3.runMain ddr3.Ddr3Gen > gen_wlmap.log 2>&1'

# Tests classiques (unitaires Verilator) — ~1 min
mill.bat -i ddr3.test
# Seulement le bruit WL :
mill.bat -i ddr3.test.testOnly ddr3.Ddr3WlNoiseTest

# Simu TB iverilog vs modèle Micron — ~10-25 min
C:\Python314\python.exe simulation\sim_ddr.py --spinal --run
# Rapide (sans VCD) — même verdict, log tb_spinal_fast.log :
C:\Python314\python.exe simulation\sim_ddr.py --spinal --no-vcd --run

# Formel sby BMC300 — ~13 min, verdict dans
# formal/Ddr3FormalBmc/Ddr3FormalTop_bmc/status (PASS)
mill.bat -i ddr3.test.runMain ddr3.Ddr3FormalProof
```

Verdicts attendus : unit `SUCCESS` (toutes suites), TB `ALL TESTS PASSED`
(lock `(0,0) rot=6 score=8`, `W=1a`), formel `PASS`, bruit `6/6`.

## 2. Bitstream : autre PC uniquement

Pas de Gowin sur ce PC (`C:\Gowin` absent, `GOWIN_HOME` vide) — `eda-flow.py`
ne peut tourner que sur l'autre PC :
```powershell
python eda-flow.py --preset ddr3 --flash none   # + flash, puis UART 115200
```
Lire sur UART : `[DDR3-OK] W=.. P=.. S=.. R=.. C=..`, `[WLMAP f=.. l=.. n=.. m=..]`,
`[FAIL] A=.. E=.. G=.. H=..`. Règle de sync : committer ici, pull là-bas
(ne plus porter des lignes à la main dans les deux sens).

## 3. Résumé des travaux

- Base saine : HEAD `def6f63` = `ALL TESTS PASSED` 8/8 en simu.
- Tentatives eye-search / milieu de fenêtre / strobes : TOUT a cassé la simu
  (6/8 ou 0) car la fenêtre d'écho (48 pas, modèle) ≠ l'œil write ; le bon
  point est au bord d'attaque. Leçon : un seul changement à la fois, simu juge.
- Retour à HEAD + instrumentation passive `[WLMAP]` (map 256 bits + f/l/n,
  zéro cycle changé) → le HW parle : `W=0A` isolé, puis `C=4`.
- Durcissement WL (tout validé vert unit/TB/formel) : vote majoritaire 2/4,
  2 matchs consécutifs, warmup (pas de lock < 8), `WL_LOCK_OFF`.
- Balayage HW de l'offset : `0`→C4, `-1`→C6 (meilleur), `+2`→C4, `-2`→C4,
  `+4`/`-3`→FF (flakes de routage probables, à retester).
- Harness bruit `Ddr3WlNoiseTest` (6 cas : clean/gauss/dropout/drift/remnant/
  combiné) : 6/6 verts — le WL tient face au physique modélisé.
- Chip : `H5TQ1G63EFR` (x16 1Gb, même famille que la baseline) ; pas de modèle
  Verilog Hynix public (tout le monde simule Micron). Comparatif timings en
  `doc/chip-timing-compare.md` : toutes les constantes WL ont 6-8× de marge,
  le problème n'est pas dans les chiffres mais dans l'échantillonnage
  (phase du routage) et l'analogique.

## 4. Le `-1` codé en dur : GARDER (pour l'instant)

`WL_LOCK_OFF = -1` n'est plus un nombre magique : c'est le meilleur point
**mesuré** (`C=6` stable sur HW vs `C=4` à 0, vert en simu/TB/formel). Le
retirer aujourd'hui = régresser (`C=4`) sans aucun bénéfice. Il partira quand
le bracketing auto mesurera le point à chaque boot — d'ici là, interdiction
de tuner à la main : que des mécanismes (vote, contraintes, bracketing).

## 5. Suite
1. Comitter les fichiers non suivis + sync autre PC.
2. **Bracketing auto de `C` en premier** : mesurer (write+read+sweep) sur des
   `W` candidats autour du verdict écho, garder le max — que de la machinerie
   prouvée, optimise l'objectif réel, insensible à la laideur de l'écho.
   Enterre `WL_LOCK_OFF`.
3. Double-front d'échantillonnage + `set_input_delay` d'encadrement (SDC) :
   seulement si le bracketing ne trouve pas d'œil (écho trop bruité même
   pour dégrossir).
4. Si `C` plafonne à 6 : instabilité `G≠H` (capture read), puis refresh auto.
