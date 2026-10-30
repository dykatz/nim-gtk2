# Included by headers/gdk2.nim; do not import directly.
proc get_window_type*(window: PWindow): TWindowType{.cdecl, dynlib: lib,
    importc: "gdk_window_get_window_type".}
