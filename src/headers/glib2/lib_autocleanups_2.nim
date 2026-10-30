# Included by headers/glib2.nim; do not import directly.
proc free*(str: PGString, free_segment: gboolean): cstring{.cdecl,
    dynlib: gliblib, importc: "g_string_free".}
