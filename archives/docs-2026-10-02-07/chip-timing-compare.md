# DDR3 timing compare — Micron model (sim) vs Hynix chip (HW) vs our sequence

## Chips
| | Sim (Micron model) | HW board | Baseline ref |
|---|---|---|---|
| Part | Micron 1024Mb x16 (`den1024Mb sg25 x16`) | SKHynix `H5TQ1G63EFR` (x16, 1Gb, 64Mx16, 8 banks) | same Hynix family (`-PBC`) |
| Row / Col / Banks | 13 / 10 / 8 | 13 (A0-A12) / 10 (A0-A9) / 8 | same |
| Speed bin (sim) | sg25 = DDR3-800 (6-6-6), tCK 2.5ns | unknown suffix (`-PBC`=1600, `-H9`=1333…) — read it off the chip | - |
| Our operating point | DDR3-800, tCK 2.5ns, CL=6, CWL=5 | same (below any max) | same |

Note: there is **no public SKHynix Verilog model** (whole OSS ecosystem sims Micron).
Hynix values below are JEDEC-standard per speed bin (same numbers Micron uses).

## WL-relevant AC timings (all have wide margin — none explains a deaf WL)

| Param | Micron sg25 (sim) | JEDEC/Hynix (any bin ≤1600) | Our sequence | Margin |
|---|---|---|---|---|
| tWLMRD (MRS→first DQS) | 40 tCK = 100ns | 40 tCK | strobe at WLMRD=44 → 11 pclk = 110ns | OK (+10ns) |
| tWLDQSEN (MRS→DQS low) | 25 tCK = 62.5ns | 25 tCK | DQS low from entry, strobe at 110ns | OK |
| tWLO (DQS edge→DQ echo) | 9000ps max | 7500–9000ps max (bin) | sample at +6 cycles = 60ns after strobe | OK (6–8×) |
| tWLOE (echo error) | 2000ps | 2000ps (JEDEC) | vote 2/4 absorbs flicker | OK |
| tWLS / tWLH (DQ setup/hold) | 325 / 325ps | JEDEC same | N/A (DRAM-side) | — |
| tDQSS (DQS vs CK, writes) | ±0.25 tCK = ±625ps | same | wstep 25ps/step, range 6.4ns | OK |
| tWPRE (write preamble) | 0.90 tCK | same | 2 phases low (~1 tCK) | marginal by design, see below |
| tWPST (write postamble) | 0.30 tCK | same | D7=0 (0.5 tCK) | OK |

## Mode registers (ours vs baseline — identical)
| | Ours (`Ddr3ControllerCore`) | Baseline (`ddr3_controller.v`) |
|---|---|---|
| WL enter | `MR1 \| 0x0084` (A7 WL + A2 → RTT_NOM RZQ/4 = 60Ω) | `MR1 \| 8'b1000_0100` — identical |
| WL exit | `MR1` (A7=0) | identical |
| Post-WL | `MR2_RTT_WR` (dynamic ODT on) | identical |
| ODT pin | tied 1 (dynamic ODT) | tied 1 — identical |
| WL seed (sim) | 0x18 | 0x18 (`SIM` ifdef) — identical |
| WL lock rule | 2 consecutive (now also HW) | `WLEVEL_COUNT` 2 sim / 1 HW |
| **WL strobe** | **`0x55` (starts HIGH)** | **`0xAA` (starts LOW)** — **only difference** |

## Geometry / config (all consistent)
MR0: CL=6 (`M_CAS=0100`), BC4/8 on-the-fly (`M_BL=01`); MR2: CWL=5 (`M_CWL=000`);
RTT_WR off until post-WL. 128Mb… all match 1Gb x16 density.

## Conclusion
No timing constant differs enough to explain an all-zero `[WLMAP]`: every WL
AC parameter has 6–8× margin in our sequence on any vendor. The HW deafness
is therefore **not a timing-value issue** — it lives in what the sim
idealizes: FPGA sampling phase of a ~1ns echo with a 10ns clock (routing
lottery per bitstream), Board/SI levels (SSTL15, VREF, ODT, ringing), and
the DRAM's analog echo shape. Consequences:
1. Freeze sampling phase with SDC constraints before any more point-hunting.
2. Keep the vote/debounce/warmup (they filter flicker, proven in noise sims).
3. Calibrate on the write result (sweep score C, auto-bracket), never on echo.
4. Strobe polarity 0x55 vs 0xAA remains the single unexplained RTL delta vs
   the working baseline — re-test on HW last, judge by the map only.
