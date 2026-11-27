# tang-primer-20k-ddr3-axi4

High-performance open-source DDR3 memory controller & AXI4 bridge written in **SpinalHDL**, targeting the Gowin GW2A-18C FPGA on the **Sipeed Tang Primer 20K** development board. It directly harnesses Gowin's native hardware primitives (`OSER8_MEM`, `IDES8_MEM`, `DQS`, `DLL`).

This repository is designed to be **clean, pure open-source, and reproducible on Windows** with automated in-tree toolchain setup (Mill & OSS CAD Suite / Verilator).

---

## Current Status & Hardware Benchmarks (Tang Primer 20K)

Working and verified on physical **Tang Primer 20K** hardware (`pclk = 75.94 MHz`, DDR3 `ck = 303.75 MHz`, Open-Page + back-to-back streaming):

| AXI4 Width | Gowin Resources | STA (`pll_clkoutd` @ 75.942 MHz) | Sustained HW Throughput (16 KiB / 1 KiB bursts, refreshes incl.) |
|---|---|---|---|
| **64-bit** (default) | `LUT=4869`, `REG=2234`, `BSRAM=1` (`0` in controller/bridge) | `75.679 MHz`, `Hold TNS = 0.000` (`1` `-46 ps` engine path) | **~546–551 MB/s Write** (~91% of 64b AXI ceiling) / **~514–517 MB/s Read** (`1025` passes, `0` fails) |
| **128-bit** (`--128`) | `LUT=4498`, `REG=1956`, `BSRAM=5` | **`78.559 MHz`**, **`Setup TNS = 0.000`**, `Hold TNS = 0.000` | **~960 MB/s Write** (peak **~965 MB/s**) / **~794 MB/s Read** (peak **~804 MB/s**) (`1185` passes, `0` fails) |

- **SpinalSim / Verilator unit tests**: `Ddr3Axi4Test` (64b + 128b), `Ddr3ControllerCoreTest`, `Ddr3TesterTopTest` (64b + 128b) all pass.

---

## Features

- **SpinalHDL Open-Page Core**: Full JEDEC DDR3 initialization, automated ZQ long calibration (`ZQCL`), majority-voted Write Leveling, relative DLL/DQS Read Calibration with cross-cycle `IDES8` rotation alignment, autonomous `7.8 us` refreshes, and Open-Page back-to-back streaming (`tCCD = 1 pclk`).
- **Parametric 64-bit / 128-bit AXI4 Bridge**: Full AXI4 burst (`len 0..255`) bridge (`Ddr3Axi4`) ready for RISC-V SoCs, DMA engines, or hardware neural network accelerators (e.g. SpinalML).
- **Native Gowin Silicon Support**: Direct control of GW2A hardware DQS logic and DLL delay lines (`GowinDdr3Phy.scala`).
- **Autonomous Hardware Tester**: `Ddr3MemtestEngine` featuring real-time UART telemetry (`[BOOT]`, `[DDR3-OK]`, `[PASS]` with live cycle counters) at 115200 baud.

---

## Quickstart (Windows)

### 1. Prerequisites
- **Python 3**: for build/flash scripts (`python --version`).
- **Java** *(Optional)*: Mill automatically downloads and manages a JDK via Coursier on its first run.
- **Gowin EDA IDE**: `gw_sh.exe` and `openFPGALoader` / `programmer_cli.exe` for bitstream synthesis and board programming (`GOWIN_HOME`).

### 2. Automatic Toolchain Setup (In-Tree)
Simply run the setup batch script from the repository root:
```cmd
setup.bat
```
This automated script:
1. Downloads `mill.bat` (v1.1.8) directly to the repository root.
2. Downloads and unpacks `oss-cad-suite` (Verilator, Icarus Verilog, etc.) into `tools/oss-cad-suite/`.
3. Resolves required Windows runtime DLLs.

---

## Usage

### SpinalHDL Compilation, Verilog Generation & Unit Tests
Run through PowerShell or Windows Command Prompt (using `-i` for non-interactive mode):
```powershell
# Generate Verilog RTL in hw/gen/ (64-bit tester top by default)
.\mill.bat -i ddr3.runMain ddr3.Ddr3Gen

# Generate Verilog RTL with 128-bit Ddr3TesterTop
.\mill.bat -i ddr3.runMain ddr3.Ddr3Gen --128

# Run fast Scala / Verilator unit tests (64-bit & 128-bit)
.\mill.bat -i ddr3.test.testOnly ddr3.Ddr3ControllerCoreTest ddr3.Ddr3Axi4Test ddr3.Ddr3TesterTopTest
```

