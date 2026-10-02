package ddr3

import spinal.core._
import spinal.lib._

/**
 * DDR3 timing and configuration parameters.
 * Default is DDR3-800 timing (tCK = 2.5ns, pclk = 100MHz).
 */
case class Ddr3Config(
  rowWidth: Int       = 14,
  colWidth: Int       = 10,
  bankWidth: Int      = 3,
  isSimulation: Boolean = false
) {
  def addrWidth: Int = rowWidth + colWidth + bankWidth

  // Timing constants in CK cycles (DDR3-800, tCK = 2.5ns)
  val CAS    = 6
  val CWL    = 5
  val WR     = 6
  val MRD    = 8
  val RP     = 6
  val RCD    = 6
  val RC     = 20
  val MOD    = 12
  val RFC    = 64 // tRFC in CK cycles: 64 x 2.5ns = 160ns, covers 1Gb (110ns) and 2Gb (160ns).
                 // The auto-refresh state must wait RFC before the next ACT,
                 // otherwise the refreshed rows (incl. the row under test) get corrupted.
  val WLMRD  = 44
  val SERDES = 16

  // Delays in pclk cycles
  val usec = 100 // 1 microsecond in 100 MHz pclk cycles

  // Iteration counts for calibration
  val wlevelCount = if (isSimulation) 2 else 1
  val rcalibCount = if (isSimulation) 1 else 8
}

object Ddr3State extends SpinalEnum {
  val RST_WAIT, CKE_WAIT, CONFIG, ZQCL, WRITE_LEVELING, READ_CALIB, IDLE, READ, WRITE, REFRESH = newElement()
}

case class Ddr3Req(config: Ddr3Config) extends Bundle {
  val write = Bool()
  val addr  = UInt(config.addrWidth bits)
  val wdata = Bits(128 bits)
  val wstrb = Bits(16 bits)
}

case class Ddr3Rsp() extends Bundle {
  val rdata = Bits(128 bits)
}

/**
 * DDR3 Controller Core logic:
 * - Initialization sequence (Reset, CKE, MRS MR0..MR3, ZQCL)
 * - Auto-calibration (Write Leveling + Read Calibration)
 * - 128-bit burst read and write
 * - Autonomous refresh timer (7.8 us periodic)
 */
class Ddr3ControllerCore(val config: Ddr3Config = Ddr3Config()) extends Component {
  val io = new Bundle {
    // User / Arbiter interface
    val req = slave Stream(Ddr3Req(config))
    val rsp = master Flow(Ddr3Rsp())

    // Autonomous refresh forced externally if needed, or status
    val init_done   = out Bool()
    val write_level_done = out Bool()
    val read_calib_done  = out Bool()
    val wstep       = out Bits(8 bits)
    val rclkpos     = out Bits(2 bits)
    val rclksel     = out Bits(3 bits)

    // Direct interface to GowinDdr3Phy
    val phy = new Bundle {
      val dlllock     = in Bool()
      val rst_lock_n  = in Bool()
      val rburst      = in Bits(2 bits)
      val dq_in       = in Vec(Bits(16 bits), 8)
      val dq_raw      = in Bits(16 bits)

      val dqs_hold    = out Bool()
      val wstep       = out Bits(8 bits)
      val rclkpos     = out Bits(2 bits)
      val rclksel     = out Bits(3 bits)
      val dqs_read    = out Bits(4 bits)
      val dq_out      = out Vec(Bits(16 bits), 8)
      val dq_oen      = out Bits(4 bits)
      val dqs_out     = out Bits(8 bits)
      val dqs_oen     = out Bits(4 bits)
      val dm_out      = out Bits(8 bits)

      val nRAS        = out Vec(Bool(), 4)
      val nCAS        = out Vec(Bool(), 4)
      val nWE         = out Vec(Bool(), 4)
      val A           = out Vec(Bits(config.rowWidth bits), 4)
      val BA          = out Vec(Bits(config.bankWidth bits), 4)
      val CKE         = out Bool()
      val resetn_delay = out Bool()
    }
  }

