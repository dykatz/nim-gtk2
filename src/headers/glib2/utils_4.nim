# Included by headers/glib2.nim; do not import directly.
proc g_atexit*(fn: TGVoidFunc){.cdecl, dynlib: gliblib, importc: "g_atexit".}
proc g_find_program_in_path*(program: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_find_program_in_path".}
proc g_bit_nth_lsf*(mask: gulong, nth_bit: gint): gint{.cdecl, dynlib: gliblib,
    importc: "g_bit_nth_lsf".}
proc g_bit_nth_msf*(mask: gulong, nth_bit: gint): gint{.cdecl, dynlib: gliblib,
    importc: "g_bit_nth_msf".}
proc g_bit_storage*(number: gulong): guint{.cdecl, dynlib: gliblib,
    importc: "g_bit_storage".}
