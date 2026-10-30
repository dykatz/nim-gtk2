# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CELL_EDITABLE*(): GType
proc CELL_EDITABLE*(obj: pointer): PCellEditable
proc CELL_EDITABLE_CLASS*(obj: pointer): PCellEditableIface
proc IS_CELL_EDITABLE*(obj: pointer): bool
proc CELL_EDITABLE_GET_IFACE*(obj: pointer): PCellEditableIface
proc cell_editable_get_type*(): GType{.cdecl, dynlib: lib,
                                       importc: "gtk_cell_editable_get_type".}
proc start_editing*(cell_editable: PCellEditable, event: gdk2.PEvent){.
    cdecl, dynlib: lib, importc: "gtk_cell_editable_start_editing".}
proc editing_done*(cell_editable: PCellEditable){.cdecl,
    dynlib: lib, importc: "gtk_cell_editable_editing_done".}
proc remove_widget*(cell_editable: PCellEditable){.cdecl,
    dynlib: lib, importc: "gtk_cell_editable_remove_widget".}
