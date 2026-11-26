#!/usr/bin/env python3
"""Fast FPGA flash + COM8 UART monitor loop for Tang Primer 20K (DDR3 bring-up).

Examples:
    python fpga_run.py                  # Flash existing .fs to SRAM (-m) + read COM8
    python fpga_run.py --build          # Mill regen + gw_sh + flash + read COM8
    python fpga_run.py --build --skip-compile  # gw_sh PnR only + flash + read COM8
    python fpga_run.py --no-flash --timeout 0  # Continuous COM8 monitor
"""

import argparse
import ctypes
from ctypes import wintypes
import os
import subprocess
import sys
import time
from pathlib import Path

REPO = Path(__file__).resolve().parent
DEFAULT_FS = REPO / "build_eda" / "impl" / "pnr" / "Ddr3TesterTop.fs"
OSS_BIN = REPO / "tools" / "oss-cad-suite" / "bin"
OSS_LIB = REPO / "tools" / "oss-cad-suite" / "lib"
OPENFPGA_EXE = OSS_BIN / "openFPGALoader.exe"


def build_eda_env() -> dict:
    env = os.environ.copy()
    extra = [str(OSS_BIN), str(OSS_LIB)]
    env["PATH"] = os.pathsep.join(extra) + os.pathsep + env.get("PATH", "")
    return env


class Win32Serial:
    """Minimal zero-dependency Win32 serial reader via kernel32 ctypes."""

    GENERIC_READ = 0x80000000
    GENERIC_WRITE = 0x40000000
    OPEN_EXISTING = 3
    INVALID_HANDLE_VALUE = wintypes.HANDLE(-1).value
    PURGE_RXCLEAR = 0x0008
    PURGE_TXCLEAR = 0x0004

    class DCB(ctypes.Structure):
        _fields_ = [
            ("DCBlength", wintypes.DWORD),
            ("BaudRate", wintypes.DWORD),
            ("flags", wintypes.DWORD),
            ("wReserved", wintypes.WORD),
            ("XonLim", wintypes.WORD),
            ("XoffLim", wintypes.WORD),
            ("ByteSize", ctypes.c_ubyte),
            ("Parity", ctypes.c_ubyte),
            ("StopBits", ctypes.c_ubyte),
            ("XonChar", ctypes.c_char),
            ("XoffChar", ctypes.c_char),
            ("ErrorChar", ctypes.c_char),
            ("EofChar", ctypes.c_char),
            ("EvtChar", ctypes.c_char),
            ("wReserved1", wintypes.WORD),
        ]

    class COMMTIMEOUTS(ctypes.Structure):
        _fields_ = [
            ("ReadIntervalTimeout", wintypes.DWORD),
            ("ReadTotalTimeoutMultiplier", wintypes.DWORD),
            ("ReadTotalTimeoutConstant", wintypes.DWORD),
            ("WriteTotalTimeoutMultiplier", wintypes.DWORD),
            ("WriteTotalTimeoutConstant", wintypes.DWORD),
        ]

    def __init__(self, port: str, baudrate: int = 115200, timeout: float = 0.2):
        self.k32 = ctypes.WinDLL("kernel32", use_last_error=True)
        self.k32.CreateFileW.argtypes = [
            wintypes.LPCWSTR, wintypes.DWORD, wintypes.DWORD, ctypes.c_void_p,
            wintypes.DWORD, wintypes.DWORD, wintypes.HANDLE,
        ]
        self.k32.CreateFileW.restype = wintypes.HANDLE
        self.k32.GetCommState.argtypes = [wintypes.HANDLE, ctypes.POINTER(self.DCB)]
        self.k32.GetCommState.restype = wintypes.BOOL
        self.k32.SetCommState.argtypes = [wintypes.HANDLE, ctypes.POINTER(self.DCB)]
        self.k32.SetCommState.restype = wintypes.BOOL
        self.k32.SetCommTimeouts.argtypes = [wintypes.HANDLE, ctypes.POINTER(self.COMMTIMEOUTS)]
        self.k32.SetCommTimeouts.restype = wintypes.BOOL
        self.k32.PurgeComm.argtypes = [wintypes.HANDLE, wintypes.DWORD]
        self.k32.PurgeComm.restype = wintypes.BOOL
        self.k32.ReadFile.argtypes = [
            wintypes.HANDLE, ctypes.c_void_p, wintypes.DWORD,
            ctypes.POINTER(wintypes.DWORD), ctypes.c_void_p,
        ]
        self.k32.ReadFile.restype = wintypes.BOOL
        self.k32.CloseHandle.argtypes = [wintypes.HANDLE]
        self.k32.CloseHandle.restype = wintypes.BOOL

        dev = port if port.startswith("\\\\.\\") else f"\\\\.\\{port}"
        self.handle = self.k32.CreateFileW(
            dev,
            self.GENERIC_READ | self.GENERIC_WRITE,
            0,
            None,
            self.OPEN_EXISTING,
            0,
            None,
        )
        if self.handle == self.INVALID_HANDLE_VALUE:
            err = ctypes.get_last_error()
            raise OSError(err, f"Cannot open {port} (WinError {err})")

        dcb = self.DCB()
        dcb.DCBlength = ctypes.sizeof(self.DCB)
        if not self.k32.GetCommState(self.handle, ctypes.byref(dcb)):
            err = ctypes.get_last_error()
            self.close()
            raise OSError(err, f"GetCommState failed (WinError {err})")

        dcb.BaudRate = baudrate
        dcb.ByteSize = 8
        dcb.Parity = 0    # NOPARITY
        dcb.StopBits = 0  # ONESTOPBIT
        # fBinary=1 (bit 0), fDtrControl=ENABLE (bit 4), fRtsControl=ENABLE (bit 12),
        # clear hardware/software flow control bits so RX is never gated
        dcb.flags = 0x00000001 | (1 << 4) | (1 << 12)
        if not self.k32.SetCommState(self.handle, ctypes.byref(dcb)):
            err = ctypes.get_last_error()
            self.close()
            raise OSError(err, f"SetCommState failed (WinError {err})")

        to_ms = max(1, int(timeout * 1000))
        timeouts = self.COMMTIMEOUTS(
            ReadIntervalTimeout=20,
            ReadTotalTimeoutMultiplier=0,
            ReadTotalTimeoutConstant=to_ms,
            WriteTotalTimeoutMultiplier=0,
            WriteTotalTimeoutConstant=500,
        )
        self.k32.SetCommTimeouts(self.handle, ctypes.byref(timeouts))
        self.k32.PurgeComm(self.handle, self.PURGE_RXCLEAR | self.PURGE_TXCLEAR)

    def read(self, size: int = 256) -> bytes:
        buf = ctypes.create_string_buffer(size)
        n = wintypes.DWORD(0)
        ok = self.k32.ReadFile(self.handle, buf, size, ctypes.byref(n), None)
        if not ok:
            return b""
        return buf.raw[: n.value]

    def reset_input_buffer(self):
        self.k32.PurgeComm(self.handle, self.PURGE_RXCLEAR)

    def close(self):
        if self.handle and self.handle != self.INVALID_HANDLE_VALUE:
            self.k32.CloseHandle(self.handle)
            self.handle = None


