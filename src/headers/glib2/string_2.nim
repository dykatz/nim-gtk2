# Included by headers/glib2.nim; do not import directly.
proc equal*(v: PGString, v2: PGString): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_string_equal".}
proc hash*(str: PGString): guint{.cdecl, dynlib: gliblib,
    importc: "g_string_hash".}
proc assign*(str: PGString, rval: cstring): PGString{.cdecl,
    dynlib: gliblib, importc: "g_string_assign".}
proc truncate*(str: PGString, len: gsize): PGString{.cdecl,
    dynlib: gliblib, importc: "g_string_truncate".}
proc set_size*(str: PGString, len: gsize): PGString{.cdecl,
    dynlib: gliblib, importc: "g_string_set_size".}
proc insert_len*(str: PGString, pos: gssize, val: cstring, len: gssize): PGString{.
    cdecl, dynlib: gliblib, importc: "g_string_insert_len".}
proc append*(str: PGString, val: cstring): PGString{.cdecl,
    dynlib: gliblib, importc: "g_string_append".}
proc append_len*(str: PGString, val: cstring, len: gssize): PGString{.
    cdecl, dynlib: gliblib, importc: "g_string_append_len".}
proc append_c*(str: PGString, c: gchar): PGString{.cdecl,
    dynlib: gliblib, importc: "g_string_append_c".}
proc append_unichar*(str: PGString, wc: gunichar): PGString{.cdecl,
    dynlib: gliblib, importc: "g_string_append_unichar".}
proc prepend*(str: PGString, val: cstring): PGString{.cdecl,
    dynlib: gliblib, importc: "g_string_prepend".}
proc prepend_c*(str: PGString, c: gchar): PGString{.cdecl,
    dynlib: gliblib, importc: "g_string_prepend_c".}
proc prepend_unichar*(str: PGString, wc: gunichar): PGString{.cdecl,
    dynlib: gliblib, importc: "g_string_prepend_unichar".}
proc prepend_len*(str: PGString, val: cstring, len: gssize): PGString{.
    cdecl, dynlib: gliblib, importc: "g_string_prepend_len".}
proc insert*(str: PGString, pos: gssize, val: cstring): PGString{.
    cdecl, dynlib: gliblib, importc: "g_string_insert".}
proc insert_c*(str: PGString, pos: gssize, c: gchar): PGString{.cdecl,
    dynlib: gliblib, importc: "g_string_insert_c".}
proc insert_unichar*(str: PGString, pos: gssize, wc: gunichar): PGString{.
    cdecl, dynlib: gliblib, importc: "g_string_insert_unichar".}
proc erase*(str: PGString, pos: gssize, len: gssize): PGString{.cdecl,
    dynlib: gliblib, importc: "g_string_erase".}
proc ascii_down*(str: PGString): PGString{.cdecl, dynlib: gliblib,
    importc: "g_string_ascii_down".}
proc ascii_up*(str: PGString): PGString{.cdecl, dynlib: gliblib,
    importc: "g_string_ascii_up".}
proc down*(str: PGString): PGString{.cdecl, dynlib: gliblib,
    importc: "g_string_down".}
proc up*(str: PGString): PGString{.cdecl, dynlib: gliblib,
    importc: "g_string_up".}
