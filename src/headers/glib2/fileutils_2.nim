# Included by headers/glib2.nim; do not import directly.
proc g_file_error_quark*(): TGQuark{.cdecl, dynlib: gliblib,
                                     importc: "g_file_error_quark".}
proc g_file_error_from_errno*(err_no: gint): TGFileError{.cdecl,
    dynlib: gliblib, importc: "g_file_error_from_errno".}
proc g_file_test*(filename: cstring, test: TGFileTest): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_file_test".}
proc g_file_get_contents*(filename: cstring, contents: PPgchar, length: Pgsize,
                          error: pointer): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_file_get_contents".}
proc g_mkstemp*(tmpl: cstring): int32{.cdecl, dynlib: gliblib,
                                       importc: "g_mkstemp".}
proc g_file_open_tmp*(tmpl: cstring, name_used: PPchar, error: pointer): int32{.
    cdecl, dynlib: gliblib, importc: "g_file_open_tmp".}
