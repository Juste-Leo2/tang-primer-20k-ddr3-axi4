"""Traces t21 de reference en parallele (1 iteration, +trt=1).

Reutilise le binaire t21_auto.vvp (tb_t21.v intact) : 6 steps courts,
un seul log gen/t21_<step>.log par step (convention run.py),
verdict = NOTE tries=001 (score/latch bus-level).
Usage : python sim_tests/t21_fifo_trace/t21_loop.py  (lance en fond)
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

CHK = re.compile(
    r"NOTE RCALIB chk pos=0 sel=1 .*?score=(\S+) rot=\S+ latch=([0-9a-fA-FxX]+)"
    r" best=\S+ tries=001"
)


def trace(step):
    log = GEN / ("t21_%02d.log" % step)
    cmd = [VVP, str(T21), "+step=%d" % step, "+trt=1"]
    with open(log, "w") as fh:
        subprocess.run(cmd, stdout=fh, stderr=subprocess.STDOUT,
                       timeout=1500, env=get_env(), cwd=str(SIM))
    txt = open(log, errors="replace").read()
    m = CHK.search(txt)
    line = "T21L step=%d score=%s latch=%s" % (
        step, m.group(1) if m else "?", m.group(2) if m else "?")
    print(line, flush=True)
    return line


if __name__ == "__main__":
    with ThreadPoolExecutor(max_workers=6) as ex:
        list(ex.map(trace, [5, 23, 25, 40, 50, 60]))
    print("ALL DONE", flush=True)
