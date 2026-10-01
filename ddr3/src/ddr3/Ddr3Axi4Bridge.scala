package ddr3

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba4.axi._

/**
 * AXI4 Slave to DDR3 Controller Request/Response Bridge.
 * Decouples AXI protocol from DDR3 burst protocol.
 * Pure digital logic - 100% simulatable with Verilator.
 */
class Ddr3Axi4Bridge(val axiConfig: Axi4Config, val config: Ddr3Config = Ddr3Config()) extends Component {
  val io = new Bundle {
    val axi       = slave(Axi4(axiConfig))
    val init_done = in Bool()

    val req       = master Stream(Ddr3Req(config))
    val rsp       = slave Flow(Ddr3Rsp())
  }

  val is64Bit  = axiConfig.dataWidth == 64
  val is128Bit = axiConfig.dataWidth == 128

  // Read channel FSM
  object ReadState extends SpinalEnum {
    val IDLE, ISSUE_REQ, WAIT_DATA, SEND_BEAT1, SEND_BEAT2 = newElement()
  }
  val rState     = RegInit(ReadState.IDLE)
  val rAddr      = Reg(UInt(axiConfig.addressWidth bits)) init(0)
  val rLen       = Reg(UInt(axiConfig.lenWidth bits)) init(0)
  val rId        = Reg(UInt(axiConfig.idWidth bits)) init(0)
  val rBuf128    = Reg(Bits(128 bits)) init(0)
  val rRemaining = Reg(UInt((axiConfig.lenWidth + 1) bits)) init(0)

  // Write channel FSM
  object WriteState extends SpinalEnum {
    val IDLE, RECV_W, ISSUE_REQ, SEND_RESP = newElement()
  }
  val wState    = RegInit(WriteState.IDLE)
  val wAddr     = Reg(UInt(axiConfig.addressWidth bits)) init(0)
  val wLen      = Reg(UInt(axiConfig.lenWidth bits)) init(0)
  val wId       = Reg(UInt(axiConfig.idWidth bits)) init(0)
  val wBuf128   = Reg(Bits(128 bits)) init(0)
  val wStrb128  = Reg(Bits(16 bits)) init(0)
  val wPhase64  = RegInit(False) // False: beat 0 (low 64), True: beat 1 (high 64)

  // Default controller request assignments
  io.req.valid := False
  io.req.write := False
  io.req.addr  := 0
  io.req.wdata := 0
  io.req.wstrb := B"16'hFFFF"

  // Default AXI handshakes
  io.axi.ar.ready := (rState === ReadState.IDLE) && io.init_done && (wState === WriteState.IDLE)
  io.axi.aw.ready := (wState === WriteState.IDLE) && io.init_done && (rState === ReadState.IDLE)
  io.axi.w.ready  := False

  io.axi.r.valid        := False
  io.axi.r.payload.data := 0
  io.axi.r.payload.id   := rId
  io.axi.r.payload.resp := B"2'b00" // OKAY
  io.axi.r.payload.last := False

  io.axi.b.valid        := False
  io.axi.b.payload.id   := wId
  io.axi.b.payload.resp := B"2'b00" // OKAY

  // Read path
  switch(rState) {
    is(ReadState.IDLE) {
      when(io.axi.ar.valid && io.axi.ar.ready) {
        rAddr      := io.axi.ar.payload.addr
        rLen       := io.axi.ar.payload.len
        rId        := io.axi.ar.payload.id
        rRemaining := (io.axi.ar.payload.len + 1).resized
        rState     := ReadState.ISSUE_REQ
      }
    }

    is(ReadState.ISSUE_REQ) {
      io.req.valid := True
      io.req.write := False
      io.req.addr  := (rAddr >> 4).resized

      when(io.req.ready) {
        rState := ReadState.WAIT_DATA
      }
    }

    is(ReadState.WAIT_DATA) {
      when(io.rsp.valid) {
        rBuf128 := io.rsp.rdata
        rState  := ReadState.SEND_BEAT1
      }
    }

    is(ReadState.SEND_BEAT1) {
      io.axi.r.valid := True
      if (is128Bit) {
        io.axi.r.payload.data := rBuf128.resized
        io.axi.r.payload.last := (rRemaining === 1)
        when(io.axi.r.ready) {
          val nextRemaining = rRemaining - 1
          rRemaining := nextRemaining
          rAddr := rAddr + 16
          when(nextRemaining === 0) {
            rState := ReadState.IDLE
          } otherwise {
            rState := ReadState.ISSUE_REQ
          }
        }
      } else {
        io.axi.r.payload.data := rBuf128(63 downto 0).resized
        io.axi.r.payload.last := (rRemaining === 1)
        when(io.axi.r.ready) {
          val nextRemaining = rRemaining - 1
          rRemaining := nextRemaining
          rAddr := rAddr + 8
          when(nextRemaining === 0) {
            rState := ReadState.IDLE
          } otherwise {
            rState := ReadState.SEND_BEAT2
          }
        }
      }
    }

    is(ReadState.SEND_BEAT2) {
      io.axi.r.valid := True
      io.axi.r.payload.data := rBuf128(127 downto 64).resized
      io.axi.r.payload.last := (rRemaining === 1)
      when(io.axi.r.ready) {
        val nextRemaining = rRemaining - 1
        rRemaining := nextRemaining
        rAddr := rAddr + 8
        when(nextRemaining === 0) {
          rState := ReadState.IDLE
        } otherwise {
          rState := ReadState.ISSUE_REQ
        }
      }
    }
  }

  // Write path
  switch(wState) {
    is(WriteState.IDLE) {
      when(io.axi.aw.valid && io.axi.aw.ready) {
        wAddr    := io.axi.aw.payload.addr
        wLen     := io.axi.aw.payload.len
        wId      := io.axi.aw.payload.id
        wPhase64 := False
        wState   := WriteState.RECV_W
      }
    }

    is(WriteState.RECV_W) {
      io.axi.w.ready := True
      when(io.axi.w.valid) {
        if (is128Bit) {
          wBuf128  := io.axi.w.payload.data.resized
          wStrb128 := io.axi.w.payload.strb.resized
          wState   := WriteState.ISSUE_REQ
        } else {
          when(!wPhase64) {
            wBuf128(63 downto 0)   := io.axi.w.payload.data.resized
            wStrb128(7 downto 0)   := io.axi.w.payload.strb.resized
            wBuf128(127 downto 64) := 0
            wStrb128(15 downto 8)  := 0
            when(io.axi.w.payload.last) {
              wState := WriteState.ISSUE_REQ
            } otherwise {
              wPhase64 := True
            }
          } otherwise {
            wBuf128(127 downto 64) := io.axi.w.payload.data.resized
            wStrb128(15 downto 8)  := io.axi.w.payload.strb.resized
            wPhase64 := False
            wState   := WriteState.ISSUE_REQ
          }
        }
      }
    }

    is(WriteState.ISSUE_REQ) {
      io.req.valid := True
      io.req.write := True
      io.req.addr  := (wAddr >> 4).resized
      io.req.wdata := wBuf128
      io.req.wstrb := wStrb128

      when(io.req.ready) {
        wState := WriteState.SEND_RESP
      }
    }

    is(WriteState.SEND_RESP) {
      io.axi.b.valid := True
      when(io.axi.b.ready) {
        wState := WriteState.IDLE
      }
    }
  }
}
