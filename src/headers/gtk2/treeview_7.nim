# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TREE_VIEW*(): GType
proc TREE_VIEW*(obj: pointer): PTreeView
proc TREE_VIEW_CLASS*(klass: pointer): PTreeViewClass
proc IS_TREE_VIEW*(obj: pointer): bool
proc IS_TREE_VIEW_CLASS*(klass: pointer): bool
proc TREE_VIEW_GET_CLASS*(obj: pointer): PTreeViewClass
proc tree_view_get_type*(): TType{.cdecl, dynlib: lib,
                                   importc: "gtk_tree_view_get_type".}
proc tree_view_new*(): PTreeView{.cdecl, dynlib: lib,
                                  importc: "gtk_tree_view_new".}
proc tree_view_new*(model: PTreeModel): PTreeView{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_new_with_model".}
proc get_model*(tree_view: PTreeView): PTreeModel{.cdecl, dynlib: lib,
    importc: "gtk_tree_view_get_model".}
proc set_model*(tree_view: PTreeView, model: PTreeModel){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_set_model".}
proc get_selection*(tree_view: PTreeView): PTreeSelection{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_get_selection".}
proc get_hadjustment*(tree_view: PTreeView): PAdjustment{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_get_hadjustment".}
proc set_hadjustment*(tree_view: PTreeView, adjustment: PAdjustment){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_set_hadjustment".}
proc get_vadjustment*(tree_view: PTreeView): PAdjustment{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_get_vadjustment".}
proc set_vadjustment*(tree_view: PTreeView, adjustment: PAdjustment){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_set_vadjustment".}
proc get_headers_visible*(tree_view: PTreeView): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_get_headers_visible".}
proc set_headers_visible*(tree_view: PTreeView,
                                    headers_visible: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_set_headers_visible".}
proc columns_autosize*(tree_view: PTreeView){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_columns_autosize".}
proc set_headers_clickable*(tree_view: PTreeView, setting: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_set_headers_clickable".}
proc set_rules_hint*(tree_view: PTreeView, setting: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_set_rules_hint".}
proc get_rules_hint*(tree_view: PTreeView): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_get_rules_hint".}
proc append_column*(tree_view: PTreeView, column: PTreeViewColumn): gint{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_append_column".}
proc remove_column*(tree_view: PTreeView, column: PTreeViewColumn): gint{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_remove_column".}
proc insert_column*(tree_view: PTreeView, column: PTreeViewColumn,
                              position: gint): gint{.cdecl, dynlib: lib,
    importc: "gtk_tree_view_insert_column".}
proc insert_column_with_data_func*(tree_view: PTreeView,
    position: gint, title: cstring, cell: PCellRenderer,
    fun: TTreeCellDataFunc, data: gpointer, dnotify: TGDestroyNotify): gint{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_insert_column_with_data_func".}
proc get_column*(tree_view: PTreeView, n: gint): PTreeViewColumn{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_get_column".}
proc get_columns*(tree_view: PTreeView): PGList{.cdecl, dynlib: lib,
    importc: "gtk_tree_view_get_columns".}
proc move_column_after*(tree_view: PTreeView, column: PTreeViewColumn,
                                  base_column: PTreeViewColumn){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_move_column_after".}
proc set_expander_column*(tree_view: PTreeView,
                                    column: PTreeViewColumn){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_set_expander_column".}
proc get_expander_column*(tree_view: PTreeView): PTreeViewColumn{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_get_expander_column".}
proc set_column_drag_function*(tree_view: PTreeView,
    fun: TTreeViewColumnDropFunc, user_data: gpointer, destroy: TDestroyNotify){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_set_column_drag_function".}
proc scroll_to_point*(tree_view: PTreeView, tree_x: gint, tree_y: gint){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_scroll_to_point".}
proc scroll_to_cell*(tree_view: PTreeView, path: PTreePath,
                               column: PTreeViewColumn, use_align: gboolean,
                               row_align: gfloat, col_align: gfloat){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_scroll_to_cell".}
proc row_activated*(tree_view: PTreeView, path: PTreePath,
                              column: PTreeViewColumn){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_row_activated".}
proc expand_to_path*(view: PTreeView, path: PTreePath) {.cdecl, dynlib: lib,
    importc: "gtk_tree_view_expand_to_path".}
proc expand_all*(tree_view: PTreeView){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_expand_all".}
proc collapse_all*(tree_view: PTreeView){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_collapse_all".}
proc expand_row*(tree_view: PTreeView, path: PTreePath,
                           open_all: gboolean): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_tree_view_expand_row".}
proc collapse_row*(tree_view: PTreeView, path: PTreePath): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_collapse_row".}
proc map_expanded_rows*(tree_view: PTreeView,
                                  fun: TTreeViewMappingFunc, data: gpointer){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_map_expanded_rows".}
proc row_expanded*(tree_view: PTreeView, path: PTreePath): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_row_expanded".}
proc set_reorderable*(tree_view: PTreeView, reorderable: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_set_reorderable".}
proc get_reorderable*(tree_view: PTreeView): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_get_reorderable".}
proc set_cursor*(tree_view: PTreeView, path: PTreePath,
                           focus_column: PTreeViewColumn,
                           start_editing: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_set_cursor".}
proc set_cursor_on_cell*(tree_view: PTreeView, path: PTreePath,
                                   focus_column: PTreeViewColumn,
                                   focus_cell: PCellRenderer,
                                   start_editing: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_set_cursor_on_cell".}
proc get_bin_window*(tree_view: PTreeView): gdk2.PWindow{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_get_bin_window".}
proc get_cell_area*(tree_view: PTreeView, path: PTreePath,
                              column: PTreeViewColumn, rect: gdk2.PRectangle){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_get_cell_area".}
proc get_background_area*(tree_view: PTreeView, path: PTreePath,
                                    column: PTreeViewColumn, rect: gdk2.PRectangle){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_get_background_area".}
proc get_visible_rect*(tree_view: PTreeView,
                                 visible_rect: gdk2.PRectangle){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_get_visible_rect".}
proc widget_to_tree_coords*(tree_view: PTreeView, wx: gint, wy: gint,
                                      tx: Pgint, ty: Pgint){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_widget_to_tree_coords".}
proc tree_to_widget_coords*(tree_view: PTreeView, tx: gint, ty: gint,
                                      wx: Pgint, wy: Pgint){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_tree_to_widget_coords".}
proc enable_model_drag_source*(tree_view: PTreeView,
    start_button_mask: gdk2.TModifierType, targets: PTargetEntry, n_targets: gint,
    actions: gdk2.TDragAction){.cdecl, dynlib: lib,
                              importc: "gtk_tree_view_enable_model_drag_source".}
proc enable_model_drag_dest*(tree_view: PTreeView,
                                       targets: PTargetEntry, n_targets: gint,
                                       actions: gdk2.TDragAction){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_enable_model_drag_dest".}
proc unset_rows_drag_source*(tree_view: PTreeView){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_unset_rows_drag_source".}
proc unset_rows_drag_dest*(tree_view: PTreeView){.cdecl, dynlib: lib,
    importc: "gtk_tree_view_unset_rows_drag_dest".}
proc set_drag_dest_row*(tree_view: PTreeView, path: PTreePath,
                                  pos: TTreeViewDropPosition){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_set_drag_dest_row".}
proc create_row_drag_icon*(tree_view: PTreeView, path: PTreePath): gdk2.PPixmap{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_create_row_drag_icon".}
proc set_enable_search*(tree_view: PTreeView, enable_search: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_set_enable_search".}
proc get_enable_search*(tree_view: PTreeView): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_get_enable_search".}
proc get_search_column*(tree_view: PTreeView): gint{.cdecl,
    dynlib: lib, importc: "gtk_tree_view_get_search_column".}
proc set_search_column*(tree_view: PTreeView, column: gint){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_set_search_column".}
proc get_search_equal_func*(tree_view: PTreeView): TTreeViewSearchEqualFunc{.
    cdecl, dynlib: lib, importc: "gtk_tree_view_get_search_equal_func".}
proc set_search_equal_func*(tree_view: PTreeView, search_equal_func: TTreeViewSearchEqualFunc,
                                      search_user_data: gpointer,
                                      search_destroy: TDestroyNotify){.cdecl,
    dynlib: lib, importc: "gtk_tree_view_set_search_equal_func".}
proc set_destroy_count_func*(tree_view: PTreeView,
                                       fun: TTreeDestroyCountFunc,
                                       data: gpointer, destroy: TDestroyNotify){.
    cdecl, dynlib: lib, importc: "gtk_tree_view_set_destroy_count_func".}
proc get_path_at_pos*(tree_view: PTreeView, x:gint, y:gint, path: ptr PTreePath,
    column: PTreeViewColumn, cell_x: gint, cell_y: gint): gint {.cdecl,
    importc: "gtk_tree_view_get_path_at_pos", dynlib: lib.}
proc TYPE_VBUTTON_BOX*(): GType
