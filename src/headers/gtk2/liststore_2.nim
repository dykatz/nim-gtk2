# Included by headers/gtk2.nim; do not import directly.
proc TYPE_LIST_STORE*(): GType
proc LIST_STORE*(obj: pointer): PListStore
proc LIST_STORE_CLASS*(klass: pointer): PListStoreClass
proc IS_LIST_STORE*(obj: pointer): bool
proc IS_LIST_STORE_CLASS*(klass: pointer): bool
proc LIST_STORE_GET_CLASS*(obj: pointer): PListStoreClass
proc columns_dirty*(a: PListStore): guint
proc set_columns_dirty*(a: PListStore, `columns_dirty`: guint)
proc list_store_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_list_store_get_type".}
proc list_store_newv*(n_columns: gint, types: PGType): PListStore{.cdecl,
    dynlib: lib, importc: "gtk_list_store_newv".}
proc set_valuesv*(store: PListStore, iter: PTreeIter, columns: Pgint,
                 values: PGValue, count: gint) {.cdecl, dynlib: lib,
    importc: "gtk_list_store_set_valuesv".}
proc insert_with_valuesv*(store: PListStore, iter: PTreeIter, position: gint,
                         columns: Pgint, values: PGValue, count: gint) {.cdecl,
    dynlib: lib, importc: "gtk_list_store_insert_with_valuesv".}
proc set_column_types*(list_store: PListStore, n_columns: gint,
                                  types: PGType){.cdecl, dynlib: lib,
    importc: "gtk_list_store_set_column_types".}
proc set_value*(list_store: PListStore, iter: PTreeIter,
                           column: gint, value: PGValue){.cdecl, dynlib: lib,
    importc: "gtk_list_store_set_value".}
proc remove*(list_store: PListStore, iter: PTreeIter): gboolean {.cdecl,
    dynlib: lib, importc: "gtk_list_store_remove".}
proc insert*(list_store: PListStore, iter: PTreeIter, position: gint){.
    cdecl, dynlib: lib, importc: "gtk_list_store_insert".}
proc insert_before*(list_store: PListStore, iter: PTreeIter,
                               sibling: PTreeIter){.cdecl, dynlib: lib,
    importc: "gtk_list_store_insert_before".}
proc insert_after*(list_store: PListStore, iter: PTreeIter,
                              sibling: PTreeIter){.cdecl, dynlib: lib,
    importc: "gtk_list_store_insert_after".}
proc prepend*(list_store: PListStore, iter: PTreeIter){.cdecl,
    dynlib: lib, importc: "gtk_list_store_prepend".}
proc append*(list_store: PListStore, iter: PTreeIter){.cdecl,
    dynlib: lib, importc: "gtk_list_store_append".}
proc clear*(list_store: PListStore){.cdecl, dynlib: lib,
    importc: "gtk_list_store_clear".}
