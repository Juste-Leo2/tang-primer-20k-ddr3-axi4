#!/usr/bin/env python3
"""VCD micro-window analysis: DQSR90 edges per burst + WPOINT/RPOINT tracks.
Usage: python3 simulation/analyze_vcd.py tb_fast_win_s23_m0.vcd [N6 ...]
Streams the file (never loads it)."""
import re
import sys
from collections import defaultdict

VAR = re.compile(r"\$var \w+ (\d+) (\S+) (\S+) .*\$end")


def find_ids(path):
    """scope-path-substring, signal name -> id (first hit wins)."""
    scope, ids = [], {}
    want = {}
    with open(path, errors="replace") as f:
        for line in f:
            if len(line) > 200000:
                continue
            s = line.strip()
            if s.startswith("$scope"):
                scope.append(s.split()[-2])
            elif s.startswith("$upscope"):
                scope.pop()
            elif s.startswith("$var"):
                m = VAR.match(s)
                if m:
                    w, i, name = int(m.group(1)), m.group(2), m.group(3)
                    p = "/".join(scope)
                    if "dQS_1" in p or "dQS_2" in p:
                        for key in ("DQSR90", "WPOINT", "RPOINT", "HOLD"):
                            if name == key or name.endswith("_" + key):
                                k = (p.split("/")[-1], key)
                                ids.setdefault(k, (i, w))
            elif s.startswith("$enddefinitions"):
                break
    return ids


def parse(path, ids):
    rev = {v[0]: (k, v[1]) for k, v in ids.items()}
    t, cur = 0, {}
    ev = defaultdict(list)  # (lane, sig) -> [(t, val)]
    vec = {}
    with open(path, errors="replace") as f:
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
                ent = rev.get(line[1:].strip())
                if ent:
                    (lane, sig), w = ent
                    v = c if c in "01" else "x"
                    if cur.get((lane, sig)) != v:
                        cur[(lane, sig)] = v
                        ev[(lane, sig)].append((t, v))
            elif c in "bB":
                parts = line[1:].split()
                if len(parts) == 2:
                    ent = rev.get(parts[1])
                    if ent:
                        (lane, sig), w = ent
                        v = parts[0]
                        if cur.get((lane, sig)) != v:
                            cur[(lane, sig)] = v
                            ev[(lane, sig)].append((t, v))
    return ev


def bursts(edges, gap):
    out, cur = [], []
    for t, v in edges:
        if cur and t - cur[-1][0] > gap:
            out.append(cur)
            cur = []
        cur.append((t, v))
    if cur:
        out.append(cur)
    return out


def main():
    path = sys.argv[1]
    ids = find_ids(path)
    print("tracked:", {k: v[0] for k, v in ids.items()})
    ev = parse(path, ids)
    for lane in ("dQS_1", "dQS_2"):
        dq = ev.get((lane, "DQSR90"), [])
        wp = ev.get((lane, "WPOINT"), [])
        rp = ev.get((lane, "RPOINT"), [])
        pos = sum(1 for i in range(1, len(dq)) if dq[i - 1][1] == "0" and dq[i][1] == "1")
        print(f"--- {lane}: DQSR90 transitions={len(dq)} posedges={pos} "
              f"WPOINT-changes={len(wp)} RPOINT-changes={len(rp)}")
        bs = bursts(dq, 50000)
        print(f"    bursts (gap>50ns): {len(bs)}")
        for b in bs[:14]:
            pe = sum(1 for i in range(1, len(b)) if b[i - 1][1] == "0" and b[i][1] == "1")
            t0, t1 = b[0][0], b[-1][0]
            wv = [v for t, v in wp if t0 - 1 <= t <= t1 + 1]
            rv = [v for t, v in rp if t0 - 1 <= t <= t1 + 1]
            print(f"    t={t0}..{t1} ({(t1-t0)/1000:.1f}ns) trans={len(b)} "
                  f"posedge={pe} W={wv[-3:] if len(wv) > 3 else wv} "
                  f"R={rv[-3:] if len(rv) > 3 else rv}")


if __name__ == "__main__":
    main()
