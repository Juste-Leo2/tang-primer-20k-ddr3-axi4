package ddr3

import spinal.core._
import spinal.lib.bus.amba4.axi.Axi4Config

/** Sim-only variant (short init timeouts) for iverilog vs Micron model. */
class Ddr3ControllerSim extends Ddr3Controller(Ddr3Config(rowWidth = 14, bankWidth = 3, isSimulation = true))

object Ddr3Gen {
  def main(args: Array[String]): Unit = {
    val spinalConfig = SpinalConfig(
      targetDirectory = "hw/gen",
      headerWithDate = true
    )

    println("Generating Ddr3Controller Verilog...")
    spinalConfig.generateVerilog(new Ddr3Controller(Ddr3Config(rowWidth = 14, bankWidth = 3)))

    println("Generating Ddr3Axi4 (64-bit data, SpinalML compatible) Verilog...")
    val axi64Config = Axi4Config(addressWidth = 32, dataWidth = 64, idWidth = 4)
    spinalConfig.generateVerilog(new Ddr3Axi4(axi64Config, Ddr3Config(rowWidth = 14, bankWidth = 3)))

    println("Generating Ddr3Axi4 (128-bit data) Verilog...")
    val axi128Config = Axi4Config(addressWidth = 32, dataWidth = 128, idWidth = 4)
    spinalConfig.generateVerilog(new Ddr3Axi4(axi128Config, Ddr3Config(rowWidth = 14, bankWidth = 3)))

    println("Generating Ddr3TesterTop (Hardware bitstream top for Tang Primer 20K)...")
    spinalConfig.generateVerilog(new Ddr3TesterTop(axi64Config, Ddr3Config(rowWidth = 14, bankWidth = 3)))

    println("Generating Ddr3ControllerSim (iverilog sim vs Micron model, short timeouts)...")
    spinalConfig.generateVerilog(new Ddr3ControllerSim)

    println("Done! Verilog files are in hw/gen/")
  }
}
