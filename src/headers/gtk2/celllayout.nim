# Included by headers/gtk2.nim; do not import directly.
proc cell_layout_get_cells*(layout: PCellLayout): PGList {.cdecl, dynlib: lib,
    importc: "gtk_cell_layout_get_cells".}
proc cell_layout_pack_start*(layout: PCellLayout, cell: PCellRenderer,
                             expand: gboolean) {.cdecl, dynlib: lib,
    importc: "gtk_cell_layout_pack_start".}
proc cell_layout_add_attribute*(layout: PCellLayout, cell: PCellRenderer,
                                attribute: cstring, column: gint) {.cdecl,
    dynlib: lib, importc: "gtk_cell_layout_add_attribute".}
proc set_attributes*(cell_layout: PCellLayout, cell: PCellRenderer){.
    cdecl, varargs, importc: "gtk_cell_layout_set_attributes", dynlib: lib.}
