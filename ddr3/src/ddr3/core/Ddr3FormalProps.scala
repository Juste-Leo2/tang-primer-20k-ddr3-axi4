package ddr3

import spinal.core._
import spinal.core.formal._

/**
 * SymbiYosys formal verification properties (P1-P14) for Ddr3ControllerCore.
 * Elaborated only under GenerationFlags.formal: zero impact on Ddr3Gen Verilog output.
 */
private[ddr3] object Ddr3FormalProps {
  def bind(core: Ddr3ControllerCore): Unit = {
    if (GenerationFlags.formal) {
      import core._
      when(pastValidAfterReset()) {
        // P1: accept in IDLE (idle, no refresh) or during active same-row stream
        assert(io.req.ready === acceptReq)
        // P2: response handshake mirrors data_ready
        assert(io.rsp.valid === data_ready)
        // P3: 128-bit assembly wiring with locked de-rotation + cross-cycle split reassembly
        for (j <- 0 until 8) {
          val slot = derot(j)
          val expBeat = (needRotSplit && U(j, 3 bits) < bestRot) ? dqPrevVec(slot) | dqVec(slot)
          assert(io.rsp.rdata(j * 16 + 15 downto j * 16) === expBeat.asBits)
        }
        // P4: data_ready implies busy (cleared together)
        assert(!data_ready || busy)
        // P5: init_done implies both calibrations done
        assert(!io.init_done || (wlevel_done && rcalib_done))
        // P6: DQS read strobe is all lanes or nothing
        assert(io.phy.dqs_read === B"4'b0000" || io.phy.dqs_read === B"4'b1111")
        // P7: functional READs carry BL8 (A12) WITHOUT auto-precharge (A10=0).
        // P8: calibration WRITEs keep auto-precharge (A10=1); functional WRITEs keep row open (A10=0).
        when(state === Ddr3State.READ && cycle === config.RCD / 4 + 1) {
          assert(A(config.RCD % 4)(12) && !A(config.RCD % 4)(10))
        }
        when(state === Ddr3State.READ && cycle === config.RCD / 4 + 2) {
          assert(A(config.RCD % 4)(12) && !A(config.RCD % 4)(10))
        }
        when(state === Ddr3State.WRITE && trainDone && cycle === config.RCD / 4 + 1) {
          assert(A(config.RCD % 4)(12) && A(config.RCD % 4)(10))
        }
        when(state === Ddr3State.WRITE && !trainDone && cycle === config.RCD / 4 + 1) {
          assert(A(config.RCD % 4)(12) && !A(config.RCD % 4)(10))
        }
        // P9: no DQ/DQS bus contention outside write drive windows.
        val wc = (config.RCD + config.CWL) / 4
        when(!(state === Ddr3State.WRITE && ((trainDone && (cycle === wc + 1 || cycle === wc + 2)) || (!trainDone && (st1Valid || st2Valid || st3Valid))))) {
          assert(dq_oen === B"4'b1111")
        }
        when(!(state === Ddr3State.WRITE_LEVELING) && !(state === Ddr3State.WRITE && ((trainDone && (cycle === wc + 1 || cycle === wc + 2 || cycle === wc + 3)) || (!trainDone && (st1Valid || st2Valid || st3Valid || (wrCooldown =/= 0)))))) {
          assert(dqs_oen === B"4'b1111")
        }
        // P10: mode-register program order MR2 -> MR3 -> MR1 -> MR0.
        when(state === Ddr3State.CONFIG && cycle === 1) {
          assert(BA(0) === MR2(15 downto 13) && A(0) === MR2(12 downto 0).resized)
        }
        when(state === Ddr3State.CONFIG && cycle === config.MRD / 4 + 1) {
          assert(BA(0) === MR3(15 downto 13) && A(0) === MR3(12 downto 0).resized)
        }
        when(state === Ddr3State.CONFIG && cycle === config.MRD / 2 + 1) {
          assert(BA(0) === MR1(15 downto 13) && A(0) === MR1(12 downto 0).resized)
        }
        when(state === Ddr3State.CONFIG && cycle === config.MRD * 3 / 4 + 1) {
          assert(BA(0) === MR0(15 downto 13) && A(0) === MR0(12 downto 0).resized)
        }
        // P11: ZQ long calibration has A10 set.
        when(state === Ddr3State.ZQCL && cycle === config.MRD * 3 / 4 + config.MOD / 4 + 2) {
          assert(A(0)(10))
        }
        // P12: data_ready only inside READ.
        assert(!data_ready || state === Ddr3State.READ)
        // P13: write datapath mapping (beats + DM vs wstrb), observable next cycle (legacy calib path).
        when(state === Ddr3State.WRITE && trainDone && cycle === wc + 1 && wrMode === 0) {
          assert(dq_out(7) === reqReg.wdata(15 downto 0))
          assert(dq_out(6) === 0)
          assert(dm_out(7) === !reqReg.wstrb(1 downto 0).orR)
          assert(dm_out(6))
        }
        when(state === Ddr3State.WRITE && trainDone && cycle === wc + 2 && wrMode === 0) {
          assert(dq_out(0) === reqReg.wdata(31 downto 16))
          assert(dq_out(1) === reqReg.wdata(47 downto 32))
          assert(dq_out(2) === reqReg.wdata(63 downto 48))
          assert(dq_out(3) === reqReg.wdata(79 downto 64))
          assert(dq_out(4) === reqReg.wdata(95 downto 80))
          assert(dq_out(5) === reqReg.wdata(111 downto 96))
          assert(dq_out(6) === reqReg.wdata(127 downto 112))
          assert(dq_out(7) === 0)
          assert(dm_out(0) === !reqReg.wstrb(3 downto 2).orR)
          assert(dm_out(1) === !reqReg.wstrb(5 downto 4).orR)
          assert(dm_out(2) === !reqReg.wstrb(7 downto 6).orR)
          assert(dm_out(3) === !reqReg.wstrb(9 downto 8).orR)
          assert(dm_out(4) === !reqReg.wstrb(11 downto 10).orR)
          assert(dm_out(5) === !reqReg.wstrb(13 downto 12).orR)
          assert(dm_out(6) === !reqReg.wstrb(15 downto 14).orR)
          assert(dm_out(7))
        }
        // P14: open-page invariants - never auto-refresh while a row is open, and commands match openBank.
        assert(!(state === Ddr3State.REFRESH && rowOpen))
        when((state === Ddr3State.READ || state === Ddr3State.WRITE) && cycle === config.RCD / 4 + 1) {
          assert(BA(config.RCD % 4) === openBank || trainDone)
        }
        // Reachability sanity
        cover(state === Ddr3State.CONFIG)
        cover(io.req.fire)
      }
    }
  }
}
