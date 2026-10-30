# Included by headers/gtk2.nim; do not import directly.
proc show_uri* (screen: gdk2.PScreen, uri: cstring, timestamp: guint32,
  error: pointer): gboolean {.cdecl, importc: "gtk_show_uri", dynlib: lib.}

