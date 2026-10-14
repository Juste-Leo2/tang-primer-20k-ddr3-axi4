# Observations boot HW — Tang Primer 20K, 14/10/2026 (bitstream preset `ddr3`)

Contexte : regen + unitaires 7/7 + formel BMC PASS + boucle T22L 6/6 +
tb_fast complet 5/23/25/40 PASS en sim. Premier boot carte.
DRAM = SK Hynix (famille Micron, docs Micron applicables — nand2mario
passe sur les deux modèles). Pas de scope. Baseline `main` : passait
bout-en-bout sur silicium avant (verdict relatif, enquête reportée).

## 1. Logs UART bruts

Boot-1 (après flash, < 1 s) :
```
[BOOT] DDR3 Core
[DDR3-OK] W=FF P=2 S=4 R=0 C=0          <- (variante P=0 S=1 au relaunch)
[WLMAP f=00 l=00 n=00 m=0000...0000     <- 64 nibbles zéro
[FAIL] A=00000000 E=0123456789ABCDEF G=7BFA4FEEFFFA19EE H=FFB7F63EFFFAF6EE
       (variante G=H=FFFAF6EEFFFAF6EE)
```

Boots suivants (bouton S0 = `sys_resetn`, T10 ; S1 non câblé) :
```
[BOOT] DDR3 Core
[CAL s=8 W=FF
[CAL s=8 W=FF        <- x4
[CAL s=5 W=FF        <- x13+
[CAL s=8 W=FF ...
```
Heartbeat à l'infini (60+ lignes ≈ 30 s+, user stoppe). Appui S0 long
vs bref : aucun changement. Jamais de `DDR3-OK` après boot-1.

LEDs : après flash (sans reset) led 2,3,4 allumées + led 1 éteinte ;
après S0 : **une seule LED** allumée.
(`led(0)=!pll_lock`, `led(1)=!init_done`, `led(2)=!wlevel_done`,
`led(3)=!rcalib_done`, `Ddr3TesterTop.scala:131-134`.)

## 2. Décodage (sourcé RTL)

- `[CAL s=X W=HH]` : **s = état** (`dbg_state := state.asBits`,
  `Ddr3ControllerCore.scala:1699`, enum `:74`), pas un score.
  s=5 = READ_CALIB, s=8 = WRITE. Imprimé toutes les ~500 ms
  (`Ddr3MemtestEngine.scala:227`).
- `W=FF` = **watchdog WL** (`:654-661`) : 512 verdicts = 2 tours
  complets des 256 taps, zéro lock → sentinelle + `wlevel_done` forcé,
  suite du flow sur taps bidon.
- `WLMAP` 64 zéros = 2e canal indépendant : **aucun tap n'a jamais
  matché** (ni marginal, ni sporadique). En sim : lock 0x19.
- `[DDR3-OK] ... C=0` : `C` = best_score (`Ddr3MemtestEngine.scala:263`).
  **Lock déclaré avec score nul** (aucune lecture valide du boot) = gap
  du flow (pas de garde), puis FAIL logique au memtest.
- `G=H` constants : les reads reviennent (protocole vivant : ACT/PRE,
  CMD/CK/ODT OK), mais faux (données constantes, WSTEP bidon).

## 3. Déductions fermes

1. **Écho WL structurellement absent sur HW** (zéro/512, pas un œil
   limite). Tout l'aval en découle (RCALIB sur 0xFF, FAIL). Cause #1.
2. **Le chemin fonctionnel vit** : boot-1 transige de bout en bout.
   Seule la boucle d'écho WL (DQS→DRAM→DQ en mode WL) est morte.
3. **Spin S0 ≠ lenteur** : tous les compteurs RTL sont bornés (survey
   40, sweep fenêtré, scan rangé, C ×2 max, WL 511). Des dizaines de
   secondes de heartbeat = machine **parquée** (`cycle` gelé si
   `!rst_lock_n`, `:531-532`, avec `rst_lock_n = resetn && dlllock`,
   `GowinDdr3Phy.scala:78`) ou **passes qui restartent** (`is(0)`
   reset `tries/bests` à chaque entrée non-`bistReturn`, `:726-768`).
