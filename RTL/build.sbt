val spinalVersion = "1.9.4"

lazy val root = (project in file("."))
  .settings(
    inThisBuild(List(
      organization := "com.github.tinyvision",
      scalaVersion := "2.12.18",
      version      := "0.0.0"
    )),
    libraryDependencies ++= Seq(
      "com.github.spinalhdl" %% "spinalhdl-core" % spinalVersion,
      "com.github.spinalhdl" %% "spinalhdl-lib" % spinalVersion,
      compilerPlugin("com.github.spinalhdl" %% "spinalhdl-idsl-plugin" % spinalVersion)
    ),
    name := "tinyCLUNX33soc",
    Compile / scalaSource := baseDirectory.value / "tinyCLUNX33soc"
  )
//  .dependsOn(
//    ProjectRef(file("VexRiscv"), "root")
//  )

fork := true
