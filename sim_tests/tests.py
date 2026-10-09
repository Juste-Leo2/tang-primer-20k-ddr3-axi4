"""Registre des mini-TB sim_tests : un seul endroit à maintenir.

Par test : sources, defines, plusargs, timeout (s), regex de verdict.
Le verdict est une ligne `TNN PASS` / `TNN FAIL ...` affichée par le TB.
"""
import re

TESTS = {
    "t01": {
        "name": "t01_dqs_law",
        "dir": "t01_dqs_law",
        "tb": "tb_t01.v",
        "includes": ["simulation", "sim_tests/common"],
        "defines": [],
        "plusargs": [],
        "timeout": 120,
        "verdict": re.compile(r"^T01 (PASS|FAIL)"),
    },
}
