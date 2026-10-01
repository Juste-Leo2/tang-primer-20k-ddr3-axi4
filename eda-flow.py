#!/usr/bin/env python3
# Copyright (c) 2026 Léonard Adamo (Juste-Leo2) - SPDX-License-Identifier: MIT

"""Headless Gowin EDA factory: SpinalHDL -> .fs bitstream, zero GUI clicks.

Stages:
  1. compile SpinalHDL via Mill (generates hw/gen/Ddr3TesterTop.v)
  2. stage files -> WORKDIR/src
  3. write build.tcl (.gprj equivalent) + run gw_sh (syn + PnR + bitstream)
  4. report resources (LUTs, Regs, BSRAM, DLL, DQS, bitstream .fs size)
  5. optional --flash via programmer_cli (vendor driver)

Usage on Windows:
    python eda-flow.py [--preset ddr3] [--skip-compile] [--report-only]
"""

import argparse
import glob
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parent

BOARDS = {
    # board profile -> (part number, device version, default cst)
    "tang-primer-20k": ("GW2A-LV18PG256C8/I7", "C", "src/tang20k.cst"),
}


def find_gowin_paths():
    if "GOWIN_HOME" in os.environ:
        base = Path(os.environ["GOWIN_HOME"])
        gw = base / "IDE" / "bin" / "gw_sh.exe"
        prog = base / "Programmer" / "bin" / "programmer_cli.exe"
        if gw.exists():
            return gw, prog

    default_gw = Path(r"C:\Gowin\Gowin_V1.9.11.03_Education_x64\IDE\bin\gw_sh.exe")
    default_prog = Path(r"C:\Gowin\Gowin_V1.9.11.03_Education_x64\Programmer\bin\programmer_cli.exe")
    if default_gw.exists():
        return default_gw, default_prog

    candidates = glob.glob(r"C:\Gowin\*\IDE\bin\gw_sh.exe")
    if candidates:
        gw = Path(candidates[0])
        prog = gw.parent.parent.parent / "Programmer" / "bin" / "programmer_cli.exe"
        return gw, prog

    return default_gw, default_prog


def find_mill_bat():
    local_mill = REPO / "mill.bat"
    if local_mill.exists():
        return local_mill
    user_mill = Path.home() / ".spinalml_tools" / "mill.bat"
    if user_mill.exists():
        return user_mill
    which_mill = shutil.which("mill.bat") or shutil.which("mill")
    if which_mill:
        return Path(which_mill)
    return local_mill


GOWIN_SH, PROGRAMMER_CLI = find_gowin_paths()
MILL_BAT = find_mill_bat()

EXPECTED = {
    "lut_min": 300, "lut_max": 18000,
    "reg_min": 300, "reg_max": 18000,
    "bsram_max": 46,
}

PRESETS = {
    # preset -> (compile flags, top, file list (repo-rel), envelope, base)
    "ddr3": (
        [], "Ddr3TesterTop",
        ["hw/gen/Ddr3TesterTop.v", "src/gowin_rpll/gowin_rpll.v",
         "src/tang20k.cst", "src/ddr3.sdc"],
        EXPECTED, "Ddr3TesterTop",
    ),
    "dram": (
        ["--dram"], "DramSoCTop",
        ["rtl/DramSoCTop.v", "dram/out/litedram_core.v",
         "src/tang20k.cst"],
        EXPECTED, "DRAM",
    ),
    "mnist": (
        ["--soc"], "UartSoC",
        ["out/mnist-control-rtl/UartSoC.v",
         "src/tang20k.cst"],
        {"lut_min": 4000, "lut_max": 14000,
         "reg_min": 3000, "reg_max": 7000, "bsram_max": 46},
        "MNIST",
    ),
}


def sh(cmd, cwd, tag):
    print(f"[{tag}] $ {' '.join(str(c) for c in cmd)}", flush=True)
    proc = subprocess.Popen(
        [str(c) for c in cmd], cwd=str(cwd),
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True,
        errors="replace")
    tail = []
    for line in proc.stdout:
        print(line, end="", flush=True)
        tail.append(line)
        if len(tail) > 200:
            tail.pop(0)
    rc = proc.wait()
    if rc != 0:
        raise SystemExit(f"[{tag}] FAILED rc={rc}\n" + "".join(tail[-30:]))
    return rc


