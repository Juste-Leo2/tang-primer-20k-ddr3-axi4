#!/usr/bin/env python3
"""Parallel mag-window scan battery (window-scan RTL + MAP_ONLY build).

Each point = one STEP x one mag window [mag0, mag0+magN): anchor, navigate
to mag0, measure the window, report WINDOW, finish (no apply/pass-3/memtest).
Points run as parallel vvp processes (--jobs); vvp is single-threaded.

REQUIRES a MAP_ONLY build: python simulation/sim_ddr.py --fast-tb --map-only
(without --run). Do NOT mix with full-sweep runs on the same tb_fast.vvp.

Usage:
  python mag_battery.py --steps 23,25,40,60 --mag0 0,10,20,30,40,50,60 --magn 10 --jobs 14
"""
import argparse
import os
import re
import subprocess
import sys
import time
from pathlib import Path

SIM = Path(__file__).resolve().parent
OSS_DIR = SIM.parent / "tools" / "oss-cad-suite"
VVP = OSS_DIR / "bin" / "vvp.exe"
WIN_RX = re.compile(
    r"RCALIB window side=(\w+) mag=(\w+) pos=(\w+) rot=(\w+) score=(\w+)")
CHK_RX = re.compile(r"NOTE RCALIB chk pos=\d sel=\d .*?score=(\d)")


def get_env():
    env = dict(os.environ)
    sep = ";" if sys.platform.startswith("win") else ":"
    env["PATH"] = f"{OSS_DIR / 'bin'}{sep}{OSS_DIR / 'lib'}{sep}{env.get('PATH', '')}"
    return env


def collect(step, mag0, magn):
    log = SIM / f"tb_fast_s{step}_m{mag0}.log"
    text = log.read_text(errors="replace")
    w = WIN_RX.search(text)
    mx = -1
    for m in CHK_RX.finditer(text):
        mx = max(mx, int(m.group(1)))
    return dict(step=step, mag0=mag0,
                wscore=w.group(5) if w else "?",
                wmag=w.group(2) if w else "?",
                maxsw=mx)


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--steps", default="23,25,40,60")
    ap.add_argument("--mag0", default="0,10,20,30,40,50,60")
    ap.add_argument("--magn", type=int, default=10)
    ap.add_argument("--jobs", type=int, default=14)
    args = ap.parse_args()

    steps = [int(x) for x in args.steps.split(",") if x != ""]
    mags = [int(x) for x in args.mag0.split(",") if x != ""]
    vvp = SIM / "tb_fast.vvp"
    if not vvp.exists():
        print("ERROR: tb_fast.vvp missing, run sim_ddr.py --fast-tb --map-only first",
              file=sys.stderr)
        return 1

    # Round-robin over mags (not steps) so every STEP starts immediately
    # even with few jobs: with --jobs 2 the first two slots are S23-m0 +
    # S25-m0 instead of two S23 windows.
    points = [(s, m) for m in mags for s in steps]
    todo = []
    for s, m in points:
        log = SIM / f"tb_fast_s{s}_m{m}.log"
        if log.exists() and WIN_RX.search(log.read_text(errors="replace")):
            continue
        todo.append((s, m))
    print(f"{len(points)} points, {len(todo)} to run, jobs={args.jobs} "
          f"(MAP_ONLY build required; RESULT lines are meaningless here, "
          f"read WINDOW/maxsw)", flush=True)

    running = []
    done = []
    queue = list(todo)
    t0 = time.time()
    env = get_env()
    try:
        while queue or running:
            while queue and len(running) < args.jobs:
                s, m = queue.pop(0)
                fh = open(SIM / f"tb_fast_s{s}_m{m}.log", "w")
                cmd = [str(VVP), str(vvp), f"+step={s}", "+phase=0",
                       f"+mag0={m}", f"+magN={args.magn}"]
                fh.write("$ " + " ".join(cmd) + "\n")
                fh.flush()
                proc = subprocess.Popen(cmd, stdout=fh, stderr=subprocess.STDOUT,
                                        cwd=str(SIM), env=env)
                running.append((proc, fh, (s, m)))
                print(f"  start step={s:<4} mag0={m:<3} "
                      f"(queued={len(queue)})", flush=True)
            time.sleep(5)
            still = []
            for proc, fh, pt in running:
                if proc.poll() is None:
                    still.append((proc, fh, pt))
                else:
                    fh.close()
                    r = collect(*pt, args.magn)
                    done.append(r)
                    print(f"  done  step={r['step']:<4} mag0={r['mag0']:<3} "
                          f"WINDOW score={r['wscore']} @mag={r['wmag']} "
                          f"maxsw={r['maxsw']}  [{int(time.time()-t0)}s]",
                          flush=True)
            running = still
    except KeyboardInterrupt:
        print("\n  abort: killing running vvp...", flush=True)
        for proc, fh, pt in running:
            try:
                proc.kill()
            except OSError:
                pass
            fh.close()
        raise SystemExit(130)

    have = {(d["step"], d["mag0"]) for d in done}
    for s, m in points:
        if (s, m) not in have:
            done.append(collect(s, m, args.magn))

    print("\n=== maxsw per (step x mag0 window) ===")
    print("step  " + "".join(f"m{m:<6}" for m in mags))
    for s in steps:
        row = ""
        for m in mags:
            hit = [d for d in done if d["step"] == s and d["mag0"] == m]
            row += f"{hit[0]['maxsw']:<7}" if hit else "?      "
        print(f"{s:<6}" + row)
    return 0


if __name__ == "__main__":
    sys.exit(main())
