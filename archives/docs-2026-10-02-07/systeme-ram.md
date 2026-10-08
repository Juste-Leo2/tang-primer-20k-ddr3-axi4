# Système DDR3 — fonctionnement actuel complet (04-10-26)

Document de référence : comment le contrôleur parle à la RAM, pourquoi le
`STEP` décide de tout, ce que fait la calibration en 3 passes + sweep K, et
les améliorations possibles (bracketing notamment).

Docs mesures : `capture-map-observations.md`, `dll-offset-K.md`,
`tb-cartographie.md`, `plan-capture-read-03-10-26.md`.

## 1. Vue d'ensemble — qui parle à qui

```mermaid
flowchart TD
    subgraph USER["Côté utilisateur"]
        AXI["Maître AXI<br/>Ddr3Axi4 (bridge 64-bit)"]
        TT["Ddr3TesterTop<br/>memtest + UART"]
    end
    subgraph CORE["Ddr3ControllerCore (SpinalHDL)"]
        FSM["FSM : RST_WAIT → CKE → CONFIG → ZQCL → WL → READ_CALIB → IDLE → READ/WRITE → REFRESH"]
        CAL["Calibration :<br/>write leveling + survey (pos,sel,rot) + sweep offset DLL"]
        SCORE["Score : compare 128 bits<br/>vs motif, 8 rotations"]
    end
    subgraph PHY["GowinDdr3Phy"]
        DLLB["DLL : aligne DQS sur FCLK<br/>sort STEP (tap 25 ps)"]
        DQSX["2× DQS (mode X4)<br/>délais + FIFO IDES 8 slots"]
        SER["OSER8_MEM / IDES8_MEM<br/>sérialiseurs"]
    end
    subgraph MEM["Dehors"]
        DRAM["DDR3 H5TQ1G63EFR<br/>BL8, 8 beats par lecture"]
    end
    AXI --> FSM
    TT --> FSM
    FSM --> CAL
    CAL --> SCORE
    FSM --> PHY
    DLLB --> DQSX
    DQSX --> SER
    PHY <--> MEM
```

Chemins de données : écriture = `dq_out/dqs_out` via OSER ; lecture =
`dq_in` (8×16 bits = 128 bits) via IDES, dé-rotatés par `bestRot`.

## 2. Le boot, étape par étape

```mermaid
flowchart TD
    A["RST_WAIT / CKE_WAIT<br/>power-on, resetn_delay"] --> B["CONFIG<br/>MRS MR2 MR3 MR1 MR0"]
    B --> C["ZQCL<br/>calibration ZQ (tZQinit)"]
    C --> D["WRITE_LEVELING<br/>balayage d'écho DQS sur DQ<br/>lock W = 0x19 (sim) / 0x0A (HW)<br/>puis W += WL_LOCK_OFF (-1)"]
    D --> E["READ_CALIB passe-1<br/>41 itérations, tout à X<br/>(DRAM vide : armement, pas mesure)"]
    E --> F["Training write bloc 0 (trainPat)<br/>+ poison write bloc 1 (~trainPat)"]
    F --> G["READ_CALIB passe-2<br/>survey 32 réglages sur données réelles<br/>trouve (pos, sel, rot) provisoires"]
    G --> H["Sweep offset DLL<br/>1024 paires (pos, offset), early-exit à 8<br/>trouve l'offset K (fenêtre STEP)"]
    H --> I["READ_CALIB passe-3<br/>re-survey sous l'offset gagnant<br/>verrouille (pos, sel, rot) + off"]
    I --> J["IDLE → fonctionnel<br/>memtest AXI 8 blocs + refresh autonome<br/>(sim : toutes les 2 µs, HW : 7,8 µs)"]
```

`WL_LOCK_OFF = -1` : ajustement empirique du tap d'écriture après le lock
d'écho. Côté **écriture uniquement** — les expériences montrent qu'il
n'influence pas la capture read (`STEP=25 + WSTEP=40` donne 8/8).

## 3. La chaîne de capture read (le cœur du sujet)

```mermaid
flowchart LR
    subgraph DRV["DRAM"]
        BL8["BL8 = 8 beats<br/>2 READ même adresse = 16 fronts DQS"]
    end
    subgraph PRM["Primitive DQS (X4)"]
        DDQS["DQSR90 = DQS retardé de STEP_eff taps<br/>STEP_eff = (STEP + off) mod 256"]
        CLKRD["clk_rd = DQSW0 ou DQSW90<br/>(rclksel[0] choisit, WSTEP ou STEP)"]
        FIFO["FIFO IDES 8 slots<br/>WPOINT (gray) avance sur fronts DQS<br/>RPOINT tourne libre sur FCLK"]
    end
    subgraph LGC["Notre logique"]
        WIN["Fenêtre dqs_read = 4 pclk (~40 ns)<br/>ouverte à rdCyc = pos + RCD/4 + 1"]
        LAT["Latch à RCD/4+10<br/>trainLatch = 8× dq_in"]
        ROT["Essai des 8 rotations<br/>sweepRot/sweepScore"]
        CMP["Compare vs trainPat<br/>score 0..8 = C"]
    end
    BL8 --> DDQS
    DDQS --> FIFO
    CLKRD --> FIFO
    FIFO --> WIN
    WIN --> LAT
    LAT --> ROT
    ROT --> CMP
```

