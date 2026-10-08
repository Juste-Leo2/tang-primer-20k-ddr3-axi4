#!/usr/bin/env python3
"""Per-burst context: rstep, HOLD/RLOADN/RMOVE activity just before, first-D xx.
One line per burst. Usage: audit_burst.py <vcd> [max_bursts]"""
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
    # want: name -> (id, width); returns name -> [(t, valstr)]
    rev, width = {}, {}
    for k, (i, w) in want.items():
        rev[i] = k
        width[k] = w
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
                if k is not None and width[k] == 1 and cur.get(k) != c:
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


def at(evlist, t, default="?"):
    v = default
    for tt, vv in evlist:
        if tt <= t:
            v = vv
        else:
            break
    return v


def any_in(evlist, lo, hi):
    return any(lo <= tt <= hi for tt, vv in evlist)


def main():
    path = sys.argv[1]
    nmax = int(sys.argv[2]) if len(sys.argv) > 2 else 14
    q = scope_ids(path, "dQS_1", ["DQSR90", "RLOADN", "RMOVE", "HOLD", "rstep_reg"])
    q.update(scope_ids(path, "iDES8_MEM_1", ["D"]))
    print("ids:", {k: v[0] for k, v in q.items()})
    ev = series(path, q)
    clk, d = ev["clk"] if "clk" in ev else ev["DQSR90"], ev["D"]
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
    print(f"posedges={len(pe)} bursts={len(bursts)}")
    for b in bursts[:nmax]:
        t0 = b[0]
        rs = at(ev["rstep_reg"], t0)
        try:
            rsi = int(rs, 2)
        except ValueError:
            rsi = rs
        xx = sum(1 for t in b if at(d, t - 1) not in "01")
        f0 = "".join(at(d, t - 1) for t in b[:2])
        hold = any_in(ev["HOLD"], t0 - 200000, t0)
        rldn = any_in(ev["RLOADN"], t0 - 200000, t0)
        rmv = [tt for tt, vv in ev["RMOVE"] if t0 - 400000 <= tt <= t0 and vv == "1"]
        print(f"  t={t0} n={len(b)} rstep={rsi} HOLDpre={int(hold)} "
              f"RLOADNpre={int(rldn)} RMOVEpre={len(rmv)} first2D={f0} xx={xx}/{len(b)}")


if __name__ == "__main__":
    main()
