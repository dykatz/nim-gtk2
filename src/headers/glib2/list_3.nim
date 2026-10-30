# Included by headers/glib2.nim; do not import directly.
proc g_completion_new*(fn: TGCompletionFunc): PGCompletion{.cdecl,
    dynlib: gliblib, importc: "g_completion_new".}
proc add_items*(cmp: PGCompletion, items: PGList){.cdecl,
    dynlib: gliblib, importc: "g_completion_add_items".}
proc remove_items*(cmp: PGCompletion, items: PGList){.cdecl,
    dynlib: gliblib, importc: "g_completion_remove_items".}
proc clear_items*(cmp: PGCompletion){.cdecl, dynlib: gliblib,
    importc: "g_completion_clear_items".}
proc complete*(cmp: PGCompletion, prefix: cstring,
                            new_prefix: PPgchar): PGList{.cdecl,
    dynlib: gliblib, importc: "g_completion_complete".}
proc set_compare*(cmp: PGCompletion,
                               strncmp_func: TGCompletionStrncmpFunc){.cdecl,
    dynlib: gliblib, importc: "g_completion_set_compare".}
proc free*(cmp: PGCompletion){.cdecl, dynlib: gliblib,
    importc: "g_completion_free".}
