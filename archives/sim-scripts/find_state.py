#!/usr/bin/env python3
"""Label each DQSR90 burst with the controller state (READ_CALIB vs WRITE)."""
import re
import sys

VAR = re.compile(r"\$var \w+ (\d+) (\S+) (\S+) .*\$end")
path = sys.argv[1]

cur, state_id, cycle_id = [], None, None
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
            if m and cur and cur[-1] == "coreArea_core":
                if m.group(3) == "state":
                    state_id = m.group(2)
                elif m.group(3) == "cycle":
                    cycle_id = m.group(2)
        elif s.startswith("$enddefinitions"):
            break
print("state:", state_id, "cycle:", cycle_id)
