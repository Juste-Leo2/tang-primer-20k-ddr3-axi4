# DDR3 + AXI4 Hardware Benchmarks (`Tang Primer 20K`)

All hardware numbers below were measured directly on a physical **Sipeed Tang Primer 20K** (`GW2A-LV18PG256C8/I7`) running at `pclk = 75.94 MHz` and `DDR3 CK = 303.75 MHz` (`607.5 MT/s`, single-direction 64-bit AXI4 ceiling = `607.5 MB/s`, full-duplex AXI4 `W + R` / native 128-bit DDR3 ceiling = `1215 MB/s`).

## Integration Constraints & Multi-Outstanding Arbiter Behavior

- **AXI4 burst types:** supports `INCR` and `FIXED` bursts (does **not** support `WRAP`).
- **`AxSIZE`:** expects `AxSIZE` matching the configured bus width (`32`, `64`, or `128` bits); use `WSTRB` for partial / sub-word writes.
- **Level-1 Multi-Outstanding (`Ddr3Config.maxOutstanding`, default `8`, supported `2 / 4 / 8 / 16`):**
  - Accepts up to `maxOutstanding` pending `AR`/`AW` requests (`+` pipelined `W`) into a unified chronological `cmdQueue` before stalling the master.
  - Preserves strict global chronological ordering across `AW` and `AR` (**RAW / WAR / WAW hazard-free**, even across different AXI `ID`s) and keeps DDR3 Open-Page active across queued same-row bursts.
  - Backwards-compatible with single-burst sequential masters (zero added latency).
- **Row policy:** single-bank open-page (`one` open bank/row tracked at a time; a row miss issues a `PRECHARGE` before opening the next row).

---

## 1. Queue Depth Scaling (`maxOutstanding = 2 / 4 / 8 / 16` — Queue-Saturated Hardware)

Measured on physical hardware (`demo/demo_ddr3.py --workload --pipe-only --runs 100`), saturating the bridge queue with back-to-back AXI4 bursts (`100`-run average per row, data bit-verified including `7.8 us` auto-refreshes):

### Resources & STA Timing (`GW2A-LV18PG256C8/I7`)

| Configuration | Target Top | LUT / ALU / SSRAM | REG (`%`) | BSRAM | `pclk` Fmax STA (`target 75.94 MHz`) |
|---|---|---|---|---|---|
| **`maxOutstanding = 2`** | `Ddr3UartDemoTop` | `5132` LUT / `287` ALU / `85` SSRAM | `2276` (`15%`) | `0` | `68.74 MHz` *(UART bench FSM path)* |
| **`maxOutstanding = 4`** | `Ddr3UartDemoTop` | `5063` LUT / `287` ALU / `85` SSRAM | `2289` (`15%`) | `0` | `70.01 MHz` *(UART bench FSM path)* |
| **`maxOutstanding = 8`** *(default)* | `Ddr3UartDemoTop` | `5085` LUT / `297` ALU / `85` SSRAM | `2302` (`15%`) | `0` | `68.80 MHz` *(UART bench FSM path)* |
| **`maxOutstanding = 16`** | `Ddr3UartDemoTop` | `5096` LUT / `322` ALU / `85` SSRAM | `2315` (`15%`) | `0` | `72.46 MHz` *(UART bench FSM path)* |
| **`maxOutstanding = 8`** *(default)* | **`Ddr3TesterTop`** | **`5019` LUT / `191` ALU / `78` SSRAM** | **`2278` (`15%`)** | `1` | **`77.13 MHz`** (**closed**, slack `+0.203 ns`, `0` failing paths; HW `932/0` pass/fail) |

*Note on STA: in `Ddr3UartDemoTop`, the worst reported path (`hostArea_uartBridge/state -> aw.valid -> ar.ready -> pCmdIdx/CE`) lives inside the pipelined UART benchmark FSM harness. In `Ddr3TesterTop` (`TangPrimer20kDdr3` + `Ddr3MemtestEngine`), all controller and bridge paths close `75.94 MHz` with positive slack (`77.13 MHz` Fmax, `411.57 MHz` on `303.77 MHz` `pll_clkout`).*

