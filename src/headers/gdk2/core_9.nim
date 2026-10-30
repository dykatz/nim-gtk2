# Included by headers/gdk2.nim; do not import directly.
proc intersect*(src1: PRectangle, src2: PRectangle, dest: PRectangle): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_rectangle_intersect".}
proc union*(src1: PRectangle, src2: PRectangle, dest: PRectangle){.
    cdecl, dynlib: lib, importc: "gdk_rectangle_union".}
proc rectangle_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "gdk_rectangle_get_type".}
proc TYPE_RECTANGLE*(): GType
proc wcstombs*(src: PWChar): cstring{.cdecl, dynlib: lib,
                                      importc: "gdk_wcstombs".}
proc mbstowcs*(dest: PWChar, src: cstring, dest_max: gint): gint{.cdecl,
    dynlib: lib, importc: "gdk_mbstowcs".}
