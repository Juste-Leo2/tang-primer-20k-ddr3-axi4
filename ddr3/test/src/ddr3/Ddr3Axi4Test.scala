package ddr3

import org.scalatest.funsuite.AnyFunSuite
import spinal.core._
import spinal.core.sim._
import spinal.lib._
import spinal.lib.bus.amba4.axi._
import scala.collection.mutable.ArrayBuffer

class Ddr3Axi4SimHarness(val axiConfig: Axi4Config, val config: Ddr3Config) extends Component {
  val io = new Bundle {
    val axi = slave(Axi4(axiConfig))
    val corePhy = new Bundle {
      val dlllock     = in Bool()
      val rst_lock_n  = in Bool()
      val rburst      = in Bits(2 bits)
      val dq_in       = in Vec(Bits(16 bits), 8)
      val dq_raw      = in Bits(16 bits)
      val dqs_out     = out Bits(8 bits)
      val dqs_read    = out Bits(4 bits)
    }
    val init_done = out Bool()
  }

  val bridge = new Ddr3Axi4Bridge(axiConfig, config)
  val core   = new Ddr3ControllerCore(config)

  bridge.io.axi       <> io.axi
  bridge.io.init_done := core.io.init_done
  core.io.req         <> bridge.io.req
  bridge.io.rsp       <> core.io.rsp
  io.init_done        := core.io.init_done

  core.io.phy.dlllock    := io.corePhy.dlllock
  core.io.phy.rst_lock_n := io.corePhy.rst_lock_n
  core.io.phy.rburst     := io.corePhy.rburst
  core.io.phy.dq_in      := io.corePhy.dq_in
  core.io.phy.dq_raw     := io.corePhy.dq_raw
  io.corePhy.dqs_out     := core.io.phy.dqs_out
  io.corePhy.dqs_read    := core.io.phy.dqs_read
}

