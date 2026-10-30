# Included by headers/glib2.nim; do not import directly.
type
  PGHookList* = ptr TGHookList
  TGHookFinalizeFunc* = proc (hook_list: PGHookList, hook: PGHook){.cdecl.}
  TGHookList*{.final.} = object
    seq_id*: gulong
    flag0*: uint32
    hooks*: PGHook
    hook_memchunk*: PGMemChunk
    finalize_hook*: TGHookFinalizeFunc
    dummy*: array[0..1, gpointer]


  TGHookCompareFunc* = proc (new_hook: PGHook, sibling: PGHook): gint{.cdecl.}
  TGHookFindFunc* = proc (hook: PGHook, data: gpointer): gboolean{.cdecl.}
  TGHookMarshaller* = proc (hook: PGHook, marshal_data: gpointer){.cdecl.}
  TGHookCheckMarshaller* = proc (hook: PGHook, marshal_data: gpointer): gboolean{.
      cdecl.}
  TGHookFunc* = proc (data: gpointer){.cdecl.}
  TGHookCheckFunc* = proc (data: gpointer): gboolean{.cdecl.}
