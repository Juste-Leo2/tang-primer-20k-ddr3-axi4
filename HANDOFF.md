# HANDOFF — reprise du debug DDR3 128-bit (contexte compacté)

Date : 03/10/2026. Repo déplacé `E:\` → **`I:\tang-primer-20k-ddr3-axi4`**
(`/mnt/i/tang-primer-20k-ddr3-axi4` sous WSL). Adapter tous les chemins `E:` en `I:`.
But : contrôleur DDR3 BL8 128-bit pour accélérateur IA. Docs de fond : `audit.md`,
`doc/bug-02-10-26-18h20.md` (résolution bug 3 le 03/10).

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

# Run simu en détaché : TOUJOURS via sim_ddr.py (il met bin+lib au PATH,
# sinon vvp meurt sur "system.vpi introuvable" + "$display() not defined").
# Ne JAMAIS lancer vvp.exe brut en détaché (Start-Process n'hérite pas le PATH).
powershell.exe -NoProfile -Command "Start-Process -FilePath 'C:\Python314\python.exe' -ArgumentList 'simulation\sim_ddr.py --spinal --run' -WorkingDirectory 'I:\tang-primer-20k-ddr3-axi4' -RedirectStandardOutput 'I:\tang-primer-20k-ddr3-axi4\simulation\sim_launch.log' -RedirectStandardError 'I:\tang-primer-20k-ddr3-axi4\simulation\sim_launch.err' -WindowStyle Hidden; echo RELAUNCHED"
# -> log : simulation/tb_spinal.log (gitignoré), VCD : simulation/tb_spinal.vcd
# (586 Mo, cwd fixé dans sim_ddr.py run()). Machine rapide : ~10 min.
# ATTENTION bash : `$env` manglé (expansion bash) -> passer par cmd.exe /c 'set ...'
# ou éviter `$`. `tail` inexistant côté cmd. `ls | Select-String` lit le CONTENU
# des binaires -> Get-ChildItem -Name pour lister.

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

## 6. État actuel exact (03/10/2026 soir — SIMU 8/8 OK)

**`SPINAL SIM: ALL TESTS PASSED`, 8/8 `READ OK`, `lock (0,0) rot=6 score=8`.**
Committé : `calib: double-burst + rotation auto, score 8/8, 2/8 reads OK`.
En place depuis (non committé) : HOLD tardif reverté + `dqs_read` en WRITE.

- Double-burst (2 READ tCCD sans AP + PRE explicite, calib + fonctionnel),
  `dqs_read` 4 pclk (~40 ns), latch training au cycle `data_ready`,
  `HOLD` par itération, gate sur score seul (RBURST mort : `dqs_en` collé).
- Sweep score les **8 rotations** (`bestRot`, égalité → plus petit indice),
  `rsp` dé-rotaté. Rotation sim stable = 6 (pure, identique tous réglages).
- Fenêtre toujours ouverte : `dqs_read` aussi en WRITE → `dqs_en` ne retombe
  jamais après init → jamais de front parasite `0→X` (pré-armement `wpt_q`)
  → rotation stable calib→fonctionnel (avant : dérive rot 4→2 entre reads).
- Seed SIM/HW : `(0,0)` (sweep trouve 8 dès le 1er essai).
- Fix prouvés formellement (ancien RTL) : parking reset Hi-Z (P9),
  `init_done`+`rburst_seen` clear au reset + garde anti-reset (P5). P7/P14/P3
  MAJ (BL8 sans AP, 2e burst, dé-rotation). `withTimeout` 600→1200.
- Infra : `build.mill` oss-cad-suite ancré sur `moduleDir` (+ `setx`
  `OSS_CAD_SUITE_HOME` persistant) — fix `sby.exe not found` (`forkEnv` vide
  car `user.dir` du daemon ≠ repo). `sim_ddr.py` lance vvp avec
  `cwd=simulation/`. `.gitignore` couvre `simulation/*.err`.
- Formal BMC300 nouveau RTL : run en cours (timeout 1200, verdict attendu PASS
  propre). Dernier run (ancien RTL) : engine `passed`, wrapper TIMEOUT (bénin).

**`xxxx` restants dans les logs = normaux :** DRAM non-écrite avant le
training-write (modèle Micron retourne X) + sweep-1 pré-training. Zéro X en
fonctionnel. Seuls warnings Micron : `tWLH/tWLS` (bénins, présents en baseline).

## 7. Mission pour l'IA suivante

1. Vérifier le verdict formel (nouveau RTL) : `formal/.../status` PASS propre.
2. Valider sur HW (memtest UART) : la rotation silicium peut différer — le
   sweep auto s'adapte, lire le verrou UART (`pos/sel/rot/score`).
3. Ensuite seulement : `row14/2048Mb` + `Ddr3Axi4` 128-bit pour IA (cf. audit P4).
   Pistes d'économie : sweep-1 pré-training inutile (41 essais sur X) — écrire
   le training AVANT le sweep et ne faire qu'un passage.
4. Ne committer que du validé (l'utilisateur commit/push lui-même) ; mettre à jour
   `doc/bug-02-10-26-18h20.md` et ce fichier.
