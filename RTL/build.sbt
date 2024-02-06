val spinalVersion = "1.9.4"

lazy val root = (project in file("."))
  .settings(
    inThisBuild(List(
      organization := "com.github.spinalhdl",
      scalaVersion := "2.11.12",
      version      := "0.0"
    )),
    libraryDependencies ++= Seq(
      "com.github.spinalhdl" % "spinalhdl-core_2.11" % spinalVersion,
      "com.github.spinalhdl" % "spinalhdl-lib_2.11" % spinalVersion,
      compilerPlugin("com.github.spinalhdl" % "spinalhdl-idsl-plugin_2.11" % spinalVersion)
    ),
    name := "tinyCLUNX33soc",
    Compile / scalaSource := baseDirectory.value / "spinal"
  )
  .dependsOn(
    RootProject(file("ip/VexRiscv"))
  )

fork := true
