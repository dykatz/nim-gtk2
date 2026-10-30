# Included by headers/gtk2.nim; do not import directly.
proc DRAW_EXPANDERS*(tree_view: PTreeView): bool
proc COLUMN_DRAG_DEAD_MULTIPLIER*(tree_view: PTreeView): int32
const
  bm_TGtkTreeViewPrivate_scroll_to_use_align* = 0x0001'u16
const
  bp_TGtkTreeViewPrivate_scroll_to_use_align* = 0'u16
const
  bm_TGtkTreeViewPrivate_fixed_height_check* = 0x0002'u16
const
  bp_TGtkTreeViewPrivate_fixed_height_check* = 1'u16
const
  bm_TGtkTreeViewPrivate_reorderable* = 0x0004'u16
const
  bp_TGtkTreeViewPrivate_reorderable* = 2'u16
const
  bm_TGtkTreeViewPrivate_header_has_focus* = 0x0008'u16
const
  bp_TGtkTreeViewPrivate_header_has_focus* = 3'u16
const
  bm_TGtkTreeViewPrivate_drag_column_window_state* = 0x0070'u16
const
  bp_TGtkTreeViewPrivate_drag_column_window_state* = 4'u16
const
  bm_TGtkTreeViewPrivate_has_rules* = 0x0080'u16
const
  bp_TGtkTreeViewPrivate_has_rules* = 7'u16
const
  bm_TGtkTreeViewPrivate_mark_rows_col_dirty* = 0x0100'u16
const
  bp_TGtkTreeViewPrivate_mark_rows_col_dirty* = 8'u16
const
  bm_TGtkTreeViewPrivate_enable_search* = 0x0200'u16
const
  bp_TGtkTreeViewPrivate_enable_search* = 9'u16
const
  bm_TGtkTreeViewPrivate_disable_popdown* = 0x0400'u16
const
  bp_TGtkTreeViewPrivate_disable_popdown* = 10'u16

proc scroll_to_use_align*(a: PTreeViewPrivate): guint
proc set_scroll_to_use_align*(a: PTreeViewPrivate,
                              `scroll_to_use_align`: guint)
proc fixed_height_check*(a: PTreeViewPrivate): guint
proc set_fixed_height_check*(a: PTreeViewPrivate,
                             `fixed_height_check`: guint)
proc reorderable*(a: PTreeViewPrivate): guint
proc set_reorderable*(a: PTreeViewPrivate, `reorderable`: guint)
proc header_has_focus*(a: PTreeViewPrivate): guint
proc set_header_has_focus*(a: PTreeViewPrivate, `header_has_focus`: guint)
proc drag_column_window_state*(a: PTreeViewPrivate): guint
proc set_drag_column_window_state*(a: PTreeViewPrivate,
                                   `drag_column_window_state`: guint)
proc has_rules*(a: PTreeViewPrivate): guint
proc set_has_rules*(a: PTreeViewPrivate, `has_rules`: guint)
proc mark_rows_col_dirty*(a: PTreeViewPrivate): guint
proc set_mark_rows_col_dirty*(a: PTreeViewPrivate,
                              `mark_rows_col_dirty`: guint)
proc enable_search*(a: PTreeViewPrivate): guint
proc set_enable_search*(a: PTreeViewPrivate, `enable_search`: guint)
proc disable_popdown*(a: PTreeViewPrivate): guint
proc set_disable_popdown*(a: PTreeViewPrivate, `disable_popdown`: guint)
