# Milestone HW (26/11/2026) — DDR3 + AXI4 stable sur Tang Primer 20K & feuille de route `nextpnr` / IA locale

État consolidé au commit `611daef` (`fix(phy): align cmd/io reset release on FCLK #4 and pin reset FFs in cst`), après le premier passage complet sur silicium (`d6972f6`).

---

## 1. Progrès accomplis et validation matérielle

### Corrections décisives pour la reproductibilité silicium
- **`ddr3/src/ddr3/Ddr3Axi4Bridge.scala`** : enregistrement de `io.axi.r.valid` (`rValidReg`), `io.axi.r.payload.data` (`rOutData`) et `io.axi.r.payload.last` (`rLastReg`), éliminant les 15 violations de setup sur `pll_clkoutd`.
- **`ddr3/src/ddr3/GowinDdr3Phy.scala` & `src/tang20k.cst`** :
  - FF de reset I/O (`rst_dqs0`, `rst_dqs1`, `rst_dq0a`, `rst_dq0b`, `rst_dq1a`, `rst_dq1b`) déplacés sur `fclkFallDomain`.
  - FF de reset commande (`rst_cmd_a`, `rst_cmd_b`) déplacés sur `ckDomain` (`io.ck`, déphasé de 90°).
  - Verrouillage des 8 emplacements CLB via `INS_LOC` dans `src/tang20k.cst` (`R44C23..28`, `R43C27`, `R38C20`) pour garantir que les 58 primitives `OSER8`/`OSER8_MEM`/`IDES8_MEM`/`DQS` relâchent `RESET` exactement sur le même front `FCLK`.

### Résultats vérifiés (commit `611daef`)
- **Tests matériels sur Tang Primer 20K (`GW2A-LV18PG256C8/I7`)** — **5/5 boots/rebuilds consécutifs réussis** (`task-1271`, `task-1278` ×3, `task-1287`) :
  - `[WLMAP f=14 l=14 n=02]`
  - `[DDR3-OK] W=1A P=0 S=0 R=4 C=8` (`wrMode = 0` sur silicium)
  - `[LATCH] A=0 ... L=A303A202A101A000A707A606A505A404`
  - `fails=0` (540, 1184, 554, 903, 1184 passes observés)
- **Analyse de timing statique (STA Gowin, `build_eda/impl/pnr/Ddr3TesterTop.rpt.txt` & logs EDA)** :
  - `pll_clkoutd` (`pclk`, `75,9375 MHz`) : `Actual Fmax = 82,151 MHz`, `Setup TNS = 0.000`, `Hold TNS = 0.000`
  - `pll_clkout` (`fclk`, `303,75 MHz` / `607,5 MT/s`) : `Actual Fmax = 444,965 MHz`
- **Tests unitaires** : `.\mill.bat -i ddr3.test.testOnly ddr3.Ddr3Axi4Test` → `Tests: succeeded 1, failed 0` (`All tests passed.`).

### Ce qui distingue ce projet
- Contrôleur DDR3 **100 % open-source en SpinalHDL** (`Ddr3ControllerCore` + `GowinDdr3Phy`) avec **bridge AXI4** (`Ddr3Axi4Bridge`) et preuve formelle SymbiYosys.
- Fonctionne sur carte en **ratio 1:4 à 303,75 MHz** avec `DLL` / `DQS` / `OSER8_MEM` / `IDES8_MEM` **sans utiliser l'IP propriétaire Gowin (`Gowin_DDR3_Memory_Interface`)**, alors que la majorité des projets reposent soit sur l'IP fermée de Gowin, soit sur `nand2mario` (SystemVerilog sans AXI4), soit sur `LiteDRAM` (`GW2DDRPHY` 1:2, souvent `DLL-off` ≤ 125 MHz).

---

## 2. Ressources disponibles & débit BRAM ↔ DRAM