### Pipelined Saturated Throughput vs Queue Depth (`64-bit AXI4 @ 75.94 MHz`, `MB/s`, `100`-run avg)

| Queue-Saturated Workload | Seq (`1` in-flight, `max=8`) | `max = 2` (WR / RD / Comb) | `max = 4` (WR / RD / Comb) | **`max = 8` default** (WR / RD / Comb) | `max = 16` (WR / RD / Comb) |
|---|---|---|---|---|---|
| **256 B Hit** | `430.2 / 391.0 (409.7)` | `599.7 / 582.3 (590.8)` | `599.8 / 582.6 (591.0)` | **`599.3 / 582.4 (590.8)`** | `599.5 / 583.1 (591.2)` |
| **256 B Row-Miss** | `415.6 / 382.3 (398.2)` | `596.1 / 578.2 (587.0)` | `596.2 / 578.1 (587.0)` | **`596.1 / 577.6 (586.7)`** | `595.9 / 578.3 (586.9)` |
| **64 B Hit** | `295.6 / 195.2 (235.1)` | `466.6 / 463.7 (465.1)` | `466.6 / 568.3 (512.4)` | **`466.4 / 568.8 (512.6)`** | `466.1 / 568.5 (512.3)` |
| **64 B Row-Miss** | `263.5 / 183.5 (216.4)` | `390.7 / 259.4 (311.8)` | `390.5 / 259.3 (311.7)` | **`390.7 / 259.5 (311.9)`** | `390.8 / 259.5 (311.9)` |
| **16 B Cache-Line Hit** | `—` (`89` / `18.5 cyc`) | `388.2 / 133.5 (198.7)` | `388.9 / 262.2 (313.2)` | **`388.7 / 438.1 (411.9)`** | **`389.0 / 558.4 (458.6)`** |
| **16 B Cache-Line Row-Miss** | `—` | `132.4 / 78.3 (98.4)` | `132.4 / 78.3 (98.4)` | **`132.4 / 78.2 (98.3)`** | `132.5 / 78.2 (98.4)` |
| **Mixed R/W 256 B Hit** *(Comb)* | `403.1` | `732.7` | `732.2` | **`732.0`** | `732.0` |
| **Mixed R/W 64 B Hit** *(Comb)* | `223.6` | `359.5` | `359.5` | **`359.5`** | `359.5` |
| **Mixed R/W 16 B Hit** *(Comb)* | `—` | `117.6` | `117.5` | **`117.5`** | `117.5` |
| **Mixed R/W 64 B Row-Miss** *(Comb)* | `217.9` | `334.6` | `334.5` | **`334.5`** | `334.4` |

**Key takeaways:**
- Because Gowin `SSRAM` (`RAM16S4`) is natively 16-deep, `2 / 4 / 8 / 16` all use **exact same `85` SSRAM** (~5.1K LUTs total).
- **`64 B` bursts saturate by `max = 4` (`568.8 MB/s` RD, `+191%` vs sequential `195.2 MB/s`)**; **`16 B` cache-line reads scale all the way to `max = 16` (`133.5 -> 262.2 -> 438.1 -> 558.4 MB/s`, `4.18x`)**.
- **`Mixed R/W 256 B` pipelined** reaches **`732.0 MB/s` combined** because AXI4 `W` and `R` transfer concurrently on independent 64-bit channels while the native 128-bit DDR3 core operates up to `1215 MB/s` peak.

---

## 2. Default Configuration (`maxOutstanding = 8`) — Complete Hardware Matrix

Measured using [`demo/demo_ddr3.py`](../demo/demo_ddr3.py) (`--workload --runs 100`), averaging **100 runs per row** (`1.6 MiB` written + `1.6 MiB` read per sequential row, bit-verified). Row misses force a `+2048 B` (`+1` DDR3 row) stride within bank `0`.

### 2a. Sequential Mode (No Saturation, `1` Burst In-Flight)