  // DDR3 Command definitions: {nRAS, nCAS, nWE}
  val CMD_SetModeReg   = B"3'b000"
  val CMD_AutoRefresh  = B"3'b001"
  val CMD_PreCharge    = B"3'b010"
  val CMD_BankActivate = B"3'b011"
  val CMD_Write        = B"3'b100"
  val CMD_Read         = B"3'b101"
  val CMD_ZQCL         = B"3'b110"
  val CMD_NOP          = B"3'b111"

  // Mode Register definitions (DDR3-800)
  val M_BL       = B"2'b01"    // BC4 or 8 on the fly
  val M_CAS      = B"4'b0100"  // 6 cycles
  val M_CWL      = B"3'b000"   // 5 cycles
  val M_WR       = B"3'b010"   // 6 cycles
  val M_DLLReset = True
  val M_RTT_NOM  = B"3'b000"   // Disabled
  val M_RTT_WR   = B"2'b01"    // 60 ohm dynamic ODT
  val M_DRIVE    = B"2'b00"    // low drive strength
  val M_AL       = B"2'b00"

  val MR0 = B"3'b000" ## False ## M_WR ## M_DLLReset ## False ## M_CAS(3 downto 1) ## False ## M_CAS(0) ## M_BL
  val MR1 = B"3'b001" ## B"3'b000" ## M_RTT_NOM(2) ## B"2'b00" ## M_RTT_NOM(1) ## M_DRIVE(1) ## M_AL ## M_RTT_NOM(0) ## M_DRIVE(0) ## False
  val MR2 = B"3'b010" ## B"7'b0000000" ## M_CWL ## B"3'b000"
  val MR2_RTT_WR = B"3'b010" ## B"2'b00" ## M_RTT_WR ## B"3'b000" ## M_CWL ## B"3'b000"
  val MR3 = B"3'b011" ## B"13'b0"

  // State registers
  val state        = RegInit(Ddr3State.RST_WAIT)
  val cycle        = Reg(UInt(5 bits)) init(0)
  val tick_counter = Reg(UInt(17 bits)) init(if (config.isSimulation) 1 else 60000)
  val tick         = RegInit(False)

  val resetn_delay = RegInit(False)
  val CKE          = RegInit(False)
  val busy         = RegInit(True)
  val data_ready   = RegInit(False)

  val wlevel_done  = RegInit(False)
  val wlevel_cnt   = Reg(UInt(4 bits)) init(0)
  val wstep        = Reg(Bits(8 bits)) init(if (config.isSimulation) B"8'h18" else B"8'h00")

  val rcalib_done  = RegInit(False)
  val rcalib_cnt   = Reg(UInt(4 bits)) init(0)
  val rclkpos      = Reg(Bits(2 bits)) init(if (config.isSimulation) B"2'd1" else B"2'd0")
  val rclksel      = Reg(Bits(3 bits)) init(if (config.isSimulation) B"3'd6" else B"3'd0")
  val rburst_seen  = Reg(Bits(2 bits)) init(0)
  val dqs_hold     = RegInit(False)

  // Autonomous Refresh timer (every 7.8 us = 781 cycles @ 100MHz)
  // Sim uses a shorter period so iverilog runs cover several refreshes.
  val refreshPeriod = if (config.isSimulation) 200 else 780
  val refresh_timer = Reg(UInt(11 bits)) init(0)
  val refresh_due   = RegInit(False)

  when(state === Ddr3State.IDLE || state === Ddr3State.READ || state === Ddr3State.WRITE) {
    when(refresh_timer === refreshPeriod) {
      refresh_due := True
      refresh_timer := 0
    } otherwise {
      refresh_timer := refresh_timer + 1
    }
  }

  // Latch transaction request
  val reqReg = Reg(Ddr3Req(config))