### Budget FPGA restant (`GW2A-18C`, `Ddr3TesterTop.rpt.txt` + `eda-flow.py`)
- **BSRAM (BRAM)** : `0 / 46` utilisées (**100 % libres** pour poids, activations et tampons DMA)
- **Logique (`LUT/ALU`)** : `4986 / 20736` (`25 %` — **~75 % libres**, incluant déjà le testeur memtest + UART)
- **Registres (`FF`)** : `1640 / 16173` (`11 %` — **~89 % libres**)
- **rPLL** : `1 / 4` utilisée (3 PLL libres) | **DLL** : `1 / 4` | **DQS** : `2 / 9`
- **Adressage DDR3** (`Ddr3ControllerCore.scala`) : `rowWidth=14`, `colWidth=10`, `bankWidth=3` (`addrWidth = 27`, soit **128 Mio** en puce 1 Gb et jusqu'à **256 Mio** en 2 Gb).

### Débits actuels (`pclk = 75,9375 MHz`, blocs de 16 octets, refresh = `17 / 592` cycles ≈ 2,8 %)
Le contrôleur actuel ouvre et referme la ligne (`ACTIVATE` + `PRECHARGE` / auto-precharge) à chaque transaction de 16 octets :

| Interface / Sens | Cycles `pclk` / 16 o | Débit brut | Débit net (avec refresh) |
| :--- | :--- | :--- | :--- |
| **Bus physique DDR3 x16 (`303,75 MHz` DDR)** | — | **1 215 Mo/s** (fil) | — |
| **Contrôleur natif `Ddr3Req` (128 bits) — Écriture (`wrMode=0`)** | **8 cycles** (`1 IDLE + 7 WRITE`) | **151,9 Mo/s** | **~147,5 Mo/s** |
| **Contrôleur natif `Ddr3Req` (128 bits) — Lecture** | **14 cycles** (`1 IDLE + 13 READ`) | **86,8 Mo/s** | **~84,3 Mo/s** |
| **Bridge AXI4 (`Ddr3Axi4Bridge`, 64 bits) — Lecture burst** | ~14–15 cycles | — | **~78–84 Mo/s** |
| **Bridge AXI4 (`Ddr3Axi4Bridge`, 64 bits) — Écriture** | ~10–13 cycles | — | **~90–115 Mo/s** |

> **Note d'évolution débit** : un mode *open-page* / bursts séquentiels (garder la row ouverte sur 128–512 octets sans toucher à la calibration PHY) permettrait d'approcher beaucoup plus près du plafond physique de 1 215 Mo/s si un futur accélérateur IA en a besoin.

---

## 3. État côté `nextpnr-himbaechel` / Project Apicula — briques manquantes

L'objectif à court terme est de contribuer à la chaîne 100 % open-source (**Yosys + `nextpnr-himbaechel` (`uarch/gowin`) + Project Apicula**) en utilisant ce design comme banc de référence vérifié sur silicium.

### Déjà supporté dans Apicula / `nextpnr-himbaechel`
- Logique générale (`LUT`, `FF`), `rPLL`, `IOBUF`
- `OSER8`, `OSER8_MEM`, `IDES8_MEM` (marqués supportés dans Apicula)
- Standard I/O `IO_TYPE=SSTL15` (mapping de base présent)

### Briques manquantes ou bloquantes pour compiler ce PHY sans Gowin EDA
1. **Primitive `DQS`** *(marquée "not yet supported" dans Apicula)* :
   - Gestion des strobes et horloges internes `DQSR90`, `DQSW0`, `DQSW270` vers `IDES8_MEM` / `OSER8_MEM`.
   - Pointeurs et calibration dynamique : `WPOINT`, `RPOINT`, `RLOADN`, `RMOVE`, `RDIR`, `WSTEP`, `RCLKSEL`, `READ`, `HOLD`, `RBURST`, `RVALID`.
2. **Primitive `DDRDLL` / `DLL` et routage dédié `DLL → DQS`** :
   - `DDRDLL` marqué "not yet supported" dans les tableaux de suivi Apicula.
   - Chemin dédié strict `DLL.STEP → DQS.DLLSTEP` sans logique fabric (règle `PR0015` sous Gowin EDA).
3. **Réseau d'horloges rapides `HCLK` & modèle timing DDR3** :
   - Routage complet des `HCLK` (`BANK4_BANK5_HCLK0`, `BANK6_BANK7_HCLK0`) et distribution vers les IOLOGIC à `303,75 MHz`.
   - Modélisation timing dans `nextpnr-himbaechel` pour tenir `fclk` et `pclk` sans skew destructeur.
4. **Compléments électriques I/O DDR3** :
   - Support complet de `SSTL15D` (paires différentielles `DDR3_CK` et `DDR3_DQS`).
   - Support de `VREF=INTERNAL` sur les banks 4 et 5 (`DDR3_DQ`).
5. **Placement contraint (`INS_LOC`) & skew de reset IOLOGIC** :
   - Support fiable de `INS_LOC` dans le parseur `.cst` de `nextpnr-himbaechel` pour figer les registres critiques (comme nos 8 FF de reset) et éviter tout décalage d'un cycle `FCLK` entre les 58 primitives.

---

## 4. Suite logique (feuille de route)

1. **Outillage open-source (`Apicula` / `nextpnr-himbaechel`)** :
   - Produire des variantes minimales / bitstreams `.fs` de référence sous Gowin EDA (`gw_sh`) pour isoler les fusibles de `DLL`, `DQS`, `HCLK`, `SSTL15D` et `VREF=INTERNAL`.
   - Ouvrir un issue/PR ou collaborer avec `YosysHQ/apicula` et `YosysHQ/nextpnr` en fournissant ce contrôleur comme test de validation matériel réel (verdict UART instantané sur Tang Primer 20K).
2. **IA locale sur Tang Primer 20K** :
   - Connecter un **DMA AXI4** (ou direct `Ddr3Req` 128 bits) pour streamer poids/activations quantifiés (INT8/INT4) entre la DDR3 et les **46 BSRAM libres** en double-buffering.
   - Déployer l'accélérateur de calcul sur les **~75 % de LUT libres**, avec évolution ultérieure possible du contrôleur vers un mode *open-page* si plus de bande passante devient nécessaire.
