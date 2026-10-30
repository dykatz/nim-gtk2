# Included by headers/atk.nim; do not import directly.
type
  TTableIface* = object of TGTypeInterface
    ref_at*: proc (table: PTable, row: gint, column: gint): PObject{.cdecl.}
    get_index_at*: proc (table: PTable, row: gint, column: gint): gint{.cdecl.}
    get_column_at_index*: proc (table: PTable, index: gint): gint{.cdecl.}
    get_row_at_index*: proc (table: PTable, index: gint): gint{.cdecl.}
    get_n_columns*: proc (table: PTable): gint{.cdecl.}
    get_n_rows*: proc (table: PTable): gint{.cdecl.}
    get_column_extent_at*: proc (table: PTable, row: gint, column: gint): gint{.
        cdecl.}
    get_row_extent_at*: proc (table: PTable, row: gint, column: gint): gint{.
        cdecl.}
    get_caption*: proc (table: PTable): PObject{.cdecl.}
    get_column_description*: proc (table: PTable, column: gint): cstring{.cdecl.}
    get_column_header*: proc (table: PTable, column: gint): PObject{.cdecl.}
    get_row_description*: proc (table: PTable, row: gint): cstring{.cdecl.}
    get_row_header*: proc (table: PTable, row: gint): PObject{.cdecl.}
    get_summary*: proc (table: PTable): PObject{.cdecl.}
    set_caption*: proc (table: PTable, caption: PObject){.cdecl.}
    set_column_description*: proc (table: PTable, column: gint,
                                   description: cstring){.cdecl.}
    set_column_header*: proc (table: PTable, column: gint, header: PObject){.
        cdecl.}
    set_row_description*: proc (table: PTable, row: gint, description: cstring){.
        cdecl.}
    set_row_header*: proc (table: PTable, row: gint, header: PObject){.cdecl.}
    set_summary*: proc (table: PTable, accessible: PObject){.cdecl.}
    get_selected_columns*: proc (table: PTable, selected: PPgint): gint{.cdecl.}
    get_selected_rows*: proc (table: PTable, selected: PPgint): gint{.cdecl.}
    is_column_selected*: proc (table: PTable, column: gint): gboolean{.cdecl.}
    is_row_selected*: proc (table: PTable, row: gint): gboolean{.cdecl.}
    is_selected*: proc (table: PTable, row: gint, column: gint): gboolean{.cdecl.}
    add_row_selection*: proc (table: PTable, row: gint): gboolean{.cdecl.}
    remove_row_selection*: proc (table: PTable, row: gint): gboolean{.cdecl.}
    add_column_selection*: proc (table: PTable, column: gint): gboolean{.cdecl.}
    remove_column_selection*: proc (table: PTable, column: gint): gboolean{.
        cdecl.}
    row_inserted*: proc (table: PTable, row: gint, num_inserted: gint){.cdecl.}
    column_inserted*: proc (table: PTable, column: gint, num_inserted: gint){.
        cdecl.}
    row_deleted*: proc (table: PTable, row: gint, num_deleted: gint){.cdecl.}
    column_deleted*: proc (table: PTable, column: gint, num_deleted: gint){.
        cdecl.}
    row_reordered*: proc (table: PTable){.cdecl.}
    column_reordered*: proc (table: PTable){.cdecl.}
    model_changed*: proc (table: PTable){.cdecl.}
    pad25*: TFunction
    pad26*: TFunction
    pad27*: TFunction
    pad28*: TFunction

  PTableIface* = ptr TTableIface
