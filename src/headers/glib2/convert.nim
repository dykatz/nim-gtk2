# Included by headers/glib2.nim; do not import directly.
proc g_convert_error_quark*(): TGQuark{.cdecl, dynlib: gliblib,
                                        importc: "g_convert_error_quark".}