### Gowin Synthesis, Bitstream & Hardware Verification
Generate the complete FPGA bitstream headlessly and flash/monitor COM8 UART:
```powershell
python eda-flow.py --preset ddr3 --skip-compile
python fpga_run.py --timeout 12 --pass-target 0
```
If Gowin is installed in a non-default location, specify `GOWIN_HOME` before running `eda-flow.py`.
The ready-to-flash bitstream is produced at `build_eda/impl/pnr/Ddr3TesterTop.fs`.

---

### Legacy Icarus Verilog vs Micron Model (Optional — Vendor Files Required)
To keep this repository 100% open-source, third-party proprietary simulation files are **not included** in Git. If you wish to run the legacy Icarus Verilog pin-level testbenches in `simulation/`:

1. **Gowin Primitive Simulation Library (`prim_sim.v`)**:
   - Already installed locally with Gowin EDA IDE under:
     `<GOWIN_HOME>/IDE/simlib/gw2a/prim_sim.v`
     (e.g. `C:\Gowin\Gowin_V1.9.11.03_Education_x64\IDE\simlib\gw2a\prim_sim.v`)
   - `simulation/sim_ddr.py` automatically detects `prim_sim.v` via `GOWIN_HOME` (or standard `C:\Gowin\...` installs), or you can copy it locally as `simulation/prim_sim_tb.v` (gitignored).
2. **Micron DDR3 SDRAM Behavioral Model (`ddr3.v` + `*_parameters.vh`)**:
   - Download the **DDR3 SDRAM Verilog Model (v1.74)** for a 1024Mb x16 part (e.g. `MT41K64M16` / `MT41J64M16`) from Micron's official catalog:
     <https://www.micron.com/products/dram/ddr3-sdram> (select a DDR3 part -> *Tools / Simulation Models*).
   - Extract and place locally into `simulation/` (gitignored):
     - `ddr3.v` -> `simulation/ddr3_vanilla.v`
     - `1024Mb_ddr3_parameters.vh` -> `simulation/1024Mb_ddr3_parameters.vh`
     - `2048Mb_ddr3_parameters.vh` -> `simulation/2048Mb_ddr3_parameters.vh` *(optional)*

Then run via `simulation/sim_ddr.py`:
```powershell
python simulation/sim_ddr.py --baseline --run   # nand2mario baseline
python simulation/sim_ddr.py --spinal --run     # SpinalHDL Ddr3ControllerSim (~10 min)
```

---

## Repository Structure

```text
├── ddr3/                    # DRAM controller & AXI4 bridge in SpinalHDL (regen via Ddr3Gen)
│   ├── src/ddr3/            #   Ddr3ControllerCore.scala (FSM), GowinDdr3Phy.scala (DLL/DQS PHY),
│   │                        #   Ddr3Controller/Axi4/Bridge, Ddr3TesterTop, Ddr3MemtestEngine, UartTx
│   └── test/                #   unit tests (src/) + formal proofs (formal/)
├── hw/gen/                  # Generated Verilog (Ddr3TesterTop.v, Ddr3Axi4*.v, ...) — via mill
├── src/                     # nand2mario baseline (kept): ddr3_controller.v, top, PLL, constraints (.cst, .sdc)
├── simulation/              # Legacy iverilog driver & testbenches (sim_ddr.py, tb_fast.v, tb_spinal.v, ...)
│                            # Vendor Micron/Gowin sim files supplied locally (gitignored)
├── measure/                 # Legacy simulation sweep & VCD analysis scripts
├── archives/                # Ranged history, out of the active path
├── doc/                     # Design & bringup documentation
├── tools/                   # Local toolchains from setup.bat (oss-cad-suite, w64devkit) — gitignored
├── setup.bat                # Automated Windows setup script (downloads Mill & OSS CAD Suite)
├── build.mill               # Mill build configuration
├── eda-flow.py              # Headless Gowin synthesis & PnR script (preset ddr3)
└── fpga_run.py              # Tang Primer 20K SRAM/Flash programmer & COM UART monitor
```

---

## License & Attribution

- **SpinalHDL Implementation & Project Scripts**: Copyright (c) 2026 Léonard Adamo ([Juste-Leo2](https://github.com/Juste-Leo2)). Released under the **[MIT License](LICENSE)**.
- **Reference Verilog RTL, PLL Wrapper & Tang Primer 20K Constraints (`src/`)**: Adapted from [nand2mario/ddr3-tang-primer-20k](https://github.com/nand2mario/ddr3-tang-primer-20k), Copyright (c) 2022 nand2mario. Released under the **[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)**.
- **Optional External Simulation Models**: Micron DDR3 Verilog models (`ddr3.v`, `*_parameters.vh`) and Gowin `prim_sim.v` are **not distributed** in this repository and remain the property of their respective copyright holders.
