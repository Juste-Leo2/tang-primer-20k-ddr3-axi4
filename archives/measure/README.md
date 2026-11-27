# measure/ — batteries et analyses (actif)

Scripts de **mesure** du contrôleur DDR3 : ils lancent des batteries de runs
`tb_fast.vvp` et analysent les logs/VCD. Les logs restent dans `simulation/`
(plusargs `+step/+phase/+mag0/+magN`, un log par point).

Pré-requis commun (build MAP_ONLY, voir `simulation/sim_ddr.py`) :

```powershell
python simulation/sim_ddr.py --fast-tb --map-only
```

| Script | Usage | Lit |
|---|---|---|
| `mag_battery.py` | `python measure/mag_battery.py --steps 23,25,40,60 --mag0 0,10,20,... --magn 10 --jobs 14` — scan window STEP × mag | `simulation/tb_fast_s*_m*.log` (lignes `WINDOW`, `CHK`) |
| `map_capture.py` | `python measure/map_capture.py --steps ... --phases ... --jobs 9` — map STEP × phase | `simulation/tb_fast_s*_p*.log` (`RESULT`, `lock`) |
| `analyze_window.py` | `python measure/analyze_window.py` — tableau maxsw (lisible pendant les runs) | `simulation/tb_fast_s*_m*.log` |
| `analyze_vcd.py` | `python measure/analyze_vcd.py <fichier.vcd>` — fronts DQSR90 + WPOINT/RPOINT par burst | VCD micro-fenêtre (passer le chemin explicite) |
| `analyze_vcd_dq.py` | `python measure/analyze_vcd_dq.py <fichier.vcd>` — échantillonnage DQ par front (détecte Hi-Z) | idem |

Conventions (cf `doc/STATUS_AND_NEXT.md`) :
- En build MAP_ONLY, `RESULT ... PASS` est **vacueux** : seules comptent les
  lignes `WINDOW` et `maxsw`.
- `vvp.exe` ne démarre que si `tools/oss-cad-suite/bin` **et** `lib` sont au
  `PATH` (géré par `get_env()` dans chaque script — même raison que dans
  `sim_ddr.py`).
- Les anciens scripts d'analyse one-shot sont en `archives/sim-scripts/`.
