version = "1.4"
author = "Nim developers"
description = "Wrapper for gtk2, a feature rich toolkit for creating graphical user interfaces."
license = "MIT"
srcDir = "src"

requires "nim >= 2.0.0"

import std/distros
foreignDep "gtk+"

task testHeaderLayout, "Check raw-binding layout and include ownership":
  exec "python3 tests/headers/theaderlayout.py"

task testBindings, "Check core GTK2 and bundled Cairo/X11/FreeType bindings without opening windows":
  exec "nim check --path:src --warningAsError:Deprecated tests/headers/tbindings.nim"

task testModernBindings, "Check core binding modernization without a display":
  exec "nim check --path:src --warningAsError:Deprecated examples/calculator.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/headers/tmodernbindings.nim"

task testRawWidgets, "Test new raw symbols/support APIs, then hidden widgets (requires a display)":
  exec "nim r --path:src --warningAsError:Deprecated tests/headers/tnewwidgets.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/headers/tnewwidgetsui.nim"

task testRawWidgetAbi, "Verify generated bindings and native ABI (requires GTK2 headers, no display)":
  exec "python3 tools/generate_widgets.py --check"
  exec "nim r --path:src --warningAsError:Deprecated tests/headers/tnewwidgetsabi.nim"

task testUi, "Test the ergonomic API using hidden widgets (requires a display)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2controls.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2layout.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2inputs.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2feedback.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2dialogs.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2text.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2models.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2trees.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2proxies.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2icons.nim"

task testCalculator, "Test calculator arithmetic and hidden UI (requires a display)":
  exec "nim r --path:src tests/tcalculator_engine.nim"
  exec "nim r --path:src tests/tcalculatorui.nim"
