# Included by headers/glib2.nim; do not import directly.
proc g_dir_open*(path: cstring, flags: guint, error: pointer): PGDir{.cdecl,
    dynlib: gliblib, importc: "g_dir_open".}
proc read_name*(dir: PGDir): cstring{.cdecl, dynlib: gliblib,
    importc: "g_dir_read_name".}
proc rewind*(dir: PGDir){.cdecl, dynlib: gliblib, importc: "g_dir_rewind".}
proc close*(dir: PGDir){.cdecl, dynlib: gliblib, importc: "g_dir_close".}
