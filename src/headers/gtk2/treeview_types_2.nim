# Included by headers/gtk2.nim; do not import directly.
type
  TTreeViewClass* = object of TContainerClass
    set_scroll_adjustments*: proc (tree_view: PTreeView,
                                   hadjustment: PAdjustment,
                                   vadjustment: PAdjustment){.cdecl.}
    row_activated*: proc (tree_view: PTreeView, path: PTreePath,
                          column: PTreeViewColumn){.cdecl.}
    test_expand_row*: proc (tree_view: PTreeView, iter: PTreeIter,
                            path: PTreePath): gboolean{.cdecl.}
    test_collapse_row*: proc (tree_view: PTreeView, iter: PTreeIter,
                              path: PTreePath): gboolean{.cdecl.}
    row_expanded*: proc (tree_view: PTreeView, iter: PTreeIter, path: PTreePath){.
        cdecl.}
    row_collapsed*: proc (tree_view: PTreeView, iter: PTreeIter, path: PTreePath){.
        cdecl.}
    columns_changed*: proc (tree_view: PTreeView){.cdecl.}
    cursor_changed*: proc (tree_view: PTreeView){.cdecl.}
    move_cursor*: proc (tree_view: PTreeView, step: TMovementStep, count: gint): gboolean{.
        cdecl.}
    select_all*: proc (tree_view: PTreeView){.cdecl.}
    unselect_all*: proc (tree_view: PTreeView){.cdecl.}
    select_cursor_row*: proc (tree_view: PTreeView, start_editing: gboolean){.
        cdecl.}
    toggle_cursor_row*: proc (tree_view: PTreeView){.cdecl.}
    expand_collapse_cursor_row*: proc (tree_view: PTreeView, logical: gboolean,
                                       expand: gboolean, open_all: gboolean){.
        cdecl.}
    select_cursor_parent*: proc (tree_view: PTreeView){.cdecl.}
    start_interactive_search*: proc (tree_view: PTreeView){.cdecl.}
    reserved760: proc (){.cdecl.}
    reserved761: proc (){.cdecl.}
    reserved762: proc (){.cdecl.}
    reserved763: proc (){.cdecl.}
    reserved764: proc (){.cdecl.}

  PTreeViewClass* = ptr TTreeViewClass
