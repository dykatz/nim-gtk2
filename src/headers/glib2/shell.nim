# Included by headers/glib2.nim; do not import directly.
proc g_shell_error_quark*(): TGQuark{.cdecl, dynlib: gliblib,
                                      importc: "g_shell_error_quark".}
proc g_shell_quote*(unquoted_string: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_shell_quote".}
proc g_shell_unquote*(quoted_string: cstring, error: pointer): cstring{.cdecl,
    dynlib: gliblib, importc: "g_shell_unquote".}
proc g_shell_parse_argv*(command_line: cstring, argcp: Pgint, argvp: PPPgchar,
                         error: pointer): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_shell_parse_argv".}
