# Included by headers/glib2.nim; do not import directly.
proc g_string_new*(init: cstring): PGString{.cdecl, dynlib: gliblib,
    importc: "g_string_new".}
proc g_string_new_len*(init: cstring, len: gssize): PGString{.cdecl,
    dynlib: gliblib, importc: "g_string_new_len".}
proc g_string_sized_new*(dfl_size: gsize): PGString{.cdecl, dynlib: gliblib,
    importc: "g_string_sized_new".}
