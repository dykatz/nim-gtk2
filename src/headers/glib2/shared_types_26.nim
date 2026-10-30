# Included by headers/glib2.nim; do not import directly.
type
  TGTraverseFunc* = proc (key: gpointer, value: gpointer, data: gpointer): gboolean{.
      cdecl.}

