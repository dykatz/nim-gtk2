# Included by headers/glib2.nim; do not import directly.
type
  PGCache* = pointer
  TGCacheNewFunc* = proc (key: gpointer): gpointer{.cdecl.}
  TGCacheDupFunc* = proc (value: gpointer): gpointer{.cdecl.}
  TGCacheDestroyFunc* = proc (value: gpointer){.cdecl.}

