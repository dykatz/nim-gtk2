# Included by headers/gdk2.nim; do not import directly.
proc flush*(){.cdecl, dynlib: lib, importc: "gdk_flush".}
