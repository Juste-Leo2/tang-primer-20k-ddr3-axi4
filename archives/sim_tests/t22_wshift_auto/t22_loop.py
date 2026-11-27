"""Driver boucle t22 : t21-short a 0, puis +p1-short a +1 si incomplet.

t22 = litteralement t21 deux fois (re-init entre les runs, pas grave) :
  phase A : t21_auto.vvp +step=N +trt=1 -> lit le NOTE tries=001.
    score == 8 -> verdict wshift=0, pas de relance.
  phase B (sinon) : t22_auto.vvp +step=N +trt=1 +p1 -> lit tries=001.
    verdict = strictement mieux gagne (comme C), sinon 0.
Usage : python sim_tests/t22_wshift_auto/t22_loop.py  (lance en fond)
"""
import re
import subprocess
import sys
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent.parent
sys.path.insert(0, str(REPO / "sim_tests"))
from run import VVP, get_env  # noqa: E402  (oss PATH bin+lib)

SIM = REPO / "simulation"
GEN = REPO / "sim_tests" / "gen"
T21 = GEN / "t21_auto.vvp"
T22 = GEN / "t22_auto.vvp"

CHK = re.compile(
    r"NOTE RCALIB chk pos=0 sel=1 .*?score=(\S+) rot=\S+ latch=([0-9a-fA-FxX]+)"
    r" best=\S+ tries=001"
)


def run_vvp(vvp, step, extra, log, mode):
    cmd = [VVP, str(vvp), "+step=%d" % step, "+trt=1"] + extra
    with open(log, mode) as fh:
        fh.write("--- %s step=%d %s ---\n" % (
            vvp.name, step, " ".join(extra) if extra else "shift0"))
        fh.flush()
        r = subprocess.run(cmd, stdout=fh, stderr=subprocess.STDOUT,
                           timeout=1500, env=get_env(), cwd=str(SIM))
    return r.returncode


def parse(log, occ=0):
    """occ=0 : phase A (1er tries=001), occ=1 : phase B (2e, log appende)."""
    txt = open(log, errors="replace").read()
    ms = CHK.findall(txt)
    if len(ms) <= occ:
        return None
    return ms[occ][0], ms[occ][1]


def score_val(s):
    if s == "8":
        return 8
    return int(s) if s.isdigit() else -1


def loop(step):
    log = GEN / ("t22_%02d.log" % step)  # un seul log/step, phase B appendee
    run_vvp(T21, step, [], log, "w")
    pa = parse(log)
    if pa and score_val(pa[0]) == 8:
        line = "T22L DONE step=%d wshift=0 scoreA=8 scoreB=- latch=%s" % (step, pa[1])
        print(line, flush=True)
        return line
    run_vvp(T22, step, ["+p1"], log, "a")
    pb = parse(log, 1)
    sa = score_val(pa[0]) if pa else -1
    sb = score_val(pb[0]) if pb else -1
    w = 1 if sb > sa else 0
    line = "T22L DONE step=%d wshift=%d scoreA=%d scoreB=%d latchB=%s" % (
        step, w, sa, sb, pb[1] if pb else "?")
    print(line, flush=True)
    return line


if __name__ == "__main__":
    steps = [5, 23, 25, 40, 50, 60]
    with ThreadPoolExecutor(max_workers=6) as ex:
        list(ex.map(loop, steps))
    print("ALL DONE", flush=True)
