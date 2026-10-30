# Included by headers/gdk2.nim; do not import directly.
proc get_display*(): cstring{.cdecl, dynlib: lib, importc: "gdk_get_display".}
proc get_display_arg_name*(): cstring{.cdecl, dynlib: lib,
                                       importc: "gdk_get_display_arg_name".}
