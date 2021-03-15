# Package

version       = "0.2.13"
author        = "jiyinyiyong"
description   = "EDN DSL for canvas rendering"
license       = "MIT"
srcDir        = "src"



# Dependencies

requires "nim >= 1.2.6"
requires "sdl2"
requires "cairo"
requires "cirru_edn >= 0.4.9"

task t, "run once":
  exec "nim compile --verbosity:0 --hints:off --threads:on -r tests/demo.nim"
