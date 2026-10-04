package ddr3

import spinal.core._
import spinal.lib._

/**
 * Gowin GW2A DDR3 PHY Layer.
 * Direct translation of the physical layer from nand2mario's ddr3_controller.v:
 * - DLL instantiation
 * - 2x DQS primitives (one per byte lane)
 * - 16x OSER8_MEM + IDES8_MEM for DQ lanes
 * - 2x OSER8_MEM for DQS lanes
 * - 2x OSER8_MEM for DM lanes
 * - OSER8 for address, bank address, and command lines (nRAS, nCAS, nWE)
 */
class GowinDdr3Phy(rowWidth: Int = 14, bankWidth: Int = 3) extends Component {
  val io = new Bundle {
    // Clocks and resets
    val pclk        = in Bool() // Primary clock (~100 MHz)
    val fclk        = in Bool() // Fast clock (~400 MHz)
    val ck          = in Bool() // 90-degree shifted fclk
    val resetn      = in Bool() // System reset (active low)

    // Controller inputs
    val dqs_hold    = in Bool()
    val wstep       = in Bits(8 bits)
    // Dynamic read-delay steppers (vendor-intended fine mover, driven by read
    // calibration). RLOADN=0 reloads the read tap (rstep) from the live DLL
    // output (anchor); RLOADN=1 holds it; RMOVE falling edges step +-1 tap
    // (RDIR: False=plus, True=minus). The sweep works RELATIVE to the DLL
    // lock -- no fabric adder on DLLSTEP, which the placer forbids (PR0015:
    // DQS.DLLSTEP must be driven DIRECTLY by the DLL, dedicated routing).
    val rloadn      = in Bool()
    val rmove       = in Bool()
    val rdir        = in Bool()
    val rclkpos     = in Bits(2 bits)
    val rclksel     = in Bits(3 bits)
    val dqs_read    = in Bits(4 bits)
    val dq_out      = in Vec(Bits(16 bits), 8)
    val dq_oen      = in Bits(4 bits)
    val dqs_out     = in Bits(8 bits)
    val dqs_oen     = in Bits(4 bits)
    val dm_out      = in Bits(8 bits)

    val nRAS        = in Vec(Bool(), 4)
    val nCAS        = in Vec(Bool(), 4)
    val nWE         = in Vec(Bool(), 4)
    val A           = in Vec(Bits(rowWidth bits), 4)
    val BA          = in Vec(Bits(bankWidth bits), 4)
    val CKE         = in Bool()
    val resetn_delay = in Bool()

    // PHY status & feedback outputs to Controller
    val dlllock     = out Bool()
    val rst_lock_n  = out Bool()
    val rburst      = out Bits(2 bits)
    val dq_in       = out Vec(Bits(16 bits), 8)
    val dq_raw      = out Bits(16 bits)

    // Physical memory pads
    val pad         = master(Ddr3Pins(rowWidth, bankWidth))
  }

  // 1. DLL
  val dll = new DLL
  dll.io.CLKIN    := io.fclk
  dll.io.RESET    := !io.resetn
  dll.io.STOP     := False
  dll.io.UPDNCNTL := False
  val dllstep = dll.io.STEP
  // NOTE: NO fabric offset is added here on purpose. DQS.DLLSTEP is driven
  // DIRECTLY by dll.io.STEP (placer rule PR0015: dedicated routing, no
  // fabric logic allowed between DLL and DQS). The calibration fine-mover
  // is rstep inside each DQS, stepped at runtime (RLOADN/RMOVE/RDIR).
  val dlllock     = dll.io.LOCK
  io.dlllock      := dlllock

  val rst_lock_n  = io.resetn && dlllock
  io.rst_lock_n   := rst_lock_n

  // Static / simple pin assignments
  io.pad.DDR3_nRESET := rst_lock_n && io.resetn_delay
  io.pad.DDR3_ODT    := True  // Dynamic ODT is enabled inside DRAM mode registers
  io.pad.DDR3_CK     := io.ck
  io.pad.DDR3_nCS    := False
  io.pad.DDR3_CKE    := io.CKE

  // 2. DQS primitives (one per byte lane)
  val dqs_waddr   = Vec(Bits(3 bits), 2)
  val dqs_raddr   = Vec(Bits(3 bits), 2)
  val clk_dqsr    = Vec(Bool(), 2)
  val clk_dqsw    = Vec(Bool(), 2)
  val clk_dqsw270 = Vec(Bool(), 2)
  val rburst      = Bits(2 bits)

  val dqs_pad_in  = Bits(2 bits)
  val dqs_buf     = Bits(2 bits)
  val dqs_buf_oen = Bits(2 bits)

