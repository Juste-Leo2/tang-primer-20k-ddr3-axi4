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
      // eye sweep + nested-K read sweep (~65 mags x 8 K-groups x 4 pos x 2
      // sides x ~13 pclk) + training/poison.
      dut.clockDomain.waitSamplingWhere(120000)(dut.io.init_done.toBoolean)
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

  test("DDR3 AXI4 32-bit, 64-bit, and 128-bit Burst Streaming Throughput") {
    for (dataW <- Seq(32, 64, 128)) {
      val axiCfg = Axi4Config(addressWidth = 32, dataWidth = dataW, idWidth = 4)
      val beatBytes = dataW / 8
      val burstSize = Integer.numberOfTrailingZeros(beatBytes)
      val fullMask  = (BigInt(1) << beatBytes) - 1
      SimConfig.compile(new Ddr3Axi4SimHarness(axiCfg, Ddr3Config(isSimulation = true))).doSim { dut =>
        dut.clockDomain.forkStimulus(period = 10)
        dut.io.axi.ar.valid #= false
        dut.io.axi.aw.valid #= false
        dut.io.axi.w.valid  #= false
        dut.io.axi.b.ready  #= true
        dut.io.axi.r.ready  #= true
        dut.io.corePhy.dlllock    #= false
        dut.io.corePhy.rst_lock_n #= false
        dut.io.corePhy.rburst     #= 0
        dut.io.corePhy.dq_raw     #= 0
        for (i <- 0 until 8) dut.io.corePhy.dq_in(i) #= 0
        dut.clockDomain.waitSampling(5)
        dut.io.corePhy.dlllock    #= true
        dut.io.corePhy.rst_lock_n #= true

        fork {
          var wlTimer = 0
          while (!dut.io.init_done.toBoolean) {
            if (dut.io.corePhy.dqs_out.toBigInt == 0xAA || dut.io.corePhy.dqs_out.toBigInt == 0x55) wlTimer = 12
            dut.io.corePhy.dq_raw #= (if (wlTimer > 0) { wlTimer -= 1; (1 | (1 << 8)) } else 0)
            dut.io.corePhy.rburst #= (if (dut.io.corePhy.dqs_read.toBigInt == 0x0F) 3 else 0)
            dut.clockDomain.waitSampling()
          }
        }
        dut.clockDomain.waitSamplingWhere(120000)(dut.io.init_done.toBoolean)
        assert(dut.io.init_done.toBoolean)
        dut.clockDomain.waitSampling(5)

        // Feed distinct beat words on dq_in (rot=0 in this mock)
        for (i <- 0 until 8) dut.io.corePhy.dq_in(i) #= (0xA000 + i)

        // 512 bytes per burst (64 beats @ 64b, 32 beats @ 128b)
        val totalBytes = 512
        val beats = totalBytes / (dataW / 8)
        var cycles = 0L
        fork {
          while (true) {
            dut.clockDomain.waitSampling()
            cycles += 1
          }
        }

        // Write burst
        val wStart = cycles
        dut.io.axi.aw.valid #= true
        dut.io.axi.aw.payload.addr  #= 0x4000
        dut.io.axi.aw.payload.len   #= beats - 1
        dut.io.axi.aw.payload.size  #= burstSize
        dut.io.axi.aw.payload.burst #= 1
        dut.io.axi.aw.payload.id    #= 1
        dut.clockDomain.waitSamplingWhere(50)(dut.io.axi.aw.ready.toBoolean)
        dut.clockDomain.waitSampling()
        dut.io.axi.aw.valid #= false

        dut.io.axi.w.valid #= true
        for (b <- 0 until beats) {
          dut.io.axi.w.payload.data #= BigInt(b + 1)
          dut.io.axi.w.payload.strb #= fullMask
          dut.io.axi.w.payload.last #= (b == beats - 1)
          dut.clockDomain.waitSamplingWhere(50)(dut.io.axi.w.ready.toBoolean)
          dut.clockDomain.waitSampling()
        }
        dut.io.axi.w.valid #= false
        dut.clockDomain.waitSamplingWhere(200)(dut.io.axi.b.valid.toBoolean)
        assert(dut.io.axi.b.valid.toBoolean, s"${dataW}b bulk write B timeout")
        val wCycles = cycles - wStart

        dut.clockDomain.waitSampling(5)

        // Read burst
        var rCount = 0
        fork {
          while (rCount < beats) {
            if (dut.io.axi.r.valid.toBoolean && dut.io.axi.r.ready.toBoolean) {
              val last = dut.io.axi.r.payload.last.toBoolean
              assert(last == (rCount == beats - 1), s"${dataW}b RLAST mismatch at beat $rCount")
              rCount += 1
            }
            dut.clockDomain.waitSampling()
          }
        }

        val rStart = cycles
        dut.io.axi.ar.valid #= true
        dut.io.axi.ar.payload.addr  #= 0x4000
        dut.io.axi.ar.payload.len   #= beats - 1
        dut.io.axi.ar.payload.size  #= burstSize
        dut.io.axi.ar.payload.burst #= 1
        dut.io.axi.ar.payload.id    #= 2
        dut.clockDomain.waitSamplingWhere(50)(dut.io.axi.ar.ready.toBoolean)
        dut.clockDomain.waitSampling()
        dut.io.axi.ar.valid #= false

        dut.clockDomain.waitSamplingWhere(200)(rCount == beats)
        assert(rCount == beats, s"${dataW}b bulk read incomplete: $rCount/$beats")
        val rCycles = cycles - rStart
        val wBw = (totalBytes * 75.9375) / wCycles
        val rBw = (totalBytes * 75.9375) / rCycles
        println(f"[BENCH ${dataW}b] 512B Write=$wCycles cyc (${wBw}%.1f MB/s @75.94MHz), Read=$rCycles cyc (${rBw}%.1f MB/s @75.94MHz)")
      }
    }
  }

  test("DDR3 AXI4 32-bit Async Clock-Domain Crossing (Axi4CC) + Unaligned Beat") {
    class AsyncCdcHarness extends Component {
      val axiCfg = Ddr3Axi4.defaultAxiConfig(dataWidth = 32)
      val userCd = ClockDomain.external("userCd")
      val io = new Bundle {
        val axi       = slave(Axi4(axiCfg))
        val init_done = out Bool()
      }
      val cfg    = Ddr3Config.simulation()
      val coreCd = ClockDomain.current
      val cc     = new Axi4CC(axiCfg, inputCd = userCd, outputCd = coreCd, 8, 8, 16, 16, 8)
      val bridge = new Ddr3Axi4Bridge(axiCfg, cfg)
      val core   = new Ddr3ControllerCore(cfg)

      cc.io.input         <> io.axi
      bridge.io.axi       <> cc.io.output
      bridge.io.init_done := core.io.init_done
      core.io.req         <> bridge.io.req
      bridge.io.rsp       <> core.io.rsp
      io.init_done        := core.io.init_done

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

      // Byte-strobe-aware 128-bit memory loopback
      val mem = Mem(Bits(128 bits), 64)
      val curWord = mem.readAsync(core.io.req.payload.addr(5 downto 0))
      val nextWord = Bits(128 bits)
      for (byteIdx <- 0 until 16) {
        nextWord(byteIdx * 8 + 7 downto byteIdx * 8) :=
          core.io.req.payload.wstrb(byteIdx) ?
            core.io.req.payload.wdata(byteIdx * 8 + 7 downto byteIdx * 8) |
            curWord(byteIdx * 8 + 7 downto byteIdx * 8)
      }
      when(core.io.req.fire && core.io.req.payload.write) {
        mem.write(core.io.req.payload.addr(5 downto 0), nextWord)
      }
      val rdFifo = new StreamFifo(Bits(128 bits), 64)
      rdFifo.io.push.valid   := core.io.req.fire && !core.io.req.payload.write
      rdFifo.io.push.payload := curWord
      rdFifo.io.pop.ready    := core.io.rsp.valid
      val rOut = rdFifo.io.pop.valid ? rdFifo.io.pop.payload | B(0, 128 bits)
      for (i <- 0 until 8) {
        core.io.phy.dq_in(i) := rOut(i * 16 + 15 downto i * 16)
      }
    }

    SimConfig.compile(new AsyncCdcHarness).doSim { dut =>
      dut.clockDomain.forkStimulus(period = 10)
      dut.userCd.forkStimulus(period = 14) // Async user clock (~71.4 MHz vs 100 MHz pclk)

      dut.io.axi.aw.valid #= false
      dut.io.axi.w.valid  #= false
      dut.io.axi.b.ready  #= true
      dut.io.axi.ar.valid #= false
      dut.io.axi.r.ready  #= true

      dut.clockDomain.waitSamplingWhere(120000)(dut.io.init_done.toBoolean)
      assert(dut.io.init_done.toBoolean, "Async CDC harness failed to initialize")
      dut.userCd.waitSampling(5)

      def waitHandShake(ready: => Boolean): Unit = {
        do { dut.userCd.waitSampling() } while (!ready)
      }

      // Write 4 aligned 32-bit beats at 0x0040
      val expected4 = Seq(0x11112222L, 0x33334444L, 0x55556666L, 0x77778888L)
      dut.io.axi.aw.valid #= true
      dut.io.axi.aw.payload.addr  #= 0x0040
      dut.io.axi.aw.payload.len   #= 3
      dut.io.axi.aw.payload.size  #= 2
      dut.io.axi.aw.payload.burst #= 1
      dut.io.axi.aw.payload.id    #= 7
      waitHandShake(dut.io.axi.aw.ready.toBoolean)
      dut.io.axi.aw.valid #= false

      dut.io.axi.w.valid #= true
      for ((word, idx) <- expected4.zipWithIndex) {
        dut.io.axi.w.payload.data #= word
        dut.io.axi.w.payload.strb #= 0xF
        dut.io.axi.w.payload.last #= (idx == 3)
        waitHandShake(dut.io.axi.w.ready.toBoolean)
      }
      dut.io.axi.w.valid #= false
      dut.userCd.waitSamplingWhere(100)(dut.io.axi.b.valid.toBoolean)
      assert(dut.io.axi.b.valid.toBoolean, "32b CDC write B timeout")

      // Overwrite only 32-bit lane 2 (addr 0x0048) via single-beat unaligned write
      dut.io.axi.aw.valid #= true
      dut.io.axi.aw.payload.addr  #= 0x0048
      dut.io.axi.aw.payload.len   #= 0
      dut.io.axi.aw.payload.size  #= 2
      dut.io.axi.aw.payload.burst #= 1
      dut.io.axi.aw.payload.id    #= 9
      waitHandShake(dut.io.axi.aw.ready.toBoolean)
      dut.io.axi.aw.valid #= false

      dut.io.axi.w.valid #= true
      dut.io.axi.w.payload.data #= 0xAABBCCDDL
      dut.io.axi.w.payload.strb #= 0xF
      dut.io.axi.w.payload.last #= true
      waitHandShake(dut.io.axi.w.ready.toBoolean)
      dut.io.axi.w.valid #= false
      dut.userCd.waitSamplingWhere(100)(dut.io.axi.b.valid.toBoolean)
      assert(dut.io.axi.b.valid.toBoolean, "32b CDC unaligned write B timeout")

      // Read back all 4 beats via CDC and verify lane 2 was updated without corrupting siblings
      val got = ArrayBuffer[Long]()
      fork {
        while (got.length < 4) {
          if (dut.io.axi.r.valid.toBoolean && dut.io.axi.r.ready.toBoolean) {
            got += dut.io.axi.r.payload.data.toLong
          }
          dut.userCd.waitSampling()
        }
      }
      dut.io.axi.ar.valid #= true
      dut.io.axi.ar.payload.addr  #= 0x0040
      dut.io.axi.ar.payload.len   #= 3
      dut.io.axi.ar.payload.size  #= 2
      dut.io.axi.ar.payload.burst #= 1
      dut.io.axi.ar.payload.id    #= 4
      waitHandShake(dut.io.axi.ar.ready.toBoolean)
      dut.io.axi.ar.valid #= false
      dut.userCd.waitSamplingWhere(150)(got.length == 4)

      val expectedAfter = Seq(0x11112222L, 0x33334444L, 0xAABBCCDDL, 0x77778888L)
      assert(got.toSeq == expectedAfter, s"32b CDC mismatch: got=${got.map(_.toHexString)}, expected=${expectedAfter.map(_.toHexString)}")
      println("[SIM 32b+CDC] Async Axi4CC + unaligned 32-bit lane write/read PASSED!")
    }
  }

  test("DDR3 AXI4 64-bit & 128-bit Mixed R/W and Short Row-Miss Workload Benchmark") {
    for (dataW <- Seq(64, 128)) {
      val axiCfg    = Axi4Config(addressWidth = 32, dataWidth = dataW, idWidth = 4)
      val beatBytes = dataW / 8
      val burstSize = Integer.numberOfTrailingZeros(beatBytes)
      val fullMask  = (BigInt(1) << beatBytes) - 1

      SimConfig.compile(new Ddr3Axi4SimHarness(axiCfg, Ddr3Config(isSimulation = true))).doSim { dut =>
        dut.clockDomain.forkStimulus(period = 10)
        dut.io.axi.ar.valid #= false
        dut.io.axi.aw.valid #= false
        dut.io.axi.w.valid  #= false
        dut.io.axi.b.ready  #= true
        dut.io.axi.r.ready  #= true
        dut.io.corePhy.dlllock    #= false
        dut.io.corePhy.rst_lock_n #= false
        dut.io.corePhy.rburst     #= 0
        dut.io.corePhy.dq_raw     #= 0
        for (i <- 0 until 8) dut.io.corePhy.dq_in(i) #= (0xB000 + i)
        dut.clockDomain.waitSampling(5)
        dut.io.corePhy.dlllock    #= true
        dut.io.corePhy.rst_lock_n #= true

        fork {
          var wlTimer = 0
          while (!dut.io.init_done.toBoolean) {
            if (dut.io.corePhy.dqs_out.toBigInt == 0xAA || dut.io.corePhy.dqs_out.toBigInt == 0x55) wlTimer = 12
            dut.io.corePhy.dq_raw #= (if (wlTimer > 0) { wlTimer -= 1; (1 | (1 << 8)) } else 0)
            dut.io.corePhy.rburst #= (if (dut.io.corePhy.dqs_read.toBigInt == 0x0F) 3 else 0)
            dut.clockDomain.waitSampling()
          }
        }
        dut.clockDomain.waitSamplingWhere(120000)(dut.io.init_done.toBoolean)
        assert(dut.io.init_done.toBoolean)
        dut.clockDomain.waitSampling(5)

        var cycles = 0L
        fork {
          while (true) { dut.clockDomain.waitSampling(); cycles += 1 }
        }

        def doWrite(addr: Long, beats: Int): Long = {
          val t0 = cycles
          dut.io.axi.aw.valid         #= true
          dut.io.axi.aw.payload.addr  #= addr
          dut.io.axi.aw.payload.len   #= beats - 1
          dut.io.axi.aw.payload.size  #= burstSize
          dut.io.axi.aw.payload.burst #= 1
          dut.io.axi.aw.payload.id    #= 1
          do { dut.clockDomain.waitSampling() } while (!dut.io.axi.aw.ready.toBoolean)
          dut.io.axi.aw.valid #= false

          dut.io.axi.w.valid #= true
          for (b <- 0 until beats) {
            dut.io.axi.w.payload.data #= BigInt(b + 1)
            dut.io.axi.w.payload.strb #= fullMask
            dut.io.axi.w.payload.last #= (b == beats - 1)
            do { dut.clockDomain.waitSampling() } while (!dut.io.axi.w.ready.toBoolean)
          }
          dut.io.axi.w.valid #= false
          dut.clockDomain.waitSamplingWhere(200)(dut.io.axi.b.valid.toBoolean)
          assert(dut.io.axi.b.valid.toBoolean, s"${dataW}b write B timeout at 0x${addr.toHexString}")
          cycles - t0
        }

        def doRead(addr: Long, beats: Int): Long = {
          val t0 = cycles
          var rCount = 0
          val mon = fork {
            while (rCount < beats) {
              if (dut.io.axi.r.valid.toBoolean && dut.io.axi.r.ready.toBoolean) rCount += 1
              dut.clockDomain.waitSampling()
            }
          }
          dut.io.axi.ar.valid         #= true
          dut.io.axi.ar.payload.addr  #= addr
          dut.io.axi.ar.payload.len   #= beats - 1
          dut.io.axi.ar.payload.size  #= burstSize
          dut.io.axi.ar.payload.burst #= 1
          dut.io.axi.ar.payload.id    #= 2
          do { dut.clockDomain.waitSampling() } while (!dut.io.axi.ar.ready.toBoolean)
          dut.io.axi.ar.valid #= false
          dut.clockDomain.waitSamplingWhere(200)(rCount == beats)
          assert(rCount == beats, s"${dataW}b read R timeout at 0x${addr.toHexString}")
          cycles - t0
        }

        val bursts64 = 8
        val beats64  = 64 / beatBytes

        // 1. Short 64B bursts: same-row hits vs +0x800 row-miss
        val wrHit64  = (0 until bursts64).map(i => doWrite(0x10000L + i * 64L, beats64)).sum
        val rdHit64  = (0 until bursts64).map(i => doRead(0x10000L + i * 64L, beats64)).sum
        val wrMiss64 = (0 until bursts64).map(i => doWrite(0x20000L + i * 2048L, beats64)).sum
        val rdMiss64 = (0 until bursts64).map(i => doRead(0x20000L + i * 2048L, beats64)).sum

        // 2. Mixed R/W alternating 64B (WR then RD per step): same-row vs row-miss
        val mixHitCyc  = (0 until bursts64).map(i => doWrite(0x30000L + i * 64L, beats64) + doRead(0x30000L + i * 64L, beats64)).sum
        val mixMissCyc = (0 until bursts64).map(i => doWrite(0x40000L + i * 2048L, beats64) + doRead(0x40000L + i * 2048L, beats64)).sum

        val totB = bursts64 * 64.0
        println(f"[WORKLOAD ${dataW}b @75.94MHz] 8x64B Hit: WR=${totB * 75.9375 / wrHit64}%.1f MB/s, RD=${totB * 75.9375 / rdHit64}%.1f MB/s")
        println(f"[WORKLOAD ${dataW}b @75.94MHz] 8x64B RowMiss: WR=${totB * 75.9375 / wrMiss64}%.1f MB/s, RD=${totB * 75.9375 / rdMiss64}%.1f MB/s")
        println(f"[WORKLOAD ${dataW}b @75.94MHz] Mixed R/W 8x(64B+64B): Hit=${2 * totB * 75.9375 / mixHitCyc}%.1f MB/s, RowMiss=${2 * totB * 75.9375 / mixMissCyc}%.1f MB/s")

        // 3. Single-block (16B) scalar latency (hit vs row-miss)
        val beats16 = 16 / beatBytes
        val wr16Hit  = (0 until 4).map(i => doWrite(0x50000L + i * 16L, beats16)).sum / 4.0
        val rd16Hit  = (0 until 4).map(i => doRead(0x50000L + i * 16L, beats16)).sum / 4.0
        val wr16Miss = (0 until 4).map(i => doWrite(0x60000L + i * 2048L, beats16)).sum / 4.0
        val rd16Miss = (0 until 4).map(i => doRead(0x60000L + i * 2048L, beats16)).sum / 4.0
        val nsPerCyc = 1000.0 / 75.9375
        println(f"[LATENCY ${dataW}b @75.94MHz] 16B Hit: WR=${wr16Hit}%.1f cyc (${wr16Hit * nsPerCyc}%.0f ns), RD=${rd16Hit}%.1f cyc (${rd16Hit * nsPerCyc}%.0f ns)")
        println(f"[LATENCY ${dataW}b @75.94MHz] 16B RowMiss: WR=${wr16Miss}%.1f cyc (${wr16Miss * nsPerCyc}%.0f ns), RD=${rd16Miss}%.1f cyc (${rd16Miss * nsPerCyc}%.0f ns)")
      }
    }
  }
}
