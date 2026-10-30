# Included by headers/gtk2.nim; do not import directly.
type
  TTreeCellDataFunc* = proc (tree_column: PTreeViewColumn, cell: PCellRenderer,
                             tree_model: PTreeModel, iter: PTreeIter,
                             data: gpointer){.cdecl.}
  TTreeViewColumnReorder*{.final, pure.} = object
    left_align*: gint
    right_align*: gint
    left_column*: PTreeViewColumn
    right_column*: PTreeViewColumn

  PTreeViewColumnReorder* = ptr TTreeViewColumnReorder
  PTreeView* = ptr TTreeView
  TTreeViewColumnDropFunc* = proc (tree_view: PTreeView,
                                   column: PTreeViewColumn,
                                   prev_column: PTreeViewColumn,
                                   next_column: PTreeViewColumn, data: gpointer): gboolean{.
      cdecl.}
  TTreeDestroyCountFunc* = proc (tree_view: PTreeView, path: PTreePath,
                                 children: gint, user_data: gpointer){.cdecl.}
  PTreeSelection* = ptr TTreeSelection
  TTreeSelectionFunc* = proc (selection: PTreeSelection, model: PTreeModel,
                              path: PTreePath,
                              path_currently_selected: gboolean, data: gpointer): gboolean{.
      cdecl.}
  TTreeSelection* = object of TGObject
    tree_view*: PTreeView
    thetype*: TSelectionMode
    user_func*: TTreeSelectionFunc
    user_data*: gpointer
    destroy*: TDestroyNotify

  TTreeViewSearchDialogPositionFunc* = proc (tree_view: PTreeView,
      search_dialog: PWidget){.cdecl.}
  PTreeViewPrivate* = ptr TTreeViewPrivate
  TTreeViewPrivate*{.final, pure.} = object
    model*: PTreeModel
    flags*: guint
    tree*: PRBTree
    button_pressed_node*: PRBNode
    button_pressed_tree*: PRBTree
    children*: PGList
    width*: gint
    height*: gint
    expander_size*: gint
    hadjustment*: PAdjustment
    vadjustment*: PAdjustment
    bin_window*: gdk2.PWindow
    header_window*: gdk2.PWindow
    drag_window*: gdk2.PWindow
    drag_highlight_window*: gdk2.PWindow
    drag_column*: PTreeViewColumn
    last_button_press*: PTreeRowReference
    last_button_press_2*: PTreeRowReference
    top_row*: PTreeRowReference
    top_row_dy*: gint
    dy*: gint
    drag_column_x*: gint
    expander_column*: PTreeViewColumn
    edited_column*: PTreeViewColumn
    presize_handler_timer*: guint
    validate_rows_timer*: guint
    scroll_sync_timer*: guint
    focus_column*: PTreeViewColumn
    anchor*: PTreeRowReference
    cursor*: PTreeRowReference
    drag_pos*: gint
    x_drag*: gint
    prelight_node*: PRBNode
    prelight_tree*: PRBTree
    expanded_collapsed_node*: PRBNode
    expanded_collapsed_tree*: PRBTree
    expand_collapse_timeout*: guint
    selection*: PTreeSelection
    n_columns*: gint
    columns*: PGList
    header_height*: gint
    column_drop_func*: TTreeViewColumnDropFunc
    column_drop_func_data*: gpointer
    column_drop_func_data_destroy*: TDestroyNotify
    column_drag_info*: PGList
    cur_reorder*: PTreeViewColumnReorder
    destroy_count_func*: TTreeDestroyCountFunc
    destroy_count_data*: gpointer
    destroy_count_destroy*: TDestroyNotify
    scroll_timeout*: guint
    drag_dest_row*: PTreeRowReference
    drag_dest_pos*: TTreeViewDropPosition
    open_dest_timeout*: guint
    pressed_button*: gint
    press_start_x*: gint
    press_start_y*: gint
    scroll_to_path*: PTreeRowReference
    scroll_to_column*: PTreeViewColumn
    scroll_to_row_align*: gfloat
    scroll_to_col_align*: gfloat
    flag0*: guint16
    search_column*: gint
    search_dialog_position_func*: TTreeViewSearchDialogPositionFunc
    search_equal_func*: TTreeViewSearchEqualFunc
    search_user_data*: gpointer
    search_destroy*: TDestroyNotify

  TTreeView* = object of TContainer
    priv*: PTreeViewPrivate

  TTreeViewMappingFunc* = proc (tree_view: PTreeView, path: PTreePath,
                                user_data: gpointer){.cdecl.}
