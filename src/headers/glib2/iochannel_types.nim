# Included by headers/glib2.nim; do not import directly.
type
  TGIOError* = enum
    G_IO_ERROR_NONE, G_IO_ERROR_AGAIN, G_IO_ERROR_INVAL, G_IO_ERROR_UNKNOWN

  PGIOError* = ptr TGIOError