  for (i <- 0 until 2) {
    val u_dqs = new DQS
    u_dqs.io.FCLK    := io.fclk
    u_dqs.io.PCLK    := io.pclk
    u_dqs.io.DQSIN   := dqs_pad_in(i)
    u_dqs.io.RESET   := !rst_lock_n
    u_dqs.io.HOLD    := io.dqs_hold
    u_dqs.io.RLOADN  := io.rloadn
    u_dqs.io.WLOADN  := False
    u_dqs.io.RMOVE   := io.rmove
    u_dqs.io.RDIR    := io.rdir
    u_dqs.io.WMOVE   := False
    u_dqs.io.DLLSTEP := dllstep
    u_dqs.io.WSTEP   := io.wstep
    u_dqs.io.RCLKSEL := io.rclksel
    u_dqs.io.READ    := io.dqs_read

    clk_dqsr(i)    := u_dqs.io.DQSR90
    dqs_waddr(i)   := u_dqs.io.WPOINT
    dqs_raddr(i)   := u_dqs.io.RPOINT
    clk_dqsw(i)    := u_dqs.io.DQSW0
    clk_dqsw270(i) := u_dqs.io.DQSW270
    rburst(i)      := u_dqs.io.RBURST

    // DQS Output SerDes
    val oser_dqs = new OSER8_MEM("DEFAULT")
    oser_dqs.io.D0    := io.dqs_out(0)
    oser_dqs.io.D1    := io.dqs_out(1)
    oser_dqs.io.D2    := io.dqs_out(2)
    oser_dqs.io.D3    := io.dqs_out(3)
    oser_dqs.io.D4    := io.dqs_out(4)
    oser_dqs.io.D5    := io.dqs_out(5)
    oser_dqs.io.D6    := io.dqs_out(6)
    oser_dqs.io.D7    := io.dqs_out(7)
    oser_dqs.io.TX0   := io.dqs_oen(0)
    oser_dqs.io.TX1   := io.dqs_oen(1)
    oser_dqs.io.TX2   := io.dqs_oen(2)
    oser_dqs.io.TX3   := io.dqs_oen(3)
    oser_dqs.io.FCLK  := io.fclk
    oser_dqs.io.PCLK  := io.pclk
    oser_dqs.io.TCLK  := clk_dqsw(i)
    oser_dqs.io.RESET := !rst_lock_n
    dqs_buf(i)        := oser_dqs.io.Q0
    dqs_buf_oen(i)    := oser_dqs.io.Q1

    // DQS IOBUF
    val iobuf_dqs = new IOBUF
    iobuf_dqs.io.I   := dqs_buf(i)
    iobuf_dqs.io.OEN := dqs_buf_oen(i)
    dqs_pad_in(i)    := iobuf_dqs.io.O
    iobuf_dqs.io.IO  := io.pad.DDR3_DQS(i)

    // DM Output SerDes
    val oser_dm = new OSER8_MEM("DQSW270")
    oser_dm.io.D0    := io.dm_out(0)
    oser_dm.io.D1    := io.dm_out(1)
    oser_dm.io.D2    := io.dm_out(2)
    oser_dm.io.D3    := io.dm_out(3)
    oser_dm.io.D4    := io.dm_out(4)
    oser_dm.io.D5    := io.dm_out(5)
    oser_dm.io.D6    := io.dm_out(6)
    oser_dm.io.D7    := io.dm_out(7)
    oser_dm.io.TX0   := False
    oser_dm.io.TX1   := False
    oser_dm.io.TX2   := False
    oser_dm.io.TX3   := False
    oser_dm.io.FCLK  := io.fclk
    oser_dm.io.PCLK  := io.pclk
    oser_dm.io.TCLK  := clk_dqsw270(i)
    oser_dm.io.RESET := !rst_lock_n
    io.pad.DDR3_DM(i) := oser_dm.io.Q0
  }
  io.rburst := rburst

  // 3. DQ lanes (16 bits)
  val dq_buf     = Bits(16 bits)
  val dq_buf_oen = Bits(16 bits)
  val dq_pad_in  = Bits(16 bits)

