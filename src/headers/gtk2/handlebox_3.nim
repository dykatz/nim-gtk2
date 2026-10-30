# Included by headers/gtk2.nim; do not import directly.
proc float_window_mapped*(a: PHandleBox): guint =
  result = (a.Handlebox_flag0 and bm_TGtkHandleBox_float_window_mapped) shr
      bp_TGtkHandleBox_float_window_mapped

proc set_float_window_mapped*(a: PHandleBox, `float_window_mapped`: guint) =
  a.Handlebox_flag0 = a.Handlebox_flag0 or
      (uint16(`float_window_mapped` shl bp_TGtkHandleBox_float_window_mapped) and
      bm_TGtkHandleBox_float_window_mapped)

proc child_detached*(a: PHandleBox): guint =
  result = (a.Handlebox_flag0 and bm_TGtkHandleBox_child_detached) shr
      bp_TGtkHandleBox_child_detached

proc set_child_detached*(a: PHandleBox, `child_detached`: guint) =
  a.Handlebox_flag0 = a.Handlebox_flag0 or
      (uint16(`child_detached` shl bp_TGtkHandleBox_child_detached) and
      bm_TGtkHandleBox_child_detached)

proc in_drag*(a: PHandleBox): guint =
  result = (a.Handlebox_flag0 and bm_TGtkHandleBox_in_drag) shr
      bp_TGtkHandleBox_in_drag

proc set_in_drag*(a: PHandleBox, `in_drag`: guint) =
  a.Handlebox_flag0 = a.Handlebox_flag0 or
      (uint16(`in_drag` shl bp_TGtkHandleBox_in_drag) and
      bm_TGtkHandleBox_in_drag)

proc shrink_on_detach*(a: PHandleBox): guint =
  result = (a.Handlebox_flag0 and bm_TGtkHandleBox_shrink_on_detach) shr
      bp_TGtkHandleBox_shrink_on_detach

proc set_shrink_on_detach*(a: PHandleBox, `shrink_on_detach`: guint) =
  a.Handlebox_flag0 = a.Handlebox_flag0 or
      (uint16(`shrink_on_detach` shl bp_TGtkHandleBox_shrink_on_detach) and
      bm_TGtkHandleBox_shrink_on_detach)

# set_snap_edge was in a when false. snap_edge put in when false as the actual return type should be GtkPositionType not gint
#when false:
proc snap_edge*(a: PHandleBox): TPositionType =
  result = ((a.Handlebox_flag0 and bm_TGtkHandleBox_snap_edge) shr
      bp_TGtkHandleBox_snap_edge).TPositionType

proc set_snap_edge*(a: PHandleBox, `snap_edge`: TPositionType) =
  a.Handlebox_flag0 = a.Handlebox_flag0 or
      (uint16(`snap_edge` shl bp_TGtkHandleBox_snap_edge) and
      bm_TGtkHandleBox_snap_edge)

