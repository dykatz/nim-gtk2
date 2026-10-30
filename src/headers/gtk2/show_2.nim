# Included by headers/gtk2.nim; do not import directly.
proc nim_init*() =
  var
    cmdLine{.importc: "cmdLine".}: array[0..255, cstring]
    cmdCount{.importc: "cmdCount".}: cint
  init(addr(cmdLine), addr(cmdCount))