def main():
    ap = argparse.ArgumentParser(description="Headless Gowin EDA factory")
    ap.add_argument("--model", default=None,
                    help="Scala model file (default per preset)")
    ap.add_argument("--board", default="tang-primer-20k")
    ap.add_argument("--workdir", default=str(REPO / "build_eda"))
    ap.add_argument("--top", default=None)
    ap.add_argument("--preset", choices=["ddr3", "dram", "mnist"], default="ddr3")
    ap.add_argument("--skip-compile", action="store_true")
    ap.add_argument("--report-only", action="store_true",
                    help="Skip compile+gw_sh, only parse WORKDIR outputs")
    ap.add_argument("--flash", choices=["none", "programmer", "openfpgaloader"],
                    default="none")
    ap.add_argument("--validate", action="store_true")
    ap.add_argument("--validate-script", default=None,
                    help="Override validation script (default per preset)")
    args = ap.parse_args()

    cflags, preset_top, preset_files, envelope, base = PRESETS[args.preset]
    top = args.top or preset_top
    part, devver, default_cst = BOARDS[args.board]
    work = Path(args.workdir)
    src = work / "src"
    src.mkdir(parents=True, exist_ok=True)

    # 1. compile MODEL ----------------------------------------------------
    if not args.skip_compile and not args.report_only:
        if args.preset == "ddr3":
            sh([str(MILL_BAT), "ddr3.runMain", "ddr3.Ddr3Gen"], REPO, "mill_gen")
        else:
            model = args.model or (r"tests\universal\UniversalScaleDemo.scala"
                                   if args.preset == "dram"
                                   else r"examples\Mnist\Model.scala")
            sh([sys.executable, "cli/main.py", "compile", model,
                *cflags, "--board", args.board], REPO, "compile")

    # 2. stage -------------------------------------------------------------
    if not args.report_only:
        files = {REPO / rel: src / Path(rel).name for rel in preset_files}
        for a, b in files.items():
            if not a.exists():
                raise SystemExit(f"missing artifact: {a} (compile first?)")
            shutil.copy2(a, b)
            print(f"[stage] {a.name} ({a.stat().st_size // 1024} KiB)")

    # 3. build.tcl + gw_sh -------------------------------------------------
    if not args.report_only:
        tcl_files = [f'add_file "src/{Path(rel).name}"' for rel in preset_files]
        tcl = "\n".join([
            f"set_device -device_version {devver} {part}",
            *tcl_files,
            f"set_option -top_module {top}",
            f"set_option -output_base_name {base}",
            "set_option -use_sspi_as_gpio 1",
            "set_option -use_mspi_as_gpio 1",
            "run all",
            "exit",
            "",
        ])
        (work / "build.tcl").write_text(tcl, encoding="utf-8")
        if not GOWIN_SH.exists():
            raise SystemExit(f"gw_sh not found: {GOWIN_SH}\n"
                             "Set GOWIN_HOME environment variable if installed in a custom location.")
        sh([GOWIN_SH, "build.tcl"], work, "gw_sh")

    # 4. report -------------------------------------------------------------
    impl = work / "impl"
    rsc = impl / "gwsynthesis" / f"{base}_syn_rsc.xml"
    rpt = impl / "pnr" / f"{base}.rpt.txt"
    fs = impl / "pnr" / f"{base}.fs"
    if not (rsc.exists() and rpt.exists() and fs.exists()):
        raise SystemExit("[report] missing outputs "
                         f"(rsc={rsc.exists()} rpt={rpt.exists()} fs={fs.exists()})")
    m = re.search(r'T_Register="(\d+).*?T_Lut="(\d+)', rsc.read_text(),
                  re.DOTALL)
    lut = int(m.group(2)) if m else -1
    reg = int(m.group(1)) if m else -1
    bsram = re.search(r'T_Bsram="(\d+)', rsc.read_text())
    bsram = int(bsram.group(1)) if bsram else 0
    txt = rpt.read_text(errors="replace")
    errs = [l for l in txt.splitlines() if "ERROR" in l]
    dll = re.search(r"DLL\s+\|\s+(\d+)", txt)
    dqs = re.search(r"DQS\s+\|\s+(\d+)", txt)
    print("=" * 60)
    print(f"[report] LUT={lut} REG={reg} BSRAM={bsram} "
          f"DLL={dll.group(1) if dll else '?'} DQS={dqs.group(1) if dqs else '?'} "
          f"ERRORs={len(errs)} fs={fs.stat().st_size // 1024} KiB")
    ok = (envelope["lut_min"] <= lut <= envelope["lut_max"]
          and envelope["reg_min"] <= reg <= envelope["reg_max"]
          and 0 <= bsram <= envelope["bsram_max"]
          and not errs and fs.stat().st_size > 500_000)
    print("[report] " + ("PASS" if ok else "CHECK MANUALLY"))
    print(f"[report] Bitstream ready: {fs}")
    if not ok:
        raise SystemExit(1)

    # 5. flash (optional) ----------------------------------------------------
    if args.flash == "programmer":
        sh([PROGRAMMER_CLI, "--device", "GW2A-18C", "--fsFile", str(fs)],
           REPO, "flash")
    elif args.flash == "openfpgaloader":
        sh([sys.executable, "cli/main.py", "flash", str(fs)], REPO, "flash")

    # 6. validate (optional) --------------------------------------------------
    if args.validate:
        print("[validate] To monitor UART output on Tang Primer 20K:")
        print("           python -m serial.tools.miniterm COMx 115200")


if __name__ == "__main__":
    main()
