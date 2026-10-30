# Included by headers/glib2.nim; do not import directly.
type
  GError* {.pure, final.} = object
    ## GLib-owned error; release with g_error_free, not Nim's allocator.
    domain*: uint32
    code*: cint
    message*: cstring

