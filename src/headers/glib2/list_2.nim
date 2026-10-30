# Included by headers/glib2.nim; do not import directly.
proc g_cache_new*(value_new_func: TGCacheNewFunc,
                  value_destroy_func: TGCacheDestroyFunc,
                  key_dup_func: TGCacheDupFunc,
                  key_destroy_func: TGCacheDestroyFunc,
                  hash_key_func: TGHashFunc, hash_value_func: TGHashFunc,
                  key_equal_func: TGEqualFunc): PGCache{.cdecl, dynlib: gliblib,
    importc: "g_cache_new".}
proc destroy*(cache: PGCache){.cdecl, dynlib: gliblib,
                                       importc: "g_cache_destroy".}
proc insert*(cache: PGCache, key: gpointer): gpointer{.cdecl,
    dynlib: gliblib, importc: "g_cache_insert".}
proc remove*(cache: PGCache, value: gconstpointer){.cdecl,
    dynlib: gliblib, importc: "g_cache_remove".}
proc key_foreach*(cache: PGCache, fn: TGHFunc, user_data: gpointer){.
    cdecl, dynlib: gliblib, importc: "g_cache_key_foreach".}
proc value_foreach*(cache: PGCache, fn: TGHFunc, user_data: gpointer){.
    cdecl, dynlib: gliblib, importc: "g_cache_value_foreach".}
