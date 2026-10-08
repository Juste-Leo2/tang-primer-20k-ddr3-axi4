#!/usr/bin/env python3
"""Compare two tb_fast logs (e.g. STEP 25 vs 23): per-phase scores, best
latches split per 16-bit lane, exit type, RESULT. Usage:
  python3 compare_runs.py <runA.log> <runB.log>
"""
import re
import sys

CHK = re.compile(
    r"NOTE RCALIB chk pos=(\d) sel=(\d) seen=(\d) score=(\d) rot=(\d) "
    r"latch=([0-9a-f]+) best=(\d) tries=([0-9a-f]+)"
)
NOTE = re.compile(r"NOTE RCALIB (dll side switch to minus|dll side=.*|lock best .*)")
RES = re.compile(r"RESULT (.*) (PASS|FAIL)")


def lanes(latch):
    return [latch[i:i + 4] for i in range(0, 32, 4)]


def parse(path):
    segs, cur = [], []
    notes, result = [], None
    with open(path, errors="replace") as f:
        for line in f:
            m = CHK.search(line)
            if m:
                pos, sel, seen, score, rot, latch, best, tries = m.groups()
                if tries == "00" and cur:
                    segs.append(cur)
                    cur = []
                cur.append(dict(pos=int(pos), sel=int(sel), score=int(score),
                                rot=int(rot), latch=latch))
                continue
            m = NOTE.search(line)
            if m:
                notes.append(m.group(1))
                continue
            m = RES.search(line)
            if m:
                result = m.groups()
    if cur:
        segs.append(cur)
    return segs, notes, result


def show(name, path):
    segs, notes, result = parse(path)
    print(f"=== {name} ({path}) ===")
    print(f"RESULT: {result}")
    print(f"RCALIB notes: {notes}")
    for i, seg in enumerate(segs):
        scores = [c["score"] for c in seg]
        mx = max(scores)
        at8 = sum(1 for s in scores if s == 8)
        perpos = {}
        for c in seg:
            perpos[c["pos"]] = max(perpos.get(c["pos"], 0), c["score"])
        best = next(c for c in seg if c["score"] == mx)
        print(f"seg{i} n={len(seg)} max={mx} n8={at8} perpos={perpos}")
        print(f"  best latch: {best['latch']} (pos={best['pos']} rot={best['rot']})")
    return segs, result


def main():
    if len(sys.argv) != 3:
        print("usage: compare_runs.py <runA.log> <runB.log>")
        sys.exit(2)
    segs_a, res_a = show("A", sys.argv[1])[:2], None
    segs_b, res_b = show("B", sys.argv[2])[:2], None
    # lane-level diff of sweep-best latches (seg2 = sweep if 4 segments)
    for tag, segs in (("A", segs_a), ("B", segs_b)):
        if len(segs) >= 3:
            seg = segs[2]
            mx = max(c["score"] for c in seg)
            best = next(c for c in seg if c["score"] == mx)
            print(f"{tag} sweep-best lanes: {lanes(best['latch'])} score={mx}")
    if len(segs_a) >= 3 and len(segs_b) >= 3:
        la = lanes(next(c for c in segs_a[2]
                        if c["score"] == max(x["score"] for x in segs_a[2]))["latch"])
        lb = lanes(next(c for c in segs_b[2]
                        if c["score"] == max(x["score"] for x in segs_b[2]))["latch"])
        print("lane : " + " ".join(f"{i:>4}" for i in range(8)))
        print("A    : " + " ".join(f"{v:>4}" for v in la))
        print("B    : " + " ".join(f"{v:>4}" for v in lb))
        print("diff : " + " ".join("   ^" if a != b else "    " for a, b in zip(la, lb)))


if __name__ == "__main__":
    main()
