# Included by headers/gdk2.nim; do not import directly.
proc font_load*(font_name: cstring): PFont{.
    cdecl, dynlib: lib, importc: "gdk_font_load".}
