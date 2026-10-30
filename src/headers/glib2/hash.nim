# Included by headers/glib2.nim; do not import directly.
proc g_hash_table_new*(hash_func: TGHashFunc, key_equal_func: TGEqualFunc): PGHashTable{.
    cdecl, dynlib: gliblib, importc: "g_hash_table_new".}
proc g_hash_table_new_full*(hash_func: TGHashFunc, key_equal_func: TGEqualFunc,
                            key_destroy_func: TGDestroyNotify,
                            value_destroy_func: TGDestroyNotify): PGHashTable{.
    cdecl, dynlib: gliblib, importc: "g_hash_table_new_full".}
proc table_destroy*(hash_table: PGHashTable){.cdecl, dynlib: gliblib,
    importc: "g_hash_table_destroy".}
proc table_insert*(hash_table: PGHashTable, key: gpointer,
                          value: gpointer){.cdecl, dynlib: gliblib,
    importc: "g_hash_table_insert".}
proc table_replace*(hash_table: PGHashTable, key: gpointer,
                           value: gpointer){.cdecl, dynlib: gliblib,
    importc: "g_hash_table_replace".}
proc table_remove*(hash_table: PGHashTable, key: gconstpointer): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_hash_table_remove".}
proc table_steal*(hash_table: PGHashTable, key: gconstpointer): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_hash_table_steal".}
proc table_lookup*(hash_table: PGHashTable, key: gconstpointer): gpointer{.
    cdecl, dynlib: gliblib, importc: "g_hash_table_lookup".}
proc table_lookup_extended*(hash_table: PGHashTable,
                                   lookup_key: gconstpointer,
                                   orig_key: Pgpointer, value: Pgpointer): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_hash_table_lookup_extended".}
proc table_foreach*(hash_table: PGHashTable, fn: TGHFunc,
                           user_data: gpointer){.cdecl, dynlib: gliblib,
    importc: "g_hash_table_foreach".}
proc table_foreach_remove*(hash_table: PGHashTable, fn: TGHRFunc,
                                  user_data: gpointer): guint{.cdecl,
    dynlib: gliblib, importc: "g_hash_table_foreach_remove".}
proc table_foreach_steal*(hash_table: PGHashTable, fn: TGHRFunc,
                                 user_data: gpointer): guint{.cdecl,
    dynlib: gliblib, importc: "g_hash_table_foreach_steal".}
proc table_size*(hash_table: PGHashTable): guint{.cdecl, dynlib: gliblib,
    importc: "g_hash_table_size".}
proc g_str_equal*(v: gconstpointer, v2: gconstpointer): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_str_equal".}
proc g_str_hash*(v: gconstpointer): guint{.cdecl, dynlib: gliblib,
    importc: "g_str_hash".}
proc g_int_equal*(v: gconstpointer, v2: gconstpointer): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_int_equal".}
proc g_int_hash*(v: gconstpointer): guint{.cdecl, dynlib: gliblib,
    importc: "g_int_hash".}
proc g_direct_hash*(v: gconstpointer): guint{.cdecl, dynlib: gliblib,
    importc: "g_direct_hash".}
proc g_direct_equal*(v: gconstpointer, v2: gconstpointer): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_direct_equal".}
