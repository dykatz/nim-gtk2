# Included by headers/glib2.nim; do not import directly.
proc g_error_free*(error: ptr GError) {.cdecl, dynlib: gliblib,
    importc: "g_error_free".}
