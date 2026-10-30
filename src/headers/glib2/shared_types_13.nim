# Included by headers/glib2.nim; do not import directly.
type
  TGHRFunc* = proc (key, value, user_data: gpointer): gboolean{.cdecl.}