| Workload (`16 KiB WR + 16 KiB RD` x 100 runs) | WR avg (peak) `MB/s` | RD avg (peak) `MB/s` | Combined avg `MB/s` |
|---|---|---|---|
| **Sequential 2 KiB bursts (same-row hits)** | `579.9` (`586.0`) | `550.0` (`559.2`) | **`564.6`** |
| **Sequential 256 B bursts (same-row hits)** | `430.2` (`435.8`) | `391.0` (`395.2`) | **`409.7`** |
| **Short 256 B bursts (100% row-miss)** | `415.6` (`419.2`) | `382.3` (`385.5`) | **`398.2`** |
| **Short 64 B bursts (same-row hits)** | `295.6` (`296.8`) | `195.2` (`196.7`) | **`235.1`** |
| **Short 64 B bursts (100% row-miss)** | `263.5` (`264.6`) | `183.5` (`183.9`) | **`216.4`** |
| **Mixed R/W 256 B alternating (same-row)** | `434.3` (`437.9`) | `376.0` (`379.0`) | **`403.1`** |
| **Mixed R/W 256 B alternating (100% row-miss)** | `419.5` (`423.6`) | `374.8` (`379.2`) | **`395.9`** |
| **Mixed R/W 64 B alternating (same-row)** | `291.6` (`297.1`) | `181.3` (`182.1`) | **`223.6`** |
| **Mixed R/W 64 B alternating (100% row-miss)** | `268.7` (`269.6`) | `183.2` (`183.8`) | **`217.9`** |

### 2b. Pipelined Multi-Outstanding Mode (`maxOutstanding = 8`, Queue-Saturated)

| Pipelined Workload (`100` runs/row, full RAW verification) | WR avg (peak) `MB/s` | RD avg (peak) `MB/s` | Combined avg `MB/s` |
|---|---|---|---|
| **Pipelined 256 B bursts (same-row hits)** | `599.3` (`603.1`) | `582.4` (`588.3`) | **`590.8`** |
| **Pipelined 256 B bursts (100% row-miss)** | `596.1` (`600.8`) | `577.6` (`584.9`) | **`586.7`** |
| **Pipelined 64 B bursts (same-row hits)** | `466.4` (`468.8`) | `568.8` (`574.7`) | **`512.6`** |
| **Pipelined 64 B bursts (100% row-miss)** | `390.7` (`391.6`) | `259.5` (`261.9`) | **`311.9`** |
| **Pipelined 16 B cache-line (same-row hits)** | `388.7` (`391.7`) | `438.1` (`443.7`) | **`411.9`** |
| **Pipelined 16 B cache-line (100% row-miss)** | `132.4` (`133.2`) | `78.2` (`78.4`) | **`98.3`** |
| **Pipelined Mixed R/W 256 B (same-row, RAW)** | `—` | `—` | **`732.0`** |
| **Pipelined Mixed R/W 64 B (same-row, RAW)** | `—` | `—` | **`359.5`** |
| **Pipelined Mixed R/W 16 B (same-row, RAW)** | `—` | `—` | **`117.5`** |
| **Pipelined Mixed R/W 64 B (row-miss, RAW)** | `—` | `—` | **`334.5`** |

### Reproduce on Hardware

```powershell
.\.venv\Scripts\python.exe demo\demo_ddr3.py --flash --workload --port COM8
```

---

## 3. 64-bit Physical Hardware Scalar & 16 B Line Latency

Measured on physical hardware (`AWVALID -> BVALID` for writes, `ARVALID -> RLAST` for reads), averaged over **6,400 transactions** per row (`100` runs x `64` transactions @ `75.94 MHz`):

| Transaction (`64-bit AXI4`) | WR avg (`min`) | RD avg (`min`) |
|---|---|---|
| **8 B scalar (same-row hit)** | `6.1` cyc (`81 ns`, min `6.0`) | `17.5` cyc (`231 ns`, min `17.3`) |
| **8 B scalar (100% row-miss)** | `8.9` cyc (`117 ns`, min `8.7`) | `19.8` cyc (`260 ns`, min `19.7`) |
| **16 B cache-line (same-row hit)** | `7.1` cyc (`93 ns`, min `7.0`) | `18.5` cyc (`243 ns`, min `18.2`) |
| **16 B cache-line (100% row-miss)** | `8.9` cyc (`118 ns`, min `8.7`) | `20.7` cyc (`273 ns`, min `20.7`) |

