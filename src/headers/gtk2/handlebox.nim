# Included by headers/gtk2.nim; do not import directly.
proc TYPE_HANDLE_BOX*(): GType
proc HANDLE_BOX*(obj: pointer): PHandleBox
proc HANDLE_BOX_CLASS*(klass: pointer): PHandleBoxClass
proc IS_HANDLE_BOX*(obj: pointer): bool
proc IS_HANDLE_BOX_CLASS*(klass: pointer): bool
proc HANDLE_BOX_GET_CLASS*(obj: pointer): PHandleBoxClass
proc handle_position*(a: PHandleBox): guint

proc float_window_mapped*(a: PHandleBox): guint
proc set_float_window_mapped*(a: PHandleBox, `float_window_mapped`: guint)
proc child_detached*(a: PHandleBox): guint
proc set_child_detached*(a: PHandleBox, `child_detached`: guint)
proc in_drag*(a: PHandleBox): guint
proc set_in_drag*(a: PHandleBox, `in_drag`: guint)
proc shrink_on_detach*(a: PHandleBox): guint
proc set_shrink_on_detach*(a: PHandleBox, `shrink_on_detach`: guint)
proc snap_edge*(a: PHandleBox): TPositionType

proc handle_box_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_handle_box_get_type".}
proc handle_box_new*(): PHandleBox{.cdecl, dynlib: lib,
                                    importc: "gtk_handle_box_new".}
proc set_shadow_type*(handle_box: PHandleBox, thetype: TShadowType){.
    cdecl, dynlib: lib, importc: "gtk_handle_box_set_shadow_type".}
proc get_shadow_type*(handle_box: PHandleBox): TShadowType{.cdecl,
    dynlib: lib, importc: "gtk_handle_box_get_shadow_type".}
proc set_handle_position*(handle_box: PHandleBox,
                                     position: TPositionType){.cdecl,
    dynlib: lib, importc: "gtk_handle_box_set_handle_position".}
proc get_handle_position*(handle_box: PHandleBox): TPositionType{.
    cdecl, dynlib: lib, importc: "gtk_handle_box_get_handle_position".}
proc set_snap_edge*(handle_box: PHandleBox, edge: TPositionType){.
    cdecl, dynlib: lib, importc: "gtk_handle_box_set_snap_edge".}
proc get_snap_edge*(handle_box: PHandleBox): TPositionType{.cdecl,
    dynlib: lib, importc: "gtk_handle_box_get_snap_edge".}
const
  bm_TGtkPaned_position_set = 0x0001'u16
const
  bp_TGtkPaned_position_set = 0'u16
const
  bm_TGtkPaned_in_drag = 0x0002'u16
const
  bp_TGtkPaned_in_drag = 1'u16
const
  bm_TGtkPaned_child1_shrink = 0x0004'u16
const
  bp_TGtkPaned_child1_shrink = 2'u16
const
  bm_TGtkPaned_child1_resize = 0x0008'u16
const
  bp_TGtkPaned_child1_resize = 3'u16
const
  bm_TGtkPaned_child2_shrink = 0x0010'u16
const
  bp_TGtkPaned_child2_shrink = 4'u16
const
  bm_TGtkPaned_child2_resize = 0x0020'u16
const
  bp_TGtkPaned_child2_resize = 5'u16
const
  bm_TGtkPaned_orientation = 0x0040'u16
const
  bp_TGtkPaned_orientation = 6'u16
const
  bm_TGtkPaned_in_recursion = 0x0080'u16
const
  bp_TGtkPaned_in_recursion = 7'u16
const
  bm_TGtkPaned_handle_prelit = 0x0100'u16
const
  bp_TGtkPaned_handle_prelit = 8'u16

