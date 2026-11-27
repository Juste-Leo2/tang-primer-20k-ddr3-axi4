# DDR3 + AXI4 Hardware Benchmarks (`Tang Primer 20K`)

All hardware numbers below were measured directly on a physical **Sipeed Tang Primer 20K** (`GW2A-LV18PG256C8/I7`) running at `pclk = 75.94 MHz` and `DDR3 CK = 303.75 MHz` (`607.5 MT/s`, theoretical 64-bit AXI4 ceiling = `607.5 MB/s`).

## Integration Constraints & Arbiter Behavior

- **AXI4 burst types:** supports `INCR` and `FIXED` bursts (does **not** support `WRAP`).
- **`AxSIZE`:** expects `AxSIZE` matching the configured bus width (`32`, `64`, or `128` bits); use `WSTRB` for partial / sub-word writes.
- **Bridge arbitration:** half-duplex per AXI4 burst (`AW/W` and `AR/R` are arbitrated one burst at a time, `AW` has priority when both arrive while idle).
- **Row policy:** single-bank open-page (`one` open bank/row tracked at a time; a row miss issues a `PRECHARGE` before opening the next row).

---

## 1. 64-bit Physical Hardware Workload Matrix

Measured using [`demo/demo_ddr3.py`](../demo/demo_ddr3.py) (`--workload --runs 100`), averaging **100 runs per row** (`1.6 MiB` written + `1.6 MiB` read and bit-verified per line, including periodic `7.8 us` auto-refreshes). Row misses are forced using a `+2048 B` (`+1` DDR3 row) stride within bank `0`.

| Workload (`16 KiB WR + 16 KiB RD` x 100 runs) | WR avg (peak) `MB/s` | RD avg (peak) `MB/s` | Combined avg `MB/s` |
|---|---|---|---|
| **Sequential 2 KiB bursts (same-row hits)** | `580.0` (`586.3`) | `548.8` (`556.7`) | **`564.0`** |
| **Sequential 256 B bursts (same-row hits)** | `430.1` (`435.5`) | `384.2` (`387.5`) | **`405.9`** |
| **Short 256 B bursts (100% row-miss)** | `415.5` (`419.8`) | `379.8` (`382.2`) | **`396.9`** |
| **Short 64 B bursts (same-row hits)** | `295.6` (`296.9`) | `188.8` (`189.9`) | **`230.4`** |
| **Short 64 B bursts (100% row-miss)** | `263.5` (`264.6`) | `175.6` (`176.1`) | **`210.8`** |
| **Mixed R/W 256 B alternating (same-row)** | `421.4` (`427.1`) | `377.9` (`382.3`) | **`398.5`** |
| **Mixed R/W 256 B alternating (100% row-miss)** | `402.0` (`414.6`) | `373.8` (`383.5`) | **`387.4`** |
| **Mixed R/W 64 B alternating (same-row)** | `277.9` (`278.9`) | `186.7` (`186.9`) | **`223.4`** |
| **Mixed R/W 64 B alternating (100% row-miss)** | `252.6` (`255.9`) | `181.4` (`182.7`) | **`211.1`** |

### Reproduce on Hardware

```powershell
.\.venv\Scripts\python.exe demo\demo_ddr3.py --flash --workload --port COM8
```

---

## 2. 64-bit Physical Hardware Scalar & 16 B Line Latency

Measured on physical hardware (`AWVALID -> BVALID` for writes, `ARVALID -> RLAST` for reads), averaged over **6,400 transactions** per row (`100` runs x `64` transactions @ `75.94 MHz`):

| Transaction (`64-bit AXI4`) | WR avg (`min`) | RD avg (`min`) |
|---|---|---|
| **8 B scalar (same-row hit)** | `6.1` cyc (`81 ns`, min `6.0`) | `18.5` cyc (`244 ns`, min `18.2`) |
| **8 B scalar (100% row-miss)** | `8.9` cyc (`117 ns`, min `8.7`) | `20.7` cyc (`273 ns`, min `20.7`) |
| **16 B cache-line (same-row hit)** | `7.1` cyc (`93 ns`, min `7.0`) | `19.5` cyc (`257 ns`, min `19.4`) |
| **16 B cache-line (100% row-miss)** | `8.9` cyc (`118 ns`, min `8.7`) | `21.7` cyc (`286 ns`, min `21.6`) |

*Note: `WR` latency measures until the bridge's `B` response (`BVALID`) once buffered/accepted toward the controller; `RD` latency measures the full round-trip from `AR` acceptance to `RLAST` back from the physical SDRAM.*

---

## 3. Verilator Simulation Comparison (64-bit vs 128-bit)

From `Ddr3Axi4Test` (`Ddr3Config.isSimulation = true`, simplified PHY loopback):

- **Short `8x64 B` bursts (`@ 75.94 MHz` equivalent):**
  - **64-bit:** Hit `WR 273.8 / RD 176.7 MB/s`, RowMiss `WR 250.8 / RD 169.8 MB/s`, Mixed R/W `218.4 MB/s` (Hit) / `216.0 MB/s` (RowMiss)
  - **128-bit:** Hit `WR 335.2 / RD 193.4 MB/s`, RowMiss `WR 373.8 / RD 196.4 MB/s`, Mixed R/W `265.4 MB/s` (Hit) / `226.0 MB/s` (RowMiss)
- **`16 B` single-block latency (`@ 75.94 MHz` equivalent):**
  - **64-bit:** Hit `WR 7.0 cyc (92 ns) / RD 20.0 cyc (263 ns)`, RowMiss `WR 8.3 cyc (109 ns) / RD 26.0 cyc (342 ns)`
  - **128-bit:** Hit `WR 6.0 cyc (79 ns) / RD 19.8 cyc (260 ns)`, RowMiss `WR 7.0 cyc (92 ns) / RD 25.0 cyc (329 ns)`
