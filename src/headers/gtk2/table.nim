# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TABLE*(): GType
proc TABLE*(obj: pointer): PTable
proc TABLE_CLASS*(klass: pointer): PTableClass
proc IS_TABLE*(obj: pointer): bool
proc IS_TABLE_CLASS*(klass: pointer): bool
proc TABLE_GET_CLASS*(obj: pointer): PTableClass
proc homogeneous*(a: PTable): guint
proc set_homogeneous*(a: PTable, `homogeneous`: guint)
proc xexpand*(a: PTableChild): guint
proc set_xexpand*(a: PTableChild, `xexpand`: guint)
proc yexpand*(a: PTableChild): guint
proc set_yexpand*(a: PTableChild, `yexpand`: guint)
proc xshrink*(a: PTableChild): guint
proc set_xshrink*(a: PTableChild, `xshrink`: guint)
proc yshrink*(a: PTableChild): guint
proc set_yshrink*(a: PTableChild, `yshrink`: guint)
proc xfill*(a: PTableChild): guint
proc set_xfill*(a: PTableChild, `xfill`: guint)
proc yfill*(a: PTableChild): guint
proc set_yfill*(a: PTableChild, `yfill`: guint)
proc need_expand*(a: PTableRowCol): guint
proc set_need_expand*(a: PTableRowCol, `need_expand`: guint)
proc need_shrink*(a: PTableRowCol): guint
proc set_need_shrink*(a: PTableRowCol, `need_shrink`: guint)
proc expand*(a: PTableRowCol): guint
proc set_expand*(a: PTableRowCol, `expand`: guint)
proc shrink*(a: PTableRowCol): guint
proc set_shrink*(a: PTableRowCol, `shrink`: guint)
proc empty*(a: PTableRowCol): guint
proc set_empty*(a: PTableRowCol, `empty`: guint)
proc table_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_table_get_type".}
proc table_new*(rows: guint, columns: guint, homogeneous: gboolean): PTable{.
    cdecl, dynlib: lib, importc: "gtk_table_new".}
proc resize*(table: PTable, rows: guint, columns: guint){.cdecl,
    dynlib: lib, importc: "gtk_table_resize".}
proc attach*(table: PTable, child: PWidget, left_attach: guint,
                   right_attach: guint, top_attach: guint, bottom_attach: guint,
                   xoptions: TAttachOptions, yoptions: TAttachOptions,
                   xpadding: guint, ypadding: guint){.cdecl, dynlib: lib,
    importc: "gtk_table_attach".}
proc attach_defaults*(table: PTable, widget: PWidget, left_attach: guint,
                            right_attach: guint, top_attach: guint,
                            bottom_attach: guint){.cdecl, dynlib: lib,
    importc: "gtk_table_attach_defaults".}
proc set_row_spacing*(table: PTable, row: guint, spacing: guint){.cdecl,
    dynlib: lib, importc: "gtk_table_set_row_spacing".}
proc get_row_spacing*(table: PTable, row: guint): guint{.cdecl,
    dynlib: lib, importc: "gtk_table_get_row_spacing".}
proc set_col_spacing*(table: PTable, column: guint, spacing: guint){.
    cdecl, dynlib: lib, importc: "gtk_table_set_col_spacing".}
proc get_col_spacing*(table: PTable, column: guint): guint{.cdecl,
    dynlib: lib, importc: "gtk_table_get_col_spacing".}
proc set_row_spacings*(table: PTable, spacing: guint){.cdecl, dynlib: lib,
    importc: "gtk_table_set_row_spacings".}
proc get_default_row_spacing*(table: PTable): guint{.cdecl, dynlib: lib,
    importc: "gtk_table_get_default_row_spacing".}
proc set_col_spacings*(table: PTable, spacing: guint){.cdecl, dynlib: lib,
    importc: "gtk_table_set_col_spacings".}
proc get_default_col_spacing*(table: PTable): guint{.cdecl, dynlib: lib,
    importc: "gtk_table_get_default_col_spacing".}
proc set_homogeneous*(table: PTable, homogeneous: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_table_set_homogeneous".}
proc get_homogeneous*(table: PTable): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_table_get_homogeneous".}
const
  bm_TGtkTearoffMenuItem_torn_off* = 0x0001'u16
const
  bp_TGtkTearoffMenuItem_torn_off* = 0'u16

