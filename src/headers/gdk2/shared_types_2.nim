# Included by headers/gdk2.nim; do not import directly.
type
  TEventFunc* = proc (event: PEvent, data: gpointer){.cdecl.}
  TFilterFunc* = proc (xevent: PXEvent, event: PEvent, data: gpointer): TFilterReturn{.
      cdecl.}
