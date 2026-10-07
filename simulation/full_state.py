#!/usr/bin/env python3
"""Full discrete-state snapshot per burst cluster.
Usage: full_state.py <vcd>
For each DQSR90 cluster: t0, n, xx, and core/model regs at t0
(s2Mag, tries, pinLeft, anchorLeft, settleLeft, aligning, state, cycle,
pos, sel, rstep, HOLD, RLOADN, RMOVE, RDIR, WPOINT, RPOINT, dqs_en, rd_en).
"""
import re
import sys

VAR = re.compile(r"\$var \w+ (\d+) (\S+) (\S+) .*\$end")
ST = {"0101": "RCALIB", "1000": "WRITE"}


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
            elif c in "01xzXZ":
                k = rev.get(line[1:].strip())
                if k is not None and want[k][1] == 1 and cur.get(k) != c:
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


def bi(bits):
    try:
        return str(int(bits, 2))
    except ValueError:
        return bits


def main():
    path = sys.argv[1]
    q = scope_ids(path, "dQS_1", ["DQSR90", "HOLD", "RLOADN", "RMOVE",
                                  "RDIR", "rstep_reg", "WPOINT", "RPOINT",
                                  "dqs_en", "rd_en"])
    q.update(scope_ids(path, "iDES8_MEM_1", ["D"]))
    q.update(scope_ids(path, "coreArea_core",
                        ["s2Mag", "rcalib_tries", "pinLeft", "anchorLeft",
                         "settleLeft", "aligning", "state", "cycle",
                         "rclkpos", "rclksel"]))
    ev = series(path, q)
    clk, d = ev["DQSR90"], ev["D"]
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
    print(f"bursts={len(bursts)}")
    for b in bursts:
        t0 = b[0]
        xx = sum(1 for t in b if at(d, t - 1) not in "01")
        g = lambda k: ev[k] if k in ev else []
        st = at(g("state"), t0)
        print(f"t={t0} n={len(b)} xx={xx}/{len(b)} "
              f"st={ST.get(st, st)} cyc={bi(at(g('cycle'), t0))} "
              f"s2mag={bi(at(g('s2Mag'), t0))} tries={at(g('tries'), t0) if 'tries' in ev else bi(at(g('rcalib_tries'), t0))} "
              f"pin={bi(at(g('pinLeft'), t0))} anc={bi(at(g('anchorLeft'), t0))} set={bi(at(g('settleLeft'), t0))} alg={at(g('aligning'), t0)} "
              f"pos={bi(at(g('rclkpos'), t0))} sel={bi(at(g('rclksel'), t0))} "
              f"rstep={bi(at(g('rstep_reg'), t0))} HOLD={at(g('HOLD'), t0)} "
              f"RMOVE={at(g('RMOVE'), t0)} W={at(g('WPOINT'), t0)} R={at(g('RPOINT'), t0)} "
              f"den={at(g('dqs_en'), t0)} ren={at(g('rd_en'), t0)}")


if __name__ == "__main__":
    main()
