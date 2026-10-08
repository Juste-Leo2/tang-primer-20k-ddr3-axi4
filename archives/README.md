# archives/ — historique rangé, hors chemin actif

Contenu déplacé par le refactoring d'octobre 2026 (`git mv`, historique
conservé via `git log --follow`). **Rien ici n'est utilisé par le flow
actif** (`simulation/sim_ddr.py`, `measure/`, `eda-flow.py`).

- `sim-scripts/` : 12 scripts d'analyse VCD/logs one-shot des batteries
  02-07/10/2026 (`audit_burst.py`, `burst_by_state.py`, `compare_runs.py`,
  `detector_state.py`, `edge_dump.py`, `find_state.py`, `full_state.py`,
  `margin_dq.py`, `odt_level.py`, `var_diff.py`, `wpoint_cover.py`,
  `analyze_nestedk.py`). Actifs au moment de leur batterie, remplacés par
  les 5 scripts de `measure/`. `analyze_nestedk.py` correspond à l'axe-K
  **réfuté** (cf `docs-2026-10-02-07/nestedk-battery-06-10-26.md`).
- `sim-legacy/` : `Makefile` (cibles `prim_sim.v`/`ddr3.v` inexistantes) et
  `run_sim.ps1` (doublon mince de `sim_ddr.py --spinal`).
- `docs-2026-10-02-07/` : 16 markdowns intermédiaires + `HANDOFF.md` /
  `audit.md` racines. L'état consolidé est dans `doc/STATUS_AND_NEXT.md`.
  Voir l'index du dossier pour la chronologie.
