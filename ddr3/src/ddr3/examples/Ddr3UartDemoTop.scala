package ddr3

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

/**
 * Simple UART-to-AXI4 bridge (64-bit AXI4 @ 115200 baud by default).
 *
 * Binary protocol (little-endian):
 *   - 'P' (0x50): Ping -> replies '!' (0x21) if init_done else '?' (0x3F)
 *   - 'W' (0x57) + addr[31:0] + len_m1[7:0] + (len_m1+1)*8 bytes -> AXI4 burst write -> replies 'K'
 *   - 'R' (0x52) + addr[31:0] + len_m1[7:0] -> AXI4 burst read -> replies (len_m1+1)*8 bytes
 *   - 'B' (0x42) + bursts_m1[7:0] -> on-chip (bursts_m1+1)*2 KiB AXI4 write+read benchmark
 *       replies 9 bytes: status ('K' or 'E') + wrCycles[31:0] + rdCycles[31:0]
 *   - 'M' (0x4D) + bursts_m1[7:0] + beats_m1[7:0] + flags[7:0] -> configurable workload benchmark
 *       flags(0)=1: mixed R/W alternating per burst, flags(1)=1: +2048B stride (force row miss)
 *       replies 9 bytes: status ('K' or 'E') + wrCycles[31:0] + rdCycles[31:0]
 */
