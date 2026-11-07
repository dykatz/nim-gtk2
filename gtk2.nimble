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
  # Nim's cached top-level executable can otherwise miss edits in the C probe.
  exec "nim r --forceBuild:on --path:src --warningAsError:Deprecated tests/headers/tnewwidgetsabi.nim"

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
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2selectors.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2ranges.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2containers.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2menus.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2toolbars.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2positioned.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2choosers.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2assistant.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2filechoosers.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2recents.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2displays.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2printing.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2desktop.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2extensions.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2transfers.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2actions.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2builder.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2uimanager.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2completion.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2inlinecompletion.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2completionmatch.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2modelfunctions.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2iconselection.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2textanchors.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2textserialization.nim"
  exec "nim r --path:src --warningAsError:Deprecated tests/tgtk2richclipboard.nim"

task testMappedMenus, "Test actual tearoff windows (isolated virtual DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1 required)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedmenus.nim"

task testMappedPrinting, "Test print dialog visibility (isolated virtual DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1 required)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedprinting.nim"

task testMappedDesktop, "Test tray lifetime and foreign XEmbed (isolated virtual DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1 required)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappeddesktop.nim"

task testMappedExtensions, "Test Cairo pixels and native editing (isolated virtual DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1 required)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedextensions.nim"

task testMappedTransfers, "Test clipboard and native text DnD (isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1; X11 DnD needs XTEST)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedtransfers.nim"

task testMappedActions, "Test command proxies and real XTEST shortcuts (isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedactions.nim"

task testMappedBuilder, "Test GtkBuilder layout/activation/teardown (isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedbuilder.nim"

task testMappedUIManager, "Test UIManager merges, radio proxies and tearoffs (isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappeduimanager.nim"

task testMappedCompletion, "Test native completion popup keyboard selection (isolated DISPLAY, GTK2_TEST_VIRTUAL_DISPLAY=1; Unix X11 needs XTEST)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedcompletion.nim"

task testMappedModelFunctions, "Test native model-function painting/sizing (isolated DISPLAY, GTK2_TEST_VIRTUAL_DISPLAY=1)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedmodelfunctions.nim"

task testMappedIconSelection, "Test native IconView keyboard selection (isolated DISPLAY, GTK2_TEST_VIRTUAL_DISPLAY=1; Unix X11 requires XTEST)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappediconselection.nim"

task testMappedTextAnchors, "Test native inline TextView widgets (isolated DISPLAY, GTK2_TEST_VIRTUAL_DISPLAY=1)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedtextanchors.nim"

task testMappedTextSerialization, "Test restored native text/tag/image layout (isolated DISPLAY, GTK2_TEST_VIRTUAL_DISPLAY=1)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedtextserialization.nim"

task testMappedRichClipboard, "Test rich clipboard negotiation and foreign owners (isolated DISPLAY, GTK2_TEST_VIRTUAL_DISPLAY=1)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedrichclipboard.nim"

task testMappedInlineCompletion, "Test native inline completion/preview keys (isolated DISPLAY, GTK2_TEST_VIRTUAL_DISPLAY=1; X11 needs XTEST)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedinlinecompletion.nim"

task testMappedCompletionMatch, "Test native custom matching and default reset (isolated DISPLAY, GTK2_TEST_VIRTUAL_DISPLAY=1; X11 needs XTEST)":
  exec "nim r --path:src --warningAsError:Deprecated tests/tmappedcompletionmatch.nim"

task testCalculator, "Test calculator arithmetic and hidden UI (requires a display)":
  exec "nim r --path:src tests/tcalculator_engine.nim"
  exec "nim r --path:src tests/tcalculatorui.nim"