  for (i <- 0 until 16) {
    val byteIdx = i / 8

    // Output SerDes
    val oser_dq = new OSER8_MEM("DQSW270")
    oser_dq.io.D0    := io.dq_out(0)(i)
    oser_dq.io.D1    := io.dq_out(1)(i)
    oser_dq.io.D2    := io.dq_out(2)(i)
    oser_dq.io.D3    := io.dq_out(3)(i)
    oser_dq.io.D4    := io.dq_out(4)(i)
    oser_dq.io.D5    := io.dq_out(5)(i)
    oser_dq.io.D6    := io.dq_out(6)(i)
    oser_dq.io.D7    := io.dq_out(7)(i)
    oser_dq.io.TX0   := io.dq_oen(0)
    oser_dq.io.TX1   := io.dq_oen(1)
    oser_dq.io.TX2   := io.dq_oen(2)
    oser_dq.io.TX3   := io.dq_oen(3)
    oser_dq.io.FCLK  := io.fclk
    oser_dq.io.PCLK  := io.pclk
    oser_dq.io.TCLK  := clk_dqsw270(byteIdx)
    oser_dq.io.RESET := !rst_lock_n || !dlllock
    dq_buf(i)        := oser_dq.io.Q0
    dq_buf_oen(i)    := oser_dq.io.Q1

    // IOBUF for DQ
    val iobuf_dq = new IOBUF
    iobuf_dq.io.I   := dq_buf(i)
    iobuf_dq.io.OEN := dq_buf_oen(i)
    dq_pad_in(i)    := iobuf_dq.io.O
    iobuf_dq.io.IO  := io.pad.DDR3_DQ(i)

    // Input DeSerDes (with clock domain crossing FIFO)
    val iser_dq = new IDES8_MEM
    iser_dq.io.D     := dq_pad_in(i)
    iser_dq.io.ICLK  := clk_dqsr(byteIdx)
    iser_dq.io.FCLK  := io.fclk
    iser_dq.io.PCLK  := io.pclk
    iser_dq.io.CALIB := False
    iser_dq.io.RESET := !rst_lock_n
    iser_dq.io.WADDR := dqs_waddr(byteIdx)
    iser_dq.io.RADDR := dqs_raddr(byteIdx)

    io.dq_in(0)(i) := iser_dq.io.Q0
    io.dq_in(1)(i) := iser_dq.io.Q1
    io.dq_in(2)(i) := iser_dq.io.Q2
    io.dq_in(3)(i) := iser_dq.io.Q3
    io.dq_in(4)(i) := iser_dq.io.Q4
    io.dq_in(5)(i) := iser_dq.io.Q5
    io.dq_in(6)(i) := iser_dq.io.Q6
    io.dq_in(7)(i) := iser_dq.io.Q7
  }
  io.dq_raw := dq_pad_in

  // 4. Command lines (nRAS, nCAS, nWE) via OSER8
  def makeCmdOser(cmdBits: Vec[Bool], padOut: Bool): Unit = {
    val oser = new OSER8
    oser.io.D0    := cmdBits(0)
    oser.io.D1    := cmdBits(0)
    oser.io.D2    := cmdBits(1)
    oser.io.D3    := cmdBits(1)
    oser.io.D4    := cmdBits(2)
    oser.io.D5    := cmdBits(2)
    oser.io.D6    := cmdBits(3)
    oser.io.D7    := cmdBits(3)
    oser.io.FCLK  := io.fclk
    oser.io.PCLK  := io.pclk
    oser.io.RESET := !rst_lock_n
    padOut        := oser.io.Q0
  }

  makeCmdOser(io.nRAS, io.pad.DDR3_nRAS)
  makeCmdOser(io.nCAS, io.pad.DDR3_nCAS)
  makeCmdOser(io.nWE,  io.pad.DDR3_nWE)

  // 5. Address lines via OSER8
  for (i <- 0 until rowWidth) {
    val oser_a = new OSER8
    oser_a.io.D0    := io.A(0)(i)
    oser_a.io.D1    := io.A(0)(i)
    oser_a.io.D2    := io.A(1)(i)
    oser_a.io.D3    := io.A(1)(i)
    oser_a.io.D4    := io.A(2)(i)
    oser_a.io.D5    := io.A(2)(i)
    oser_a.io.D6    := io.A(3)(i)
    oser_a.io.D7    := io.A(3)(i)
    oser_a.io.FCLK  := io.fclk
    oser_a.io.PCLK  := io.pclk
    oser_a.io.RESET := !rst_lock_n
    io.pad.DDR3_A(i) := oser_a.io.Q0
  }

  // 6. Bank address lines via OSER8
  for (i <- 0 until bankWidth) {
    val oser_ba = new OSER8
    oser_ba.io.D0    := io.BA(0)(i)
    oser_ba.io.D1    := io.BA(0)(i)
    oser_ba.io.D2    := io.BA(1)(i)
    oser_ba.io.D3    := io.BA(1)(i)
    oser_ba.io.D4    := io.BA(2)(i)
    oser_ba.io.D5    := io.BA(2)(i)
    oser_ba.io.D6    := io.BA(3)(i)
    oser_ba.io.D7    := io.BA(3)(i)
    oser_ba.io.FCLK  := io.fclk
    oser_ba.io.PCLK  := io.pclk
    oser_ba.io.RESET := !rst_lock_n
    io.pad.DDR3_BA(i) := oser_ba.io.Q0
  }
}