  // Command & Address outputs to PHY
  val nRAS = Vec(Reg(Bool()) init(True), 4)
  val nCAS = Vec(Reg(Bool()) init(True), 4)
  val nWE  = Vec(Reg(Bool()) init(True), 4)
  val A    = Vec(Reg(Bits(config.rowWidth bits)) init(0), 4)
  val BA   = Vec(Reg(Bits(config.bankWidth bits)) init(0), 4)

  val dq_out  = Vec(Reg(Bits(16 bits)) init(0), 8)
  val dq_oen  = Reg(Bits(4 bits)) init(B"4'b1111")
  val dqs_out = Reg(Bits(8 bits)) init(0)
  val dqs_oen = Reg(Bits(4 bits)) init(B"4'b1111")
  val dm_out  = Reg(Bits(8 bits)) init(B"8'b1111_1111")

  // Helper function to set command on a specific sub-cycle
  def setCmd(subcycle: Int, cmd: Bits, baVal: Bits, aVal: Bits): Unit = {
    nRAS(subcycle) := cmd(2)
    nCAS(subcycle) := cmd(1)
    nWE(subcycle)  := cmd(0)
    BA(subcycle)   := baVal.resized
    A(subcycle)    := aVal.resized
  }

  // Monitor rburst strobe
  when(io.phy.rburst(0)) { rburst_seen(0) := True }
  when(io.phy.rburst(1)) { rburst_seen(1) := True }

  // Generate dqs_read pulse
  val dqs_read = Reg(Bits(4 bits)) init(0)
  dqs_read := 0
  when((state === Ddr3State.READ || state === Ddr3State.READ_CALIB) &&
       cycle === (rclkpos.asUInt.resize(5) + config.RCD / 4 + 1)) {
    dqs_read := B"4'b1111"
  }

  // Ready to accept user requests only when in IDLE and no refresh due
  val acceptReq = (state === Ddr3State.IDLE) && !busy && !refresh_due
  io.req.ready := acceptReq

