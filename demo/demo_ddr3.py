#!/usr/bin/env python3
"""Plug-and-play PC <-> Tang Primer 20K DDR3 demo over UART (pyserial):
1. Optional --flash using the prebuilt demo/Ddr3UartDemoTop.fs (no Gowin/Mill needed)
2. RGB image + text round-trip verified in physical DDR3 and displayed in terminal
3. Live AXI4 DDR3 throughput graph (MB/s + peaks) sampled from FPGA cycle counters

Run with the prepared virtualenv:
    .venv\\Scripts\\python.exe demo\\demo_ddr3.py --flash --port COM8
"""

import argparse
from collections import deque
import os
from pathlib import Path
import shutil
import struct
import subprocess
import sys
import time
import serial

DEMO_DIR = Path(__file__).resolve().parent
REPO_DIR = DEMO_DIR.parent
DEFAULT_FS = DEMO_DIR / "Ddr3UartDemoTop.fs"

PCLK_HZ = 75_937_500
MAX_BURST_BYTES = 2048
SPARK = "▁▂▃▄▅▆▇█"


def flash_demo(fs_path: Path, board: str = "tangprimer20k") -> None:
    local_exe = REPO_DIR / "tools" / "oss-cad-suite" / "bin" / "openFPGALoader.exe"
    exe = str(local_exe) if local_exe.exists() else shutil.which("openFPGALoader")
    if not exe:
        raise FileNotFoundError("openFPGALoader not found (run setup.bat or add it to PATH)")
    env = os.environ.copy()
    if local_exe.exists():
        env["PATH"] = f"{local_exe.parent}{os.pathsep}{local_exe.parent.parent / 'lib'}{os.pathsep}{env.get('PATH', '')}"
    print(f"[flash] {fs_path.name} ({fs_path.stat().st_size // 1024} KiB) -> FPGA SRAM...")
    subprocess.run([exe, "-b", board, "-m", str(fs_path)], cwd=str(REPO_DIR), env=env, check=True)


def read_exact(ser: serial.Serial, n: int) -> bytes:
    buf = bytearray()
    deadline = time.monotonic() + max(2.0, ser.timeout or 2.0)
    while len(buf) < n:
        chunk = ser.read(n - len(buf))
        if chunk:
            buf.extend(chunk)
        elif time.monotonic() > deadline:
            raise TimeoutError(f"UART timeout: got {len(buf)}/{n} bytes")
    return bytes(buf)


def ping_ddr3(ser: serial.Serial, retries: int = 20) -> None:
    for _ in range(retries):
        ser.reset_input_buffer()
        ser.write(b"P")
        if ser.read(1) == b"!":
            return
        time.sleep(0.1)
    raise RuntimeError("FPGA did not reply '!' (run with --flash or check COM port)")


