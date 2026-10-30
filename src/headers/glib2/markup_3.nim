# Included by headers/glib2.nim; do not import directly.
proc parse_context_new*(parser: PGMarkupParser,
                                 flags: TGMarkupParseFlags, user_data: gpointer,
                                 user_data_dnotify: TGDestroyNotify): PGMarkupParseContext{.
    cdecl, dynlib: gliblib, importc: "g_markup_parse_context_new".}
proc parse_context_free*(context: PGMarkupParseContext){.cdecl,
    dynlib: gliblib, importc: "g_markup_parse_context_free".}
proc parse_context_parse*(context: PGMarkupParseContext, text: cstring,
                                   text_len: gssize, error: pointer): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_markup_parse_context_parse".}
proc parse_context_end_parse*(context: PGMarkupParseContext,
                                       error: pointer): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_markup_parse_context_end_parse".}
proc parse_context_get_position*(context: PGMarkupParseContext,
    line_number: Pgint, char_number: Pgint){.cdecl, dynlib: gliblib,
    importc: "g_markup_parse_context_get_position".}
proc g_markup_escape_text*(text: cstring, length: gssize): cstring{.cdecl,
    dynlib: gliblib, importc: "g_markup_escape_text".}
