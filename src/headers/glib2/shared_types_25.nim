# Included by headers/glib2.nim; do not import directly.
type
  TGNodeTraverseFunc* = proc (node: PGNode, data: gpointer): gboolean{.cdecl.}
  TGNodeForeachFunc* = proc (node: PGNode, data: gpointer){.cdecl.}

