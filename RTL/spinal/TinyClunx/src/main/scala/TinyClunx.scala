package TinyClunx

import spinal.core._
import spinal.lib._
import spinal.lib.bus.amba3.apb._
import spinal.lib.bus.amba4.axi._
import spinal.lib.bus.wishbone.{Wishbone, WishboneConfig}
import spinal.lib.io.{TriStateArray, TriState}

import spinal.lib.misc.HexTools

import scala.collection.mutable.ArrayBuffer
import scala.collection.Seq


class TinyClunx(
                onChipRamSize : BigInt,
                slaveAXISize  : BigInt
                ) extends Component{

    val axiMConfig = Axi4Config(
    addressWidth = 24,
    dataWidth    = 64,
    idWidth      = 8,
    useRegion    = false,
    useLock      = true,
    useQos      = false,
    useResp = false,
    useProt=true,
    useStrb=true
        )

    val axiSConfig = Axi4Config(
    addressWidth = log2Up(slaveAXISize),
    dataWidth    = 64,
    idWidth      = 9,
    useRegion    = false,
    useLock      = false,
    useQos      = false,
    useResp = false,
    useProt=false,
    useStrb=true
    )

  val wbMConfig = WishboneConfig(
    addressWidth = 32,
    dataWidth    = 32,
    selWidth     = 4,
    useSTALL     = false,
    useERR       = false
  )

  val io = new Bundle{
    //Clocks / reset
    val axiReset = in Bool()
    val axiClk   = in Bool()
    val usbM     = slave(Axi4(axiMConfig))
    val sysM     = slave(Axi4(axiMConfig))
  }
  noIoPrefix()

  val axiClockDomain = ClockDomain(
    clock = io.axiClk,
    reset = io.axiReset
    )

  val axi1 = new ClockingArea(axiClockDomain) {
    val ram1 = Axi4SharedOnChipRam(
      dataWidth = 64,
      byteCount = onChipRamSize,
      idWidth = axiMConfig.idWidth+1
    )

    val axiCrossbar = Axi4CrossbarFactory()

    axiCrossbar.addSlaves(
      ram1.io.axi       -> (0x00000000L,   onChipRamSize)
    )

    axiCrossbar.addConnections(
      io.usbM        -> List(ram1.io.axi),
      io.sysM        -> List(ram1.io.axi)
    )

    axiCrossbar.build()

  }

}

object TinyClunx{
  def main(args: Array[String]) {
    val config = SpinalConfig(targetDirectory="src")
    config.generateVerilog({
      val toplevel = new TinyClunx(onChipRamSize = 1 kB, slaveAXISize = 16 MB)
      toplevel
    })
  }
}
