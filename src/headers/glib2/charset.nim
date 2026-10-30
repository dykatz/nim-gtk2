# Included by headers/glib2.nim; do not import directly.
proc g_get_charset*(charset: PPchar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_get_charset".}
