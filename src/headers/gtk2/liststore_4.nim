# Included by headers/gtk2.nim; do not import directly.
proc list_store_new*(n_columns: gint): PListStore{.varargs, cdecl,
    importc: "gtk_list_store_new", dynlib: lib.}
proc set*(list_store: PListStore, iter: PTreeIter){.varargs, cdecl,
    importc: "gtk_list_store_set", dynlib: lib.}
proc set_valist*(list_store: PListStore, iter: PTreeIter){.varargs,
    cdecl, importc: "gtk_list_store_set_valist", dynlib: lib.}
