# Included by headers/glib2.nim; do not import directly.
proc g_gstring_get_type*(): GType{.cdecl, dynlib: gobjectlib,
                                   importc: "g_gstring_get_type".}
