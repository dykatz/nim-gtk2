# Included by headers/glib2.nim; do not import directly.
proc g_path_is_absolute*(file_name: cstring): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_path_is_absolute".}
proc g_path_skip_root*(file_name: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_path_skip_root".}
proc g_basename*(file_name: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_basename".}
proc g_dirname*(file_name: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_path_get_dirname".}
proc g_get_current_dir*(): cstring{.cdecl, dynlib: gliblib,
                                    importc: "g_get_current_dir".}
proc g_path_get_basename*(file_name: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_path_get_basename".}
proc g_path_get_dirname*(file_name: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_path_get_dirname".}