  // Main FSM
  when(io.phy.rst_lock_n) {
    cycle := (cycle === 31) ? U(31, 5 bits) | (cycle + 1)
    tick := (tick_counter === 1)
    tick_counter := (tick_counter === 0) ? U(0, 17 bits) | (tick_counter - 1)

    // Defaults every cycle
    for (i <- 0 until 4) {
      nRAS(i) := True
      nCAS(i) := True
      nWE(i)  := True
      A(i)    := 0
      BA(i)   := 0
    }
    dm_out  := B"8'b1111_1111"
    dqs_oen := B"4'b1111"
    dq_oen  := B"4'b1111"
    dqs_out := 0
    dqs_hold := False

    switch(state) {
      is(Ddr3State.RST_WAIT) {
        when(tick) {
          resetn_delay := True
          tick_counter := (if (config.isSimulation) U(19, 17 bits) else U(500 * config.usec + 20, 17 bits))
          state := Ddr3State.CKE_WAIT
        }
      }

      is(Ddr3State.CKE_WAIT) {
        when(tick_counter === 15) {
          CKE := True
        }
        when(tick) {
          state := Ddr3State.CONFIG
          cycle := 0
        }
      }

      is(Ddr3State.CONFIG) {
        switch(cycle) {
          is(0) {
            setCmd(0, CMD_SetModeReg, MR2(15 downto 13), MR2(12 downto 0))
          }
          is(config.MRD / 4) { // cycle 2
            setCmd(0, CMD_SetModeReg, MR3(15 downto 13), MR3(12 downto 0))
          }
          is(config.MRD / 2) { // cycle 4
            setCmd(0, CMD_SetModeReg, MR1(15 downto 13), MR1(12 downto 0))
          }
          is(config.MRD * 3 / 4) { // cycle 6
            setCmd(0, CMD_SetModeReg, MR0(15 downto 13), MR0(12 downto 0))
          }
          is(config.MRD * 3 / 4 + config.MOD / 4 + 1) { // cycle 10
            // ZQCL (long calibration): BA=0, A[10]=1. CAUTION: bit 10, not bit 0!
            setCmd(0, CMD_ZQCL, B"3'b0", (B"1'b1".resize(config.rowWidth) |<< 10))
            // Wait tZQinit (512 CK for sg25). Sim uses a realistic wait so the
            // Micron model completes init (else every read errors + $stop spam).
            tick_counter := (if (config.isSimulation) U(130, 17 bits) else U(514, 17 bits))
            state := Ddr3State.ZQCL
          }
        }
      }

      is(Ddr3State.ZQCL) {
        when(tick) {
          state := Ddr3State.WRITE_LEVELING
          cycle := 0
        }
      }

      is(Ddr3State.WRITE_LEVELING) {
        switch(cycle) {
          is(0) {
            // Enter write leveling mode: MR1[7] = 1, RTT_NOM = 60 ohm
            val mr1_wlevel = MR1 | B"16'h0084"
            setCmd(0, CMD_SetModeReg, mr1_wlevel(15 downto 13), mr1_wlevel(12 downto 0))
            wlevel_cnt := 0
          }
          is(config.WLMRD / 4 - 1, config.WLMRD / 4 + 1, config.WLMRD / 4 + 2,
             config.WLMRD / 4 + 3, config.WLMRD / 4 + 4, config.WLMRD / 4 + 5) {
            dqs_out := 0
            dqs_oen := 0
          }
          is(config.WLMRD / 4) {
            dqs_out := B"8'b0101_0101" // Test strobe pulse (D0=1, D1=0, D2=1, D3=0...)
            dqs_oen := 0
          }
          is(config.WLMRD / 4 + 6) {
            dqs_out := 0
            dqs_oen := 0
            when(!io.phy.dq_raw(0) || !io.phy.dq_raw(8)) {
              wstep := (wstep.asUInt + 1).asBits
              wlevel_cnt := 0
              cycle := config.WLMRD / 4 - 1 // loop back
            } otherwise {
              wlevel_cnt := wlevel_cnt + 1
              when(wlevel_cnt === config.wlevelCount - 1) {
                wlevel_done := True
                setCmd(0, CMD_SetModeReg, MR1(15 downto 13), MR1(12 downto 0)) // exit write leveling
              } otherwise {
                cycle := config.WLMRD / 4 - 1
              }
            }
          }
          is((config.WLMRD + config.MRD) / 4 + 6) {
            // Turn on dynamic ODT (MR2_RTT_WR)
            setCmd(0, CMD_SetModeReg, MR2_RTT_WR(15 downto 13), MR2_RTT_WR(12 downto 0))
          }
          is((config.WLMRD + config.MRD + config.MOD) / 4 + 6) {
            state := Ddr3State.READ_CALIB
            cycle := 0
          }
        }
      }

      is(Ddr3State.READ_CALIB) {
        switch(cycle) {
          is(0) {
            setCmd(0, CMD_BankActivate, B"3'b0", B"0".resized)
            rcalib_cnt := 0
          }
          is(config.RCD / 4) {
            // Issue BL8 read without auto-precharge
            setCmd(2, CMD_Read, B"3'b0", B"1'b1".resize(config.rowWidth) |<< 12)
            rburst_seen := 0
          }
          is(config.RCD / 4 + 10) {
            when(rburst_seen =/= B"2'b11") {
              rclksel := (rclksel.asUInt + 1).asBits
              when(rclksel === 7) {
                rclkpos := (rclkpos.asUInt + 1).asBits
              }
              rcalib_cnt := 0
              cycle := config.RCD / 4 // loop back
            } otherwise {
              rcalib_cnt := rcalib_cnt + 1
              when(rcalib_cnt === config.rcalibCount - 1) {
                rcalib_done := True
                setCmd(0, CMD_PreCharge, B"3'b0", B"0".resized)
              } otherwise {
                cycle := config.RCD / 4
              }
            }
          }
          is(config.RCD / 4 + 10 + config.RP / 4) {
            busy  := False
            state := Ddr3State.IDLE
          }
        }
      }

      is(Ddr3State.IDLE) {
        when(refresh_due) {
          // Autonomous refresh
          setCmd(0, CMD_AutoRefresh, B"3'b0", B"0".resized)
          state := Ddr3State.REFRESH
          cycle := 1
          busy  := True
          refresh_due := False
        } elsewhen(io.req.valid) {
          reqReg := io.req.payload
          val blockIdx = io.req.addr
          val col  = (blockIdx(config.colWidth - 4 downto 0) @@ U"3'b000").asBits
          val row  = blockIdx(config.colWidth - 4 + config.rowWidth downto config.colWidth - 3).asBits
          val bank = blockIdx(config.colWidth - 4 + config.rowWidth + config.bankWidth downto config.colWidth - 3 + config.rowWidth).asBits

          setCmd(0, CMD_BankActivate, bank, row.resized)
          state := io.req.write ? Ddr3State.WRITE | Ddr3State.READ
          cycle := 1
          busy  := True
          when(!io.req.write) {
            dqs_hold := True
          }
        }
      }

      is(Ddr3State.READ) {
        val blockIdx = reqReg.addr
        val col  = (blockIdx(config.colWidth - 4 downto 0) @@ U"3'b000").asBits
        val bank = blockIdx(config.colWidth - 4 + config.rowWidth + config.bankWidth downto config.colWidth - 3 + config.rowWidth).asBits

        // Read command with Auto-Precharge (A[10]=1) and BL8 (A[12]=1)
        when(cycle === config.RCD / 4) {
          val readA = (col.resized | B"16'h1400".resized) // A[12]=1 (BL8), A[10]=1 (AutoPrecharge)
          setCmd(config.RCD % 4, CMD_Read, bank, readA)
          dqs_hold := True
        }

        when(cycle === (config.RCD + config.CAS + config.SERDES) / 4 + 1) {
          data_ready := True
        }

        when(cycle === (config.RCD + config.CAS + config.SERDES) / 4 + 2) {
          data_ready := False
          busy  := False
          state := Ddr3State.IDLE
        }
      }

      is(Ddr3State.WRITE) {
        val blockIdx = reqReg.addr
        val col  = (blockIdx(config.colWidth - 4 downto 0) @@ U"3'b000").asBits
        val bank = blockIdx(config.colWidth - 4 + config.rowWidth + config.bankWidth downto config.colWidth - 3 + config.rowWidth).asBits

        when(cycle === config.RCD / 4) {
          val writeA = (col.resized | B"16'h1400".resized) // A[12]=1 (BL8), A[10]=1 (AutoPrecharge)
          setCmd(config.RCD % 4, CMD_Write, bank, writeA)
        }

        // Cycle 2: Subcycle 2 (CK 10) = Preamble; Subcycle 3 (CK 11) = Beat 0
        when(cycle === (config.RCD + config.CWL) / 4) {
          dqs_out := B"8'b0100_0000" // D4=0, D5=0 (preamble low); D6=1, D7=0 (Beat 0)
          dqs_oen := B"4'b0011"      // TX2=0, TX3=0 enabled; TX0=1, TX1=1 disabled
          dq_oen  := B"4'b0111"      // TX3=0 enabled; TX0..2=1 disabled

          dq_out(6) := 0
          dq_out(7) := reqReg.wdata(15 downto 0)   // Beat 0

          dm_out(6) := True
          dm_out(7) := !reqReg.wstrb(1 downto 0).orR
        }

        // Cycle 3: Subcycles 0..2 (CK 12..14) = Beats 1..6; Subcycle 3 (CK 15) = Beat 7 + Postamble
        when(cycle === (config.RCD + config.CWL) / 4 + 1) {
          dqs_out := B"8'b0101_0101" // D0..D6 toggle for Beats 1..7; D7=0 postamble
          dqs_oen := B"4'b0000"      // All TX enabled
          dq_oen  := B"4'b0000"      // All TX enabled

          dq_out(0) := reqReg.wdata(31 downto 16)  // Beat 1
          dq_out(1) := reqReg.wdata(47 downto 32)  // Beat 2
          dq_out(2) := reqReg.wdata(63 downto 48)  // Beat 3
          dq_out(3) := reqReg.wdata(79 downto 64)  // Beat 4
          dq_out(4) := reqReg.wdata(95 downto 80)  // Beat 5
          dq_out(5) := reqReg.wdata(111 downto 96) // Beat 6
          dq_out(6) := reqReg.wdata(127 downto 112)// Beat 7
          dq_out(7) := 0

          dm_out(0) := !reqReg.wstrb(3 downto 2).orR
          dm_out(1) := !reqReg.wstrb(5 downto 4).orR
          dm_out(2) := !reqReg.wstrb(7 downto 6).orR
          dm_out(3) := !reqReg.wstrb(9 downto 8).orR
          dm_out(4) := !reqReg.wstrb(11 downto 10).orR
          dm_out(5) := !reqReg.wstrb(13 downto 12).orR
          dm_out(6) := !reqReg.wstrb(15 downto 14).orR
          dm_out(7) := True
        }

        // Cycle 4: Postamble completion (held low) then all return to high-Z
        when(cycle === (config.RCD + config.CWL) / 4 + 2) {
          dqs_out := 0
          dqs_oen := B"4'b1110"      // TX0=0 held low for 1/2 CK postamble
          dq_oen  := B"4'b1111"
        }

        when(cycle === 28 / 4) {
          busy  := False
          state := Ddr3State.IDLE
        }
      }

      is(Ddr3State.REFRESH) {
        // Wait full tRFC (not just tRC): the next ACT too early corrupts DRAM contents.
        when(cycle === config.RFC / 4) {
          busy  := False
          state := Ddr3State.IDLE
        }
      }
    }
  } otherwise {
    // Reset condition
    busy := True
    data_ready := False
    CKE := False
    for (i <- 0 until 4) {
      nRAS(i) := True
      nCAS(i) := True
      nWE(i)  := True
    }
    tick_counter := (if (config.isSimulation) U(1, 17 bits) else U(60000, 17 bits))
    tick := False
    cycle := 0
    wlevel_cnt := 0
    wlevel_done := False
    wstep := (if (config.isSimulation) B"8'h18" else B"8'h00")
    rcalib_cnt := 0
    rcalib_done := False
    rclkpos := (if (config.isSimulation) B"2'd1" else B"2'd0")
    rclksel := (if (config.isSimulation) B"3'd6" else B"3'd0")
    resetn_delay := False
    state := Ddr3State.RST_WAIT
  }

