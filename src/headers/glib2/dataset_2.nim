# Included by headers/glib2.nim; do not import directly.
proc g_quark_from_string*(str: cstring): TGQuark{.cdecl, dynlib: gliblib,
    importc: "g_quark_from_string".}
