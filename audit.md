# Audit DDR3 128-bit — SpinalHDL vs baseline nand2mario vs Micron

Date : 2026-10-02. Repo : `tang-primer-20k-ddr3-axi4` (WSL sur `/mnt/e/...`, exec obligatoire via PowerShell).
Objectif : contrôleur 128-bit BL8 pour IA. Stratégie validée : **plus simple d'abord** (1024Mb + `req/rsp` nu), puis 2048Mb/row14 + AXI128.

## 1. Contexte et commandes

- `README.md:41-60` : gen via `.\mill.bat -i ddr3.runMain ddr3.Ddr3Gen`, simu via `python simulation/sim_ddr.py --baseline --run` et `--spinal --run`. Logs : `simulation/tb_orig.log`, `simulation/tb_spinal.log`.
- WSL : tout `git`, `mill`, `python sim` passe par `powershell.exe -NoProfile -Command "..."`. Scripts `.bat/.ps1` autorisés si besoin. Commits locaux OK, **push interdit**.
- Références : `src/ddr3_controller.v` (baseline, `ROW_WIDTH=13`, `COL_WIDTH=10`), `simulation/ddr3_controller_sim.v` (copie SIM), `simulation/tb_controller.v`, `simulation/tb_spinal.v`, `simulation/prim_sim_tb.v` (modèle Gowin), `simulation/ddr3_vanilla.v` + `1024Mb_ddr3_parameters.vh` (+ `2048Mb_...` dispo).
- Spinal : `ddr3/src/ddr3/Ddr3ControllerCore.scala` (FSM), `GowinDdr3Phy.scala` (DLL/DQS/OSER/IDES/IOBUF), `Ddr3Controller.scala`, `Ddr3Gen.scala:7` (`Ddr3ControllerSim` = `rowWidth=14,isSimulation=true`), `hw/gen/Ddr3ControllerSim.v` (généré).

## 2. État des lieux (preuves logs)

- Init OK côté spinal : `tb_spinal.log:386` `[SPINAL-OK] W=1a P=2 S=0`. `wstep=0x1A=26` identique baseline `tb_orig.log:74,91`.
- Séquence init Micron OK : `Load Mode 2/3/1/0`, `ZQ long`, write-leveling `wstep 18->19->1a`, read-calib `sel 6->7->0 / pos 1->2`, `Precharge`, puis trafic.
- Writes spinal OK au niveau pins : ex `tb_spinal.log:413-424` `WRITE blk=0000100` -> Micron `WRITE @ DQS bank=0 row=0002 col=00000000..07 data=1111,2222...8888` dans l'ordre. Idem `blk=0000000/0000200/0001040`.
- Reads Micron OK côté DRAM : ex `tb_spinal.log:451-459` `READ @ DQS row=0002 data=1111...8888` correct. Mais côté contrôleur `tb_spinal.log:460` `DEBUG_READ [0]=4567 [1]=0123...` puis `got=01234567... expected=8888... MISMATCH`. Tous les autres reads : `tb_spinal.log:410,474,488,503,517,531,545` `got=xxxx... MISMATCH`. Total `tb_spinal.log:548` `8 ERRORS`.
- Baseline : `tb_orig.log:207,220,232,244` 4 reads OK (`dout=1234,5678,abcd,8765`), seules erreurs = `tZQinit violation` (`tick_counter=2` trop court, simu seulement, non fonctionnel).

Conclusion : **TX 128-bit BL8 prouvé, RX IDES/DQS non capturé (`xxxx` = FIFO vide).**

## 3. Comparatif baseline vs spinal (points exacts)