def write_ddr3(ser: serial.Serial, addr: int, data: bytes) -> None:
    padded = data + b"\x00" * ((-len(data)) % 8)
    for off in range(0, len(padded), MAX_BURST_BYTES):
        chunk = padded[off : off + MAX_BURST_BYTES]
        ser.write(b"W" + struct.pack("<IB", addr + off, len(chunk) // 8 - 1) + chunk)
        if read_exact(ser, 1) != b"K":
            raise RuntimeError(f"Write error at 0x{addr + off:08X}")


def read_ddr3(ser: serial.Serial, addr: int, length: int) -> bytes:
    padded_len = ((length + 7) // 8) * 8
    out = bytearray()
    for off in range(0, padded_len, MAX_BURST_BYTES):
        n = min(MAX_BURST_BYTES, padded_len - off)
        ser.write(b"R" + struct.pack("<IB", addr + off, n // 8 - 1))
        out.extend(read_exact(ser, n))
    return bytes(out[:length])


def bench_ddr3(ser: serial.Serial, bursts: int = 8) -> tuple[float, float]:
    """Run (bursts * 2 KiB) AXI4 write+read benchmark on FPGA and return (wr_mbs, rd_mbs)."""
    ser.write(b"B" + bytes([bursts - 1]))
    status, wr_cyc, rd_cyc = struct.unpack("<cII", read_exact(ser, 9))
    if status != b"K":
        raise RuntimeError(f"DDR3 benchmark verify failed (status={status!r})")
    size_bytes = bursts * 2048
    return (size_bytes * PCLK_HZ / wr_cyc / 1e6, size_bytes * PCLK_HZ / rd_cyc / 1e6)


def make_demo_image(w: int = 32, h: int = 16) -> bytes:
    rgb = bytearray()
    cx, cy = (w - 1) / 2.0, (h - 1) / 2.0
    for y in range(h):
        for x in range(w):
            d = abs(x - cx) / 10.0 + abs(y - cy) / 6.0
            rgb.extend((255, int(230 * (1 - d)), 40) if d < 1 else (int(255 * x / (w - 1)), int(255 * y / (h - 1)), 190))
    return bytes(rgb)


def show_ansi_image(rgb: bytes, w: int = 32, h: int = 16) -> None:
    for y in range(0, h, 2):
        row = []
        for x in range(w):
            i1, i2 = (y * w + x) * 3, ((y + 1) * w + x) * 3
            row.append(f"\x1b[38;2;{rgb[i1]};{rgb[i1+1]};{rgb[i1+2]};48;2;{rgb[i2]};{rgb[i2+1]};{rgb[i2+2]}m\u2580")
        print("  " + "".join(row) + "\x1b[0m")


def bar_and_spark(val: float, peak: float, hist: deque[float], ceiling: float = 607.5) -> str:
    n = max(0, min(20, int(round(20 * val / ceiling))))
    bar = "#" * n + "-" * (20 - n)
    spark = "".join(SPARK[max(0, min(7, int(7 * v / ceiling)))] for v in hist)
    return f"[{bar}] {val:5.1f} MB/s (peak {peak:5.1f})  {spark}"


def main() -> int:
    os.system("")
    ap = argparse.ArgumentParser(description="PC <-> Tang Primer 20K DDR3 UART demo + live bandwidth graph")
    ap.add_argument("--flash", action="store_true", help="Flash demo/Ddr3UartDemoTop.fs to FPGA SRAM first")
    ap.add_argument("--fs", type=Path, default=DEFAULT_FS, help="Bitstream .fs path for --flash")
    ap.add_argument("--port", default="COM8", help="Serial port (default: COM8)")
    ap.add_argument("--baud", type=int, default=115200, help="UART baud rate (default: 115200)")
    ap.add_argument("--samples", type=int, default=30, help="Live throughput samples (default: 30)")
    ap.add_argument("--bursts", type=int, default=8, help="2 KiB bursts per sample (default: 8 -> 16 KiB)")
    args = ap.parse_args()

    if args.flash:
        flash_demo(args.fs)

    with serial.Serial(args.port, args.baud, timeout=2.0) as ser:
        ping_ddr3(ser)
        print(f"[OK] Tang Primer 20K DDR3 bridge ready on {args.port} @ {args.baud} baud")

        msg = b"Hello Tang Primer 20K DDR3! AXI4 64-bit round-trip OK."
        write_ddr3(ser, 0x00001000, msg)

        img = make_demo_image(32, 16)
        write_ddr3(ser, 0x00100000, img)
        got = read_ddr3(ser, 0x00100000, len(img))
        assert got == img, "DDR3 image mismatch!"
        print(f"[OK] Image 32x16 RGB ({len(img)} B) round-trip @ 0x00100000:")
        show_ansi_image(got, 32, 16)

        got_msg = read_ddr3(ser, 0x00001000, len(msg))
        assert got_msg == msg, "Message mismatch!"
        print(f"[OK] Persistence @ 0x00001000: {got_msg.decode()}")

        print(f"\nLive AXI4 DDR3 throughput ({args.bursts * 2} KiB bursts, {args.samples} samples):")
        wr_hist, rd_hist = deque(maxlen=28), deque(maxlen=28)
        wr_peak = rd_peak = 0.0
        tty = sys.stdout.isatty()
        for i in range(args.samples):
            wr_mbs, rd_mbs = bench_ddr3(ser, args.bursts)
            wr_peak, rd_peak = max(wr_peak, wr_mbs), max(rd_peak, rd_mbs)
            wr_hist.append(wr_mbs)
            rd_hist.append(rd_mbs)
            if tty and i > 0:
                print("\x1b[2A", end="")
            if tty or i == args.samples - 1 or i == 0:
                print(f"  WR {bar_and_spark(wr_mbs, wr_peak, wr_hist)}")
                print(f"  RD {bar_and_spark(rd_mbs, rd_peak, rd_hist)}", flush=True)
            time.sleep(0.05)

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
