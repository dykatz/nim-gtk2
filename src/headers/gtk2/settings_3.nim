# Included by headers/gtk2.nim; do not import directly.
proc rc_context_get_default_font_name*(settings: PSettings): cstring{.cdecl,
    dynlib: lib, importc: "_gtk_rc_context_get_default_font_name".}
