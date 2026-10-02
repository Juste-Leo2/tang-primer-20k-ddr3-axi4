# HANDOFF — reprise du debug DDR3 128-bit (contexte compacté)

Date : 03/10/2026. Repo : `E:\tang-primer-20k-ddr3-axi4` (`/mnt/e/tang-primer-20k-ddr3-axi4` sous WSL).
But : contrôleur DDR3 BL8 128-bit pour accélérateur IA. Docs de fond : `audit.md`,
`doc/bug-02-10-26-18h20.md`.

## 1. Règle d'environnement (CRITIQUE)

On travaille depuis WSL sur un repo Windows. **Tout ce qui touche à l'exécution
et à git passe OBLIGATOIREMENT par `powershell.exe`** (les binaires sont des `.exe`
Windows). Ne jamais lancer `mill`/`python sim`/`vvp`/`git` en natif Linux.
Commits locaux OK, **push INTERDIT** (l'utilisateur push lui-même).
Pas de `sleep` dans les commandes (l'utilisateur surveille et interrompt).

## 2. Commandes Windows via WSL (toutes testées)

Travail dans `/mnt/e/tang-primer-20k-ddr3-axi4`. Le wrapper `powershell.exe`
met souvent >60s à répondre : prévoir `timeout` large sur l'outil bash, et
lancer les longs jobs en détaché.

```bash
# Git (toujours via powershell)
powershell.exe -NoProfile -Command "git status --short"
powershell.exe -NoProfile -Command "git add <files>; git commit -m 'msg'; git log --oneline -5"

# Regen Verilog SpinalHDL (après tout edit Scala)
powershell.exe -NoProfile -Command ".\mill.bat -i ddr3.runMain ddr3.Ddr3Gen 2>&1 | Select-Object -Last 3"

# Compile scala seule / tests unitaires
powershell.exe -NoProfile -Command ".\mill.bat -i ddr3.test.compile 2>&1 | Select-Object -Last 6"

# Preuve formelle (template Ddr3FormalProof, Boolector, BMC300) en détaché
powershell.exe -NoProfile -Command "Start-Process -FilePath 'E:\tang-primer-20k-ddr3-axi4\mill.bat' -ArgumentList '-i ddr3.test.runMain ddr3.Ddr3FormalProof' -WorkingDirectory 'E:\tang-primer-20k-ddr3-axi4' -RedirectStandardOutput 'E:\tang-primer-20k-ddr3-axi4\formal_bmc300.log' -RedirectStandardError 'E:\tang-primer-20k-ddr3-axi4\formal_bmc300.err' -WindowStyle Hidden; echo RELAUNCHED"
# -> verdict : formal_bmc300.log + formal/Ddr3FormalBmc/Ddr3FormalTop_bmc/{status,logfile.txt,engine_0/trace.vcd}

# Build simu iverilog (sans run)
powershell.exe -NoProfile -Command "python simulation/sim_ddr.py --spinal 2>&1 | Select-Object -Last 3"
# -> BUILD rc = 0, produit simulation/tb_spinal.vvp

# Run simu en détaché (I/O très lent, ~15 min pour ~14 us sim-time)
powershell.exe -NoProfile -Command "Start-Process -FilePath 'E:\tang-primer-20k-ddr3-axi4\tools\oss-cad-suite\bin\vvp.exe' -ArgumentList 'E:\tang-primer-20k-ddr3-axi4\simulation\tb_spinal.vvp' -WorkingDirectory 'E:\tang-primer-20k-ddr3-axi4\simulation' -RedirectStandardOutput 'E:\tang-primer-20k-ddr3-axi4\simulation\tb_spinal.log' -WindowStyle Hidden; echo SIM_LAUNCHED"
# -> log : simulation/tb_spinal.log (gitignoré), VCD : simulation/tb_spinal.vcd (430 Mo !)

# Tuer des process bloqués
powershell.exe -NoProfile -Command "taskkill /F /IM vvp.exe"
powershell.exe -NoProfile -Command "taskkill /F /IM java.exe"   # tue aussi le daemon mill + job formel !
powershell.exe -NoProfile -Command "tasklist /FI 'IMAGENAME eq vvp.exe'"
# ATTENTION : un seul daemon mill -> un seul job mill à la fois. vvp/iverilog sont indépendants.
```

Fichiers ignorés (git) : `simulation/*.log,*.vvp,*.vcd`, `/formal/`, `formal_*.log/err`, `out/`.

## 3. Méthodo d'analyse des logs classiques (`simulation/tb_spinal.log`)

Filtres de base (bash, pas de `cat` sur gros fichiers) :

```bash
grep -n "SPINAL-OK\|SPINAL SIM\|RCALIB WARN\|RCALIB lock" simulation/tb_spinal.log
grep -n "READ  blk" simulation/tb_spinal.log
grep -n "DEBUG_READ" simulation/tb_spinal.log   # pos/sel/rburst/dqsrd/hold/wpt/rpt + dq_in[0..7]
grep -n "RCALIB chk" simulation/tb_spinal.log   # pos/sel/seen/score=X/8/best/tries par essai
grep -n "Read.*auto precharge 0" simulation/tb_spinal.log  # lectures de calib côté Micron
```

Lecture :
- `[SPINAL-OK] W=.. P=.. S=..` = fin calib (watchdog `force` si `RCALIB WARN` avant).
- `RCALIB chk` : `seen=3` (11b) = strobe vu ; `score=N/8` = beats valides vs motif
  `trainPat = 0x1000..0x1007` ; `match=x` = présence de `X` (partiel) ; `best` ne monte
  que si `seen==11 && score>best`.
- `DEBUG_READ` : `[0..7]` = `dq_in` (attention : `got=` = `{dq7..dq0}`) ; `wpt/rpt` =
  pointeurs FIFO (figés = suspect) ; comparer avec les lignes Micron `READ @ DQS`
  (données DRAM de référence, beats `data = ...`).
- Référence saine : `simulation/tb_orig.log` (baseline nand2mario, 0 mismatch
  fonctionnel, `dout = dq_in[4]`).

## 4. Méthodo VCD (`simulation/tb_spinal.vcd`, 430 Mo)

IDs VCD **changés à chaque build** : toujours re-`grep` le header d'abord.

```bash
grep -a -n " dqs_en \| DQSR90 \| DQSIN \| dqs_hold\| dqs_read \| WPOINT\| RPOINT\| cycle \| state " simulation/tb_spinal.vcd | head
```

Puis extraction python par fenêtre temporelle (ps ! `1 ns = 1000`, ex `t0=2290000`
pour 2290 ns). Formats : vecteurs `b101 ligne`, scalaires yosys `b0 id`/`b1 id`
(même 1 bit !), attention CRLF. DQSIN/DQSR90/dqs_en donnent la **fenêtre réelle**
(`dqs_en = DQSIN & enable`, cf. `prim_sim_tb.v:14101`).

Points durs déjà établis (ne pas les redécouvrir) :
- `prim_sim_tb.v:14090-14101` : `dqs_en` se ferme au 1er `negedge DQS` après `rd_en=0`.
- `prim_sim_tb.v:14189-14224` : `WPOINT` avance sur fronts `DQSR90` (DQS retardé
  de `DLLSTEP=25` soit 0.625 ns), reset par `HOLD`.
- `prim_sim_tb.v:13959-14065` : `READ` échantillonné sur `PCLK`, pipeline `rd_d0→rd_d1→
  rd_dq_x4` avec compteurs libres (`update0/1` 1/4) → chargement sensible à la phase ;
  `RCLKSEL[2]` ajoute 1 CK, `[0]/[1]` changent les horloges d'échantillonnage
  (pas de micro-pas 0.625 ns côté fenêtre !).
- `rstep_reg = DLLSTEP` constant (pas piloté par `RCLKSEL`).

## 5. Méthodo logs formels

- Verdict : `formal_bmc300.log` + `formal/.../status` (`PASS`/`FAIL`/`TIMEOUT`).
  `TIMEOUT 8 0` = wrapper `withTimeout` (pas un fail !). Dernier run : 300/300 steps
  passés, timeout à la finalisation → monter `withTimeout(1200)` si besoin d'un PASS propre.
- Échec : `logfile.txt` donne `Assert failed ... Ddr3FormalTop.sv:LINE` + step ;
  retrouver l'assert via le commentaire `// Ddr3ControllerCore.scala:Lxxx`, puis
  lire `engine_0/trace.vcd` (signaux `init_done_latched,wlevel_done,rcalib_done,
  state,busy`, parseur python ad hoc, timestamps ≠ steps).
- Pièges connus et résolus : `GenerationFlags.formal` gate les `report()` (sinon
  `assert(1'b0)`) ; `withSyncResetDefault` requis (yosys `prep/async2sync` rejette
  les `$check` multi-trigger en reset async) ; PATH doit inclure `oss/lib`
  (voir `build.mill` forkEnv) sinon `0xC0000135`.
- Les asserts P1-P14 sont dans `Ddr3ControllerCore.scala` sous
  `if (GenerationFlags.formal)` + `when(pastValidAfterReset())` (zéro impact RTL).

## 6. État actuel exact (03/10/2026)

Implémenté et commité ou en place :
- Training sur données (option 2) : écriture motif `0x1000-0x1007` en bloc 0 via
  l'état WRITE, sweep 41 essais avec **score /8 par réglage + best-of-sweep**
  (`Ddr3ControllerCore.scala`, `bestCnt/bestPos/bestSel`, gate `seen==11` anti-stale).
- `dqs_read` élargie à **2 cycles pclk** (`rdCyc`, `rdCyc+1`).
- Seed SIM : `(rclkpos,rclksel) = (0,0)` (HW inchangé à `(0,0)` déjà).
- Fix prouvés formellement : parking reset Hi-Z (P9), `init_done`+`rburst_seen`
  clear au reset + garde anti-reset sur le set (P5).
- Formel BMC300 : 300/300 steps sans violation (statut wrapper TIMEOUT, à passer à 1200).

**Dernier résultat simu (seed 0,0 + pulse 2 cycles) : AUCUN `seen` nulle part
(score=x partout, lock best (0,0)/0 par défaut, 8 mismatch).** L'impulsion 2-cycles
a même tué la détection qui marchait en 1-cycle (singles à (1,1),(2,0),(2,3)).
Pire : en 1-cycle/seed (1,0), verrou (1,1) avec beats 0,1 capturés (doublés) —
fenêtre ~2.5-5 ns (2-4 beats max), jamais 8. **Question ouverte n°1 : la fenêtre
`rd_en` du modèle peut-elle couvrir 10 ns ?** Mesurer `dqs_en` haut (montée/descente)
autour d'une lecture à (1,0) 1-cycle si besoin de trancher.

## 7. Mission pour l'IA suivante

1. Relire `Ddr3ControllerCore.scala` (surtout `dqs_read`, `READ_CALIB`, training),
   le Verilog généré `hw/gen/Ddr3ControllerSim.v` si doute, et `prim_sim_tb.v`
   §DQS (lignes ~13674-14300).
2. Trancher la question n°1 par mesure VCD (pas par théorie) : largeur/position
   de `dqs_en` vs rafale DQS à (1,0) 1-cycle.
3. Apporter LA correction qui donne `score=8` au sweep puis `8/8 READ OK` :
   pistes par probabilité : (a) revenir impulsion 1-cycle + seed (1,0) et chercher
   le réglage pleine-fenêtre via le survey (déjà instrumenté) ; (b) si la fenêtre
   modèle est intrinsèquement < 10 ns, double-lecture + recollement des moitiés ;
   (c) valider sur HW (memtest UART) que le silicium n'a pas ce plafond.
4. Ne committer que du validé (l'utilisateur commit/push lui-même) ; mettre à jour
   `doc/bug-02-10-26-18h20.md` et ce fichier.
