# tang-primer-20k-ddr3-axi4

High-performance DDR3 memory controller written in **SpinalHDL** targeting the Gowin GW2A-18C FPGA on the **Sipeed Tang Primer 20K** development board. It directly harnesses Gowin's native hardware primitives (`OSER8_MEM`, `IDES8_MEM`, `DQS`, `DLL`).

This repository is designed to be **100% self-contained and reproducible on Windows** with automated in-tree toolchain setup (Mill & OSS CAD Suite).

---

## Status (October 2026)

**The controller does not work yet**: read calibration locks a false 6/8
(C=6) both in simulation and on silicon. TX path (128-bit BL8 writes) is
proven at the pins against the Micron model; the RX capture window is the
open issue. Current state and next debug steps: `doc/STATUS_AND_NEXT.md`.
Environment rules for WSL contributors: `AGENTS.md`.

What is green: Verilog regen, Scala/Verilator unit tests (7/7), formal BMC
proofs, S25 control run in simulation.

---

## Features

- **SpinalHDL Core Architecture**: Comprehensive state machine implementing full JEDEC DDR3 initialization, automated ZQ long calibration (ZQCL), Write Leveling, Read Calibration, and autonomous background refreshes.
- **AXI4 Bus & BL8 Bursts**: 128-bit burst interface optimized for high-throughput memory transfers, DMA, RISC-V SoCs, and hardware neural network accelerators.
- **Native Gowin Silicon Support**: Direct control of GW2A hardware DQS logic and DLL-based delay lines running up to DDR3-800 speeds.
- **Built-in Self-Test Engine**: Autonomous `Ddr3MemtestEngine` featuring real-time UART telemetry reporting at 115200 bauds.
- **Self-Contained Verification Suite**: Full Icarus Verilog testbenches verified against the official Micron DRAM model (`ddr3.v` with exact 1024Mb parameters included).

---

## Quickstart (Windows)

### 1. Prerequisites
- **Python 3**: for running simulation drivers and the EDA flow (`python --version`).
- **Java** *(Optional)*: If not already installed, Mill will automatically download and manage a JDK via Coursier on its first run.
- **Gowin IDE** *(Optional for simulation, required for bitstream synthesis)*: `gw_sh.exe` and `programmer_cli.exe`.

### 2. Automatic Toolchain Setup (In-Tree)
Simply run the setup batch script from the repository root:
```cmd
setup.bat
```
This automated script:
1. Downloads `mill.bat` (v1.1.8) directly to the repository root.
2. Downloads and unpacks `oss-cad-suite` (Icarus Verilog, Verilator, etc.) into `tools/oss-cad-suite/`.
3. Resolves required Windows runtime DLLs (`libreadline8.dll` and `libtermcap-0.dll` copied into `bin/`).

---

## Usage

### SpinalHDL Compilation & Verilog Generation
Run through PowerShell or Windows Command Prompt (using `-i` for non-interactive mode):
```powershell
# Generate Verilog RTL in hw/gen/
.\mill.bat -i ddr3.runMain ddr3.Ddr3Gen

# Run Scala / Verilator unit tests
.\mill.bat -i ddr3.test
```

### RTL Simulation (Icarus Verilog vs Micron DRAM Model)
All vendor parameter files (`1024Mb_ddr3_parameters.vh`) and primitives are self-contained in `simulation/`:

```powershell
# Run the original nand2mario golden baseline simulation
python simulation/sim_ddr.py --baseline --run

# Run the SpinalHDL controller simulation
python simulation/sim_ddr.py --spinal --run
```
Outputs are streamed to the console and logged to `simulation/tb_orig.log` and `simulation/tb_spinal.log`.

### Gowin Synthesis & Bitstream Generation
Generate the complete FPGA bitstream headlessly without opening the Gowin GUI:
```powershell
python eda-flow.py --preset ddr3
```
If Gowin is installed in a non-default location, specify `GOWIN_HOME`:
```powershell
$env:GOWIN_HOME = "C:\Gowin\Gowin_V1.9.11.03_Education_x64"
python eda-flow.py --preset ddr3
```
The ready-to-flash bitstream will be produced at `build_eda/impl/pnr/Ddr3TesterTop.fs`.

---

## Repository Structure

```text
├── ddr3/                    # DRAM controller RTL in SpinalHDL (do not edit without regen)
│   ├── src/ddr3/            #   Ddr3ControllerCore.scala (FSM), GowinDdr3Phy.scala (DLL/DQS PHY),
│   │                        #   Ddr3Controller/Axi4/Bridge, Ddr3TesterTop, Ddr3MemtestEngine, UartTx
│   └── test/                #   unit tests (src/) + formal proofs (formal/)
├── hw/gen/                  # Generated Verilog (Ddr3TesterTop.v, Ddr3ControllerSim.v, ...) — via mill
├── src/                     # nand2mario baseline (kept): ddr3_controller.v, top, PLL, constraints (.cst, .sdc)
├── simulation/               # sim_ddr.py driver, TBs (tb_fast.v active, tb_spinal.v, tb_controller.v),
│                            # Micron models (ddr3_vanilla.v, *parameters.vh), Gowin prim model
├── measure/                 # Active measurement batteries & analyses (mag_battery.py, map_capture.py, ...)
├── archives/                # Ranged history, out of the active path (old scripts, legacy sim, 2026-10-02-07 docs)
├── doc/                     # design.md + STATUS_AND_NEXT.md (current state & next steps)
├── tools/                   # Local toolchains from setup.bat (oss-cad-suite, w64devkit) — gitignored
├── AGENTS.md                # WSL/powershell environment rules (read first when working via WSL)
├── setup.bat                # Automated Windows setup script (downloads Mill & OSS CAD Suite)
├── build.mill               # Mill build configuration (auto-detects local toolchain)
└── eda-flow.py              # Automated headless Gowin synthesis script (preset ddr3)
```

---

## License & Attribution

This repository combines multiple works with their respective open-source licenses:

- **SpinalHDL Implementation & Project Scripts**: Copyright (c) 2026 Léonard Adamo ([Juste-Leo2](https://github.com/Juste-Leo2)). Released under the **[MIT License](LICENSE)**.
- **Reference Verilog RTL & Tang Primer 20K Constraints (`src/`)**: Copyright (c) 2022 [nand2mario](https://github.com/nand2mario/ddr3-tang-primer-20k). Released under the **[Apache License 2.0](https://www.apache.org/licenses/LICENSE-2.0)**.
- **Micron DRAM Simulation Model (`simulation/ddr3_vanilla.v`, `*parameters.vh`)**: Copyright (c) Micron Technology, Inc. Subject to Micron's simulation model terms and conditions.
- **Gowin Primitives Behavioral Simulation (`simulation/prim_sim_tb.v`)**: Copyright (c) Gowin Semiconductor Corp.
