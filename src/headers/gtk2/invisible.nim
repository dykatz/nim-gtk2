# Included by headers/gtk2.nim; do not import directly.
proc TYPE_INVISIBLE*(): GType
proc INVISIBLE*(obj: pointer): PInvisible
proc INVISIBLE_CLASS*(klass: pointer): PInvisibleClass
proc IS_INVISIBLE*(obj: pointer): bool
proc IS_INVISIBLE_CLASS*(klass: pointer): bool
proc INVISIBLE_GET_CLASS*(obj: pointer): PInvisibleClass
proc invisible_get_type*(): TType{.cdecl, dynlib: lib,
                                   importc: "gtk_invisible_get_type".}
proc invisible_new*(): PInvisible{.cdecl, dynlib: lib,
                                   importc: "gtk_invisible_new".}
proc invisible_new_for_screen*(screen: gdk2.PScreen): PInvisible{.cdecl,
    dynlib: lib, importc: "gtk_invisible_new_for_screen".}
proc set_screen*(invisible: PInvisible, screen: gdk2.PScreen){.cdecl,
    dynlib: lib, importc: "gtk_invisible_set_screen".}
proc get_screen*(invisible: PInvisible): gdk2.PScreen{.cdecl,
    dynlib: lib, importc: "gtk_invisible_get_screen".}
