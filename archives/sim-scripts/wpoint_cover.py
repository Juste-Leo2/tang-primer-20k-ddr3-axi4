#!/usr/bin/env python3
"""WPOINT coverage per double-burst + RPOINT at latch time.
Usage: wpoint_cover.py <vcd> <t0_ps>  (t0 = first posedge of the double-burst)
"""
import re
import sys

VAR = re.compile(r"\$var \w+ (\d+) (\S+) (\S+) .*\$end")


def scope_ids(path, scope, names):
    out, cur = {}, []
    with open(path, errors="replace") as fh:
        for line in fh:
            if len(line) > 200000:
                continue
            s = line.strip()
            if s.startswith("$scope"):
                cur.append(s.split()[-2])
            elif s.startswith("$upscope"):
                if cur:
                    cur.pop()
            elif s.startswith("$var"):
                m = VAR.match(s)
                if m and cur and cur[-1] == scope and m.group(3) in names:
                    out[m.group(3)] = (m.group(2), int(m.group(1)))
            elif s.startswith("$enddefinitions"):
                break
    return out


def series(path, want):
    rev = {v[0]: k for k, v in want.items()}
    cur, ev = {}, {k: [] for k in want}
    t = 0
    with open(path, errors="replace") as fh:
        for line in fh:
            if not line or len(line) > 1000:
                continue
            c = line[0]
            if c == "#":
                try:
                    t = int(line[1:])
                except ValueError:
                    pass
            elif c in "bB":
                p = line[1:].split()
                if len(p) == 2:
                    k = rev.get(p[1])
                    if k is not None and cur.get(k) != p[0]:
                        cur[k] = p[0]
                        ev[k].append((t, p[0]))
    return ev


def at(evlist, t, default="?"):
    v = default
    for tt, vv in evlist:
        if tt <= t:
            v = vv
        else:
            break
    return v


def main():
    path, t0 = sys.argv[1], int(sys.argv[2])
    q = scope_ids(path, "dQS_1", ["WPOINT", "RPOINT"])
    ev = series(path, q)
    wp, rp = ev["WPOINT"], ev["RPOINT"]
    t1 = t0 + 25000  # double-burst ~10ns + margin
    seq = [v for t, v in wp if t0 - 3000 <= t <= t1]
    print(f"WPOINT seq during double-burst @{t0}: {seq}")
    print(f"  distinct W cells written: {sorted(set(seq))} ({len(set(seq))}/8)")
    r_latch = at(rp, t0 + 60000)
    print(f"RPOINT @+60ns (latch-stable): {r_latch} = {int(r_latch, 2)}")


if __name__ == "__main__":
    main()
