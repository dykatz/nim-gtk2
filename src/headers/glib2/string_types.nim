# Included by headers/glib2.nim; do not import directly.
type
  TGString*{.final.} = object
    str*: cstring
    len*: gsize
    allocated_len*: gsize
  PGString* = ptr TGString
