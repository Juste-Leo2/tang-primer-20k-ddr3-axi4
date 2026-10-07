#!/usr/bin/env python3
"""Per-burst xx by controller state: are xx-bursts READS or WRITES?
Compares S23 (rstep 25 zone) vs S25 (rstep 25)."""
import re
import sys

VAR = re.compile(r"\$var \w+ (\d+) (\S+) (\S+) .*\$end")
ST = {5: "RCALIB", 8: "WRITE"}


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


def vecval(bits):
    try:
        return int(bits, 2)
    except ValueError:
        return -1


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
            elif c in "bB":
                p = line[1:].split()
                if len(p) == 2:
                    k = rev.get(p[1])
                    if k is not None and cur.get(k) != p[0]:
                        cur[k] = p[0]
                        ev[k].append((t, p[0]))
    return ev


def at(evlist, t, isvec=False):
    v = None
    for tt, vv in evlist:
        if tt <= t:
            v = vv
        else:
            break
    if v is None:
        return "?"
    return vecval(v) if isvec else v


def main():
    path = sys.argv[1]
    tmin = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    q = dict(ids(path, "dQS_1", ["DQSR90"]),
             **ids(path, "iDES8_MEM_1", ["D"]),
             **ids(path, "coreArea_core", ["state"]))
    ev = series(path, {"clk": q["DQSR90"], "d": q["D"], "st": q["state"]})
    clk, d, st = ev["clk"], ev["d"], ev["st"]
    pe = [t for i, (t, v) in enumerate(clk)
          if i > 0 and clk[i - 1][1] == "0" and v == "1" and t >= tmin]
    bursts, cur = [], []
    for t in pe:
        if cur and t - cur[-1] > 50000:
            bursts.append(cur)
            cur = []
        cur.append(t)
    if cur:
        bursts.append(cur)
    for b in bursts[:14]:
        s = at(st, b[0], isvec=True)
        nxx = sum(1 for t in b if at(d, t - 1) not in "01")
        print(f"t={b[0]} n={len(b)} state={ST.get(s, s)} xx={nxx}/{len(b)}")


if __name__ == "__main__":
    main()