  // Feed read data out (128 bits: {dq_in[0]..dq_in[7]})
  io.rsp.valid := data_ready
  io.rsp.rdata := (io.phy.dq_in(7) ## io.phy.dq_in(6) ## io.phy.dq_in(5) ## io.phy.dq_in(4) ##
                   io.phy.dq_in(3) ## io.phy.dq_in(2) ## io.phy.dq_in(1) ## io.phy.dq_in(0))

  // Connect control ports to PHY
  io.phy.dqs_hold     := dqs_hold
  io.phy.wstep        := wstep
  io.phy.rclkpos      := rclkpos
  io.phy.rclksel      := rclksel
  io.phy.dqs_read     := dqs_read
  io.phy.dq_out       := dq_out
  io.phy.dq_oen       := dq_oen
  io.phy.dqs_out      := dqs_out
  io.phy.dqs_oen      := dqs_oen
  io.phy.dm_out       := dm_out
  io.phy.nRAS         := nRAS
  io.phy.nCAS         := nCAS
  io.phy.nWE          := nWE
  io.phy.A            := A
  io.phy.BA           := BA
  io.phy.CKE          := CKE
  io.phy.resetn_delay := resetn_delay

  // Status outputs
  val init_done_latched = RegInit(False)
  when(!busy && (state === Ddr3State.IDLE) && wlevel_done && rcalib_done) {
    init_done_latched := True
  }
  io.init_done        := init_done_latched
  io.write_level_done := wlevel_done
  io.read_calib_done  := rcalib_done
  io.wstep            := wstep
  io.rclkpos          := rclkpos
  io.rclksel          := rclksel
}
