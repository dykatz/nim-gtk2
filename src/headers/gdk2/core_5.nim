# Included by headers/gdk2.nim; do not import directly.
proc set_locale*(): cstring{.cdecl, dynlib: lib, importc: "gdk_set_locale".}
proc get_program_class*(): cstring{.cdecl, dynlib: lib,
                                    importc: "gdk_get_program_class".}
proc set_program_class*(program_class: cstring){.cdecl, dynlib: lib,
    importc: "gdk_set_program_class".}
proc error_trap_push*(){.cdecl, dynlib: lib, importc: "gdk_error_trap_push".}
proc error_trap_pop*(): gint{.cdecl, dynlib: lib, importc: "gdk_error_trap_pop".}
