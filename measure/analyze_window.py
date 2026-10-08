#!/usr/bin/env python3
"""Partial window-battery analysis (safe to run while sims are going)."""
import re
import collections
from pathlib import Path

SIM = Path(__file__).resolve().parent
CHK = re.compile(r"NOTE RCALIB chk pos=(\d) sel=(\d).*?score=(\d) rot=(\d) latch=([0-9a-f]+)")
WIN = re.compile(r"RCALIB window side=(\w+) mag=(\w+) pos=(\w+) rot=(\w+) score=(\w+)")
WSTART = re.compile(r"RCALIB window start mag0=(\w+) n=(\w+)")


def one(p):
    rows, win, started = [], None, False
    with open(p, errors="replace") as f:
        for line in f:
            m = CHK.search(line)
            if m:
                rows.append(m.groups())
                continue
            m = WIN.search(line)
            if m:
                win = m.groups()
                continue
            if WSTART.search(line):
                started = True
    return rows, win, started


def main():
    logs = sorted(
        (p for p in SIM.glob("tb_fast_s*_m*.log")
         if re.match(r"tb_fast_s\d+_m\d+$", p.stem)),
        key=lambda p: (int(p.stem.split("_")[2][1:]), p.stem))
    mat = collections.defaultdict(dict)
    for p in logs:
        m = re.match(r"tb_fast_s(\d+)_m(\d+)", p.stem)
        s, mg = int(m.group(1)), int(m.group(2))
        rows, win, started = one(p)
        mx = max([int(r[2]) for r in rows], default=-1)
        st = f"W{win[4]}@{win[1]}" if win else ("..." if started or rows else "WL")
        mat[s][mg] = (mx, st, len(rows))
    steps = sorted(mat)
    mags = sorted({m for v in mat.values() for m in v})
    print("=== maxsw / status per (step x mag0) ===")
    print("step  " + "".join(f"m{m:<11}" for m in mags))
    for s in steps:
        row = ""
        for m in mags:
            if m in mat[s]:
                mx, st, n = mat[s][m]
                row += f"{mx} {st}({n})".ljust(12)
            else:
                row += "?           "
        print(f"{s:<6}" + row)


if __name__ == "__main__":
    main()
