# Included by headers/glib2.nim; do not import directly.
proc g_unichar_isalnum*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_isalnum".}
proc g_unichar_isalpha*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_isalpha".}
proc g_unichar_iscntrl*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_iscntrl".}
proc g_unichar_isdigit*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_isdigit".}
proc g_unichar_isgraph*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_isgraph".}
proc g_unichar_islower*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_islower".}
proc g_unichar_isprint*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_isprint".}
proc g_unichar_ispunct*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_ispunct".}
proc g_unichar_isspace*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_isspace".}
proc g_unichar_isupper*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_isupper".}
proc g_unichar_isxdigit*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_isxdigit".}
proc g_unichar_istitle*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_istitle".}
proc g_unichar_isdefined*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_isdefined".}
proc g_unichar_iswide*(c: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_iswide".}
proc g_unichar_toupper*(c: gunichar): gunichar{.cdecl, dynlib: gliblib,
    importc: "g_unichar_toupper".}
proc g_unichar_tolower*(c: gunichar): gunichar{.cdecl, dynlib: gliblib,
    importc: "g_unichar_tolower".}
proc g_unichar_totitle*(c: gunichar): gunichar{.cdecl, dynlib: gliblib,
    importc: "g_unichar_totitle".}
proc g_unichar_digit_value*(c: gunichar): gint{.cdecl, dynlib: gliblib,
    importc: "g_unichar_digit_value".}
proc g_unichar_xdigit_value*(c: gunichar): gint{.cdecl, dynlib: gliblib,
    importc: "g_unichar_xdigit_value".}
proc g_unichar_type*(c: gunichar): TGUnicodeType{.cdecl, dynlib: gliblib,
    importc: "g_unichar_type".}
proc g_unichar_break_type*(c: gunichar): TGUnicodeBreakType{.cdecl,
    dynlib: gliblib, importc: "g_unichar_break_type".}
proc unicode_canonical_ordering*(str: Pgunichar, len: gsize){.cdecl,
    dynlib: gliblib, importc: "g_unicode_canonical_ordering".}
proc g_unicode_canonical_decomposition*(ch: gunichar, result_len: Pgsize): Pgunichar{.
    cdecl, dynlib: gliblib, importc: "g_unicode_canonical_decomposition".}
proc utf8_next_char*(p: Pguchar): Pguchar
proc g_utf8_get_char*(p: cstring): gunichar{.cdecl, dynlib: gliblib,
    importc: "g_utf8_get_char".}
proc g_utf8_get_char_validated*(p: cstring, max_len: gssize): gunichar{.cdecl,
    dynlib: gliblib, importc: "g_utf8_get_char_validated".}
proc g_utf8_offset_to_pointer*(str: cstring, offset: glong): cstring{.cdecl,
    dynlib: gliblib, importc: "g_utf8_offset_to_pointer".}
proc g_utf8_pointer_to_offset*(str: cstring, pos: cstring): glong{.cdecl,
    dynlib: gliblib, importc: "g_utf8_pointer_to_offset".}
proc g_utf8_prev_char*(p: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_utf8_prev_char".}
proc g_utf8_find_next_char*(p: cstring, `end`: cstring): cstring{.cdecl,
    dynlib: gliblib, importc: "g_utf8_find_next_char".}
proc g_utf8_find_prev_char*(str: cstring, p: cstring): cstring{.cdecl,
    dynlib: gliblib, importc: "g_utf8_find_prev_char".}
proc g_utf8_strlen*(p: cstring, max: gssize): glong{.cdecl, dynlib: gliblib,
    importc: "g_utf8_strlen".}
proc g_utf8_strncpy*(dest: cstring, src: cstring, n: gsize): cstring{.cdecl,
    dynlib: gliblib, importc: "g_utf8_strncpy".}
proc g_utf8_strchr*(p: cstring, len: gssize, c: gunichar): cstring{.cdecl,
    dynlib: gliblib, importc: "g_utf8_strchr".}
proc g_utf8_strrchr*(p: cstring, len: gssize, c: gunichar): cstring{.cdecl,
    dynlib: gliblib, importc: "g_utf8_strrchr".}
proc g_utf8_to_utf16*(str: cstring, len: glong, items_read: Pglong,
                      items_written: Pglong, error: pointer): Pgunichar2{.cdecl,
    dynlib: gliblib, importc: "g_utf8_to_utf16".}
proc g_utf8_to_ucs4*(str: cstring, len: glong, items_read: Pglong,
                     items_written: Pglong, error: pointer): Pgunichar{.cdecl,
    dynlib: gliblib, importc: "g_utf8_to_ucs4".}
proc g_utf8_to_ucs4_fast*(str: cstring, len: glong, items_written: Pglong): Pgunichar{.
    cdecl, dynlib: gliblib, importc: "g_utf8_to_ucs4_fast".}
proc utf16_to_ucs4*(str: Pgunichar2, len: glong, items_read: Pglong,
                      items_written: Pglong, error: pointer): Pgunichar{.cdecl,
    dynlib: gliblib, importc: "g_utf16_to_ucs4".}
proc utf16_to_utf8*(str: Pgunichar2, len: glong, items_read: Pglong,
                      items_written: Pglong, error: pointer): cstring{.cdecl,
    dynlib: gliblib, importc: "g_utf16_to_utf8".}
proc ucs4_to_utf16*(str: Pgunichar, len: glong, items_read: Pglong,
                      items_written: Pglong, error: pointer): Pgunichar2{.cdecl,
    dynlib: gliblib, importc: "g_ucs4_to_utf16".}
proc ucs4_to_utf8*(str: Pgunichar, len: glong, items_read: Pglong,
                     items_written: Pglong, error: pointer): cstring{.cdecl,
    dynlib: gliblib, importc: "g_ucs4_to_utf8".}
proc g_unichar_to_utf8*(c: gunichar, outbuf: cstring): gint{.cdecl,
    dynlib: gliblib, importc: "g_unichar_to_utf8".}
proc g_utf8_validate*(str: cstring, max_len: gssize, `end`: PPgchar): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_utf8_validate".}
proc g_unichar_validate*(ch: gunichar): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_unichar_validate".}
proc g_utf8_strup*(str: cstring, len: gssize): cstring{.cdecl, dynlib: gliblib,
    importc: "g_utf8_strup".}
proc g_utf8_strdown*(str: cstring, len: gssize): cstring{.cdecl,
    dynlib: gliblib, importc: "g_utf8_strdown".}
proc g_utf8_casefold*(str: cstring, len: gssize): cstring{.cdecl,
    dynlib: gliblib, importc: "g_utf8_casefold".}