*Note: `WR` latency measures until the bridge's `B` response (`BVALID`) once buffered/accepted toward the controller; `RD` latency measures the full round-trip from `AR` acceptance to `RLAST` back from the physical SDRAM.*

---

## 4. Verilator Simulation Comparison (`64-bit` vs `128-bit`, `maxOutstanding = 8`)

From `Ddr3Axi4Test` (`Ddr3Config.isSimulation = true`, simplified PHY loopback, `@ 75.94 MHz` equivalent):

- **Short `8x64 B` Sequential (`1` in-flight):**
  - **64-bit:** Hit `WR 273.8 / RD 176.7 MB/s`, RowMiss `WR 250.8 / RD 169.8 MB/s`, Mixed R/W `218.4` (Hit) / `216.0 MB/s` (RowMiss)
  - **128-bit:** Hit `WR 335.2 / RD 193.4 MB/s`, RowMiss `WR 373.8 / RD 196.4 MB/s`, Mixed R/W `265.4` (Hit) / `226.0 MB/s` (RowMiss)
- **Short `8x64 B` Pipelined Multi-Outstanding (`8` queued):**
  - **64-bit:** Hit **`WR 366.8 / RD 474.1 MB/s`** (`82` cyc RD)
  - **128-bit:** Hit **`WR 370.3 / RD 627.1 MB/s`** (`62` cyc RD)
- **`16 B` single-block latency:**
  - **64-bit:** Hit `WR 7.0 cyc (92 ns) / RD 20.0 cyc (263 ns)`, RowMiss `WR 8.3 cyc (109 ns) / RD 26.0 cyc (342 ns)`
  - **128-bit:** Hit `WR 6.0 cyc (79 ns) / RD 19.8 cyc (260 ns)`, RowMiss `WR 7.0 cyc (92 ns) / RD 25.0 cyc (329 ns)`

*Sim vs Hardware note:* `Ddr3Axi4Test` pipelined benchmarks measure over only `8` bursts (`512 B`, so initial startup/latency weighs more heavily), whereas physical hardware measures `256` continuous bursts (`64 B` pipelined RD reaches `474.1 MB/s` in sim vs `568.8 MB/s` on silicon).

---

## 5. Theoretical Ceiling vs Measured Hardware Efficiency (`@ 75.94 MHz`)

| Metric (`GW2A-LV18PG256C8/I7`, `maxOutstanding = 8` unless noted) | Measured (HW) | Theoretical Ceiling | Efficiency |
|---|---|---|---|
| **Sequential `2 KiB` same-row (WR / RD)** | `579.9` / `550.0 MB/s` | `607.5 MB/s` *(64b 1-dir)* | **`95.5%` / `90.5%`** |
| **Pipelined `256 B` same-row (WR / RD)** | `599.3` / `582.4 MB/s` | `607.5 MB/s` *(64b 1-dir)* | **`98.7%` / `95.9%`** |
| **Pipelined `256 B` row-miss (WR / RD)** | `596.1` / `577.6 MB/s` | `607.5 MB/s` *(64b 1-dir)* | **`98.1%` / `95.1%`** |
| **Pipelined `64 B` same-row (WR / RD)** | `466.4` / `568.8 MB/s` | `607.5 MB/s` *(64b 1-dir)* | **`76.8%` / `93.6%`** |
| **Pipelined `16 B` same-row (`max = 16`, WR / RD)** | `389.0` / `558.4 MB/s` | `607.5 MB/s` *(64b 1-dir)* | **`64.0%` / `91.9%`** |
| **Pipelined Mixed R/W `256 B` same-row (Comb)** | `732.0 MB/s` | `1215.0 MB/s` *(full-duplex `W+R` / 128b DQ)* | **`60.2%`** |

*Note: all hardware percentages include periodic `7.8 us` (`592` `pclk` cycle) SDRAM auto-refreshes (`tRFC = 64 CK`).*
