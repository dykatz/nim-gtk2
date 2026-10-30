# Included by headers/glib2.nim; do not import directly.
proc g_thread_pool_new*(fn: TGFunc, user_data: gpointer, max_threads: gint,
                        exclusive: gboolean, error: pointer): PGThreadPool{.
    cdecl, dynlib: gliblib, importc: "g_thread_pool_new".}
proc pool_push*(pool: PGThreadPool, data: gpointer, error: pointer){.
    cdecl, dynlib: gliblib, importc: "g_thread_pool_push".}
proc pool_set_max_threads*(pool: PGThreadPool, max_threads: gint,
                                    error: pointer){.cdecl, dynlib: gliblib,
    importc: "g_thread_pool_set_max_threads".}
proc pool_get_max_threads*(pool: PGThreadPool): gint{.cdecl,
    dynlib: gliblib, importc: "g_thread_pool_get_max_threads".}
proc pool_get_num_threads*(pool: PGThreadPool): guint{.cdecl,
    dynlib: gliblib, importc: "g_thread_pool_get_num_threads".}
proc pool_unprocessed*(pool: PGThreadPool): guint{.cdecl,
    dynlib: gliblib, importc: "g_thread_pool_unprocessed".}
proc pool_free*(pool: PGThreadPool, immediate: gboolean, wait: gboolean){.
    cdecl, dynlib: gliblib, importc: "g_thread_pool_free".}
proc g_thread_pool_set_max_unused_threads*(max_threads: gint){.cdecl,
    dynlib: gliblib, importc: "g_thread_pool_set_max_unused_threads".}
proc g_thread_pool_get_max_unused_threads*(): gint{.cdecl, dynlib: gliblib,
    importc: "g_thread_pool_get_max_unused_threads".}
proc g_thread_pool_get_num_unused_threads*(): guint{.cdecl, dynlib: gliblib,
    importc: "g_thread_pool_get_num_unused_threads".}
proc g_thread_pool_stop_unused_threads*(){.cdecl, dynlib: gliblib,
    importc: "g_thread_pool_stop_unused_threads".}
