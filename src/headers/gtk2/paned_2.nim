# Included by headers/gtk2.nim; do not import directly.
proc TYPE_PANED*(): GType =
  result = paned_get_type()

proc PANED*(obj: pointer): PPaned =
  result = cast[PPaned](CHECK_CAST(obj, TYPE_PANED()))

proc PANED_CLASS*(klass: pointer): PPanedClass =
  result = cast[PPanedClass](CHECK_CLASS_CAST(klass, TYPE_PANED()))

proc IS_PANED*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_PANED())

proc IS_PANED_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_PANED())

proc PANED_GET_CLASS*(obj: pointer): PPanedClass =
  result = cast[PPanedClass](CHECK_GET_CLASS(obj, TYPE_PANED()))

proc position_set*(a: PPaned): guint =
  result = (a.Panedflag0 and bm_TGtkPaned_position_set) shr
      bp_TGtkPaned_position_set

proc set_position_set*(a: PPaned, `position_set`: guint) =
  a.Panedflag0 = a.Panedflag0 or
      (uint16(`position_set` shl bp_TGtkPaned_position_set) and
      bm_TGtkPaned_position_set)

proc in_drag*(a: PPaned): guint =
  result = (a.Panedflag0 and bm_TGtkPaned_in_drag) shr bp_TGtkPaned_in_drag

proc set_in_drag*(a: PPaned, `in_drag`: guint) =
  a.Panedflag0 = a.Panedflag0 or
      (uint16(`in_drag` shl bp_TGtkPaned_in_drag) and bm_TGtkPaned_in_drag)

proc child1_shrink*(a: PPaned): guint =
  result = (a.Panedflag0 and bm_TGtkPaned_child1_shrink) shr
      bp_TGtkPaned_child1_shrink

proc set_child1_shrink*(a: PPaned, `child1_shrink`: guint) =
  a.Panedflag0 = a.Panedflag0 or
      (uint16(`child1_shrink` shl bp_TGtkPaned_child1_shrink) and
      bm_TGtkPaned_child1_shrink)

proc child1_resize*(a: PPaned): guint =
  result = (a.Panedflag0 and bm_TGtkPaned_child1_resize) shr
      bp_TGtkPaned_child1_resize

proc set_child1_resize*(a: PPaned, `child1_resize`: guint) =
  a.Panedflag0 = a.Panedflag0 or
      (uint16(`child1_resize` shl bp_TGtkPaned_child1_resize) and
      bm_TGtkPaned_child1_resize)

proc child2_shrink*(a: PPaned): guint =
  result = (a.Panedflag0 and bm_TGtkPaned_child2_shrink) shr
      bp_TGtkPaned_child2_shrink

proc set_child2_shrink*(a: PPaned, `child2_shrink`: guint) =
  a.Panedflag0 = a.Panedflag0 or
      (uint16(`child2_shrink` shl bp_TGtkPaned_child2_shrink) and
      bm_TGtkPaned_child2_shrink)

proc child2_resize*(a: PPaned): guint =
  result = (a.Panedflag0 and bm_TGtkPaned_child2_resize) shr
      bp_TGtkPaned_child2_resize

proc set_child2_resize*(a: PPaned, `child2_resize`: guint) =
  a.Panedflag0 = a.Panedflag0 or
      (uint16(`child2_resize` shl bp_TGtkPaned_child2_resize) and
      bm_TGtkPaned_child2_resize)

proc orientation*(a: PPaned): guint =
  result = (a.Panedflag0 and bm_TGtkPaned_orientation) shr
      bp_TGtkPaned_orientation

proc set_orientation*(a: PPaned, `orientation`: guint) =
  a.Panedflag0 = a.Panedflag0 or
      (uint16(`orientation` shl bp_TGtkPaned_orientation) and
      bm_TGtkPaned_orientation)

proc in_recursion*(a: PPaned): guint =
  result = (a.Panedflag0 and bm_TGtkPaned_in_recursion) shr
      bp_TGtkPaned_in_recursion

proc set_in_recursion*(a: PPaned, `in_recursion`: guint) =
  a.Panedflag0 = a.Panedflag0 or
      (uint16(`in_recursion` shl bp_TGtkPaned_in_recursion) and
      bm_TGtkPaned_in_recursion)

proc handle_prelit*(a: PPaned): guint =
  result = (a.Panedflag0 and bm_TGtkPaned_handle_prelit) shr
      bp_TGtkPaned_handle_prelit

proc set_handle_prelit*(a: PPaned, `handle_prelit`: guint) =
  a.Panedflag0 = a.Panedflag0 or
      (uint16(`handle_prelit` shl bp_TGtkPaned_handle_prelit) and
      bm_TGtkPaned_handle_prelit)

proc paned_gutter_size*(p: pointer, s: gint) =
  if (p != nil) and (s != 0'i32): discard

proc paned_set_gutter_size*(p: pointer, s: gint) =
  if (p != nil) and (s != 0'i32): discard

proc TYPE_HBUTTON_BOX*(): GType =
  result = hbutton_box_get_type()

