# Included by headers/glib2.nim; do not import directly.
type
  TGValueTransform* = proc (src_value: PGValue, dest_value: PGValue){.cdecl.}

