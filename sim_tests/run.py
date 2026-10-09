#!/usr/bin/env python3
"""Runner sim_tests : builds iverilog SERIALISES + runs vvp + verdicts.

Usage (via powershell, binaires .exe Windows) :
  python sim_tests/run.py --test t01
  python sim_tests/run.py --all

Un seul `iverilog -o` à la fois (binaire corrompu + use_island sinon).
Met oss/bin+lib au PATH comme sim_ddr.py. cwd libre (chemins absolus).
"""
import argparse
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent          # sim_tests/
REPO = ROOT.parent
GEN = ROOT / "gen"
sys.path.insert(0, str(ROOT))
from tests import TESTS


def find_oss():
    home = Path.home()
    cands = [
        home / ".spinalml_tools" / "oss-cad-suite",
        REPO / "tools" / "oss-cad-suite",
    ]
    for c in cands:
        if (c / "bin" / "iverilog.exe").exists() or (c / "bin" / "iverilog").exists():
            return c
    w = shutil.which("iverilog")
    if w:
        return Path(w).resolve().parent.parent
    return None


OSS = find_oss()
IS_WIN = sys.platform.startswith("win")
EXE = ".exe" if IS_WIN else ""
IVERILOG = str(OSS / "bin" / f"iverilog{EXE}") if OSS else "iverilog"
VVP = str(OSS / "bin" / f"vvp{EXE}") if OSS else "vvp"


def get_env():
    env = dict(os.environ)
    if OSS:
        sep = ";" if IS_WIN else ":"
        env["PATH"] = f"{OSS / 'bin'}{sep}{OSS / 'lib'}{sep}{env.get('PATH', '')}"
    return env


def run_one(key):
    cfg = TESTS[key]
    tdir = ROOT / cfg["dir"]
    GEN.mkdir(exist_ok=True)
    vvp = GEN / (Path(cfg["tb"]).stem + ".vvp")
    log = GEN / (cfg["name"] + ".log")

    cmd = [IVERILOG, "-o", str(vvp), "-g2012"]
    for d in cfg.get("defines", []):
        cmd += ["-D", d]
    for inc in cfg.get("includes", []):
        cmd += ["-I", str(REPO / inc)]
    cmd.append(str(tdir / cfg["tb"]))
    print("$", " ".join(cmd), flush=True)
    b = subprocess.run(cmd, capture_output=True, text=True, timeout=600,
                       errors="replace", env=get_env())
    if b.stdout:
        print(b.stdout, end="")
    if b.stderr:
        print("STDERR:", b.stderr[-2000:], end="")
    if b.returncode != 0:
        print(f"{key}: BUILD FAIL rc={b.returncode}")
        return False

    cmd = [VVP, str(vvp)] + [f"+{a}" for a in cfg.get("plusargs", [])]
    print("$", " ".join(cmd), f"> {log}", flush=True)
    try:
        with open(log, "w") as fh:
            r = subprocess.run(cmd, stdout=fh, stderr=subprocess.STDOUT,
                               timeout=cfg.get("timeout", 120), errors="replace",
                               env=get_env(), cwd=str(REPO / "simulation"))
    except subprocess.TimeoutExpired:
        print(f"{key}: TIMEOUT")
        return False
    if r.returncode != 0:
        print(f"{key}: RUN FAIL rc={r.returncode} (voir {log})")
        return False

    pat = cfg["verdict"]
    verdict = None
    with open(log, errors="replace") as fh:
        for line in fh:
            m = pat.search(line.strip())
            if m:
                verdict = m.group(0)
    print(f"{key}: {verdict if verdict else 'VERDICT MANQUANT'}")
    return verdict is not None and "PASS" in verdict


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--test", default=None, help="clé du test (ex: t01)")
    ap.add_argument("--all", action="store_true", help="tous les tests, séquentiel")
    args = ap.parse_args()
    keys = list(TESTS) if args.all else [args.test]
    if not args.all and args.test not in TESTS:
        print(f"test inconnu: {args.test} (connus: {', '.join(TESTS)})")
        return 2
    ok = True
    for k in keys:
        if not run_one(k):
            ok = False
    print("ALL PASS" if ok else "ECHEC (voir ci-dessus)")
    return 0 if ok else 1


if __name__ == "__main__":
    sys.exit(main())
