#!/usr/bin/env python3
"""Ps-precision edge dump around a burst: DQSIN, DQSR90, D, ODT.
Usage: edge_dump.py <vcd> <t0_ps> ; prints events in [t0-8000, t0+8000]."""
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
                    out[m.group(3)] = m.group(2)
            elif s.startswith("$enddefinitions"):
                break
    return out


def main():
    path, t0 = sys.argv[1], int(sys.argv[2])
    q = scope_ids(path, "dQS_1", ["DQSR90", "DQSIN"])
    q.update(scope_ids(path, "iDES8_MEM_1", ["D"]))
    q.update(scope_ids(path, "tb_spinal", ["odt"]))
    rev = {v: k for k, v in q.items()}
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
            elif c in "01xzXZ" and t0 - 8000 <= t <= t0 + 8000:
                k = rev.get(line[1:].strip())
                if k is not None:
                    print(f"{t - t0:+7d}ps  {k} -> {c}")


if __name__ == "__main__":
    main()