- FSM : mêmes états et formules (`RCD=6,CAS=6,CWL=5,SERDES=16,WLMRD=44`), `dqs_read` quand `READ||READ_CALIB && cycle==rclkpos+RCD/4+1` (`ddr3_controller.v:601-607` vs `Ddr3ControllerCore.scala:202-205`), `data_ready` à `(RCD+CAS+SERDES)/4+1`, `dqs_hold` en IDLE sur accept + en READ à `RCD/4` (voulu 2 cycles).
- `rburst_seen` : clear à l'émission du read de calib, set sur `rburst[0/1]`. Généré `hw/gen/Ddr3ControllerSim.v:3564-3569` (set) puis `:3739` (clear) — clear gagne comme baseline. OK a priori.
- Diff calib : `src/ddr3_controller.v:220-221` `WLEVEL_COUNT=2,RCALIB_COUNT=2` en SIM vs `Ddr3ControllerCore.scala:37-38` `wlevelCount=2,rcalibCount=1` en `isSimulation`. Baseline finit `(pos=1,sel=7)`, spinal `(pos=2,sel=0)` = cran suivant. Spinal rate `(1,7)` (`rburst=00`) là où baseline verrouille.
- Adressage : baseline `addr[25:0]` 13+10+3 ; spinal `addr[26:0]` 14+10+3, décodage `Ddr3ControllerCore.scala:374-376,390-391` et généré `hw/gen/Ddr3ControllerSim.v:3787-3788` (`BA<=addr[23:21],A<=addr[20:7],col={addr[6:0],000}`). Bits `[26:24]` ignorés. Cohérent write/read pour petits blocs mais incohérent modèle (`ROW 13` vs `rowWidth 14`, `A[13]` HW câblé `src/tang20k.cst:17`).
- BL : baseline write BC4 (`A[12]=0`), spinal write+read BL8 (`A[12]=1`, `A[10]=1` auto-precharge). Légal (MR0 OTF), logs Micron OK. `dm_out` spinal `Ddr3ControllerCore.scala:430-456` masque beats dummy (`dm[6]/dm[7]=1`) — à garder.
- Ordre `rsp` : spinal `Ddr3ControllerCore.scala:506-507` `{dq_in7..dq_in0}` = round-trip correct. Baseline `{dq_in0..dq_in7}` inversé mais inutilisé (16-bit `dout=dq_in[4]` en SIM). Ne pas « corriger » l'ordre spinal.
- PHY : `GowinDdr3Phy.scala` vs baseline identique (DLL `SCAL_EN true/CODESCAL 101`, DQS `X4/HWL false`, OSER DQ/DM `DQSW270`, DQS `DEFAULT`, OSER cmd/addr `D0=D0,D1=D0...`). Seule diff : `IOBUF` vs `assign tri-state` — modèle `prim_sim_tb.v:1306-1315` (`bufif0` avec `OEN=1`=Hi-Z) OK, writes le prouvent.
- TB : `tb_spinal.v:97-100` force `DLL LOCK/STEP`, horloges `tck=2500` identiques baseline, `dowrite/doread` avec `to_cnt=9` constant = latence contrôle OK.

## 4. Hypothèses classées

- **H1 (prioritaire) — mauvaise fenêtre `rclkpos/rclksel`** : `(2,0)` probablement alias 1 pclk tardif de `(1,7)`. Un seul hit suffit (`rcalibCount=1`) -> verrouillage fragile -> `dqs_read/RADDR` à côté -> `xxxx`, et 1 cas partiel avec 2 derniers beats seulement. Action : parité `rcalibCount=2`, instrumenter `WPOINT/RPOINT/rburst`, sweep manuel si besoin.
- **H2 (avéré) — `rowWidth` simu** : `14` vs modèle `1024Mb/13`. Non bloquant pour tests actuels mais à aligner en `13` pour valider l'infra (passer en `14/2048Mb` après).
- **H3 — détails BL8/DM/HOLD** : à auditer cycle-à-cycle mais logs prouvent le TX. Garder `BL8+AP`, `DM=0` sur 8 beats utiles.
- **H4 — IOBUF/DQS model** : peu probable (TX OK), lever par dump `HOLD/READ/RPOINT/WPOINT`.

## 5. Plan P0-P4 (décision : simple d'abord)

- **P0 instru** : `tb_spinal.v:172-175` étendre `DEBUG_READ` (`rclkpos/rclksel/WPOINT/RPOINT/rburst/hold/read`) + `$dumpfile/$dumpvars` comme `tb_controller.v:186-187`. Repro PowerShell : `powershell.exe -NoProfile -Command "python simulation/sim_ddr.py --spinal --run"` puis `grep -n "ERROR|MISMATCH|DEBUG_READ|WRITE blk|READ  blk|SPINAL-OK|Activate|Refresh" simulation/tb_spinal.log`.
- **P1 calib** : `Ddr3ControllerCore.scala:38` `rcalibCount 1->2` (parité baseline), `.\mill.bat -i ddr3.runMain ddr3.Ddr3Gen`, re-simu. Attendu : `P=1 S=7` et `dq_in` non-`xxxx`.
- **P2 read** : vérifier `dqs_hold/read`, `data_ready/busy`, `dm_out`, handshake `req_ready/refresh_due`.
- **P3 adressage** : passer simu en `rowWidth=13` (`Ddr3Gen.scala:7`, `Ddr3Config`, `tb_spinal.v`, `sim_ddr.py DEFINES`) face à `1024Mb`. Garder `MR OTF/RTT_WR/ODT=1`.
- **P4 validation** : `0 ERROR`, soak refresh (`refreshPeriod=200`), puis seulement : `row14/2048Mb` + `Ddr3Axi4` 128-bit pour IA.
- Git : `powershell.exe -NoProfile -Command "git status; git diff; git log --oneline -10"` avant chaque commit, commits locaux, pas de push.

## 6. Critères de succès

- `SPINAL SIM: ALL TESTS PASSED`, 8/8 reads `got==expected`, `dq_in` valides, `Refresh` sans corruption, pas de régression baseline.
