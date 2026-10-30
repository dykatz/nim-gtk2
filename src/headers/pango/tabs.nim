# Included by headers/pango.nim; do not import directly.
proc tab_array_new*(initial_size: gint, positions_in_pixels: gboolean): PTabArray{.
    cdecl, dynlib: lib, importc: "pango_tab_array_new".}
proc tab_array_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "pango_tab_array_get_type".}
proc copy*(src: PTabArray): PTabArray{.cdecl, dynlib: lib,
    importc: "pango_tab_array_copy".}
proc free*(tab_array: PTabArray){.cdecl, dynlib: lib,
    importc: "pango_tab_array_free".}
proc get_size*(tab_array: PTabArray): gint{.cdecl, dynlib: lib,
    importc: "pango_tab_array_get_size".}
proc resize*(tab_array: PTabArray, new_size: gint){.cdecl,
    dynlib: lib, importc: "pango_tab_array_resize".}
proc set_tab*(tab_array: PTabArray, tab_index: gint,
                        alignment: TTabAlign, location: gint){.cdecl,
    dynlib: lib, importc: "pango_tab_array_set_tab".}
proc get_tab*(tab_array: PTabArray, tab_index: gint,
                        alignment: PTabAlign, location: Pgint){.cdecl,
    dynlib: lib, importc: "pango_tab_array_get_tab".}
proc get_positions_in_pixels*(tab_array: PTabArray): gboolean{.cdecl,
    dynlib: lib, importc: "pango_tab_array_get_positions_in_pixels".}
