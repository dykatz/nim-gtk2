# Included by headers/glib2.nim; do not import directly.
proc g_getenv*(variable: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_getenv".}
