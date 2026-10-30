# Included by headers/glib2.nim; do not import directly.
proc g_free*(mem: gpointer){.cdecl, dynlib: gliblib, importc: "g_free".}
