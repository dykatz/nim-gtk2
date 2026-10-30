# Included by headers/gtk2.nim; do not import directly.
proc TYPE_STATUSBAR*(): GType
proc STATUSBAR*(obj: pointer): PStatusbar
proc STATUSBAR_CLASS*(klass: pointer): PStatusbarClass
proc IS_STATUSBAR*(obj: pointer): bool
proc IS_STATUSBAR_CLASS*(klass: pointer): bool
proc STATUSBAR_GET_CLASS*(obj: pointer): PStatusbarClass
const
  bm_TGtkStatusbar_has_resize_grip* = 0x0001'u16
const
  bp_TGtkStatusbar_has_resize_grip* = 0'u16

proc has_resize_grip*(a: PStatusbar): guint
proc set_has_resize_grip*(a: PStatusbar, `has_resize_grip`: guint)
proc statusbar_get_type*(): TType{.cdecl, dynlib: lib,
                                   importc: "gtk_statusbar_get_type".}
proc statusbar_new*(): PStatusbar{.cdecl, dynlib: lib,
                                   importc: "gtk_statusbar_new".}
proc get_context_id*(statusbar: PStatusbar,
                               context_description: cstring): guint{.cdecl,
    dynlib: lib, importc: "gtk_statusbar_get_context_id".}
proc push*(statusbar: PStatusbar, context_id: guint, text: cstring): guint{.
    cdecl, dynlib: lib, importc: "gtk_statusbar_push".}
proc pop*(statusbar: PStatusbar, context_id: guint){.cdecl,
    dynlib: lib, importc: "gtk_statusbar_pop".}
proc remove*(statusbar: PStatusbar, context_id: guint,
                       message_id: guint){.cdecl, dynlib: lib,
    importc: "gtk_statusbar_remove".}
proc get_message_area*(statusbar: PStatusbar): PWidget {.cdecl, dynlib: lib,
    importc: "gtk_statusbar_get_message_area".}
proc set_has_resize_grip*(statusbar: PStatusbar, setting: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_statusbar_set_has_resize_grip".}
proc get_has_resize_grip*(statusbar: PStatusbar): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_statusbar_get_has_resize_grip".}
const
  bm_TGtkTable_homogeneous* = 0x0001'u16
const
  bp_TGtkTable_homogeneous* = 0'u16
const
  bm_TGtkTableChild_xexpand* = 0x0001'u16
const
  bp_TGtkTableChild_xexpand* = 0'u16
const
  bm_TGtkTableChild_yexpand* = 0x0002'u16
const
  bp_TGtkTableChild_yexpand* = 1'u16
const
  bm_TGtkTableChild_xshrink* = 0x0004'u16
const
  bp_TGtkTableChild_xshrink* = 2'u16
const
  bm_TGtkTableChild_yshrink* = 0x0008'u16
const
  bp_TGtkTableChild_yshrink* = 3'u16
const
  bm_TGtkTableChild_xfill* = 0x0010'u16
const
  bp_TGtkTableChild_xfill* = 4'u16
const
  bm_TGtkTableChild_yfill* = 0x0020'u16
const
  bp_TGtkTableChild_yfill* = 5'u16
const
  bm_TGtkTableRowCol_need_expand* = 0x0001'u16
const
  bp_TGtkTableRowCol_need_expand* = 0'u16
const
  bm_TGtkTableRowCol_need_shrink* = 0x0002'u16
const
  bp_TGtkTableRowCol_need_shrink* = 1'u16
const
  bm_TGtkTableRowCol_expand* = 0x0004'u16
const
  bp_TGtkTableRowCol_expand* = 2'u16
const
  bm_TGtkTableRowCol_shrink* = 0x0008'u16
const
  bp_TGtkTableRowCol_shrink* = 3'u16
const
  bm_TGtkTableRowCol_empty* = 0x0010'u16
const
  bp_TGtkTableRowCol_empty* = 4'u16

