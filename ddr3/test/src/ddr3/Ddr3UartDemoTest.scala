package ddr3

import org.scalatest.funsuite.AnyFunSuite
import spinal.core._
import spinal.core.sim._
import spinal.lib._

class Ddr3UartDemoHarness extends Component {
  val io = new Bundle {
    val uart_rxp  = in Bool()
    val uart_txp  = out Bool()
    val init_done = out Bool()
  }

  val axiConfig = Ddr3Axi4.defaultAxiConfig(dataWidth = 64)
  val config    = Ddr3Config(isSimulation = true)

  val bridge     = new Ddr3Axi4Bridge(axiConfig, config)
  val core       = new Ddr3ControllerCore(config)
  // Divider = 8 (80 kHz / 10 kHz) for fast Verilator UART simulation
  val uartBridge = new Ddr3UartBridge(axiConfig, clkFreqHz = 80000, baudRate = 10000)

  uartBridge.io.init_done := core.io.init_done
  uartBridge.io.axi       <> bridge.io.axi
  uartBridge.io.uart_rxp  := io.uart_rxp
  io.uart_txp             := uartBridge.io.uart_txp
  io.init_done            := core.io.init_done

  bridge.io.init_done := core.io.init_done
  core.io.req         <> bridge.io.req
  bridge.io.rsp       <> core.io.rsp

  // Emulate PHY calibration + 128-bit memory loopback
  core.io.phy.dlllock    := True
  core.io.phy.rst_lock_n := True

  val wlTimer = Reg(UInt(4 bits)) init(0)
  when(core.io.phy.dqs_out === 0xAA || core.io.phy.dqs_out === 0x55) {
    wlTimer := 12
  } elsewhen(wlTimer > 0) {
    wlTimer := wlTimer - 1
  }
  core.io.phy.dq_raw := (wlTimer > 0) ? B"16'h0101" | B"16'h0000"
  core.io.phy.rburst := (core.io.phy.dqs_read === 0x0F) ? B"2'b11" | B"2'b00"

  val mem = Mem(Bits(128 bits), 256)
  val curWord = mem.readAsync(core.io.req.payload.addr(7 downto 0))
  val nextWord = Bits(128 bits)
  for (byteIdx <- 0 until 16) {
    nextWord(byteIdx * 8 + 7 downto byteIdx * 8) :=
      core.io.req.payload.wstrb(byteIdx) ?
        core.io.req.payload.wdata(byteIdx * 8 + 7 downto byteIdx * 8) |
        curWord(byteIdx * 8 + 7 downto byteIdx * 8)
  }
  when(core.io.req.fire && core.io.req.payload.write) {
    mem.write(core.io.req.payload.addr(7 downto 0), nextWord)
  }

  val simRdFifo = new StreamFifo(Bits(128 bits), 64)
  simRdFifo.io.push.valid   := core.io.req.fire && !core.io.req.payload.write
  simRdFifo.io.push.payload := curWord
  simRdFifo.io.pop.ready    := core.io.rsp.valid
  val readData = simRdFifo.io.pop.valid ? simRdFifo.io.pop.payload | B(0, 128 bits)
  for (i <- 0 until 8) {
    core.io.phy.dq_in(i) := readData(i * 16 + 15 downto i * 16)
  }
}

class Ddr3UartDemoTest extends AnyFunSuite {
  test("Ddr3UartBridge round-trip Ping, Write/Read burst, and Benchmark via UART") {
    val div = 8

    SimConfig.compile(new Ddr3UartDemoHarness).doSim { dut =>
      dut.io.uart_rxp #= true
      dut.clockDomain.forkStimulus(period = 10)

      def sendByte(b: Int): Unit = {
        dut.io.uart_rxp #= false
        dut.clockDomain.waitSampling(div)
        for (i <- 0 until 8) {
          dut.io.uart_rxp #= ((b >> i) & 1) != 0
          dut.clockDomain.waitSampling(div)
        }
        dut.io.uart_rxp #= true
        dut.clockDomain.waitSampling(div)
      }

      def recvByte(timeoutCycles: Int = 100000): Int = {
        var waited = 0
        while (dut.io.uart_txp.toBoolean && waited < timeoutCycles) {
          dut.clockDomain.waitSampling()
          waited += 1
        }
        assert(waited < timeoutCycles, "UART RX timeout waiting for start bit")
        dut.clockDomain.waitSampling(div + div / 2)
        var v = 0
        for (i <- 0 until 8) {
          if (dut.io.uart_txp.toBoolean) v |= (1 << i)
          dut.clockDomain.waitSampling(div)
        }
        v
      }

      dut.clockDomain.waitSamplingWhere(50000)(dut.io.init_done.toBoolean)
      dut.clockDomain.waitSampling(32)

      // 1. Ping
      sendByte('P'.toInt)
      assert(recvByte() == '!'.toInt, "Expected '!' on Ping after calibration")

      // 2. Write 2 x 64-bit words (16 bytes) at addr 0x00000040
      val payload = (0 until 16).map(i => (0x30 + i * 7) & 0xff).toArray
      val addr = 0x00000040
      sendByte('W'.toInt)
      for (s <- 0 until 4) sendByte((addr >> (s * 8)) & 0xff)
      sendByte(1)
      for (b <- payload) sendByte(b)
      assert(recvByte() == 'K'.toInt, "Expected 'K' ACK after Write")

      // 3. Read back 2 x 64-bit words
      sendByte('R'.toInt)
      for (s <- 0 until 4) sendByte((addr >> (s * 8)) & 0xff)
      sendByte(1)
      val readBack = Array.fill(16)(recvByte())
      assert(readBack.sameElements(payload), s"Round-trip mismatch: ${readBack.mkString(",")}")

      // 4. On-chip benchmark (1 burst = 2 KiB)
      sendByte('B'.toInt)
      sendByte(0) // bursts_m1 = 0 -> 1 burst (2048 B)
      val status = recvByte()
      val bytes  = Array.fill(8)(recvByte())
      val wrCyc  = (0 until 4).map(i => bytes(i) << (i * 8)).sum
      val rdCyc  = (0 until 4).map(i => bytes(4 + i) << (i * 8)).sum
      assert(status == 'K'.toInt, s"Benchmark status expected 'K', got ${status.toChar}")
      assert(wrCyc > 0 && rdCyc > 0, s"Expected positive cycle counts, got wr=$wrCyc rd=$rdCyc")
      println(f"[SIM UART-DEMO] Ping + 16B round-trip + 2KiB bench (wr=${wrCyc} cyc, rd=${rdCyc} cyc) PASSED!")
    }
  }
}
