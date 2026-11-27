package ddr3

import spinal.core._
import spinal.lib.bus.amba4.axi.Axi4Config

/** Sim-only variant (short init timeouts) for iverilog vs Micron model. */
class Ddr3ControllerSim extends Ddr3Controller(Ddr3Config.simulation())

object Ddr3Gen {
  def main(args: Array[String]): Unit = {
    val spinalConfig = SpinalConfig(
      targetDirectory = "hw/gen",
      headerWithDate = true
    )

    val envWidth = sys.env.get("DDR3_AXI_WIDTH")
    val width =
      if (args.contains("--32") || envWidth.contains("32")) 32
      else if (args.contains("--128") || envWidth.contains("128")) 128
      else 64
    val useCdc = args.contains("--cdc") || sys.env.get("DDR3_AXI_CDC").contains("1")

    val axiConfig = Ddr3Axi4.defaultAxiConfig(dataWidth = width)
    val hwConfig  = Ddr3Config.tangPrimer20k()

    println("Generating Ddr3Controller Verilog...")
    spinalConfig.generateVerilog(new Ddr3Controller(hwConfig))

    println(s"Generating Ddr3Axi4 (${width}-bit AXI4) Verilog...")
    spinalConfig.generateVerilog(new Ddr3Axi4(axiConfig, hwConfig))

    println(s"Generating TangPrimer20kDdr3 (${width}-bit AXI4 plug-and-play) Verilog...")
    spinalConfig.generateVerilog(new TangPrimer20kDdr3(axiConfig, hwConfig))

    val cdcLabel = if (useCdc) ", async 27MHz Axi4CC" else ""
    println(s"Generating Ddr3TesterTop (${width}-bit AXI4${cdcLabel} hardware top for Tang Primer 20K)...")
    spinalConfig.generateVerilog(new Ddr3TesterTop(axiConfig, hwConfig, useAsyncAxiClock = useCdc))

    println("Generating Ddr3ControllerSim (iverilog sim vs Micron model, short timeouts)...")
    spinalConfig.generateVerilog(new Ddr3ControllerSim)

    println("Done! Verilog files are in hw/gen/")
  }
}
