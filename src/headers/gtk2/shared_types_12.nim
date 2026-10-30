# Included by headers/gtk2.nim; do not import directly.
type
  TFileFilterFunc* = proc (filter_info: PFileFilterInfo, data: gpointer): gboolean{.
      cdecl.}

