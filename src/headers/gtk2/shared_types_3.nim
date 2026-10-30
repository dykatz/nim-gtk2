# Included by headers/gtk2.nim; do not import directly.
type
  TCallbackMarshal* = proc (anObject: PObject, data: gpointer, n_args: guint,
                            args: PArg){.cdecl.}
