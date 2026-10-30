# Included by headers/glib2.nim; do not import directly.
proc g_tree_new*(key_compare_func: TGCompareFunc): PGTree{.cdecl,
    dynlib: gliblib, importc: "g_tree_new".}
proc g_tree_new*(key_compare_func: TGCompareDataFunc,
                           key_compare_data: gpointer): PGTree{.cdecl,
    dynlib: gliblib, importc: "g_tree_new_with_data".}
proc g_tree_new_full*(key_compare_func: TGCompareDataFunc,
                      key_compare_data: gpointer,
                      key_destroy_func: TGDestroyNotify,
                      value_destroy_func: TGDestroyNotify): PGTree{.cdecl,
    dynlib: gliblib, importc: "g_tree_new_full".}
proc destroy*(tree: PGTree){.cdecl, dynlib: gliblib,
                                    importc: "g_tree_destroy".}
proc insert*(tree: PGTree, key: gpointer, value: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_tree_insert".}
proc replace*(tree: PGTree, key: gpointer, value: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_tree_replace".}
proc remove*(tree: PGTree, key: gconstpointer){.cdecl, dynlib: gliblib,
    importc: "g_tree_remove".}
proc steal*(tree: PGTree, key: gconstpointer){.cdecl, dynlib: gliblib,
    importc: "g_tree_steal".}
proc lookup*(tree: PGTree, key: gconstpointer): gpointer{.cdecl,
    dynlib: gliblib, importc: "g_tree_lookup".}
proc lookup_extended*(tree: PGTree, lookup_key: gconstpointer,
                             orig_key: Pgpointer, value: Pgpointer): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_tree_lookup_extended".}
proc foreach*(tree: PGTree, fn: TGTraverseFunc, user_data: gpointer){.
    cdecl, dynlib: gliblib, importc: "g_tree_foreach".}
proc search*(tree: PGTree, search_func: TGCompareFunc,
                    user_data: gconstpointer): gpointer{.cdecl, dynlib: gliblib,
    importc: "g_tree_search".}
proc height*(tree: PGTree): gint{.cdecl, dynlib: gliblib,
    importc: "g_tree_height".}
proc nnodes*(tree: PGTree): gint{.cdecl, dynlib: gliblib,
    importc: "g_tree_nnodes".}
