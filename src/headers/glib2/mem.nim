# Included by headers/glib2.nim; do not import directly.
proc g_malloc*(n_bytes: gulong): gpointer{.cdecl, dynlib: gliblib,
    importc: "g_malloc".}
proc g_malloc0*(n_bytes: gulong): gpointer{.cdecl, dynlib: gliblib,
    importc: "g_malloc0".}
proc g_realloc*(mem: gpointer, n_bytes: gulong): gpointer{.cdecl,
    dynlib: gliblib, importc: "g_realloc".}
