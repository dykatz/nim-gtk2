# Included by headers/glib2.nim; do not import directly.
proc g_ascii_tolower*(c: gchar): gchar{.cdecl, dynlib: gliblib,
                                        importc: "g_ascii_tolower".}
proc g_ascii_toupper*(c: gchar): gchar{.cdecl, dynlib: gliblib,
                                        importc: "g_ascii_toupper".}
proc g_ascii_digit_value*(c: gchar): gint{.cdecl, dynlib: gliblib,
    importc: "g_ascii_digit_value".}
proc g_ascii_xdigit_value*(c: gchar): gint{.cdecl, dynlib: gliblib,
    importc: "g_ascii_xdigit_value".}
const
  G_STR_DELIMITERS* = "``-|> <."

proc g_strdelimit*(str: cstring, delimiters: cstring, new_delimiter: gchar): cstring{.
    cdecl, dynlib: gliblib, importc: "g_strdelimit".}
proc g_strcanon*(str: cstring, valid_chars: cstring, substitutor: gchar): cstring{.
    cdecl, dynlib: gliblib, importc: "g_strcanon".}
proc g_strerror*(errnum: gint): cstring{.cdecl, dynlib: gliblib,
    importc: "g_strerror".}
proc g_strsignal*(signum: gint): cstring{.cdecl, dynlib: gliblib,
    importc: "g_strsignal".}
proc g_strreverse*(str: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_strreverse".}
proc g_strlcpy*(dest: cstring, src: cstring, dest_size: gsize): gsize{.cdecl,
    dynlib: gliblib, importc: "g_strlcpy".}
proc g_strlcat*(dest: cstring, src: cstring, dest_size: gsize): gsize{.cdecl,
    dynlib: gliblib, importc: "g_strlcat".}
proc g_strstr_len*(haystack: cstring, haystack_len: gssize, needle: cstring): cstring{.
    cdecl, dynlib: gliblib, importc: "g_strstr_len".}
proc g_strrstr*(haystack: cstring, needle: cstring): cstring{.cdecl,
    dynlib: gliblib, importc: "g_strrstr".}
proc g_strrstr_len*(haystack: cstring, haystack_len: gssize, needle: cstring): cstring{.
    cdecl, dynlib: gliblib, importc: "g_strrstr_len".}
proc g_str_has_suffix*(str: cstring, suffix: cstring): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_str_has_suffix".}
proc g_str_has_prefix*(str: cstring, prefix: cstring): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_str_has_prefix".}
proc g_strtod*(nptr: cstring, endptr: PPgchar): gdouble{.cdecl, dynlib: gliblib,
    importc: "g_strtod".}
proc g_ascii_strtod*(nptr: cstring, endptr: PPgchar): gdouble{.cdecl,
    dynlib: gliblib, importc: "g_ascii_strtod".}
const
  G_ASCII_DTOSTR_BUF_SIZE* = 29 + 10

proc g_ascii_dtostr*(buffer: cstring, buf_len: gint, d: gdouble): cstring{.
    cdecl, dynlib: gliblib, importc: "g_ascii_dtostr".}
proc g_ascii_formatd*(buffer: cstring, buf_len: gint, format: cstring,
                      d: gdouble): cstring{.cdecl, dynlib: gliblib,
    importc: "g_ascii_formatd".}
proc g_strchug*(str: cstring): cstring{.cdecl, dynlib: gliblib,
                                        importc: "g_strchug".}
proc g_strchomp*(str: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_strchomp".}
proc g_ascii_strcasecmp*(s1: cstring, s2: cstring): gint{.cdecl,
    dynlib: gliblib, importc: "g_ascii_strcasecmp".}
proc g_ascii_strncasecmp*(s1: cstring, s2: cstring, n: gsize): gint{.cdecl,
    dynlib: gliblib, importc: "g_ascii_strncasecmp".}
proc g_ascii_strdown*(str: cstring, len: gssize): cstring{.cdecl,
    dynlib: gliblib, importc: "g_ascii_strdown".}
proc g_ascii_strup*(str: cstring, len: gssize): cstring{.cdecl, dynlib: gliblib,
    importc: "g_ascii_strup".}
proc g_strdup*(str: cstring): cstring{.cdecl, dynlib: gliblib,
                                       importc: "g_strdup".}
proc g_strndup*(str: cstring, n: gsize): cstring{.cdecl, dynlib: gliblib,
    importc: "g_strndup".}
proc g_strnfill*(length: gsize, fill_char: gchar): cstring{.cdecl,
    dynlib: gliblib, importc: "g_strnfill".}
proc g_strcompress*(source: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_strcompress".}
proc g_strescape*(source: cstring, exceptions: cstring): cstring{.cdecl,
    dynlib: gliblib, importc: "g_strescape".}
proc g_memdup*(mem: gconstpointer, byte_size: guint): gpointer{.cdecl,
    dynlib: gliblib, importc: "g_memdup".}
proc g_strsplit*(str: cstring, delimiter: cstring, max_tokens: gint): PPgchar{.
    cdecl, dynlib: gliblib, importc: "g_strsplit".}
proc g_strjoinv*(separator: cstring, str_array: PPgchar): cstring{.cdecl,
    dynlib: gliblib, importc: "g_strjoinv".}
proc g_strfreev*(str_array: PPgchar){.cdecl, dynlib: gliblib,
                                      importc: "g_strfreev".}
proc g_strdupv*(str_array: PPgchar): PPgchar{.cdecl, dynlib: gliblib,
    importc: "g_strdupv".}
proc g_stpcpy*(dest: cstring, src: cstring): cstring{.cdecl, dynlib: gliblib,
    importc: "g_stpcpy".}
