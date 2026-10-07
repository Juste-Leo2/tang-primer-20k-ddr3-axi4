#!/usr/bin/env python3
"""Detector-state comparison: dqs_set / rstn_det / dqs_r_clean around the
first post-anchor bursts, S23 (pinned) vs S25 (never pinned)."""
import re
import sys

VAR = re.compile(r"\$var \w+ (\d+) (\S+) (\S+) .*\$end")


def ids(path, scope, names):
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


def series(path, want):
    rev = {v: k for k, v in want.items()}
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
            elif c in "01xzXZ":
                k = rev.get(line[1:].strip())
                if k is not None and cur.get(k) != c:
                    cur[k] = c
                    ev[k].append((t, c))
    return ev


def main():
    for path in sys.argv[1:]:
        q = dict(ids(path, "dQS_1", ["DQSR90", "dqs_r_clean", "dqs_set",
                                     "rstn_det", "HOLD", "WPOINT"]))
        ev = series(path, {"clk": q["DQSR90"], "clean": q["dqs_r_clean"],
                            "set": q["dqs_set"], "rst": q["rstn_det"],
                            "h": q["HOLD"], "w": q["WPOINT"]})
        clk = ev["clk"]
        pe = [t for i, (t, v) in enumerate(clk)
              if i > 0 and clk[i - 1][1] == "0" and v == "1"]
        print(f"== {path.split('/')[-1]}: {len(pe)} posedges")
        for t in pe[:6]:
            row = {}
            for k in ("clean", "set", "rst", "h", "w"):
                v = "?"
                for tt, vv in ev[k]:
                    if tt <= t + 1:
                        v = vv
                    else:
                        break
                row[k] = v
            print(f"  pe@{t}: " + " ".join(f"{k}={v}" for k, v in row.items()))


if __name__ == "__main__":
    main()
