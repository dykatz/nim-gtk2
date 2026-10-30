# Included by headers/glib2.nim; do not import directly.
proc g_timeout_add*(interval: guint, function, data: gpointer): guint {.
  cdecl, dynlib: gliblib, importc: "g_timeout_add".}

proc g_timeout_add_full*(priority: gint, interval: guint, function,
  data, notify: gpointer): guint {.cdecl, dynlib: gliblib,
  importc: "g_timeout_add_full".}

proc g_idle_add*(function, data: gpointer): guint {.
  cdecl, dynlib: gliblib, importc: "g_idle_add".}

proc g_idle_add_full*(priority: guint, function,
  data, notify: gpointer): guint {.cdecl, dynlib: gliblib,
  importc: "g_idle_add_full".}

proc g_source_remove*(tag: guint): gboolean {.
  cdecl, dynlib: gliblib, importc: "g_source_remove".}

proc g_signal_emit_by_name*(instance: gpointer, detailed_signal: cstring) {.
  cdecl, varargs, dynlib: gobjectlib, importc.}

