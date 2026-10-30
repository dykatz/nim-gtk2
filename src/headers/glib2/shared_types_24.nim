# Included by headers/glib2.nim; do not import directly.
type
  TGPrintFunc* = proc (str: cstring){.cdecl, varargs.}

