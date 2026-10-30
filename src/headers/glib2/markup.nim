# Included by headers/glib2.nim; do not import directly.
proc g_markup_error_quark*(): TGQuark{.cdecl, dynlib: gliblib,
                                       importc: "g_markup_error_quark".}
