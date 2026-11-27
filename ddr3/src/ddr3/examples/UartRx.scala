package ddr3

import spinal.core._
import spinal.lib._

/**
 * Simple, glitch-filtered 8N1 UART receiver.
 * Emits a 1-cycle Flow pulse per received byte once the stop bit is sampled high.
 */
class UartRx(clkFreqHz: Int = 75937500, baudRate: Int = 115200) extends Component {
  val io = new Bundle {
    val rxd  = in Bool()
    val read = master Flow(Bits(8 bits))
  }

  val divider = clkFreqHz / baudRate
  require(divider >= 4, s"UartRx clock/baud divider must be >= 4, got $divider")

  val rxSync   = RegNext(RegNext(io.rxd, True), True)
  val cnt      = Reg(UInt(log2Up(divider + 1) bits)) init(0)
  val state    = RegInit(U(0, 2 bits)) // 0: IDLE, 1: START, 2: DATA, 3: STOP
  val bitIdx   = Reg(UInt(3 bits)) init(0)
  val shiftReg = Reg(Bits(8 bits)) init(0)
  val outValid = RegInit(False)

  outValid        := False
  io.read.valid   := outValid
  io.read.payload := shiftReg

  switch(state) {
    is(0) { // IDLE
      when(!rxSync) {
        cnt   := divider / 2 - 1
        state := 1
      }
    }
    is(1) { // START (sample mid-bit)
      when(cnt === 0) {
        when(!rxSync) {
          cnt    := divider - 1
          bitIdx := 0
          state  := 2
        } otherwise {
          state := 0
        }
      } otherwise {
        cnt := cnt - 1
      }
    }
    is(2) { // DATA (8 LSB-first bits)
      when(cnt === 0) {
        shiftReg(bitIdx) := rxSync
        cnt := divider - 1
        when(bitIdx === 7) {
          state := 3
        } otherwise {
          bitIdx := bitIdx + 1
        }
      } otherwise {
        cnt := cnt - 1
      }
    }
    is(3) { // STOP
      when(cnt === 0) {
        outValid := rxSync
        state    := 0
      } otherwise {
        cnt := cnt - 1
      }
    }
  }
}
