package ddr3

import spinal.core._
import spinal.lib._

/**
 * Zero-latency FIFO forced to distributed LUTRAM (syn_ramstyle = "distributed")
 * so Gowin synthesis never packs registered AXI outputs into slow BSRAM DO latches.
 */
class DistLowLatencyFifo[T <: Data](dataType: HardType[T], depth: Int) extends Component {
  require(isPow2(depth))
  val io = new Bundle {
    val push      = slave Stream(dataType())
    val pop       = master Stream(dataType())
    val occupancy = out UInt(log2Up(depth + 1) bits)
  }

  val ptrWidth        = log2Up(depth)
  val pushPtr         = Reg(UInt(ptrWidth bits)) init(0)
  val popPtr          = Reg(UInt(ptrWidth bits)) init(0)
  val risingOccupancy = RegInit(False)

  val ptrMatch = pushPtr === popPtr
  val empty    = ptrMatch && !risingOccupancy
  val full     = ptrMatch && risingOccupancy

  val ram = Mem(dataType(), depth)
  ram.addAttribute("syn_ramstyle", "distributed")

  io.push.ready  := !full
  io.pop.valid   := !empty
  io.pop.payload := ram.readAsync(popPtr)

  when(io.push.fire) {
    ram.write(pushPtr, io.push.payload)
    pushPtr := pushPtr + 1
  }
  when(io.pop.fire) {
    popPtr := popPtr + 1
  }
  when(io.push.fire =/= io.pop.fire) {
    risingOccupancy := io.push.fire
  }

  val ptrDiff = (pushPtr - popPtr).resize(log2Up(depth + 1))
  io.occupancy := empty ? U(0, log2Up(depth + 1) bits) | (full ? U(depth, log2Up(depth + 1) bits) | ptrDiff)
}
