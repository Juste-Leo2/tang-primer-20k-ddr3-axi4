package ddr3

import spinal.core._
import spinal.lib._

/**
 * Clean, robust UART transmitter for reporting and console output.
 * Configured for 8N1 (8 data bits, no parity, 1 stop bit).
 */
class UartTx(clkFreqHz: Int = 99560000, baudRate: Int = 115200) extends Component {
  val io = new Bundle {
    val write = slave Stream(Bits(8 bits))
    val txd   = out Bool()
    val busy  = out Bool()
  }

  val divider = clkFreqHz / baudRate
  val bitCounter = Reg(UInt(log2Up(divider + 1) bits)) init(0)
  val bitTick = bitCounter === divider - 1

  when(bitTick) {
    bitCounter := 0
  } otherwise {
    bitCounter := bitCounter + 1
  }

  val state = RegInit(U(0, 4 bits))
  // state 0: IDLE
  // state 1: START bit (0)
  // state 2..9: DATA bits 0..7
  // state 10: STOP bit (1)

  val shiftReg = Reg(Bits(8 bits)) init(0)
  val txdReg   = Reg(Bool()) init(True)

  io.busy := state =/= 0
  io.write.ready := state === 0
  io.txd := txdReg

  when(state === 0) {
    txdReg := True
    when(io.write.valid) {
      shiftReg := io.write.payload
      state := 1
      bitCounter := 0
    }
  } otherwise {
    when(bitTick) {
      switch(state) {
        is(1) { // START bit
          txdReg := False
          state := 2
        }
        for (i <- 0 until 8) {
          is(2 + i) { // DATA bits
            txdReg := shiftReg(i)
            state := (if (i == 7) 10 else 3 + i)
          }
        }
        is(10) { // STOP bit
          txdReg := True
          state := 0
        }
      }
    }
  }
}