Points clés :
- **Un seul burst BL8 ne remplit que ~5 slots sur 8** (préambule + 4
  périodes). Le 2e burst dos-à-dos (tCCD = 1 pclk) remplit les slots gray
  complémentaires → un sample après le burst 2 voit 8 beats frais.
- **La ligne reste ouverte** pendant tout un survey/sweep (ACT en entrée de
  passe, PRECHARGE en sortie vers IDLE). Le refresh autonome ne part que
  depuis IDLE — d'où le PRECHARGE obligatoire à chaque sortie.
- **Scores quantifiés pairs (8/6/4/X)** : le compteur gray `WPOINT` saute
  parfois 2 slots par front. Pas du bruit : lisser ne servirait à rien.
- **`rclkpos` = pas de 10 ns** (ouverture de fenêtre), **`rclksel` = mux de
  routage** (8 combinaisons). Grille grossière : 4 fenêtres × 8 routages.
  Le grain fin (25 ps) vient uniquement de l'offset DLL.

## 4. L'histoire du STEP (résumé des mesures)

- Le DLL aligne le DQS sur `FCLK` et sort `STEP`. En simu le TB le force
  (`STEP=25`, raccourci des 33600 cycles de lock) ; sur HW c'est le vrai
  DLL, qui dérive (température/tension).
- Carte `STEP × phase` : phase pclk/FCLK **totalement neutre** ; seul STEP
  compte, fenêtre de **2 taps** : `{25, 26}` → 8, tout le reste → 6/4/2/0.
  Le meilleur `pos` glisse avec STEP (0 quand aligné, 2 sinon).
- Hypothèses réfutées par l'expérience : `WSTEP == STEP` (40/40 → 6,
  25/40 → 8), `sel[0]=1` invariant (aucun `sel` n'atteint 8 hors fenêtre).
- Lecture retenue : le DLL aligne, mais le FIFO veut une **marge** — un
  terme constant que seul notre offset peut ajouter. L'offset est balayé
  (jamais codé en dur, il doit suivre la dérive) : 4 `pos` × 256 offsets =
  1024 paires, early-exit à 8/8, puis passe-3 de confirmation.
- Le `C=8` historique du TB était une coïncidence (STEP forcé 25 =
  WSTEP locké 0x19 par hasard) ; le `C=6` HW = la même carte, loin de la
  fenêtre. Le sweep K rend le design auto-adaptatif au silicium réel.

## 5. Améliorations possibles (pistes, pas de décision)

```mermaid
flowchart TD
    K["K validé (sweep offset DLL)"] --> B1["Bracketing WL (côté écriture)<br/>sweep autour du lock WSTEP<br/>miroir de K, branche parkée<br/>+ re-fit WL_LOCK_OFF sur C fiable"]
    K --> B2["Re-calib périodique<br/>si le DLL dérive post-boot<br/>déclenchée sur signature d'erreur<br/>(RBURST/RVALID), pas en continu"]
    K --> B3["Coût sim du sweep<br/>pire cas ~1000 itérations (~2 h)<br/>piste : coarse-to-fine (pas de 8 + raffinement)<br/>HW : ~150 µs, rien à optimiser côté puce"]
    K --> B4["Survey 41 itérations<br/>32 réglages + 9 de marge/re-mesure<br/>voir verdict dédié (hors doc)"]
    K --> B5["Formel ciblé<br/>BMC300 ne couvre pas 1024 itérations<br/>propriétés locales : wrap mod-256,<br/>bornes, pas de double-ACT"]
    K --> B6["Parké (hors périmètre)<br/>SDC, double-front, refresh auto avancé,<br/>modèle de capture Scala"]
```

- **Bracketing** : le trafic supplémentaire perturbait la mesure quand `C`
  n'était pas fiable. Avec K, chaque mesure est en lecture seule
  (pas de réécriture entre itérations) → le bracketing redevient
  envisageable côté écriture, là où K ne touche pas.
- Le sweep actuel fige `rclksel` au `bestSel` de la passe-2 (la passe-3
  re-trouve `sel/rot` sous l'offset gagnant) : un balayage 3D complet
  (8192 itérations) n'est pas nécessaire vu l'insensibilité de `sel`
  dans la fenêtre.
- Fichiers de référence : `Ddr3ControllerCore.scala` (FSM, calibration),
  `GowinDdr3Phy.scala` (`DLLSTEP := dllstep + off`), `Ddr3Controller.scala`
  (plumbing), `simulation/tb_fast.v` (`+step/+phase/+wl/+k`),
  `simulation/map_capture.py` (carte parallèle).
