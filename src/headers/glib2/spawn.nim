# Included by headers/glib2.nim; do not import directly.
proc g_spawn_error_quark*(): TGQuark{.cdecl, dynlib: gliblib,
                                      importc: "g_spawn_error_quark".}
proc g_spawn_async*(working_directory: cstring, argv: PPgchar, envp: PPgchar,
                    flags: TGSpawnFlags, child_setup: TGSpawnChildSetupFunc,
                    user_data: gpointer, child_pid: Pgint, error: pointer): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_spawn_async".}
proc g_spawn_async*(working_directory: cstring, argv: PPgchar,
                               envp: PPgchar, flags: TGSpawnFlags,
                               child_setup: TGSpawnChildSetupFunc,
                               user_data: gpointer, child_pid: Pgint,
                               standard_input: Pgint, standard_output: Pgint,
                               standard_error: Pgint, error: pointer): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_spawn_async_with_pipes".}
proc g_spawn_sync*(working_directory: cstring, argv: PPgchar, envp: PPgchar,
                   flags: TGSpawnFlags, child_setup: TGSpawnChildSetupFunc,
                   user_data: gpointer, standard_output: PPgchar,
                   standard_error: PPgchar, exit_status: Pgint, error: pointer): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_spawn_sync".}
proc g_spawn_command_line_sync*(command_line: cstring, standard_output: PPgchar,
                                standard_error: PPgchar, exit_status: Pgint,
                                error: pointer): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_spawn_command_line_sync".}
proc g_spawn_command_line_async*(command_line: cstring, error: pointer): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_spawn_command_line_async".}
proc G_TYPE_IS_BOXED*(theType: GType): gboolean
