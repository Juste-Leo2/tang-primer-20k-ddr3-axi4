#!/usr/bin/env python3
"""Diff the VCD variable sets (scope, name, width) between two VCDs.
Usage: var_diff.py <a.vcd> <b.vcd>  (prints only-in-each, capped)."""
import re
import sys

VAR = re.compile(r"\$var \w+ (\d+) (\S+) (\S+) .*\$end")


def varset(path):
    cur, out = [], set()
    with open(path, errors="replace") as fh:
        for line in fh:
            if len(line) > 200000:
                continue
            t = line.strip()
            if t.startswith("$scope"):
                cur.append(t.split()[-2])
            elif t.startswith("$upscope"):
                if cur:
                    cur.pop()
            elif t.startswith("$var"):
                m = VAR.match(t)
                if m:
                    out.add(("/".join(cur), m.group(3), m.group(1)))
            elif t.startswith("$enddefinitions"):
                break
    return out


def main():
    a = varset(sys.argv[1])
    b = varset(sys.argv[2])
    print(f"a vars: {len(a)}  b vars: {len(b)}")
    oa = sorted(a - b)
    ob = sorted(b - a)
    print(f"only in a ({len(oa)}):")
    for x in oa[:20]:
        print("  ", x)
    print(f"only in b ({len(ob)}):")
    for x in ob[:20]:
        print("  ", x)


if __name__ == "__main__":
    main()