class Ddr3UartBridge(
  val axiConfig: Axi4Config = Ddr3Axi4.defaultAxiConfig(dataWidth = 64),
  clkFreqHz: Int = 75937500,
  baudRate: Int = 115200
) extends Component {
  require(axiConfig.dataWidth == 64, "Ddr3UartBridge expects 64-bit AXI4")

  val io = new Bundle {
    val init_done = in Bool()
    val axi       = master(Axi4(axiConfig))
    val uart_rxp  = in Bool()
    val uart_txp  = out Bool()
    val busy      = out Bool()
    val cmd_count = out UInt(4 bits)
  }

  val rx = new UartRx(clkFreqHz, baudRate)
  val tx = new UartTx(clkFreqHz, baudRate)
  rx.io.rxd   := io.uart_rxp
  io.uart_txp := tx.io.txd

  object S extends SpinalEnum {
    val IDLE, SEND_PING, RX_HDR, WR_AW, WR_RX_WORD, WR_W_BEAT, WR_B, WR_ACK,
        RD_AR, RD_WAIT_R, RD_TX_WORD,
        B_RX_LEN, M_RX_HDR, B_WR_AW, B_WR_W, B_WR_B, B_RD_AR, B_RD_R, B_TX_RES = newElement()
  }

  val state      = RegInit(S.IDLE)
  val isWrite    = RegInit(False)
  val addrReg    = Reg(UInt(32 bits)) init(0)
  val lenM1      = Reg(UInt(8 bits)) init(0)
  val hdrIdx     = Reg(UInt(3 bits)) init(0)
  val beatCnt    = Reg(UInt(8 bits)) init(0)
  val byteIdx    = Reg(UInt(4 bits)) init(0)
  val wordBuf    = Reg(Bits(64 bits)) init(0)
  val rdLast     = RegInit(False)
  val txByte     = Reg(Bits(8 bits)) init(0)
  val cmdCnt     = Reg(UInt(4 bits)) init(0)

  // On-chip throughput benchmark registers
  val bBurstsM1  = Reg(UInt(8 bits)) init(0)
  val bBeatsM1   = Reg(UInt(8 bits)) init(255)
  val bMixed     = RegInit(False)
  val bRowStride = RegInit(False)
  val bHdrIdx    = Reg(UInt(2 bits)) init(0)
  val bBurstIdx  = Reg(UInt(8 bits)) init(0)
  val bWrCycles  = Reg(UInt(32 bits)) init(0)
  val bRdCycles  = Reg(UInt(32 bits)) init(0)
  val bErr       = RegInit(False)

  val bStrideBytes = bRowStride ? U(2048, 32 bits) | ((bBeatsM1.resize(16) + 1) << 3).resize(32)

  val benchWord = (B"16'hA55A" ## bBurstIdx.asBits ## beatCnt.asBits ##
                   B"16'hCAFE" ## (bBurstIdx ^ beatCnt).asBits ## (~beatCnt).asBits)

  when(state === S.B_WR_AW || state === S.B_WR_W || state === S.B_WR_B) {
    bWrCycles := bWrCycles + 1
  }
  when(state === S.B_RD_AR || state === S.B_RD_R) {
    bRdCycles := bRdCycles + 1
  }

  io.busy      := (state =/= S.IDLE)
  io.cmd_count := cmdCnt

  // AXI4 defaults
  val inBenchWr = (state === S.B_WR_AW || state === S.B_WR_W || state === S.B_WR_B)
  val inBenchRd = (state === S.B_RD_AR || state === S.B_RD_R)

  io.axi.aw.valid        := (state === S.WR_AW || state === S.B_WR_AW)
  io.axi.aw.payload.addr := addrReg.resized
  io.axi.aw.payload.id   := 0
  io.axi.aw.payload.len  := inBenchWr ? bBeatsM1 | lenM1
  io.axi.aw.payload.size := 3 // 8 bytes per beat (64-bit)
  io.axi.aw.payload.burst := B"2'b01" // INCR
  io.axi.aw.payload.lock := 0
  io.axi.aw.payload.cache := 0
  io.axi.aw.payload.prot := 0
  io.axi.aw.payload.qos  := 0
  io.axi.aw.payload.region := 0

  io.axi.w.valid        := (state === S.WR_W_BEAT || state === S.B_WR_W)
  io.axi.w.payload.data := (state === S.B_WR_W) ? benchWord | wordBuf
  io.axi.w.payload.strb := B"8'hFF"
  io.axi.w.payload.last := (state === S.B_WR_W) ? (beatCnt === bBeatsM1) | (beatCnt === lenM1)

  io.axi.b.ready := (state === S.WR_B || state === S.B_WR_B)

  io.axi.ar.valid        := (state === S.RD_AR || state === S.B_RD_AR)
  io.axi.ar.payload.addr := addrReg.resized
  io.axi.ar.payload.id   := 0
  io.axi.ar.payload.len  := inBenchRd ? bBeatsM1 | lenM1
  io.axi.ar.payload.size := 3
  io.axi.ar.payload.burst := B"2'b01"
  io.axi.ar.payload.lock := 0
  io.axi.ar.payload.cache := 0
  io.axi.ar.payload.prot := 0
  io.axi.ar.payload.qos  := 0
  io.axi.ar.payload.region := 0

  io.axi.r.ready := (state === S.RD_WAIT_R || state === S.B_RD_R)

  // TX stream defaults
  tx.io.write.valid   := False
  tx.io.write.payload := txByte

  val rxByte    = rx.io.read.payload
  val wordBytes = wordBuf.subdivideIn(8 bits)
  val benchResBytes = Vec(
    bErr ? B(0x45, 8 bits) | B(0x4B, 8 bits), // 'E' or 'K'
    bWrCycles(7 downto 0).asBits,  bWrCycles(15 downto 8).asBits,
    bWrCycles(23 downto 16).asBits, bWrCycles(31 downto 24).asBits,
    bRdCycles(7 downto 0).asBits,  bRdCycles(15 downto 8).asBits,
    bRdCycles(23 downto 16).asBits, bRdCycles(31 downto 24).asBits
  )

  switch(state) {
    is(S.IDLE) {
      when(rx.io.read.valid) {
        when(rxByte === 0x50) { // 'P'
          txByte := io.init_done ? B(0x21, 8 bits) | B(0x3F, 8 bits)
          state  := S.SEND_PING
        } elsewhen(rxByte === 0x57 || rxByte === 0x52) { // 'W' or 'R'
          isWrite := (rxByte === 0x57)
          hdrIdx  := 0
          cmdCnt  := cmdCnt + 1
          state   := S.RX_HDR
        } elsewhen(rxByte === 0x42) { // 'B'
          cmdCnt := cmdCnt + 1
          state  := S.B_RX_LEN
        } elsewhen(rxByte === 0x4D) { // 'M'
          cmdCnt  := cmdCnt + 1
          bHdrIdx := 0
          state   := S.M_RX_HDR
        }
      }
    }

    is(S.SEND_PING) {
      tx.io.write.valid := True
      when(tx.io.write.fire) {
        state := S.IDLE
      }
    }

    is(S.RX_HDR) {
      when(rx.io.read.valid) {
        switch(hdrIdx) {
          is(0) { addrReg(7 downto 0)   := rxByte.asUInt }
          is(1) { addrReg(15 downto 8)  := rxByte.asUInt }
          is(2) { addrReg(23 downto 16) := rxByte.asUInt }
          is(3) { addrReg(31 downto 24) := rxByte.asUInt }
          is(4) {
            lenM1   := rxByte.asUInt
            beatCnt := 0
            byteIdx := 0
            state   := isWrite ? S.WR_AW | S.RD_AR
          }
        }
        hdrIdx := hdrIdx + 1
      }
    }

    is(S.WR_AW) {
      when(io.axi.aw.fire) { state := S.WR_RX_WORD }
    }

    is(S.WR_RX_WORD) {
      when(rx.io.read.valid) {
        for (i <- 0 until 8) {
          when(byteIdx === i) { wordBuf(i * 8 + 7 downto i * 8) := rxByte }
        }
        when(byteIdx === 7) {
          state := S.WR_W_BEAT
        } otherwise {
          byteIdx := byteIdx + 1
        }
      }
    }

    is(S.WR_W_BEAT) {
      when(io.axi.w.fire) {
        when(beatCnt === lenM1) {
          state := S.WR_B
        } otherwise {
          beatCnt := beatCnt + 1
          byteIdx := 0
          state   := S.WR_RX_WORD
        }
      }
    }

    is(S.WR_B) {
      when(io.axi.b.valid) {
        txByte := B(0x4B, 8 bits) // 'K'
        state  := S.WR_ACK
      }
    }

    is(S.WR_ACK) {
      tx.io.write.valid := True
      when(tx.io.write.fire) { state := S.IDLE }
    }

    is(S.RD_AR) {
      when(io.axi.ar.fire) { state := S.RD_WAIT_R }
    }

    is(S.RD_WAIT_R) {
      when(io.axi.r.valid) {
        wordBuf := io.axi.r.payload.data
        rdLast  := io.axi.r.payload.last
        byteIdx := 0
        state   := S.RD_TX_WORD
      }
    }

    is(S.RD_TX_WORD) {
      tx.io.write.valid   := True
      tx.io.write.payload := wordBytes(byteIdx(2 downto 0))
      when(tx.io.write.fire) {
        when(byteIdx === 7) {
          state := rdLast ? S.IDLE | S.RD_WAIT_R
        } otherwise {
          byteIdx := byteIdx + 1
        }
      }
    }

    // --- On-chip 64-bit AXI4 Burst Benchmark ('B' and 'M') ---
    is(S.B_RX_LEN) {
      when(rx.io.read.valid) {
        bBurstsM1  := rxByte.asUInt
        bBeatsM1   := 255
        bMixed     := False
        bRowStride := False
        bBurstIdx  := 0
        beatCnt    := 0
        bWrCycles  := 0
        bRdCycles  := 0
        bErr       := False
        addrReg    := U"32'h0020_0000"
        state      := S.B_WR_AW
      }
    }

    is(S.M_RX_HDR) {
      when(rx.io.read.valid) {
        switch(bHdrIdx) {
          is(0) { bBurstsM1 := rxByte.asUInt }
          is(1) { bBeatsM1  := rxByte.asUInt }
          is(2) {
            bMixed     := rxByte(0)
            bRowStride := rxByte(1)
            bBurstIdx  := 0
            beatCnt    := 0
            bWrCycles  := 0
            bRdCycles  := 0
            bErr       := False
            addrReg    := U"32'h0020_0000"
            state      := S.B_WR_AW
          }
        }
        bHdrIdx := bHdrIdx + 1
      }
    }

    is(S.B_WR_AW) {
      when(io.axi.aw.fire) {
        beatCnt := 0
        state   := S.B_WR_W
      }
    }

    is(S.B_WR_W) {
      when(io.axi.w.fire) {
        when(beatCnt === bBeatsM1) {
          state := S.B_WR_B
        } otherwise {
          beatCnt := beatCnt + 1
        }
      }
    }

    is(S.B_WR_B) {
      when(io.axi.b.valid) {
        when(bMixed) {
          state := S.B_RD_AR
        } elsewhen(bBurstIdx === bBurstsM1) {
          bBurstIdx := 0
          addrReg   := U"32'h0020_0000"
          state     := S.B_RD_AR
        } otherwise {
          bBurstIdx := bBurstIdx + 1
          addrReg   := addrReg + bStrideBytes
          state     := S.B_WR_AW
        }
      }
    }

    is(S.B_RD_AR) {
      when(io.axi.ar.fire) {
        beatCnt := 0
        state   := S.B_RD_R
      }
    }

    is(S.B_RD_R) {
      when(io.axi.r.valid) {
        when(io.axi.r.payload.data =/= benchWord) {
          bErr := True
        }
        when(io.axi.r.payload.last) {
          when(bBurstIdx === bBurstsM1) {
            byteIdx := 0
            state   := S.B_TX_RES
          } otherwise {
            bBurstIdx := bBurstIdx + 1
            addrReg   := addrReg + bStrideBytes
            state     := bMixed ? S.B_WR_AW | S.B_RD_AR
          }
        } otherwise {
          beatCnt := beatCnt + 1
        }
      }
    }

    is(S.B_TX_RES) {
      tx.io.write.valid   := True
      tx.io.write.payload := benchResBytes(byteIdx)
      when(tx.io.write.fire) {
        when(byteIdx === 8) {
          state := S.IDLE
        } otherwise {
          byteIdx := byteIdx + 1
        }
      }
    }
  }
}

/**
 * Plug-and-play UART <-> DDR3 round-trip demo top for Tang Primer 20K.
 * Instantiates TangPrimer20kDdr3 (64-bit AXI4) + Ddr3UartBridge in a single clocking area.
 */
class Ddr3UartDemoTop extends Component {
  noIoPrefix()

  val ddrConfig = Ddr3Config.tangPrimer20k()
  val axiConfig = Ddr3Axi4.defaultAxiConfig(dataWidth = 64)

  val io = new Bundle {
    val sys_clk    = in Bool()
    val sys_resetn = in Bool()

    val led        = out Bits(8 bits)
    val led2       = out Bits(8 bits)

    val uart_txp   = out Bool()
    val uart_rxp   = in Bool()

    val DDR3_DQ     = inout(Analog(Bits(16 bits)))
    val DDR3_DQS    = inout(Analog(Bits(2 bits)))
    val DDR3_DM     = out Bits(2 bits)
    val DDR3_A      = out Bits(ddrConfig.rowWidth bits)
    val DDR3_BA     = out Bits(ddrConfig.bankWidth bits)
    val DDR3_nRAS   = out Bool()
    val DDR3_nCAS   = out Bool()
    val DDR3_nWE    = out Bool()
    val DDR3_nCS    = out Bool()
    val DDR3_CK     = out Bool()
    val DDR3_CKE    = out Bool()
    val DDR3_nRESET = out Bool()
    val DDR3_ODT    = out Bool()
  }

  // 1. Plug-and-play DDR3 subsystem (PLL + POR + 64-bit AXI4 controller)
  val ddr3 = TangPrimer20kDdr3(dataWidth = 64, config = ddrConfig)
  ddr3.io.sys_clk    := io.sys_clk
  ddr3.io.sys_resetn := io.sys_resetn

  io.DDR3_DQ     <> ddr3.io.pad.DDR3_DQ
  io.DDR3_DQS    <> ddr3.io.pad.DDR3_DQS
  io.DDR3_DM     := ddr3.io.pad.DDR3_DM
  io.DDR3_A      := ddr3.io.pad.DDR3_A
  io.DDR3_BA     := ddr3.io.pad.DDR3_BA
  io.DDR3_nRAS   := ddr3.io.pad.DDR3_nRAS
  io.DDR3_nCAS   := ddr3.io.pad.DDR3_nCAS
  io.DDR3_nWE    := ddr3.io.pad.DDR3_nWE
  io.DDR3_nCS    := ddr3.io.pad.DDR3_nCS
  io.DDR3_CK     := ddr3.io.pad.DDR3_CK
  io.DDR3_CKE    := ddr3.io.pad.DDR3_CKE
  io.DDR3_nRESET := ddr3.io.pad.DDR3_nRESET
  io.DDR3_ODT    := ddr3.io.pad.DDR3_ODT

  // 2. Host UART-to-AXI4 bridge running in the controller clock domain (75.94 MHz)
  val hostArea = new ClockingArea(ddr3.controllerClockDomain) {
    val uartBridge = new Ddr3UartBridge(axiConfig, clkFreqHz = ddrConfig.pclkHz, baudRate = 115200)
    uartBridge.io.init_done := ddr3.io.init_done
    uartBridge.io.axi       <> ddr3.io.axi
    uartBridge.io.uart_rxp  := io.uart_rxp
    io.uart_txp             := uartBridge.io.uart_txp

    io.led(0)          := !ddr3.io.pll_lock
    io.led(1)          := !ddr3.io.status.init_done
    io.led(2)          := !ddr3.io.status.write_level_done
    io.led(3)          := !ddr3.io.status.read_calib_done
    io.led(4)          := !uartBridge.io.busy
    io.led(7 downto 5) := ~uartBridge.io.cmd_count(2 downto 0).asBits
    io.led2            := ~ddr3.io.status.wstep
  }
}
