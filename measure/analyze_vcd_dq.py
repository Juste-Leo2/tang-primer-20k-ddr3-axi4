#!/usr/bin/env python3
"""Per-posedge DQ sampling: what does D hold at each DQSR90 rising edge?
Detects Hi-Z (x) sampling, esp. at burst-first edges (preamble)."""
import re
import sys

VAR = re.compile(r"\$var \w+ (\d+) (\S+) (\S+) .*\$end")


def scope_vars(path, scope, names):
    out, cur, want = {}, [], set(names)
    with open(path, errors='replace') as f:
        for line in f:
            if len(line) > 200000:
                continue
            s = line.strip()
            if s.startswith("$scope"):
                cur.append(s.split()[-2])
            elif s.startswith("$upscope"):
                cur.pop()
            elif s.startswith("$var"):
                m = VAR.match(s)
                if m and cur and cur[-1] == scope and m.group(3) in want:
                    out[m.group(3)] = m.group(2)
            elif s.startswith("$enddefinitions"):
                break
    return out


def series(path, ids):
    """id -> sorted [(t, val)] (scalar only)."""
    rev = {v: k for k, v in ids.items()}
    cur, ev = {}, {k: [] for k in ids.keys()}
    t = 0
    with open(path, errors='replace') as f:
        for line in f:
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
    path = sys.argv[1]
    dqs = scope_vars(path, "dQS_1", ["DQSR90"])
    l0 = scope_vars(path, "iDES8_MEM_1", ["D"])
    l8 = scope_vars(path, "iDES8_MEM_9", ["D"])
    print("ids:", dqs, l0, l8)
    ids = {"clk": dqs["DQSR90"], "d0": l0["D"], "d8": l8["D"]}
    ev = series(path, ids)
    clk, d0, d8 = ev["clk"], ev["d0"], ev["d8"]
    pe = [t for i, (t, v) in enumerate(clk)
          if i > 0 and clk[i - 1][1] == "0" and v == "1"]
    print(f"posedges: {len(pe)}")

    def at(evlist, t):
        v = "?"
        for tt, vv in evlist:
            if tt <= t:
                v = vv
            else:
                break
        return v

    # group into bursts (gap > 50ns), report first 3 posedges' D per burst
    bursts, cur = [], []
    for t in pe:
        if cur and t - cur[-1] > 50000:
            bursts.append(cur)
            cur = []
        cur.append(t)
    if cur:
        bursts.append(cur)
    print(f"bursts: {len(bursts)}")
    for b in bursts[:16]:
        row = []
        for t in b[:4]:
            row.append(f"{at(d0, t - 1)}{at(d8, t - 1)}")
        x = sum(1 for t in b if at(d0, t - 1) not in "01")
        print(f"  t={b[0]} n={len(b)} firstD(l0l8)={row} xCount(l0)={x}/{len(b)}")


if __name__ == "__main__":
    main()
