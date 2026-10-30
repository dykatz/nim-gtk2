# Included by headers/glib2.nim; do not import directly.
proc g_iconv_open*(to_codeset: cstring, from_codeset: cstring): TGIConv{.cdecl,
    dynlib: gliblib, importc: "g_iconv_open".}
proc g_iconv*(`converter`: TGIConv, inbuf: PPgchar, inbytes_left: Pgsize,
              outbuf: PPgchar, outbytes_left: Pgsize): gsize{.cdecl,
    dynlib: gliblib, importc: "g_iconv".}
proc g_iconv_close*(`converter`: TGIConv): gint{.cdecl, dynlib: gliblib,
    importc: "g_iconv_close".}
proc g_convert*(str: cstring, len: gssize, to_codeset: cstring,
                from_codeset: cstring, bytes_read: Pgsize,
                bytes_written: Pgsize, error: pointer): cstring{.cdecl,
    dynlib: gliblib, importc: "g_convert".}
proc g_convert*(str: cstring, len: gssize, `converter`: TGIConv,
                           bytes_read: Pgsize, bytes_written: Pgsize,
                           error: pointer): cstring{.cdecl, dynlib: gliblib,
    importc: "g_convert_with_iconv".}
proc g_convert*(str: cstring, len: gssize, to_codeset: cstring,
                              from_codeset: cstring, fallback: cstring,
                              bytes_read: Pgsize, bytes_written: Pgsize,
                              error: pointer): cstring{.cdecl, dynlib: gliblib,
    importc: "g_convert_with_fallback".}
proc g_locale_to_utf8*(opsysstring: cstring, len: gssize, bytes_read: Pgsize,
                       bytes_written: Pgsize, error: pointer): cstring{.cdecl,
    dynlib: gliblib, importc: "g_locale_to_utf8".}
proc g_locale_from_utf8*(utf8string: cstring, len: gssize, bytes_read: Pgsize,
                         bytes_written: Pgsize, error: pointer): cstring{.cdecl,
    dynlib: gliblib, importc: "g_locale_from_utf8".}
proc g_filename_to_utf8*(opsysstring: cstring, len: gssize, bytes_read: Pgsize,
                         bytes_written: Pgsize, error: pointer): cstring{.cdecl,
    dynlib: gliblib, importc: "g_filename_to_utf8".}
proc g_filename_from_utf8*(utf8string: cstring, len: gssize, bytes_read: Pgsize,
                           bytes_written: Pgsize, error: pointer): cstring{.
    cdecl, dynlib: gliblib, importc: "g_filename_from_utf8".}
proc g_filename_from_uri*(uri: cstring, hostname: PPchar, error: pointer): cstring{.
    cdecl, dynlib: gliblib, importc: "g_filename_from_uri".}
proc g_filename_to_uri*(filename: cstring, hostname: cstring, error: pointer): cstring{.
    cdecl, dynlib: gliblib, importc: "g_filename_to_uri".}
