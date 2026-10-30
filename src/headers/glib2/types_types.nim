# Included by headers/glib2.nim; do not import directly.
type
  TGTimeVal*{.final.} = object
    tv_sec*: glong
    tv_usec*: glong

  PGTimeVal* = ptr TGTimeVal
