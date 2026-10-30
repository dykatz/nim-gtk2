# Included by headers/glib2.nim; do not import directly.
proc g_set_print_handler*(fn: TGPrintFunc): TGPrintFunc{.cdecl,
    dynlib: gliblib, importc: "g_set_print_handler".}
proc g_set_printerr_handler*(fn: TGPrintFunc): TGPrintFunc{.cdecl,
    dynlib: gliblib, importc: "g_set_printerr_handler".}
