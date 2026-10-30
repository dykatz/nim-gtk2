# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TREE_VIEW_COLUMN*(): GType
proc TREE_VIEW_COLUMN*(obj: pointer): PTreeViewColumn
proc TREE_VIEW_COLUMN_CLASS*(klass: pointer): PTreeViewColumnClass
proc IS_TREE_VIEW_COLUMN*(obj: pointer): bool
proc IS_TREE_VIEW_COLUMN_CLASS*(klass: pointer): bool
proc TREE_VIEW_COLUMN_GET_CLASS*(obj: pointer): PTreeViewColumnClass
proc visible*(a: PTreeViewColumn): guint
proc set_visible*(a: PTreeViewColumn, `visible`: guint)
proc resizable*(a: PTreeViewColumn): guint
proc set_resizable*(a: PTreeViewColumn, `resizable`: guint)
proc clickable*(a: PTreeViewColumn): guint
proc set_clickable*(a: PTreeViewColumn, `clickable`: guint)
proc dirty*(a: PTreeViewColumn): guint
proc set_dirty*(a: PTreeViewColumn, `dirty`: guint)
proc show_sort_indicator*(a: PTreeViewColumn): guint
proc set_show_sort_indicator*(a: PTreeViewColumn,
                              `show_sort_indicator`: guint)
