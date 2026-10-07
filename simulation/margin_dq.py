#!/usr/bin/env python3
"""Margin measurement: (first driven-DQ time) - (first DQSR90 posedge time)
per idle-separated burst. Positive = samples data, negative = samples Hi-Z."""
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
        q = dict(ids(path, "dQS_1", ["DQSR90"]),
                 **ids(path, "iDES8_MEM_1", ["D"]))
        ev = series(path, {"clk": q["DQSR90"], "d": q["D"]})
        clk, d = ev["clk"], ev["d"]
        pe = [t for i, (t, v) in enumerate(clk)
              if i > 0 and clk[i - 1][1] == "0" and v == "1"]
        bursts, cur = [], []
        for t in pe:
            if cur and t - cur[-1] > 50000:
                bursts.append(cur)
                cur = []
            cur.append(t)
        if cur:
            bursts.append(cur)
        mg = []
        for b in bursts[:10]:
            t0 = b[0]
            dv = next((tt for tt, vv in d if tt >= t0 - 60000 and vv in "01"
                       and all(vv2 not in "01" for tt2, vv2 in d
                               if t0 - 60000 <= tt2 < tt)), None)
            # first driven-D at/after idle: last x->0/1 transition before/at t0
            lastx = None
            for tt, vv in d:
                if tt > t0:
                    break
                if vv in "01":
                    lastx = tt
            mg.append((t0, (lastx - t0) if lastx else None))
        name = path.split("/")[-1]
        print(f"== {name}: (firstPE, drivenDQ-minus-PE ps) [<=0 means Hi-Z at edge]")
        for t0, m in mg:
            print(f"  {t0}: {m}")


if __name__ == "__main__":
    main()
