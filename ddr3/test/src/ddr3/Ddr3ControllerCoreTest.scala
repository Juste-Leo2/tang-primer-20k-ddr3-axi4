package ddr3

import org.scalatest.funsuite.AnyFunSuite
import spinal.core._
import spinal.core.sim._

class Ddr3ControllerCoreTest extends AnyFunSuite {
  test("DDR3 Controller Initialization, Write and Read BL8") {
    val simConfig = SimConfig.withWave
    simConfig.compile(new Ddr3ControllerCore(Ddr3Config(isSimulation = true))).doSim { dut =>
      dut.clockDomain.forkStimulus(period = 10) // 100 MHz pclk = 10ns period

      // Initial inputs
      dut.io.req.valid #= false
      dut.io.phy.dlllock #= false
      dut.io.phy.rst_lock_n #= false
      dut.io.phy.rburst #= 0
      dut.io.phy.dq_raw #= 0
      for (i <- 0 until 8) {
        dut.io.phy.dq_in(i) #= 0
      }

      dut.clockDomain.waitSampling(5)

      // Lock DLL
      dut.io.phy.dlllock #= true
      dut.io.phy.rst_lock_n #= true

      println("[SIM] DLL locked, waiting for init sequence...")

      val simCalibration = fork {
        var wlTimer = 0
        while (!dut.io.init_done.toBoolean) {
          if (dut.io.phy.dqs_out.toBigInt == 0xAA || dut.io.phy.dqs_out.toBigInt == 0x55) {
            wlTimer = 12
          }
          if (wlTimer > 0) {
            dut.io.phy.dq_raw #= (1 | (1 << 8))
            wlTimer -= 1
          } else {
            dut.io.phy.dq_raw #= 0
          }

          if (dut.io.phy.dqs_read.toBigInt == 0x0F) {
            dut.io.phy.rburst #= 3
          } else {
            dut.io.phy.rburst #= 0
          }

          dut.clockDomain.waitSampling()
        }
        println("[SIM] Calibration complete! init_done asserted.")
      }

      // Wait until init_done is asserted (with timeout). Full calib is
      // long: 256-step WL eye sweep + nested-K read sweep (~65 mags x 8
      // K-groups x 4 pos x 2 sides x ~13 pclk) + training/poison writes.
      dut.clockDomain.waitSamplingWhere(120000)(dut.io.init_done.toBoolean)
      assert(dut.io.init_done.toBoolean, "DDR3 controller failed to initialize")
      assert(dut.io.write_level_done.toBoolean, "Write leveling failed")
      assert(dut.io.read_calib_done.toBoolean, "Read calibration failed")

      println(s"[SIM] Calibration results: wstep=0x${dut.io.wstep.toBigInt.toString(16)}, rclkpos=${dut.io.rclkpos.toBigInt}, rclksel=${dut.io.rclksel.toBigInt}")

      dut.clockDomain.waitSampling(5)

      // -------------------------------------------------------------
      // TEST 1: Write 128-bit BL8 burst
      // -------------------------------------------------------------
      println("[SIM] Issuing 128-bit write request...")
      dut.io.req.valid #= true
      dut.io.req.write #= true
      dut.io.req.addr #= 0x1000
      val testWData = BigInt("FEDCBA9876543210FEDCBA9876543210", 16)
      dut.io.req.wdata #= testWData
      dut.io.req.wstrb #= 0xFFFF

      dut.clockDomain.waitSamplingWhere(dut.io.req.ready.toBoolean)
      dut.clockDomain.waitSampling()
      dut.io.req.valid #= false

      // Wait for write to complete and return to IDLE
      dut.clockDomain.waitSamplingWhere(50)(dut.io.req.ready.toBoolean)
      println("[SIM] Write completed successfully.")

      dut.clockDomain.waitSampling(5)

      // -------------------------------------------------------------
      // TEST 2: Read 128-bit BL8 burst
      // -------------------------------------------------------------
      println("[SIM] Issuing 128-bit read request...")
      dut.io.req.valid #= true
      dut.io.req.write #= false
      dut.io.req.addr #= 0x1000

      dut.clockDomain.waitSamplingWhere(dut.io.req.ready.toBoolean)
      dut.clockDomain.waitSampling()
      dut.io.req.valid #= false

      // Feed read data on dq_in
      dut.io.phy.dq_in(0) #= 0x1111
      dut.io.phy.dq_in(1) #= 0x2222
      dut.io.phy.dq_in(2) #= 0x3333
      dut.io.phy.dq_in(3) #= 0x4444
      dut.io.phy.dq_in(4) #= 0x5555
      dut.io.phy.dq_in(5) #= 0x6666
      dut.io.phy.dq_in(6) #= 0x7777
      dut.io.phy.dq_in(7) #= 0x8888

      dut.clockDomain.waitSamplingWhere(50)(dut.io.rsp.valid.toBoolean)
      assert(dut.io.rsp.valid.toBoolean, "Read response timeout")

      val expectedRData = (BigInt(0x8888) << 112) |
                          (BigInt(0x7777) << 96) |
                          (BigInt(0x6666) << 80) |
                          (BigInt(0x5555) << 64) |
                          (BigInt(0x4444) << 48) |
                          (BigInt(0x3333) << 32) |
                          (BigInt(0x2222) << 16) |
                          BigInt(0x1111)

      val actualRData = dut.io.rsp.rdata.toBigInt
      println(s"[SIM] Read response received: 0x${actualRData.toString(16)}")
      assert(actualRData == expectedRData, s"Mismatch: expected 0x${expectedRData.toString(16)}, got 0x${actualRData.toString(16)}")

      // Wait until controller is back to IDLE
      dut.clockDomain.waitSamplingWhere(20)(dut.io.req.ready.toBoolean)
      println("[SIM] Read completed successfully.")

      dut.clockDomain.waitSampling(10)
      println("[SIM] All tests passed!")
    }
  }
}
