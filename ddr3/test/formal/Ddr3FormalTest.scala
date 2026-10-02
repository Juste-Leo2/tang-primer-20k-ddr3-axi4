package ddr3

import spinal.core._
import spinal.core.formal._

/** SymbiYosys proof harness for Ddr3ControllerCore (template spinalML).
  *
  * The safety properties (P1-P8) live in Ddr3ControllerCore under
  * `if (GenerationFlags.formal)` (zero impact on Ddr3Gen output).
  * PHY inputs are left free (anyseq): proofs hold for any PHY behavior.
  *
  * Requires: sby + yosys + boolector in PATH (oss-cad-suite, see
  * build.mill forkEnv). Run with:
  *   powershell: .\mill.bat -i ddr3.test.runMain ddr3.Ddr3FormalProof
  */
class Ddr3FormalTop extends Component {
  val dut = FormalDut(new Ddr3ControllerCore(Ddr3Config(isSimulation = true)))

  anyseq(dut.io.req.valid)
  anyseq(dut.io.req.payload)
  anyseq(dut.io.phy.dlllock)
  anyseq(dut.io.phy.rst_lock_n)
  anyseq(dut.io.phy.rburst)
  anyseq(dut.io.phy.dq_raw)
  for (i <- 0 until 8) {
    anyseq(dut.io.phy.dq_in(i))
  }

  assumeInitial(clockDomain.isResetActive)
}

object Ddr3FormalProof {
  def main(args: Array[String]): Unit = {
    implicit val className: String = "Ddr3FormalBmc"
    FormalConfig
      .withSymbiYosys
      .withBMC(300)
      .withTimeout(600)
      .withDebug
      .withSyncResetDefault
      .withEngies(List(SmtBmc(solver = SmtBmcSolver.Boolector)))
      .workspacePath("formal")
      .doVerify(new Ddr3FormalTop, "ddr3_core")
  }
}
