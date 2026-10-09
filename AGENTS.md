# AGENTS.md — règles d'environnement WSL (lire en premier)

Repo Windows manipulé depuis WSL (`/mnt/i/tang-primer-20k-ddr3-axi4` ↔
`I:\tang-primer-20k-ddr3-axi4`). Les binaires sont des `.exe` Windows.

## 1. Natif vs powershell

- **Natif OK (rapide, préféré)** : lecture/édition/création de fichiers,
  `glob`, `grep`, `git diff`-style inspection via outils natifs.
- **OBLIGATOIRE via `powershell.exe -NoProfile -Command "..."`** : toute
  **exécution** (`mill`, `python sim_ddr.py` / `measure/*`, `vvp`, `git`,
  `taskkill`, `tasklist`). Ne jamais lancer ces binaires en natif Linux.
- Écrire les commandes powershell **sans `$`** quand on passe par bash
  (expansion bash : `$env` manglé) — passer par `cmd.exe /c 'set ...'` si
  besoin d'env, ou éviter `$` (ex : `git status --short`, pas de
  `Select-Object` avec `$_.`).
- Le wrapper `powershell.exe` met souvent >60 s à répondre : prévoir un
  `timeout` large, lancer les longs jobs en **détaché** (`Start-Process`
  + redirection vers `.log`), jamais de `sleep` dans les commandes
  (l'utilisateur surveille et interrompt).
- Commits locaux OK, **push INTERDIT** (l'utilisateur push lui-même).

## 2. Arborescence (après refactoring 10/2026)

- `ddr3/src/ddr3/` : RTL SpinalHDL (ne pas toucher sans regen).
  `ddr3/test/` : tests unitaires + formel. `hw/gen/` : Verilog généré.
- `src/` : baseline nand2mario **gardée** (`ddr3_controller.v`,
  contraintes, PLL) + top. `simulation/` : driver `sim_ddr.py`, TBs
  (`tb_fast.v` = actif, `tb_spinal.v`, `tb_controller.v` = baseline),
  modèles Micron + `prim_sim_tb.v`. Rien d'autre.
- `measure/` : batteries/analyses actives (`mag_battery.py`,
  `map_capture.py`, `analyze_window.py`, `analyze_vcd*.py`), logs lus dans
  `simulation/`. Voir `measure/README.md`.
- `archives/` : historique rangé (`sim-scripts/`, `sim-legacy/`,
  `docs-2026-10-02-07/`), hors chemin actif, historique git conservé.
- `doc/` : `design.md` + `STATUS_AND_NEXT.md` (état + suite). Le reste est
  archivé. `eda-flow.py` : flow Gowin conservé tel quel (preset `ddr3`).

## 3. Commandes validées (depuis la racine, via powershell)

```powershell
git status --short
.\mill.bat -i ddr3.runMain ddr3.Ddr3Gen        # regen Verilog après tout edit Scala
.\mill.bat -i ddr3.test                        # unitaires (~1 min)
.\mill.bat -i ddr3.test.runMain ddr3.Ddr3FormalProof   # formel BMC (~30 min)
python simulation/sim_ddr.py --fast-tb --map-only   # build MAP_ONLY
python simulation/sim_ddr.py --fast-tb --map-only --run   # contrôle S25 (défauts step=25)
python simulation/sim_ddr.py --spinal --run    # simu complète (~10 min)
python measure/mag_battery.py --steps 23,25 --mag0 0 --magn 10 --jobs 2
taskkill /F /IM vvp.exe                        # tuer simu bloquée
taskkill /F /IM java.exe                       # tue aussi le daemon mill !
```

Batterie anti-régression (ordre, 08/10/2026) : regen → unitaires →
formel + TB S25 **en fond en parallèle** (mill et vvp indépendants).
Verdicts : regen `SUCCESS`, unit `All tests passed`, build TB `BUILD rc = 0`
(dans `tb_launch.log`, avant le run), formel `formal/.../status` PASS,
TB `simulation/tb_fast_s25_p0_w-1_k0.log` (`WINDOW` 8 / `RESULT` PASS réel).

Jobs détachés (`Start-Process`, jamais de `sleep`) :
```powershell
Start-Process -FilePath 'I:\tang-primer-20k-ddr3-axi4\mill.bat' -ArgumentList '-i','ddr3.test.runMain','ddr3.Ddr3FormalProof' -WorkingDirectory 'I:\tang-primer-20k-ddr3-axi4' -RedirectStandardOutput 'I:\tang-primer-20k-ddr3-axi4\formal_bmc300.log' -RedirectStandardError 'I:\tang-primer-20k-ddr3-axi4\formal_bmc300.err' -WindowStyle Hidden
Start-Process -FilePath 'cmd.exe' -ArgumentList '/c','python simulation\sim_ddr.py --fast-tb --map-only --run > simulation\tb_launch.log 2>&1' -WorkingDirectory 'I:\tang-primer-20k-ddr3-axi4' -WindowStyle Hidden
```

- Un seul daemon mill → un seul job mill à la fois (`vvp` indépendant).
- `sim_ddr.py` met `bin+lib` au PATH : **toujours** lancer via lui, jamais
  `vvp.exe` brut en détaché (`Start-Process` n'hérite pas le PATH).
  Exit code = `BUILD rc` puis run rc (nonzéro = échec ; 124 = timeout).
- `measure/*_battery.py`, `map_capture.py` : points manquants → `?`, jamais
  de crash (batteries interrompues restent lisibles).
- `cwd` des runs = `simulation/` (fixé dans `sim_ddr.py`).

## 4. Pièges déjà payés (ne pas redécouvrir)

- `prim_sim_tb.v` : `dqs_en` se ferme au 1er `negedge DQS` après `rd_en=0` ;
  `WPOINT` avance sur fronts `DQSR90` (DLLSTEP=25 = 0.625 ns), reset par
  `HOLD` ; `READ` échantillonné sur `PCLK` (pipeline sensible à la phase) ;
  `RCLKSEL[2]` +1 CK, `[0]/[1]` changent les horloges (pas de micro-pas).
- Le DQS ne compte que les **fronts descendants** de `RMOVE`/`WMOVE`
  (`prim_sim_tb.v:14194`) : N slots consécutifs à 1 = UN seul pas. Toujours
  un slot de gap entre deux pulses (`navigateLeft` compte des slots, pulse
  sur comptes impairs).
- Jamais plusieurs `iverilog -o` concurrents vers le même `.vvp` (binaire
  corrompu → `Assertion failed: use_island, vvp_island.cc:309` au load,
  avant même la ligne MAP ; 09/10 : 3 rebuilds parallèles). Un seul build,
  puis runs `vvp` parallèles — ou `sim_ddr.py --run` en séquentiel (`&&`,
  rebuilds sérialisés OK : un `vvp` déjà chargé garde son image).
- IDs VCD changent à chaque build → toujours re-`grep` le header d'abord.
- `RPOINT` en roue libre : jamais de comparaison absolue.
- En MAP_ONLY, `RESULT ... PASS` est vacueux : lire `WINDOW`/`maxsw`.
- `win*.log` en UTF-16 (convertir avant grep) ; `$dumpfile` relatif au CWD.
- `ls | Select-String` lit le contenu des binaires → `Get-ChildItem -Name`.
- `tail` inexistant côté cmd ; formel : `GenerationFlags.formal` gate les
  `report()`, `withSyncResetDefault` requis, PATH doit inclure `oss/lib`.
