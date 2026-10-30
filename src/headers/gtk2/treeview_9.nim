# Included by headers/gtk2.nim; do not import directly.
proc DRAW_EXPANDERS*(tree_view: PTreeView): bool =
  result = (not (FLAG_SET(tree_view, TREE_VIEW_IS_LIST))) and
      (FLAG_SET(tree_view, TREE_VIEW_SHOW_EXPANDERS))

proc COLUMN_DRAG_DEAD_MULTIPLIER*(tree_view: PTreeView): int32 =
  result = 10'i32 * (HEADER_HEIGHT(tree_view))

proc scroll_to_use_align*(a: PTreeViewPrivate): guint =
  result = (a.flag0 and bm_TGtkTreeViewPrivate_scroll_to_use_align) shr
      bp_TGtkTreeViewPrivate_scroll_to_use_align

proc set_scroll_to_use_align*(a: PTreeViewPrivate,
                              `scroll_to_use_align`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`scroll_to_use_align` shl
      bp_TGtkTreeViewPrivate_scroll_to_use_align) and
      bm_TGtkTreeViewPrivate_scroll_to_use_align)

proc fixed_height_check*(a: PTreeViewPrivate): guint =
  result = (a.flag0 and bm_TGtkTreeViewPrivate_fixed_height_check) shr
      bp_TGtkTreeViewPrivate_fixed_height_check

proc set_fixed_height_check*(a: PTreeViewPrivate,
                             `fixed_height_check`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`fixed_height_check` shl
      bp_TGtkTreeViewPrivate_fixed_height_check) and
      bm_TGtkTreeViewPrivate_fixed_height_check)

proc reorderable*(a: PTreeViewPrivate): guint =
  result = (a.flag0 and bm_TGtkTreeViewPrivate_reorderable) shr
      bp_TGtkTreeViewPrivate_reorderable

proc set_reorderable*(a: PTreeViewPrivate, `reorderable`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`reorderable` shl bp_TGtkTreeViewPrivate_reorderable) and
      bm_TGtkTreeViewPrivate_reorderable)

proc header_has_focus*(a: PTreeViewPrivate): guint =
  result = (a.flag0 and bm_TGtkTreeViewPrivate_header_has_focus) shr
      bp_TGtkTreeViewPrivate_header_has_focus

proc set_header_has_focus*(a: PTreeViewPrivate, `header_has_focus`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`header_has_focus` shl bp_TGtkTreeViewPrivate_header_has_focus) and
      bm_TGtkTreeViewPrivate_header_has_focus)

proc drag_column_window_state*(a: PTreeViewPrivate): guint =
  result = (a.flag0 and bm_TGtkTreeViewPrivate_drag_column_window_state) shr
      bp_TGtkTreeViewPrivate_drag_column_window_state

proc set_drag_column_window_state*(a: PTreeViewPrivate,
                                   `drag_column_window_state`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`drag_column_window_state` shl
      bp_TGtkTreeViewPrivate_drag_column_window_state) and
      bm_TGtkTreeViewPrivate_drag_column_window_state)

proc has_rules*(a: PTreeViewPrivate): guint =
  result = (a.flag0 and bm_TGtkTreeViewPrivate_has_rules) shr
      bp_TGtkTreeViewPrivate_has_rules

proc set_has_rules*(a: PTreeViewPrivate, `has_rules`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`has_rules` shl bp_TGtkTreeViewPrivate_has_rules) and
      bm_TGtkTreeViewPrivate_has_rules)

proc mark_rows_col_dirty*(a: PTreeViewPrivate): guint =
  result = (a.flag0 and bm_TGtkTreeViewPrivate_mark_rows_col_dirty) shr
      bp_TGtkTreeViewPrivate_mark_rows_col_dirty

proc set_mark_rows_col_dirty*(a: PTreeViewPrivate,
                              `mark_rows_col_dirty`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`mark_rows_col_dirty` shl
      bp_TGtkTreeViewPrivate_mark_rows_col_dirty) and
      bm_TGtkTreeViewPrivate_mark_rows_col_dirty)

proc enable_search*(a: PTreeViewPrivate): guint =
  result = (a.flag0 and bm_TGtkTreeViewPrivate_enable_search) shr
      bp_TGtkTreeViewPrivate_enable_search

proc set_enable_search*(a: PTreeViewPrivate, `enable_search`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`enable_search` shl bp_TGtkTreeViewPrivate_enable_search) and
      bm_TGtkTreeViewPrivate_enable_search)

proc disable_popdown*(a: PTreeViewPrivate): guint =
  result = (a.flag0 and bm_TGtkTreeViewPrivate_disable_popdown) shr
      bp_TGtkTreeViewPrivate_disable_popdown

proc set_disable_popdown*(a: PTreeViewPrivate, `disable_popdown`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`disable_popdown` shl bp_TGtkTreeViewPrivate_disable_popdown) and
      bm_TGtkTreeViewPrivate_disable_popdown)

proc SET_FLAG*(tree_view: PTreeView, flag: guint) =
  tree_view.priv.flags = tree_view.priv.flags or (flag)

proc UNSET_FLAG*(tree_view: PTreeView, flag: guint) =
  tree_view.priv.flags = tree_view.priv.flags and not (flag)

proc TYPE_TREE_VIEW*(): GType =
  result = tree_view_get_type()

proc TREE_VIEW*(obj: pointer): PTreeView =
  result = cast[PTreeView](CHECK_CAST(obj, TYPE_TREE_VIEW()))

proc TREE_VIEW_CLASS*(klass: pointer): PTreeViewClass =
  result = cast[PTreeViewClass](CHECK_CLASS_CAST(klass, TYPE_TREE_VIEW()))

proc IS_TREE_VIEW*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_TREE_VIEW())

proc IS_TREE_VIEW_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_TREE_VIEW())

proc TREE_VIEW_GET_CLASS*(obj: pointer): PTreeViewClass =
  result = cast[PTreeViewClass](CHECK_GET_CLASS(obj, TYPE_TREE_VIEW()))

proc TYPE_VBUTTON_BOX*(): GType =
  result = vbutton_box_get_type()