def open_serial(port: str, baudrate: int, timeout: float = 0.2):
    try:
        import serial  # type: ignore
        ser = serial.Serial(port=port, baudrate=baudrate, timeout=timeout)
        ser.reset_input_buffer()
        return ser
    except ImportError:
        return Win32Serial(port=port, baudrate=baudrate, timeout=timeout)


def run_build(skip_compile: bool) -> int:
    cmd = [sys.executable, str(REPO / "eda-flow.py"), "--preset", "ddr3"]
    if skip_compile:
        cmd.append("--skip-compile")
    print(f"[build] $ {' '.join(cmd)}", flush=True)
    return subprocess.run(cmd, cwd=str(REPO)).returncode


def flash_fpga(fs_path: Path, board: str, spi_flash: bool) -> int:
    if not OPENFPGA_EXE.exists():
        print(f"[flash] ERROR: openFPGALoader not found at {OPENFPGA_EXE}", file=sys.stderr)
        return 1
    if not fs_path.exists():
        print(f"[flash] ERROR: bitstream not found at {fs_path}", file=sys.stderr)
        return 1

    mode_flag = "-f" if spi_flash else "-m"
    mode_name = "SPI Flash (-f)" if spi_flash else "SRAM (-m)"
    cmd = [str(OPENFPGA_EXE), "-b", board, mode_flag, str(fs_path)]
    print(f"[flash] {mode_name}: {fs_path.name} ({fs_path.stat().st_size // 1024} KiB)", flush=True)
    t0 = time.monotonic()
    rc = subprocess.run(cmd, cwd=str(REPO), env=build_eda_env()).returncode
    dt = time.monotonic() - t0
    if rc == 0:
        print(f"[flash] OK in {dt:.2f}s", flush=True)
    else:
        print(f"[flash] FAILED rc={rc} after {dt:.2f}s", file=sys.stderr, flush=True)
    return rc


