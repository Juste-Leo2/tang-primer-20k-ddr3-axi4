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
