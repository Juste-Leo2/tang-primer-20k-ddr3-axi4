#!/usr/bin/env python3
"""Nested-K battery analysis: per-point summary + K-group gap-eye tables."""
import re
import collections
import sys
from pathlib import Path

SIM = Path(__file__).resolve().parent
CHK = re.compile(
    r"NOTE RCALIB chk pos=(\d) sel=(\d)(?: side=(\d) mag=(\w+) k=(\d))?"
    r".*?score=(\d) rot=(\d) latch=([0-9a-f]+).*?best=(\d+)(?: bestK=(\d+))?.*?tries=([0-9a-f]+)")
LOCK = re.compile(r"RCALIB lock best pos=(\d) sel=(\d) rot=(\d+) score=(\w+)")
RES = re.compile(r"RESULT step=(\d+).*?errors=(\d+) (\w+)")
EXIT = re.compile(r"RCALIB dll side=(\w+) mag=(\w+) pos=(\w+) score=(\w+)")
SW = re.compile(r"RCALIB dll side switch to minus")


def load(p):
    rows = []
    locks, res, exits, switched = [], None, [], False
    with open(p, errors="replace") as f:
        for line in f:
            m = CHK.search(line)
            if m:
                rows.append(m.groups())
                continue
            m = LOCK.search(line)
            if m:
                locks.append(m.groups())
                continue
            m = RES.search(line)
            if m:
                res = m.groups()
                continue
            m = EXIT.search(line)
            if m:
                exits.append(m.groups())
                continue
            if SW.search(line):
                switched = True
    return rows, locks, res, exits, switched


def main():
    steps = sys.argv[1:] or ["20", "23", "25", "26", "40", "60", "64"]
    for s in steps:
        p = SIM / f"tb_fast_s{s}_p0.log"
        if not p.exists():
            print(f"--- step {s}: NO LOG")
            continue
        rows, locks, res, exits, switched = load(p)
        scores = collections.Counter(r[5] for r in rows)
        print(f"=== step {s}: {res[2] if res else '?'} err={res[1] if res else '?'} "
              f"slots={len(rows)} switched={switched}")
        print(f"  scores: {dict(sorted(scores.items()))}")
        print(f"  locks: {locks}")
        print(f"  exits: {exits}")
        # max score + where (new chk has side/mag/k)
        withk = [r for r in rows if r[2] is not None]
        if withk:
            mx = max(int(r[5]) for r in withk)
            at = sorted({(r[2], r[3], r[4]) for r in withk if int(r[5]) == mx})
            print(f"  maxsw={mx} at (side/mag/k)={at[:12]}")
            # score by K-group
            byk = collections.defaultdict(list)
            for r in withk:
                byk[(r[2], r[4])].append(int(r[5]))
            print("  max by (side,K): " + " ".join(
                f"{k}={max(v)}" for k, v in sorted(byk.items())))
        print()


if __name__ == "__main__":
    main()
