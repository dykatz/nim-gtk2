# Included by headers/glib2.nim; do not import directly.
type
  TGDataForeachFunc* = proc (key_id: TGQuark, data: gpointer,
                             user_data: gpointer){.cdecl.}

