# Included by headers/glib2.nim; do not import directly.
proc g_pattern_spec_new*(pattern: cstring): PGPatternSpec{.cdecl,
    dynlib: gliblib, importc: "g_pattern_spec_new".}
proc spec_free*(pspec: PGPatternSpec){.cdecl, dynlib: gliblib,
    importc: "g_pattern_spec_free".}
proc spec_equal*(pspec1: PGPatternSpec, pspec2: PGPatternSpec): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_pattern_spec_equal".}
proc match*(pspec: PGPatternSpec, string_length: guint, str: cstring,
                      string_reversed: cstring): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_pattern_match".}
proc match_string*(pspec: PGPatternSpec, str: cstring): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_pattern_match_string".}
proc g_pattern_match_simple*(pattern: cstring, str: cstring): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_pattern_match_simple".}