4. **S0 ≠ cold boot** : au reset logiciel, PLL/DLL déjà lockées +
   DRAM warm, `porDone` déjà latché (`Ddr3TesterTop.scala:67-77`) →
   redémarrage immédiat sans délai POR, DLL re-resetée
   (`dll.io.RESET := !resetn`, `:67`) devant se re-locker.
   Le spin stable (insensible à la durée d'appui) écarte rebond et
   transitoires POR.
5. **Hynix ≈ Micron écarté** comme cause du zéro-total (nand2mario
   passe sur les deux ; un mismatch timings donnerait des matchs
   partiels, pas zéro). Reste une 2e différence sim/HW après les
   primitifs.
6. **Régression vs `main`** (passait bout-en-bout sur silicium) : le
   delta RTL depuis (vote majoritaire WL + warmup + watchdog + WLMAP,
   scan/sweep, branche C, mapping `when(wrAdv)`, arm `is(0)`) contient
   le coupable HW — à bissecter (enquête séparée, pas ici).

## 4. Hypothèses classées (écho WL mort)

- **H1 — DQS jamais drivé sur silicium** (polarité `dqs_oen` réelle vs
  modèle `prim_sim_tb`). Un seul bit inversé explique 512 zéros.
  Piste la plus rentable. Réf : `GowinDdr3Phy.scala:105-141`.
- **H2 — DRAM jamais entrée en WL** (MR1[7]) / ODT (RTT 60 Ω forcé,
  `:604-605`). Séquence identique sim/HW → moins probable seule.
- **H3 — fenêtre d'échantillonnage vs vol PCB : rejetée seule.** Le
  scan couvre 256 taps (6.4 ns) — un écho présent serait trouvé.
- **H4 — DLL non (re-)lockée** → `cycle` gelé. N'explique pas boot-1
  (terminé) mais candidate #1 pour le **spin S0**. Angle mort :
  aucune LED sur `dlllock` aujourd'hui.
- **H5 — jitter d'échantillonnage : rejetée** (zéro total, pas
  sporadique ; vote majoritaire déjà en place).

## 5. Gaps design relevés (à corriger, build séparé)

1. `DDR3-OK` avec `C=0` : gater `init_done` sur best > 0.
2. Pas de watchdog global RCALIB : ajouter diag UART
   (`tries`, `wlevel_tries`, `shiftCalDone`) + anti-spin infini.
3. Bypass WL debug (WSTEP manuel) : valide l'aval sans WL, isole
   l'écho comme unique coupable.
4. Exposer `dlllock` (LED ou heartbeat codé) : cœur du diagnostic
   spin S0.

## 6. Plan proposé

1. Bypass WL (1) → si lock 8/8 + memtest PASS sur carte : RCALIB,
   wshift et PHY validés, reste le seul fix WL (H1/H2).
2. Selon (1) : fix WL ciblé, revalidé par `WLMAP` non nul.
3. Gates + watchdogs (5.1, 5.2, 5.4).
4. Non-régression sim (unit + formel déjà verts sur ce bitstream).

## 7. Passage 66 MHz (décision debug timing) — 14/10/2026

Constat STA (bitstream `dev2`, `Ddr3TesterTop_tr_content.html`) :
**461 endpoints en violation setup sur `pll_clkoutd`** (pclk 99.56 MHz),
TNS −755.9 ns, Fmax réelle 75.7 MHz (logic level 14), hold 0.
Pires chemins (WNS −3.17 ns) : `trainLatch[*]` → `bestRot/bestCnt` et
`bestCnt` → `reqReg_wdata[*]/CE` = le cône score/comparaison 128 bits.
Le design tournait ~25 % trop vite pour son silicium (coin slow
0.95V/85C = cas warm) : froid OK, S0 KO, `main` aléatoire.

