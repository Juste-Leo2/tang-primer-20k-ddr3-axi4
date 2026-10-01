#!/usr/bin/env python3
"""Driver for DDR3 iverilog simulations (Micron ddr3.v + Gowin prim_sim.v).

Usage on Windows (PowerShell or CMD):
    python simulation/sim_ddr.py --baseline [--run]
    python simulation/sim_ddr.py --spinal [--run]

--baseline : original nand2mario ddr3_controller.v + tb_controller.v
--spinal   : Spinal-generated Ddr3ControllerSim.v + tb_spinal.v
--run      : also run vvp (default = build only)
--fastdll  : spinal sim: force DLL lock (faster)
"""
import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path

SIM = Path(__file__).resolve().parent
REPO = SIM.parent
GOWIN_SIM = SIM / "prim_sim_tb.v"
DEFINES = ["SIM", "den1024Mb", "sg25", "x16"]


def find_oss_cad_suite():
    # 1. Local tools folder (from setup.bat)
    local_oss = REPO / "tools" / "oss-cad-suite"
    if (local_oss / "bin" / "iverilog.exe").exists() or (local_oss / "bin" / "iverilog").exists():
        return local_oss

    # 2. Environment variable
    if "OSS_CAD_SUITE_HOME" in os.environ:
        p = Path(os.environ["OSS_CAD_SUITE_HOME"])
        if p.exists():
            return p

    # 3. Known default Windows user locations
    home = Path.home()
    user_oss = home / ".spinalml_tools" / "oss-cad-suite"
    if (user_oss / "bin" / "iverilog.exe").exists():
        return user_oss

    # 4. In system PATH
    which_iverilog = shutil.which("iverilog")
    if which_iverilog:
        p = Path(which_iverilog).resolve().parent.parent
        return p

    return None


OSS_DIR = find_oss_cad_suite()

if OSS_DIR:
    is_windows = sys.platform.startswith("win")
    IVERILOG = str(OSS_DIR / "bin" / ("iverilog.exe" if is_windows else "iverilog"))
    VVP = str(OSS_DIR / "bin" / ("vvp.exe" if is_windows else "vvp"))
else:
    IVERILOG = shutil.which("iverilog") or "iverilog"
    VVP = shutil.which("vvp") or "vvp"


def get_env():
    env = dict(os.environ)
    if OSS_DIR:
        bin_dir = str(OSS_DIR / "bin")
        lib_dir = str(OSS_DIR / "lib")
        sep = ";" if sys.platform.startswith("win") else ":"
        env["PATH"] = f"{bin_dir}{sep}{lib_dir}{sep}{env.get('PATH', '')}"
    return env


def sh(cmd, timeout=600):
    print("$", " ".join(cmd), flush=True)
    env = get_env()
    p = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout,
                       errors="replace", env=env)
    if p.stdout:
        print(p.stdout[-4000:], flush=True)
    if p.stderr:
        print("STDERR:", p.stderr[-4000:], flush=True)
    return p.returncode


def sh_stream(cmd, fh, timeout):
    print("$", " ".join(cmd), flush=True)
    env = get_env()
    p = subprocess.Popen(cmd, stdout=fh, stderr=subprocess.STDOUT, env=env)
    try:
        return p.wait(timeout=timeout)
    except subprocess.TimeoutExpired:
        p.kill()
        fh.write("\n[TIMEOUT]\n")
        return 124


def build(top_files, out_vvp, extra_defines=()):
    cmd = [IVERILOG, "-o", str(out_vvp)]
    for d in DEFINES + list(extra_defines):
        cmd += ["-D", d]
    # Include SIM directory so local 1024Mb_ddr3_parameters.vh is automatically found
    cmd += ["-g", "2012", "-I", str(SIM)]
    cmd += [str(f) for f in top_files]
    return sh(cmd)


def run(vvp_file, timeout=900):
    log = SIM / (Path(vvp_file).stem + ".log")
    print(f"vvp streaming -> {log}", flush=True)
    with open(log, "w") as f:
        rc = sh_stream([VVP, str(vvp_file)], f, timeout)
    return rc


def main():
    ap = argparse.ArgumentParser(description="Run DDR3 iverilog simulations")
    ap.add_argument("--baseline", action="store_true", help="original nand2mario ddr3 controller")
    ap.add_argument("--spinal", action="store_true", help="SpinalHDL Ddr3ControllerSim")
    ap.add_argument("--run", action="store_true", help="also execute vvp after build")
    ap.add_argument("--fastdll", action="store_true", help="spinal sim: force DLL lock")
    args = ap.parse_args()

    if not shutil.which(IVERILOG) and not Path(IVERILOG).exists():
        print(f"ERROR: iverilog executable not found at '{IVERILOG}'.", file=sys.stderr)
        print("Please run setup.bat or ensure oss-cad-suite is in tools/ or PATH.", file=sys.stderr)
        return 1

    if args.baseline:
        out = SIM / "tb_orig.vvp"
        rc = build([SIM / "tb_controller.v",
                    SIM / "ddr3_vanilla.v",
                    SIM / "ddr3_controller_sim.v",
                    GOWIN_SIM], out)
        print("BUILD rc =", rc)
        if rc == 0 and args.run:
            run(out)
    elif args.spinal:
        out = SIM / "tb_spinal.vvp"
        extra = ["FASTDLL"] if args.fastdll else []
        rc = build([SIM / "tb_spinal.v",
                    SIM / "ddr3_vanilla.v",
                    REPO / "hw" / "gen" / "Ddr3ControllerSim.v",
                    GOWIN_SIM], out, extra_defines=extra)
        print("BUILD rc =", rc)
        if rc == 0 and args.run:
            run(out)
    else:
        ap.print_help()
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
