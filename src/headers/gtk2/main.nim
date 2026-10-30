# Included by headers/gtk2.nim; do not import directly.
proc check_version*(required_major: guint, required_minor: guint,
                    required_micro: guint): cstring{.cdecl, dynlib: lib,
    importc: "gtk_check_version".}
proc disable_setlocale*(){.cdecl, dynlib: lib, importc: "gtk_disable_setlocale".}
proc set_locale*(): cstring{.cdecl, dynlib: lib, importc: "gtk_set_locale".}
proc get_default_language*(): pango.PLanguage{.cdecl, dynlib: lib,
    importc: "gtk_get_default_language".}
proc events_pending*(): gint{.cdecl, dynlib: lib, importc: "gtk_events_pending".}
proc main_do_event*(event: gdk2.PEvent){.cdecl, dynlib: lib,
                                       importc: "gtk_main_do_event".}

