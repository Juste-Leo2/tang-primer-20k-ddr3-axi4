# archives/ — historique rangé, hors chemin actif

Contenu déplacé par les refactorings (`git mv`, historique conservé via
`git log --follow`). **Rien ici n'est utilisé par le flow actif**
(`ddr3/`, `eda-flow.py`, `fpga_run.py`).

- `simulation/` : ancien driver Icarus Verilog (`sim_ddr.py`), testbenches
  (`tb_fast.v`, `tb_spinal.v`, `tb_controller.v`, `ddr3_controller_sim.v`)
  et `README.md` (les modèles tiers Gowin/Micron restent fournis localement).
- `measure/` : scripts de batteries et d'analyse VCD/window d'octobre 2026
  (`mag_battery.py`, `map_capture.py`, `analyze_*.py`).
- `sim_tests/` : 10 mini-testbenches isolés (`t01..t22`) ayant servi à
  caractériser `prim_sim_tb.v`.
- `baseline-nand2mario/` : RTL Verilog baseline d'origine (`ddr3_controller.v`,
  `ddr3_top.v`, `print.v`, `uart_tx_V2.v`, sous Apache 2.0).
- `docs-bringup/` : journaux de debug et captures d'octobre 2026 déplacés de
  `doc/` (`STATUS_AND_NEXT.md`, `bug-02-10-26...`, `t21_*`, captures PNG).
- `ddr3.gprj` : ancien fichier projet GUI Gowin (remplacé par `eda-flow.py`).
- `sim-scripts/` : 12 scripts d'analyse VCD/logs one-shot des batteries
  02-07/10/2026 (`audit_burst.py`, `burst_by_state.py`, `compare_runs.py`,
  `detector_state.py`, `edge_dump.py`, `find_state.py`, `full_state.py`,
  `margin_dq.py`, `odt_level.py`, `var_diff.py`, `wpoint_cover.py`,
  `analyze_nestedk.py`).
- `sim-legacy/` : `Makefile` et `run_sim.ps1`.
- `docs-2026-10-02-07/` : 16 markdowns intermédiaires + `HANDOFF.md` /
  `audit.md` racines.