proc maybe_reordered*(a: PTreeViewColumn): guint
proc set_maybe_reordered*(a: PTreeViewColumn, `maybe_reordered`: guint)
proc reorderable*(a: PTreeViewColumn): guint
proc set_reorderable*(a: PTreeViewColumn, `reorderable`: guint)
proc use_resized_width*(a: PTreeViewColumn): guint
proc set_use_resized_width*(a: PTreeViewColumn, `use_resized_width`: guint)
proc tree_view_column_get_type*(): TType{.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_get_type".}
proc tree_view_column_new*(): PTreeViewColumn{.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_new".}
proc column_get_tree_view*(column: PTreeViewColumn): PWidget {.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_get_tree_view".}
proc column_pack_start*(tree_column: PTreeViewColumn,
                                  cell: PCellRenderer, expand: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_pack_start".}
proc column_pack_end*(tree_column: PTreeViewColumn,
                                cell: PCellRenderer, expand: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_pack_end".}
proc column_clear*(tree_column: PTreeViewColumn){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_clear".}
proc column_get_cell_renderers*(tree_column: PTreeViewColumn): PGList{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_get_cell_renderers".}
proc column_add_attribute*(tree_column: PTreeViewColumn,
                                     cell_renderer: PCellRenderer,
                                     attribute: cstring, column: gint){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_add_attribute".}
proc column_set_cell_data_func*(tree_column: PTreeViewColumn,
    cell_renderer: PCellRenderer, fun: TTreeCellDataFunc, func_data: gpointer,
    destroy: TDestroyNotify){.cdecl, dynlib: lib, importc: "gtk_tree_view_column_set_cell_data_func".}
proc column_clear_attributes*(tree_column: PTreeViewColumn,
                                        cell_renderer: PCellRenderer){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_clear_attributes".}
proc column_set_spacing*(tree_column: PTreeViewColumn, spacing: gint){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_set_spacing".}
proc column_get_spacing*(tree_column: PTreeViewColumn): gint{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_get_spacing".}
proc column_set_visible*(tree_column: PTreeViewColumn,
                                   visible: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_set_visible".}
proc column_get_visible*(tree_column: PTreeViewColumn): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_get_visible".}
proc column_set_resizable*(tree_column: PTreeViewColumn,
                                     resizable: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_set_resizable".}
proc column_get_resizable*(tree_column: PTreeViewColumn): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_get_resizable".}
proc column_set_sizing*(tree_column: PTreeViewColumn,
                                  thetype: TTreeViewColumnSizing){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_set_sizing".}
proc column_get_sizing*(tree_column: PTreeViewColumn): TTreeViewColumnSizing{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_get_sizing".}
proc column_get_width*(tree_column: PTreeViewColumn): gint{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_get_width".}
proc column_get_fixed_width*(tree_column: PTreeViewColumn): gint{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_get_fixed_width".}
proc column_set_fixed_width*(tree_column: PTreeViewColumn,
                                       fixed_width: gint){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_set_fixed_width".}
proc column_set_min_width*(tree_column: PTreeViewColumn,
                                     min_width: gint){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_set_min_width".}
proc column_get_min_width*(tree_column: PTreeViewColumn): gint{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_get_min_width".}
proc column_set_max_width*(tree_column: PTreeViewColumn,
                                     max_width: gint){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_set_max_width".}
proc column_get_max_width*(tree_column: PTreeViewColumn): gint{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_get_max_width".}
proc column_clicked*(tree_column: PTreeViewColumn){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_clicked".}
proc column_set_title*(tree_column: PTreeViewColumn, title: cstring){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_set_title".}
proc column_get_title*(tree_column: PTreeViewColumn): cstring{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_get_title".}
proc column_set_clickable*(tree_column: PTreeViewColumn,
                                     clickable: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_set_clickable".}
proc column_get_clickable*(tree_column: PTreeViewColumn): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_get_clickable".}
proc column_set_widget*(tree_column: PTreeViewColumn, widget: PWidget){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_set_widget".}
proc column_get_widget*(tree_column: PTreeViewColumn): PWidget{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_get_widget".}
proc column_set_alignment*(tree_column: PTreeViewColumn,
                                     xalign: gfloat){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_set_alignment".}
proc column_get_alignment*(tree_column: PTreeViewColumn): gfloat{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_get_alignment".}
proc column_set_reorderable*(tree_column: PTreeViewColumn,
                                       reorderable: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_column_set_reorderable".}
proc column_get_reorderable*(tree_column: PTreeViewColumn): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_get_reorderable".}
proc column_set_sort_column_id*(tree_column: PTreeViewColumn,
    sort_column_id: gint){.cdecl, dynlib: lib,
                           importc: "gtk_tree_view_column_set_sort_column_id".}
proc column_get_sort_column_id*(tree_column: PTreeViewColumn): gint{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_get_sort_column_id".}
proc column_set_sort_indicator*(tree_column: PTreeViewColumn,
    setting: gboolean){.cdecl, dynlib: lib,
                        importc: "gtk_tree_view_column_set_sort_indicator".}
proc column_get_sort_indicator*(tree_column: PTreeViewColumn): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_get_sort_indicator".}
proc column_set_sort_order*(tree_column: PTreeViewColumn,
                                      order: TSortType){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_set_sort_order".}
proc column_get_sort_order*(tree_column: PTreeViewColumn): TSortType{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_get_sort_order".}
proc column_cell_set_cell_data*(tree_column: PTreeViewColumn,
    tree_model: PTreeModel, iter: PTreeIter, is_expander: gboolean,
    is_expanded: gboolean){.cdecl, dynlib: lib,
                            importc: "gtk_tree_view_column_cell_set_cell_data".}
proc column_cell_get_size*(tree_column: PTreeViewColumn,
                                     cell_area: gdk2.PRectangle, x_offset: Pgint,
                                     y_offset: Pgint, width: Pgint,
                                     height: Pgint){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_cell_get_size".}
proc column_cell_is_visible*(tree_column: PTreeViewColumn): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_cell_is_visible".}
proc column_focus_cell*(tree_column: PTreeViewColumn,
                                  cell: PCellRenderer){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_column_focus_cell".}
proc column_set_expand*(tree_column: PTreeViewColumn, Expand: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_set_expand".}
proc column_get_expand*(tree_column: PTreeViewColumn): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_column_get_expand".}
const
  RBNODE_BLACK* = 1 shl 0
const
  RBNODE_RED* = 1 shl 1
const
  RBNODE_IS_PARENT* = 1 shl 2
const
  RBNODE_IS_SELECTED* = 1 shl 3
const
  RBNODE_IS_PRELIT* = 1 shl 4
const
  RBNODE_IS_SEMI_COLLAPSED* = 1 shl 5
const
  RBNODE_IS_SEMI_EXPANDED* = 1 shl 6
const
  RBNODE_INVALID* = 1 shl 7
const
  RBNODE_COLUMN_INVALID* = 1 shl 8
const
  RBNODE_DESCENDANTS_INVALID* = 1 shl 9
const
  RBNODE_NON_COLORS* = RBNODE_IS_PARENT or RBNODE_IS_SELECTED or
      RBNODE_IS_PRELIT or RBNODE_IS_SEMI_COLLAPSED or RBNODE_IS_SEMI_EXPANDED or
      RBNODE_INVALID or RBNODE_COLUMN_INVALID or RBNODE_DESCENDANTS_INVALID

const
  bm_TGtkRBNode_flags* = 0x3FFF'u16
const
  bp_TGtkRBNode_flags* = 0'u16
const
  bm_TGtkRBNode_parity* = 0x4000'u16
const
  bp_TGtkRBNode_parity* = 14'u16

proc flags*(a: PRBNode): guint
proc set_flags*(a: PRBNode, `flags`: guint)
proc parity*(a: PRBNode): guint
proc set_parity*(a: PRBNode, `parity`: guint)
proc GET_COLOR*(node: PRBNode): guint
proc SET_COLOR*(node: PRBNode, color: guint)
proc GET_HEIGHT*(node: PRBNode): gint
proc SET_FLAG*(node: PRBNode, flag: guint16)
proc UNSET_FLAG*(node: PRBNode, flag: guint16)
proc FLAG_SET*(node: PRBNode, flag: guint): bool
proc rbtree_push_allocator*(allocator: PGAllocator){.cdecl, dynlib: lib,
    importc: "_gtk_rbtree_push_allocator".}
proc rbtree_pop_allocator*(){.cdecl, dynlib: lib,
                              importc: "_gtk_rbtree_pop_allocator".}
proc rbtree_new*(): PRBTree{.cdecl, dynlib: lib, importc: "_gtk_rbtree_new".}
proc free*(tree: PRBTree){.cdecl, dynlib: lib,
                                  importc: "_gtk_rbtree_free".}
proc remove*(tree: PRBTree){.cdecl, dynlib: lib,
                                    importc: "_gtk_rbtree_remove".}
proc destroy*(tree: PRBTree){.cdecl, dynlib: lib,
                                     importc: "_gtk_rbtree_destroy".}
proc insert_before*(tree: PRBTree, node: PRBNode, height: gint,
                           valid: gboolean): PRBNode{.cdecl, dynlib: lib,
    importc: "_gtk_rbtree_insert_before".}
proc insert_after*(tree: PRBTree, node: PRBNode, height: gint,
                          valid: gboolean): PRBNode{.cdecl, dynlib: lib,
    importc: "_gtk_rbtree_insert_after".}
proc remove_node*(tree: PRBTree, node: PRBNode){.cdecl, dynlib: lib,
    importc: "_gtk_rbtree_remove_node".}
proc reorder*(tree: PRBTree, new_order: Pgint, length: gint){.cdecl,
    dynlib: lib, importc: "_gtk_rbtree_reorder".}
proc find_count*(tree: PRBTree, count: gint): PRBNode{.cdecl,
    dynlib: lib, importc: "_gtk_rbtree_find_count".}
proc node_set_height*(tree: PRBTree, node: PRBNode, height: gint){.
    cdecl, dynlib: lib, importc: "_gtk_rbtree_node_set_height".}
proc node_mark_invalid*(tree: PRBTree, node: PRBNode){.cdecl,
    dynlib: lib, importc: "_gtk_rbtree_node_mark_invalid".}
proc node_mark_valid*(tree: PRBTree, node: PRBNode){.cdecl, dynlib: lib,
    importc: "_gtk_rbtree_node_mark_valid".}
proc column_invalid*(tree: PRBTree){.cdecl, dynlib: lib,
    importc: "_gtk_rbtree_column_invalid".}
proc mark_invalid*(tree: PRBTree){.cdecl, dynlib: lib,
    importc: "_gtk_rbtree_mark_invalid".}
proc set_fixed_height*(tree: PRBTree, height: gint){.cdecl, dynlib: lib,
    importc: "_gtk_rbtree_set_fixed_height".}
proc node_find_offset*(tree: PRBTree, node: PRBNode): gint{.cdecl,
    dynlib: lib, importc: "_gtk_rbtree_node_find_offset".}
proc node_find_parity*(tree: PRBTree, node: PRBNode): gint{.cdecl,
    dynlib: lib, importc: "_gtk_rbtree_node_find_parity".}
proc traverse*(tree: PRBTree, node: PRBNode, order: TGTraverseType,
                      fun: TRBTreeTraverseFunc, data: gpointer){.cdecl,
    dynlib: lib, importc: "_gtk_rbtree_traverse".}
proc next*(tree: PRBTree, node: PRBNode): PRBNode{.cdecl, dynlib: lib,
    importc: "_gtk_rbtree_next".}
proc prev*(tree: PRBTree, node: PRBNode): PRBNode{.cdecl, dynlib: lib,
    importc: "_gtk_rbtree_prev".}
proc get_depth*(tree: PRBTree): gint{.cdecl, dynlib: lib,
    importc: "_gtk_rbtree_get_depth".}
const
  TREE_VIEW_DRAG_WIDTH* = 6
const
  TREE_VIEW_IS_LIST* = 1 shl 0
const
  TREE_VIEW_SHOW_EXPANDERS* = 1 shl 1
const
  TREE_VIEW_IN_COLUMN_RESIZE* = 1 shl 2
const
  TREE_VIEW_ARROW_PRELIT* = 1 shl 3
const
  TREE_VIEW_HEADERS_VISIBLE* = 1 shl 4
const
  TREE_VIEW_DRAW_KEYFOCUS* = 1 shl 5
const
  TREE_VIEW_MODEL_SETUP* = 1 shl 6
const
  TREE_VIEW_IN_COLUMN_DRAG* = 1 shl 7
const
  DRAG_COLUMN_WINDOW_STATE_UNSET* = 0
const
  DRAG_COLUMN_WINDOW_STATE_ORIGINAL* = 1
const
  DRAG_COLUMN_WINDOW_STATE_ARROW* = 2
const
  DRAG_COLUMN_WINDOW_STATE_ARROW_LEFT* = 3
const
  DRAG_COLUMN_WINDOW_STATE_ARROW_RIGHT* = 4

