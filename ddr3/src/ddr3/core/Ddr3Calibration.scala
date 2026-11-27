package ddr3

import spinal.core._

/**
 * 2-stage pipelined rotation scorer used by read calibration:
 * compares an 8-beat 128-bit capture against all 8 cyclic rotations of trainPat
 * and selects the best beat count (0..8) and rotation index (0..7) via a balanced tree.
 */
private[ddr3] class Ddr3RotationScorer(trainPat: Bits) extends Area {
  val trainLatch = Reg(Bits(128 bits)) init(0)

  private val latchBeats = Vec(Bits(16 bits), 8)
  private val patBeats   = Vec(Bits(16 bits), 8)
  for (i <- 0 until 8) {
    latchBeats(i) := trainLatch(i * 16 + 15 downto i * 16)
    patBeats(i)   := trainPat(i * 16 + 15 downto i * 16)
  }

  private val rotScores = Vec(UInt(4 bits), 8)
  for (r <- 0 until 8) {
    var acc: UInt = U(0, 4 bits)
    for (i <- 0 until 8) {
      acc = acc + (latchBeats(i) === patBeats((i + r) % 8)).asUInt.resize(4)
    }
    rotScores(r) := acc
  }

  val rotScoresReg = Vec(Reg(UInt(4 bits)) init(0), 8)

  private val treeS1 = Vec(UInt(4 bits), 4)
  private val treeI1 = Vec(UInt(3 bits), 4)
  for (k <- 0 until 4) {
    val better = rotScoresReg(2 * k + 1) > rotScoresReg(2 * k)
    treeS1(k) := better ? rotScoresReg(2 * k + 1) | rotScoresReg(2 * k)
    treeI1(k) := better ? U(2 * k + 1, 3 bits) | U(2 * k, 3 bits)
  }

  private val treeS2 = Vec(UInt(4 bits), 2)
  private val treeI2 = Vec(UInt(3 bits), 2)
  for (k <- 0 until 2) {
    val better = treeS1(2 * k + 1) > treeS1(2 * k)
    treeS2(k) := better ? treeS1(2 * k + 1) | treeS1(2 * k)
    treeI2(k) := better ? treeI1(2 * k + 1) | treeI1(2 * k)
  }

  private val betterTop = treeS2(1) > treeS2(0)
  val topScore = betterTop ? treeS2(1) | treeS2(0)
  val topIdx   = betterTop ? treeI2(1) | treeI2(0)

  val sweepScore = Reg(UInt(4 bits)) init(0)
  val sweepRot   = Reg(UInt(3 bits)) init(0)

  def captureStage1(): Unit = {
    rotScoresReg := rotScores
  }

  def captureStage2(): Unit = {
    sweepScore := topScore
    sweepRot   := topIdx
  }

  def resetScorer(): Unit = {
    for (r <- 0 until 8) {
      rotScoresReg(r) := 0
    }
    sweepScore := 0
    sweepRot   := 0
    trainLatch := 0
  }
}
