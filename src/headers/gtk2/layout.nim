# Included by headers/gtk2.nim; do not import directly.
proc TYPE_LAYOUT*(): GType
proc LAYOUT*(obj: pointer): PLayout
proc LAYOUT_CLASS*(klass: pointer): PLayoutClass
proc IS_LAYOUT*(obj: pointer): bool
proc IS_LAYOUT_CLASS*(klass: pointer): bool
proc LAYOUT_GET_CLASS*(obj: pointer): PLayoutClass
proc layout_get_type*(): TType{.cdecl, dynlib: lib,
                                importc: "gtk_layout_get_type".}
proc layout_new*(hadjustment: PAdjustment, vadjustment: PAdjustment): PLayout{.
    cdecl, dynlib: lib, importc: "gtk_layout_new".}
proc put*(layout: PLayout, child_widget: PWidget, x: gint, y: gint){.
    cdecl, dynlib: lib, importc: "gtk_layout_put".}
proc move*(layout: PLayout, child_widget: PWidget, x: gint, y: gint){.
    cdecl, dynlib: lib, importc: "gtk_layout_move".}
proc set_size*(layout: PLayout, width: guint, height: guint){.cdecl,
    dynlib: lib, importc: "gtk_layout_set_size".}
proc get_size*(layout: PLayout, width: Pguint, height: Pguint){.cdecl,
    dynlib: lib, importc: "gtk_layout_get_size".}
proc get_hadjustment*(layout: PLayout): PAdjustment{.cdecl, dynlib: lib,
    importc: "gtk_layout_get_hadjustment".}
proc get_vadjustment*(layout: PLayout): PAdjustment{.cdecl, dynlib: lib,
    importc: "gtk_layout_get_vadjustment".}
proc set_hadjustment*(layout: PLayout, adjustment: PAdjustment){.cdecl,
    dynlib: lib, importc: "gtk_layout_set_hadjustment".}
proc set_vadjustment*(layout: PLayout, adjustment: PAdjustment){.cdecl,
    dynlib: lib, importc: "gtk_layout_set_vadjustment".}
const
  bm_TGtkList_selection_mode* = 0x0003'u16
const
  bp_TGtkList_selection_mode* = 0'u16
const
  bm_TGtkList_drag_selection* = 0x0004'u16
const
  bp_TGtkList_drag_selection* = 2'u16
const
  bm_TGtkList_add_mode* = 0x0008'u16
const
  bp_TGtkList_add_mode* = 3'u16

