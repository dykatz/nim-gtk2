# Included by headers/gdk2.nim; do not import directly.
type
  TPropMode* = enum
    PROP_MODE_REPLACE, PROP_MODE_PREPEND, PROP_MODE_APPEND
  PPropMode* = ptr TPropMode
