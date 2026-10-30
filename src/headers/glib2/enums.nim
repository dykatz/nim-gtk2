# Included by headers/glib2.nim; do not import directly.
proc g_type_name*(theType: GType): cstring{.cdecl, dynlib: gobjectlib,
    importc: "g_type_name".}
