package ddr3

import org.scalatest.funsuite.AnyFunSuite
import spinal.core._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

class Ddr3TesterSimHarness(val axiConfig: Axi4Config, val config: Ddr3Config, val testBursts: Int) extends Component {
  val io = new Bundle {
    val uart_tx   = out Bool()
    val test_pass = out Bool()
    val test_err  = out Bool()
    val init_done = out Bool()
  }

  val bridge = new Ddr3Axi4Bridge(axiConfig, config)
  val core   = new Ddr3ControllerCore(config)
  // Use divider = 4 (40kHz / 10kHz) for fast UART simulation
  val engine = new Ddr3MemtestEngine(axiConfig, testBursts, clkFreqHz = 40000, baudRate = 10000)

  // Interconnect Engine <-> Bridge <-> Core
  engine.io.axi       <> bridge.io.axi
  bridge.io.init_done := core.io.init_done
  core.io.req         <> bridge.io.req
  bridge.io.rsp       <> core.io.rsp

  engine.io.pll_lock         := True
  engine.io.init_done        := core.io.init_done
  engine.io.write_level_done := core.io.write_level_done
  engine.io.read_calib_done  := core.io.read_calib_done
  engine.io.wstep            := core.io.wstep
  engine.io.rclkpos          := core.io.rclkpos
  engine.io.rclksel          := core.io.rclksel

  io.uart_tx   := engine.io.uart_tx
  io.test_pass := engine.io.test_pass
  io.test_err  := engine.io.test_error
  io.init_done := core.io.init_done

  // Autonomous PHY Emulation (DLL, Calibration, and Memory Loopback)
  core.io.phy.dlllock    := True
  core.io.phy.rst_lock_n := True

  // Write leveling response: transition dq_raw on DQS toggle
  val wlTimer = Reg(UInt(4 bits)) init(0)
  when(core.io.phy.dqs_out === 0xAA || core.io.phy.dqs_out === 0x55) {
    wlTimer := 12
  } elsewhen(wlTimer > 0) {
    wlTimer := wlTimer - 1
  }
  core.io.phy.dq_raw := (wlTimer > 0) ? B"16'h0101" | B"16'h0000"

  // Read calibration response: DQS read window lock
  core.io.phy.rburst := (core.io.phy.dqs_read === 0x0F) ? B"2'b11" | B"2'b00"

  // 128-bit memory loopback storage
  val mem = Mem(Bits(128 bits), 64)
  when(core.io.req.fire && core.io.req.payload.write) {
    mem.write(core.io.req.payload.addr(5 downto 0), core.io.req.payload.wdata)
  }
  val readData = Reg(Bits(128 bits)) init(0)
  when(core.io.req.fire && !core.io.req.payload.write) {
    readData := mem.readAsync(core.io.req.payload.addr(5 downto 0))
  }

  for (i <- 0 until 8) {
    core.io.phy.dq_in(i) := readData(i * 16 + 15 downto i * 16)
  }
}

class Ddr3TesterTopTest extends AnyFunSuite {
  test("Autonomous Ddr3MemtestEngine & UART Streaming Verification") {
    val axi64Config = Axi4Config(addressWidth = 32, dataWidth = 64, idWidth = 4)
    val testBursts  = 4
    val simConfig   = SimConfig.withWave

    simConfig.compile(new Ddr3TesterSimHarness(axi64Config, Ddr3Config(isSimulation = true), testBursts)).doSim { dut =>
      dut.clockDomain.forkStimulus(period = 10)

      println("[SIM] Waiting for DDR3 controller auto-initialization & calibration...")

      // UART receiver thread
      val receivedChars = new StringBuilder
      val uartBaudPeriod = 4 // clkFreqHz / baudRate = 40000 / 10000 = 4 cycles
      fork {
        while (true) {
          // Wait for start bit (txd falling from 1 to 0)
          while (dut.io.uart_tx.toBoolean) {
            dut.clockDomain.waitSampling()
          }
          // Middle of start bit: wait 2 cycles
          dut.clockDomain.waitSampling(2)
          if (!dut.io.uart_tx.toBoolean) {
            var charCode = 0
            for (bit <- 0 until 8) {
              dut.clockDomain.waitSampling(uartBaudPeriod)
              if (dut.io.uart_tx.toBoolean) {
                charCode |= (1 << bit)
              }
            }
            // Stop bit
            dut.clockDomain.waitSampling(uartBaudPeriod)
            val c = charCode.toChar
            receivedChars.append(c)
            print(c)
            Console.flush()
          }
        }
      }

      // Wait for test_pass or test_err
      dut.clockDomain.waitSamplingWhere(3000)(dut.io.test_pass.toBoolean || dut.io.test_err.toBoolean)

      println(s"\n[SIM] Console output received:\n${receivedChars.toString.trim}")
      assert(!dut.io.test_err.toBoolean, "Ddr3MemtestEngine reported an error!")
      assert(dut.io.test_pass.toBoolean, "Ddr3MemtestEngine did not assert test_pass!")
      println("[SIM] TesterTop autonomous verification PASSED with 100% SUCCESS!")
    }
  }
}
