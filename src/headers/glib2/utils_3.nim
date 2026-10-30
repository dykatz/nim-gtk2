# Included by headers/glib2.nim; do not import directly.
proc nullify_pointer*(nullify_location: Pgpointer){.cdecl, dynlib: gliblib,
    importc: "g_nullify_pointer".}
