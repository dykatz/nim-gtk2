# Included by headers/glib2.nim; do not import directly.
proc g_value_array_get_type*(): GType{.cdecl, dynlib: gobjectlib,
                                       importc: "g_value_array_get_type".}
