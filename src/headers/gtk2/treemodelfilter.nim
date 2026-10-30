# Included by headers/gtk2.nim; do not import directly.
proc tree_model_filter_get_type*(): GType {.cdecl, dynlib: lib,
    importc: "gtk_tree_model_filter_get_type".}
proc tree_model_filter_new*(child: PTreeModel, root: PTreePath): PTreeModel {.cdecl,
    dynlib: lib, importc: "gtk_tree_model_filter_new".}
proc tree_model_filter_set_visible_column*(filter: ptr TreeModelFilter, column: gint) {.cdecl,
    dynlib: lib, importc: "gtk_tree_model_filter_set_visible_column".}
proc tree_model_filter_get_model*(filter: ptr TreeModelFilter): PTreeModel {.cdecl,
    dynlib: lib, importc: "gtk_tree_model_filter_get_model".}
proc tree_model_filter_convert_child_path_to_path*(filter: ptr TreeModelFilter,
    path: PTreePath): PTreePath {.cdecl, dynlib: lib,
    importc: "gtk_tree_model_filter_convert_child_path_to_path".}
proc tree_model_filter_convert_path_to_child_path*(filter: ptr TreeModelFilter,
    path: PTreePath): PTreePath {.cdecl, dynlib: lib,
    importc: "gtk_tree_model_filter_convert_path_to_child_path".}
proc tree_model_filter_refilter*(filter: ptr TreeModelFilter) {.cdecl, dynlib: lib,
    importc: "gtk_tree_model_filter_refilter".}

