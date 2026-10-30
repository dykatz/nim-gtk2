# Included by headers/glib2.nim; do not import directly.
type
  TGMemVTable*{.final.} = object
    malloc*: proc (n_bytes: gsize): gpointer{.cdecl.}
    realloc*: proc (mem: gpointer, n_bytes: gsize): gpointer{.cdecl.}
    free*: proc (mem: gpointer){.cdecl.}
    calloc*: proc (n_blocks: gsize, n_block_bytes: gsize): gpointer{.cdecl.}
    try_malloc*: proc (n_bytes: gsize): gpointer{.cdecl.}
    try_realloc*: proc (mem: gpointer, n_bytes: gsize): gpointer{.cdecl.}

  PGMemVTable* = ptr TGMemVTable