class Ddr3Axi4Test extends AnyFunSuite {
  test("DDR3 AXI4 64-bit Frontend - SpinalML compatible") {
    val axi64Config = Axi4Config(addressWidth = 32, dataWidth = 64, idWidth = 4)
    val simConfig = SimConfig.withWave
    simConfig.compile(new Ddr3Axi4SimHarness(axi64Config, Ddr3Config(isSimulation = true))).doSim { dut =>
      dut.clockDomain.forkStimulus(period = 10)

      // Initial inputs
      dut.io.axi.ar.valid #= false
      dut.io.axi.aw.valid #= false
      dut.io.axi.w.valid  #= false
      dut.io.axi.b.ready  #= true
      dut.io.axi.r.ready  #= true

      dut.io.corePhy.dlllock    #= false
      dut.io.corePhy.rst_lock_n #= false
      dut.io.corePhy.rburst     #= 0
      dut.io.corePhy.dq_raw     #= 0
      for (i <- 0 until 8) {
        dut.io.corePhy.dq_in(i) #= 0
      }

      dut.clockDomain.waitSampling(5)

      // Lock DLL
      dut.io.corePhy.dlllock    #= true
      dut.io.corePhy.rst_lock_n #= true

      // Handle calibration in background
      val simCalibration = fork {
        var wlTimer = 0
        while (!dut.io.init_done.toBoolean) {
          if (dut.io.corePhy.dqs_out.toBigInt == 0xAA || dut.io.corePhy.dqs_out.toBigInt == 0x55) {
            wlTimer = 12
          }
          if (wlTimer > 0) {
            dut.io.corePhy.dq_raw #= (1 | (1 << 8))
            wlTimer -= 1
          } else {
            dut.io.corePhy.dq_raw #= 0
          }

          if (dut.io.corePhy.dqs_read.toBigInt == 0x0F) {
            dut.io.corePhy.rburst #= 3
          } else {
            dut.io.corePhy.rburst #= 0
          }

          dut.clockDomain.waitSampling()
        }
        println("[SIM] Calibration complete! Ddr3Axi4 ready for AXI transactions.")
      }

      // Wait for init_done with timeout. Full calib is long: 256-step WL
      // eye sweep + read sweeps x 41 iters x ~13 pclk + training/poison
      // (+ bracket candidates when armed).
      dut.clockDomain.waitSamplingWhere(20000)(dut.io.init_done.toBoolean)
      assert(dut.io.init_done.toBoolean, "Ddr3Axi4 failed to initialize")

      dut.clockDomain.waitSampling(5)

      // Background monitors for AXI B and R channels to avoid race conditions
      var bSeen = false
      var bId = -1
      fork {
        while (true) {
          if (dut.io.axi.b.valid.toBoolean && dut.io.axi.b.ready.toBoolean) {
            bSeen = true
            bId = dut.io.axi.b.payload.id.toInt
          }
          dut.clockDomain.waitSampling()
        }
      }

      val rBeats = ArrayBuffer[(BigInt, Boolean, Int)]()
      fork {
        while (true) {
          if (dut.io.axi.r.valid.toBoolean && dut.io.axi.r.ready.toBoolean) {
            rBeats += ((
              dut.io.axi.r.payload.data.toBigInt,
              dut.io.axi.r.payload.last.toBoolean,
              dut.io.axi.r.payload.id.toInt
            ))
          }
          dut.clockDomain.waitSampling()
        }
      }

      // -------------------------------------------------------------
      // TEST 1: AXI4 Write (2 beats of 64-bit = 128-bit burst)
      // -------------------------------------------------------------
      println("[SIM] Sending AXI4 AW request...")
      dut.io.axi.aw.valid #= true
      dut.io.axi.aw.payload.addr #= 0x2000
      dut.io.axi.aw.payload.len  #= 1 // 2 beats
      dut.io.axi.aw.payload.id   #= 3

      dut.clockDomain.waitSamplingWhere(50)(dut.io.axi.aw.ready.toBoolean)
      dut.clockDomain.waitSampling()
      dut.io.axi.aw.valid #= false

      // Send beat 0 (lower 64 bits)
      println("[SIM] Sending AXI4 W beat 0...")
      dut.io.axi.w.valid #= true
      dut.io.axi.w.payload.data #= BigInt("1122334455667788", 16)
      dut.io.axi.w.payload.strb #= 0xFF
      dut.io.axi.w.payload.last #= false

      dut.clockDomain.waitSamplingWhere(50)(dut.io.axi.w.ready.toBoolean)
      dut.clockDomain.waitSampling()

      // Send beat 1 (upper 64 bits, last = true)
      println("[SIM] Sending AXI4 W beat 1 (last)...")
      dut.io.axi.w.payload.data #= BigInt("99AABBCCDDEEFF00", 16)
      dut.io.axi.w.payload.strb #= 0xFF
      dut.io.axi.w.payload.last #= true

      dut.clockDomain.waitSamplingWhere(50)(dut.io.axi.w.ready.toBoolean)
      dut.clockDomain.waitSampling()
      dut.io.axi.w.valid #= false

      // Wait for B response via monitor
      dut.clockDomain.waitSamplingWhere(50)(bSeen)
      assert(bSeen, "AXI4 B response timeout")
      assert(bId == 3, s"AXI4 B ID mismatch: expected 3, got $bId")
      println("[SIM] AXI4 Write transaction acknowledged (B response OKAY).")

      dut.clockDomain.waitSampling(10)

      // -------------------------------------------------------------
      // TEST 2: AXI4 Read (2 beats of 64-bit = 128-bit burst)
      // -------------------------------------------------------------
      println("[SIM] Sending AXI4 AR request...")
      // Feed read data on dq_in when read is executed. Direct beat order
      // matches the written data because calib locked rot=0 here (dq_in
      // held at 0 during the sweep -> all rotation scores 0 -> identity).
      dut.io.corePhy.dq_in(0) #= 0x7788
      dut.io.corePhy.dq_in(1) #= 0x5566
      dut.io.corePhy.dq_in(2) #= 0x3344
      dut.io.corePhy.dq_in(3) #= 0x1122
      dut.io.corePhy.dq_in(4) #= 0xFF00
      dut.io.corePhy.dq_in(5) #= 0xDDEE
      dut.io.corePhy.dq_in(6) #= 0xBBCC
      dut.io.corePhy.dq_in(7) #= 0x99AA

      dut.io.axi.ar.valid #= true
      dut.io.axi.ar.payload.addr #= 0x2000
      dut.io.axi.ar.payload.len  #= 1 // 2 beats
      dut.io.axi.ar.payload.id   #= 5

      dut.clockDomain.waitSamplingWhere(50)(dut.io.axi.ar.ready.toBoolean)
      dut.clockDomain.waitSampling()
      dut.io.axi.ar.valid #= false

      // Wait for 2 beats on R channel via monitor
      dut.clockDomain.waitSamplingWhere(50)(rBeats.length >= 2)
      assert(rBeats.length == 2, s"Expected 2 read beats, got ${rBeats.length}")

      val (rData0, rLast0, rId0) = rBeats(0)
      val (rData1, rLast1, rId1) = rBeats(1)

      println(s"[SIM] AXI4 R beat 0 received: 0x${rData0.toString(16)}, last=$rLast0, id=$rId0")
      assert(rData0 == BigInt("1122334455667788", 16), "Beat 0 data mismatch")
      assert(!rLast0, "Beat 0 should not be last")
      assert(rId0 == 5, "Beat 0 ID mismatch")

      println(s"[SIM] AXI4 R beat 1 received: 0x${rData1.toString(16)}, last=$rLast1, id=$rId1")
      assert(rData1 == BigInt("99AABBCCDDEEFF00", 16), "Beat 1 data mismatch")
      assert(rLast1, "Beat 1 should have last = true")
      assert(rId1 == 5, "Beat 1 ID mismatch")

      dut.clockDomain.waitSampling(5)
      println("[SIM] AXI4 64-bit Read and Write tests PASSED with 100% SUCCESS!")
    }
  }
}
