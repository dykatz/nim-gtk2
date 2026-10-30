# Included by headers/glib2.nim; do not import directly.
proc g_parse_debug_string*(str: cstring, keys: PGDebugKey, nkeys: guint): guint{.
    cdecl, dynlib: gliblib, importc: "g_parse_debug_string".}
