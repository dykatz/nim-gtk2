# Included by headers/atk.nim; do not import directly.
proc TYPE_TABLE*(): GType
proc IS_TABLE*(obj: pointer): bool
proc TABLE*(obj: pointer): PTable
proc TABLE_GET_IFACE*(obj: pointer): PTableIface
proc table_get_type*(): GType{.cdecl, dynlib: lib, importc: "atk_table_get_type".}
proc ref_at*(table: PTable, row, column: gint): PObject{.cdecl,
    dynlib: lib, importc: "atk_table_ref_at".}
proc get_index_at*(table: PTable, row, column: gint): gint{.cdecl,
    dynlib: lib, importc: "atk_table_get_index_at".}
proc get_column_at_index*(table: PTable, index: gint): gint{.cdecl,
    dynlib: lib, importc: "atk_table_get_column_at_index".}
proc get_row_at_index*(table: PTable, index: gint): gint{.cdecl,
    dynlib: lib, importc: "atk_table_get_row_at_index".}
proc get_n_columns*(table: PTable): gint{.cdecl, dynlib: lib,
    importc: "atk_table_get_n_columns".}
proc get_n_rows*(table: PTable): gint{.cdecl, dynlib: lib,
    importc: "atk_table_get_n_rows".}
proc get_column_extent_at*(table: PTable, row: gint, column: gint): gint{.
    cdecl, dynlib: lib, importc: "atk_table_get_column_extent_at".}
proc get_row_extent_at*(table: PTable, row: gint, column: gint): gint{.
    cdecl, dynlib: lib, importc: "atk_table_get_row_extent_at".}
proc get_caption*(table: PTable): PObject{.cdecl, dynlib: lib,
    importc: "atk_table_get_caption".}
proc get_column_description*(table: PTable, column: gint): cstring{.cdecl,
    dynlib: lib, importc: "atk_table_get_column_description".}
proc get_column_header*(table: PTable, column: gint): PObject{.cdecl,
    dynlib: lib, importc: "atk_table_get_column_header".}
proc get_row_description*(table: PTable, row: gint): cstring{.cdecl,
    dynlib: lib, importc: "atk_table_get_row_description".}
proc get_row_header*(table: PTable, row: gint): PObject{.cdecl,
    dynlib: lib, importc: "atk_table_get_row_header".}
proc get_summary*(table: PTable): PObject{.cdecl, dynlib: lib,
    importc: "atk_table_get_summary".}
proc set_caption*(table: PTable, caption: PObject){.cdecl, dynlib: lib,
    importc: "atk_table_set_caption".}
proc set_column_description*(table: PTable, column: gint,
                                   description: cstring){.cdecl, dynlib: lib,
    importc: "atk_table_set_column_description".}
proc set_column_header*(table: PTable, column: gint, header: PObject){.
    cdecl, dynlib: lib, importc: "atk_table_set_column_header".}
proc set_row_description*(table: PTable, row: gint, description: cstring){.
    cdecl, dynlib: lib, importc: "atk_table_set_row_description".}
proc set_row_header*(table: PTable, row: gint, header: PObject){.cdecl,
    dynlib: lib, importc: "atk_table_set_row_header".}
proc set_summary*(table: PTable, accessible: PObject){.cdecl, dynlib: lib,
    importc: "atk_table_set_summary".}
proc get_selected_columns*(table: PTable, selected: PPgint): gint{.cdecl,
    dynlib: lib, importc: "atk_table_get_selected_columns".}
proc get_selected_rows*(table: PTable, selected: PPgint): gint{.cdecl,
    dynlib: lib, importc: "atk_table_get_selected_rows".}
proc is_column_selected*(table: PTable, column: gint): gboolean{.cdecl,
    dynlib: lib, importc: "atk_table_is_column_selected".}
proc is_row_selected*(table: PTable, row: gint): gboolean{.cdecl,
    dynlib: lib, importc: "atk_table_is_row_selected".}
proc is_selected*(table: PTable, row: gint, column: gint): gboolean{.
    cdecl, dynlib: lib, importc: "atk_table_is_selected".}
proc add_row_selection*(table: PTable, row: gint): gboolean{.cdecl,
    dynlib: lib, importc: "atk_table_add_row_selection".}
proc remove_row_selection*(table: PTable, row: gint): gboolean{.cdecl,
    dynlib: lib, importc: "atk_table_remove_row_selection".}
proc add_column_selection*(table: PTable, column: gint): gboolean{.cdecl,
    dynlib: lib, importc: "atk_table_add_column_selection".}
proc remove_column_selection*(table: PTable, column: gint): gboolean{.
    cdecl, dynlib: lib, importc: "atk_table_remove_column_selection".}
