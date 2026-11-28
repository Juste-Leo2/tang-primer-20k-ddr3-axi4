package ddr3

import spinal.core._
import spinal.lib._

/**
 * Zero-latency FIFO forced to distributed LUTRAM (syn_ramstyle = "distributed")
 * so Gowin synthesis never packs registered AXI outputs into slow BSRAM DO latches.
 * Full/empty/occupancy are pure flip-flops for high Fmax timing closure.
 */
class DistLowLatencyFifo[T <: Data](dataType: HardType[T], depth: Int) extends Component {
  require(isPow2(depth))
  val io = new Bundle {
    val push      = slave Stream(dataType())
    val pop       = master Stream(dataType())
    val occupancy = out UInt(log2Up(depth + 1) bits)
  }

  val ptrWidth     = log2Up(depth)
  val pushPtr      = Reg(UInt(ptrWidth bits)) init(0)
  val popPtr       = Reg(UInt(ptrWidth bits)) init(0)
  val emptyReg     = RegInit(True)
  val fullReg      = RegInit(False)
  val occupancyReg = Reg(UInt(log2Up(depth + 1) bits)) init(0)

  val ram = Mem(dataType(), depth)
  ram.addAttribute("syn_ramstyle", "distributed")

  io.push.ready  := !fullReg
  io.pop.valid   := !emptyReg
  io.pop.payload := ram.readAsync(popPtr)
  io.occupancy   := occupancyReg

  val pushFire = io.push.fire
  val popFire  = io.pop.fire

  when(pushFire) {
    ram.write(pushPtr, io.push.payload)
    pushPtr := pushPtr + 1
  }
  when(popFire) {
    popPtr := popPtr + 1
  }
  when(pushFire && !popFire) {
    emptyReg     := False
    occupancyReg := occupancyReg + 1
    when(occupancyReg === (depth - 1)) {
      fullReg := True
    }
  } elsewhen(!pushFire && popFire) {
    fullReg      := False
    occupancyReg := occupancyReg - 1
    when(occupancyReg === 1) {
      emptyReg := True
    }
  }
}
