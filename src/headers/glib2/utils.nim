# Included by headers/glib2.nim; do not import directly.
proc g_get_user_name*(): cstring{.cdecl, dynlib: gliblib,
                                  importc: "g_get_user_name".}
proc g_get_real_name*(): cstring{.cdecl, dynlib: gliblib,
                                  importc: "g_get_real_name".}
proc g_get_home_dir*(): cstring{.cdecl, dynlib: gliblib,
                                 importc: "g_get_home_dir".}
proc g_get_tmp_dir*(): cstring{.cdecl, dynlib: gliblib, importc: "g_get_tmp_dir".}
proc g_get_prgname*(): cstring{.cdecl, dynlib: gliblib, importc: "g_get_prgname".}
proc g_set_prgname*(prgname: cstring){.cdecl, dynlib: gliblib,
                                       importc: "g_set_prgname".}
