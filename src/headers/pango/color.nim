# Included by headers/pango.nim; do not import directly.
proc color_get_type*(): GType{.cdecl, dynlib: lib,
                               importc: "pango_color_get_type".}
proc copy*(src: PColor): PColor{.cdecl, dynlib: lib,
                                       importc: "pango_color_copy".}
proc free*(color: PColor){.cdecl, dynlib: lib, importc: "pango_color_free".}
proc parse*(color: PColor, spec: cstring): gboolean{.cdecl, dynlib: lib,
    importc: "pango_color_parse".}
proc TYPE_ATTR_LIST*(): GType
