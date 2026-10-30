# Included by headers/gdk2.nim; do not import directly.
proc parse_args*(argc: Pgint, v: var PPgchar){.cdecl, dynlib: lib,
    importc: "gdk_parse_args".}
proc init*(argc: Pgint, v: var PPgchar){.cdecl, dynlib: lib, importc: "gdk_init".}
proc init_check*(argc: Pgint, v: var PPgchar): gboolean{.cdecl, dynlib: lib,
    importc: "gdk_init_check".}
