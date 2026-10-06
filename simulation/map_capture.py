#!/usr/bin/env python3
"""Parallel STEP x phase capture map.

One build (tb_fast.vvp), N runs: STEP and phase are runtime plusargs, so each
point is just a vvp invocation with its own log. Collects C (best sweep score),
the locked rotation and the locked write tap per point, then prints a table.

vvp is single-threaded, so parallelism is one OS process per point (20 logical
cores available; --jobs should stay well below that to leave room for the host).

Usage:
  python map_capture.py --steps 0,25,64,128,192,255 --phases 0,312,625 --jobs 9
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
LOCK_RX = re.compile(r"RCALIB lock best pos=(\d) sel=(\d) rot=(\d+) score=(\w+)")
CHK_RX = re.compile(r"NOTE RCALIB chk pos=\d sel=\d side=(\d) mag=(\w+) k=(\d).*?score=(\d)")
RESULT_RX = re.compile(
    r"RESULT step=(\d+) phase_ps=(\d+) wl=(-?\d+) W=(\w+) P=(\d+) S=(\d+) errors=(\d+) (\w+)")


def get_env():
    """oss-cad-suite binaries need their own bin/lib on PATH; vvp.exe will not
    start without it (same reason sim_ddr.py sets it)."""
    env = dict(os.environ)
    sep = ";" if sys.platform.startswith("win") else ":"
    env["PATH"] = f"{OSS_DIR / 'bin'}{sep}{OSS_DIR / 'lib'}{sep}{env.get('PATH', '')}"
    return env


def collect(step, phase):
    log = SIM / f"tb_fast_s{step}_p{phase}.log"
    text = log.read_text(errors="replace")
    locks = LOCK_RX.findall(text)
    res = RESULT_RX.search(text)
    # Max settled sweep score + where (side/mag/k): the gap-eye evidence.
    # Nested-K chk lines carry side/mag/k; older logs without them yield -.
    best = (-1, None)
    for m in CHK_RX.finditer(text):
        sc = int(m.group(4))
        if sc > best[0]:
            best = (sc, f"{m.group(1)}/{m.group(2)}/{m.group(3)}")
    # The LAST lock line is sweep-2 (written after the training pattern): that
    # is the real measurement. The first one is sweep-1 (score 0 by design).
    c = locks[-1][3] if locks else "?"
    rot = locks[-1][2] if locks else "?"
    pos = locks[-1][0] if locks else "?"
    sel = locks[-1][1] if locks else "?"
    w = res.group(4) if res else "?"
    return dict(step=step, phase=phase, c=c, rot=rot, pos=pos, sel=sel, w=w,
                errors=res.group(7) if res else "?",
                maxsw=best[0], at=best[1] or "-")


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--steps", default="0,25,64,128,192,255")
    ap.add_argument("--phases", default="0,312,625")
    ap.add_argument("--jobs", type=int, default=9)
    args = ap.parse_args()

    steps = [int(x) for x in args.steps.split(",") if x != ""]
    phases = [int(x) for x in args.phases.split(",") if x != ""]
    vvp = SIM / "tb_fast.vvp"
    if not vvp.exists():
        print(f"ERROR: {vvp} missing, run sim_ddr.py --fast-tb first", file=sys.stderr)
        return 1

    points = [(s, p) for p in phases for s in steps]
    # Skip points whose log already holds a completed RESULT line.
    todo = []
    for s, p in points:
        log = SIM / f"tb_fast_s{s}_p{p}.log"
        if log.exists() and RESULT_RX.search(log.read_text(errors="replace")):
            continue
        todo.append((s, p))
    print(f"{len(points)} points, {len(todo)} to run, jobs={args.jobs}", flush=True)

    running = []  # (proc, filehandle, (step, phase))
    done = []
    queue = list(todo)
    t0 = time.time()
    while queue or running:
        while queue and len(running) < args.jobs:
            s, p = queue.pop(0)
            fh = open(SIM / f"tb_fast_s{s}_p{p}.log", "w")
            cmd = [str(VVP), str(vvp), f"+step={s}", f"+phase={p}"]
            fh.write("$ " + " ".join(cmd) + "\n")
            fh.flush()
            proc = subprocess.Popen(cmd, stdout=fh, stderr=subprocess.STDOUT,
                                    cwd=str(SIM), env=get_env())
            running.append((proc, fh, (s, p)))
            print(f"  start step={s:<4} phase={p}", flush=True)
        time.sleep(5)
        still = []
        for proc, fh, pt in running:
            if proc.poll() is None:
                still.append((proc, fh, pt))
            else:
                fh.close()
                r = collect(*pt)
                done.append(r)
                print(f"  done  step={r['step']:<4} phase={r['phase']:<5} "
                      f"C={r['c']} rot={r['rot']} P/S={r['pos']}/{r['sel']} "
                      f"W={r['w']} err={r['errors']} maxsw={r['maxsw']}@{r['at']}  [{int(time.time()-t0)}s]",
                      flush=True)
        running = still

    # Fill in points skipped as already-done so the table is complete.
    have = {(d["step"], d["phase"]) for d in done}
    for s, p in points:
        if (s, p) not in have:
            done.append(collect(s, p))

    print("\n=== C (best sweep score) ===")
    print("step  " + "".join(f"ph{p:<7}" for p in phases))
    for s in steps:
        row = ""
        for p in phases:
            hit = [d for d in done if d["step"] == s and d["phase"] == p]
            row += f"{hit[0]['c']:<9}" if hit else "?        "
        print(f"{s:<6}" + row)
    return 0


if __name__ == "__main__":
    sys.exit(main())