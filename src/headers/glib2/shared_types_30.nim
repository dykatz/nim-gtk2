# Included by headers/glib2.nim; do not import directly.
type
  PGModule* = pointer
  TGModuleFlags* = int32
  TGModuleCheckInit* = proc (module: PGModule): cstring{.cdecl.}
  TGModuleUnload* = proc (module: PGModule){.cdecl.}

