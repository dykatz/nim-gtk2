# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TREE_SELECTION*(): GType
proc TREE_SELECTION*(obj: pointer): PTreeSelection
proc TREE_SELECTION_CLASS*(klass: pointer): PTreeSelectionClass
proc IS_TREE_SELECTION*(obj: pointer): bool
proc IS_TREE_SELECTION_CLASS*(klass: pointer): bool
proc TREE_SELECTION_GET_CLASS*(obj: pointer): PTreeSelectionClass
proc tree_selection_get_type*(): TType{.cdecl, dynlib: lib,
                                        importc: "gtk_tree_selection_get_type".}
proc set_mode*(selection: PTreeSelection, thetype: TSelectionMode){.
    cdecl, dynlib: lib, importc: "gtk_tree_selection_set_mode".}
proc get_mode*(selection: PTreeSelection): TSelectionMode{.cdecl,
    dynlib: lib, importc: "gtk_tree_selection_get_mode".}
proc set_select_function*(selection: PTreeSelection,
    fun: TTreeSelectionFunc, data: gpointer, destroy: TDestroyNotify){.cdecl,
    dynlib: lib, importc: "gtk_tree_selection_set_select_function".}
proc get_user_data*(selection: PTreeSelection): gpointer{.cdecl,
    dynlib: lib, importc: "gtk_tree_selection_get_user_data".}
proc get_tree_view*(selection: PTreeSelection): PTreeView{.cdecl,
    dynlib: lib, importc: "gtk_tree_selection_get_tree_view".}
proc get_selected*(selection: PTreeSelection,
                                  model: PPGtkTreeModel, iter: PTreeIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_selection_get_selected".}
proc get_selected_rows*(selection: PTreeSelection,
                                       model: PPGtkTreeModel): PGList{.cdecl,
    dynlib: lib, importc: "gtk_tree_selection_get_selected_rows".}
proc selected_foreach*(selection: PTreeSelection,
                                      fun: TTreeSelectionForeachFunc,
                                      data: gpointer){.cdecl, dynlib: lib,
    importc: "gtk_tree_selection_selected_foreach".}
proc select_path*(selection: PTreeSelection, path: PTreePath){.
    cdecl, dynlib: lib, importc: "gtk_tree_selection_select_path".}
proc unselect_path*(selection: PTreeSelection, path: PTreePath){.
    cdecl, dynlib: lib, importc: "gtk_tree_selection_unselect_path".}
proc select_iter*(selection: PTreeSelection, iter: PTreeIter){.
    cdecl, dynlib: lib, importc: "gtk_tree_selection_select_iter".}
proc unselect_iter*(selection: PTreeSelection, iter: PTreeIter){.
    cdecl, dynlib: lib, importc: "gtk_tree_selection_unselect_iter".}
proc path_is_selected*(selection: PTreeSelection, path: PTreePath): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_selection_path_is_selected".}
proc iter_is_selected*(selection: PTreeSelection, iter: PTreeIter): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_selection_iter_is_selected".}
proc select_all*(selection: PTreeSelection){.cdecl, dynlib: lib,
    importc: "gtk_tree_selection_select_all".}
proc unselect_all*(selection: PTreeSelection){.cdecl,
    dynlib: lib, importc: "gtk_tree_selection_unselect_all".}
proc select_range*(selection: PTreeSelection,
                                  start_path: PTreePath, end_path: PTreePath){.
    cdecl, dynlib: lib, importc: "gtk_tree_selection_select_range".}
proc count_selected_rows*(selection: PTreeSelection): gint {.cdecl,
    importc: "gtk_tree_selection_count_selected_rows", dynlib: lib.}
const
  bm_TGtkTreeStore_columns_dirty* = 0x0001'u16
const
  bp_TGtkTreeStore_columns_dirty* = 0'u16