def monitor_uart(
    ser,
    port: str,
    baud: int,
    timeout: float,
    pass_target: int,
    fail_fast: bool,
) -> int:
    if ser is None:
        ser = open_serial(port, baud, timeout=0.15)
    print(f"[uart] Listening on {port} @ {baud} baud (timeout={timeout}s, pass_target={pass_target})...", flush=True)
    t0 = time.monotonic()
    buf = ""
    passes = 0
    fails = 0
    saw_boot = False

    try:
        while True:
            if timeout > 0 and (time.monotonic() - t0) >= timeout:
                break
            chunk = ser.read(512)
            if chunk:
                text = chunk.decode("utf-8", errors="replace")
                buf += text
                while "\n" in buf:
                    line, buf = buf.split("\n", 1)
                    line = line.rstrip("\r")
                    if not line:
                        continue
                    dt = time.monotonic() - t0
                    print(f"[+{dt:6.2f}s] {line}", flush=True)
                    if "[BOOT]" in line:
                        saw_boot = True
                    if "[PASS]" in line:
                        passes += 1
                        if pass_target > 0 and passes >= pass_target:
                            print(f"[uart] PASS target reached ({passes}/{pass_target})", flush=True)
                            return 0
                    if "[FAIL]" in line:
                        fails += 1
                        if fail_fast:
                            print("[uart] FAIL detected (fail-fast)", flush=True)
                            return 2
    except KeyboardInterrupt:
        print("\n[uart] Interrupted by user.", flush=True)
    finally:
        ser.close()

    if buf.strip():
        dt = time.monotonic() - t0
        print(f"[+{dt:6.2f}s] {buf.strip()}", flush=True)

    print(f"[uart] Summary: boot={saw_boot} passes={passes} fails={fails}", flush=True)
    if fails > 0:
        return 2
    if pass_target > 0 and passes < pass_target:
        return 3
    return 0


def main() -> int:
    ap = argparse.ArgumentParser(description="Fast FPGA flash + COM8 UART monitor loop")
    ap.add_argument("--build", action="store_true", help="Run eda-flow.py --preset ddr3 before flashing")
    ap.add_argument("--skip-compile", action="store_true", help="With --build, skip Mill Ddr3Gen")
    ap.add_argument("--fs", type=Path, default=DEFAULT_FS, help="Bitstream .fs path")
    ap.add_argument("--board", default="tangprimer20k", help="openFPGALoader board target")
    ap.add_argument("--spi-flash", action="store_true", help="Write SPI flash (-f) instead of SRAM (-m)")
    ap.add_argument("--no-flash", action="store_true", help="Skip flashing, monitor UART only")
    ap.add_argument("--port", default="COM8", help="Serial port (default: COM8)")
    ap.add_argument("--baud", type=int, default=115200, help="UART baud rate (default: 115200)")
    ap.add_argument("--timeout", type=float, default=15.0, help="UART listen timeout in seconds (0 = infinite)")
    ap.add_argument("--pass-target", type=int, default=1, help="Stop after N [PASS] lines (0 = wait full timeout)")
    ap.add_argument("--no-fail-fast", action="store_true", help="Do not stop immediately on [FAIL]")
    args = ap.parse_args()

    if args.build:
        rc = run_build(args.skip_compile)
        if rc != 0:
            return rc

    # Open COM port BEFORE flashing so the OS FIFO captures [BOOT] and early lines
    # emitted immediately when the FPGA releases reset after DONE.
    ser = None
    try:
        ser = open_serial(args.port, args.baud, timeout=0.15)
        ser.reset_input_buffer()
    except Exception as e:
        print(f"[uart] Warning: could not pre-open {args.port} ({e}); will retry after flash.", flush=True)
        ser = None

    if not args.no_flash:
        rc = flash_fpga(args.fs, args.board, args.spi_flash)
        if rc != 0:
            if ser is not None:
                ser.close()
            return rc

    return monitor_uart(
        ser=ser,
        port=args.port,
        baud=args.baud,
        timeout=args.timeout,
        pass_target=args.pass_target,
        fail_fast=not args.no_fail_fast,
    )


if __name__ == "__main__":
    raise SystemExit(main())
