# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TREE_SORTABLE*(): GType
proc TREE_SORTABLE*(obj: pointer): PTreeSortable
proc TREE_SORTABLE_CLASS*(obj: pointer): PTreeSortableIface
proc IS_TREE_SORTABLE*(obj: pointer): bool
proc TREE_SORTABLE_GET_IFACE*(obj: pointer): PTreeSortableIface
proc tree_sortable_get_type*(): GType{.cdecl, dynlib: lib,
                                       importc: "gtk_tree_sortable_get_type".}
proc sort_column_changed*(sortable: PTreeSortable){.cdecl,
    dynlib: lib, importc: "gtk_tree_sortable_sort_column_changed".}
proc get_sort_column_id*(sortable: PTreeSortable,
                                       sort_column_id: Pgint, order: PSortType): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_sortable_get_sort_column_id".}
proc set_sort_column_id*(sortable: PTreeSortable,
                                       sort_column_id: gint, order: TSortType){.
    cdecl, dynlib: lib, importc: "gtk_tree_sortable_set_sort_column_id".}
proc set_sort_func*(sortable: PTreeSortable, sort_column_id: gint,
                                  sort_func: TTreeIterCompareFunc,
                                  user_data: gpointer, destroy: TDestroyNotify){.
    cdecl, dynlib: lib, importc: "gtk_tree_sortable_set_sort_func".}
proc set_default_sort_func*(sortable: PTreeSortable,
    sort_func: TTreeIterCompareFunc, user_data: gpointer,
    destroy: TDestroyNotify){.cdecl, dynlib: lib, importc: "gtk_tree_sortable_set_default_sort_func".}
proc has_default_sort_func*(sortable: PTreeSortable): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_sortable_has_default_sort_func".}
