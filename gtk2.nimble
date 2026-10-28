version = "1.4"
author = "Nim developers"
description = "Wrapper for gtk2, a feature rich toolkit for creating graphical user interfaces."
license = "MIT"
srcDir = "src"

requires "nim >= 2.0.0"

import std/distros
foreignDep "gtk+"

task testBindings, "Check core GTK2 and bundled Cairo/X11/FreeType bindings without opening windows":
  exec "nim check --path:src tests/tbindings.nim"