Décision : baisser pclk 99.56 → **66.375 MHz** (fclk 398.25 → 265.5,
ratio 4:1 conservé pour les OSER x4, tCK 3.77 ns = DDR3-533).
5 fichiers : `src/gowin_rpll/gowin_rpll.v` (`IDIV_SEL` 3→5),
`src/ddr3.sdc` (15.058/3.767 ns), `Ddr3ControllerCore.scala`
(`usec` 100→66 conditional sim, `refreshPeriod` 780→517 —
780 cycles @66 MHz = 11.75 µs > 7.8 µs requis),
`Ddr3MemtestEngine.scala` + `UartTx.scala` (`clkFreqHz` → 66375000).
Vérifié dans le Verilog stagé (517, 663750). PLL locke (LED1 éteinte).

Résultats : **spin S0 terminé** (6/6 boots complètent), **WL
déterministe au tap sim** (`W=18/19`, `f=19/1A`, sim = 0x19),
**STA 0 setup + 0 hold**. Le lock marginal au tap 10 d'avant était un
artefact d'échantillonnage du clock violé. RCALIB atteint `C=8`
(6/11 boots) mais memtest FAIL toujours.

Note placement : un build intermédiaire est retombé à `W=FF`×6 avec un
core inchangé (seuls les patterns engine avaient bougé) puis le rebuild
suivant a relocké. Le SDC n'a aucun délai d'entrée : le flop
d'échantillonnage WL est placé au hasard et le sweep (~6 ns) couvre une
fraction de la période (15 ns) → loterie par build. À traiter
(`max_delay` DQ, voire couverture plein-période).

## 8. Signature résiduelle + deux pistes (point de pause)

Signature (66 MHz, STA propre, WL locké) :
- `C=5-8` (dont `C=8` répétés en `P=2 S=0 R=0`), FAIL à `A=0` à chaque boot.
- `G`/`H` = **beat0/beat1 du même burst** (pas deux lectures) :
  beats répétés (`BA6776ABBA6776AB`, `G==H`), décalés de 32 bits
  (`H[63:32]=G[31:0]`), restes trainPat (`1000/1001/1005`) et garbage
  power-on — ni trainPat ni E-pattern.
- Déterministe par boot (5/6/11 identiques à lock égal), variable entre boots.
- Arriver à `C=8` prouve que le datapath assemble correctement :
  le calib lit le trainPat écrit par le BIST ; le fonctionnel (pattern
  dense `0123/FEDC` via AXI) échoue.

Exclus par l'enquête : bridge AXI (relu, sain), `len` (global =1),
WL (déterministe), refresh (517), timing (STA 0), framing (P1/formel).

- **Piste A — phase RPOINT calib vs fonctionnel.** Le survey ne re-pinne
  HOLD qu'en entrée de passe (free-run entre tries, `:718` vs `:773`),
  le fonctionnel pinne à chaque lecture (`:1407`, `:1424`).
  `bestRot` est locké à la phase du survey ; si la phase au `data_ready`
  fonctionnel diffère (comptes d'arêtes DQS silicium vs modèle),
  le derot applique la mauvaise rotation. En sim les deux coïncident
  par construction (d'où PASS sim / FAIL carte).
  Test : pin HOLD par try de survey (miroir du fonctionnel) → gate sim
  (`tb_fast` S25 8/8 + PASS) puis flash.
- **Piste B — SSO / densité du pattern.** trainPat (sparse, ~4 bits/beat)
  passe à 8/8 ; E-pattern (dense, tous les DQ commutent) casse.
  Le datapath digital est agnostique au contenu ; la sim est idéale (pas
  de SSO). Test : pattern single-phase sparse
  (`1000100010001000`/`0800080008000800`, préparé puis reverté) →
  Phase1 PASS ⇒ centrage d'œil d'écriture (sweep WSTEP scoré) ou réglage
  SI ; FAIL ⇒ bitstream d'instrumentation (dump `dq_in` brut sur FAIL).
