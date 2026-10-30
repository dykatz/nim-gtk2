# Included by headers/glib2.nim; do not import directly.
proc TGIOChannel_use_buffer*(a: PGIOChannel): guint
proc TGIOChannel_set_use_buffer*(a: PGIOChannel, `use_buffer`: guint)
proc TGIOChannel_do_encode*(a: PGIOChannel): guint
proc TGIOChannel_set_do_encode*(a: PGIOChannel, `do_encode`: guint)
proc TGIOChannel_close_on_unref*(a: PGIOChannel): guint
proc TGIOChannel_set_close_on_unref*(a: PGIOChannel, `close_on_unref`: guint)
proc TGIOChannel_is_readable*(a: PGIOChannel): guint
proc TGIOChannel_set_is_readable*(a: PGIOChannel, `is_readable`: guint)
proc TGIOChannel_is_writeable*(a: PGIOChannel): guint
proc TGIOChannel_set_is_writeable*(a: PGIOChannel, `is_writeable`: guint)
proc TGIOChannel_is_seekable*(a: PGIOChannel): guint
proc TGIOChannel_set_is_seekable*(a: PGIOChannel, `is_seekable`: guint)
proc channel_init*(channel: PGIOChannel){.cdecl, dynlib: gliblib,
    importc: "g_io_channel_init".}
proc channel_ref*(channel: PGIOChannel){.cdecl, dynlib: gliblib,
    importc: "g_io_channel_ref".}
proc channel_unref*(channel: PGIOChannel){.cdecl, dynlib: gliblib,
    importc: "g_io_channel_unref".}
proc channel_read*(channel: PGIOChannel, buf: cstring, count: gsize,
                        bytes_read: Pgsize): TGIOError{.cdecl, dynlib: gliblib,
    importc: "g_io_channel_read".}
proc channel_write*(channel: PGIOChannel, buf: cstring, count: gsize,
                         bytes_written: Pgsize): TGIOError{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_write".}
proc channel_seek*(channel: PGIOChannel, offset: gint64,
                        theType: TGSeekType): TGIOError{.cdecl, dynlib: gliblib,
    importc: "g_io_channel_seek".}
proc channel_close*(channel: PGIOChannel){.cdecl, dynlib: gliblib,
    importc: "g_io_channel_close".}
proc channel_shutdown*(channel: PGIOChannel, flush: gboolean, err: pointer): TGIOStatus{.
    cdecl, dynlib: gliblib, importc: "g_io_channel_shutdown".}
proc add_watch_full*(channel: PGIOChannel, priority: gint,
                          condition: TGIOCondition, fn: TGIOFunc,
                          user_data: gpointer, notify: TGDestroyNotify): guint{.
    cdecl, dynlib: gliblib, importc: "g_io_add_watch_full".}
proc create_watch*(channel: PGIOChannel, condition: TGIOCondition): PGSource{.
    cdecl, dynlib: gliblib, importc: "g_io_create_watch".}
proc add_watch*(channel: PGIOChannel, condition: TGIOCondition,
                     fn: TGIOFunc, user_data: gpointer): guint{.cdecl,
    dynlib: gliblib, importc: "g_io_add_watch".}
proc channel_set_buffer_size*(channel: PGIOChannel, size: gsize){.cdecl,
    dynlib: gliblib, importc: "g_io_channel_set_buffer_size".}
proc channel_get_buffer_size*(channel: PGIOChannel): gsize{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_get_buffer_size".}
proc channel_get_buffer_condition*(channel: PGIOChannel): TGIOCondition{.
    cdecl, dynlib: gliblib, importc: "g_io_channel_get_buffer_condition".}
proc channel_set_flags*(channel: PGIOChannel, flags: TGIOFlags,
                             error: pointer): TGIOStatus{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_set_flags".}
proc channel_get_flags*(channel: PGIOChannel): TGIOFlags{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_get_flags".}
proc channel_set_line_term*(channel: PGIOChannel, line_term: cstring,
                                 length: gint){.cdecl, dynlib: gliblib,
    importc: "g_io_channel_set_line_term".}
proc channel_get_line_term*(channel: PGIOChannel, length: Pgint): cstring{.
    cdecl, dynlib: gliblib, importc: "g_io_channel_get_line_term".}
proc channel_set_buffered*(channel: PGIOChannel, buffered: gboolean){.
    cdecl, dynlib: gliblib, importc: "g_io_channel_set_buffered".}
proc channel_get_buffered*(channel: PGIOChannel): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_get_buffered".}
proc channel_set_encoding*(channel: PGIOChannel, encoding: cstring,
                                error: pointer): TGIOStatus{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_set_encoding".}
proc channel_get_encoding*(channel: PGIOChannel): cstring{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_get_encoding".}
proc channel_set_close_on_unref*(channel: PGIOChannel, do_close: gboolean){.
    cdecl, dynlib: gliblib, importc: "g_io_channel_set_close_on_unref".}
proc channel_get_close_on_unref*(channel: PGIOChannel): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_get_close_on_unref".}
proc channel_flush*(channel: PGIOChannel, error: pointer): TGIOStatus{.
    cdecl, dynlib: gliblib, importc: "g_io_channel_flush".}
proc channel_read_line*(channel: PGIOChannel, str_return: PPgchar,
                             length: Pgsize, terminator_pos: Pgsize,
                             error: pointer): TGIOStatus{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_read_line".}
proc channel_read_line_string*(channel: PGIOChannel, buffer: PGString,
                                    terminator_pos: Pgsize, error: pointer): TGIOStatus{.
    cdecl, dynlib: gliblib, importc: "g_io_channel_read_line_string".}
proc channel_read_to_end*(channel: PGIOChannel, str_return: PPgchar,
                               length: Pgsize, error: pointer): TGIOStatus{.
    cdecl, dynlib: gliblib, importc: "g_io_channel_read_to_end".}
proc channel_read_chars*(channel: PGIOChannel, buf: cstring, count: gsize,
                              bytes_read: Pgsize, error: pointer): TGIOStatus{.
    cdecl, dynlib: gliblib, importc: "g_io_channel_read_chars".}
proc channel_read_unichar*(channel: PGIOChannel, thechar: Pgunichar,
                                error: pointer): TGIOStatus{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_read_unichar".}
proc channel_write_chars*(channel: PGIOChannel, buf: cstring,
                               count: gssize, bytes_written: Pgsize,
                               error: pointer): TGIOStatus{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_write_chars".}
proc channel_write_unichar*(channel: PGIOChannel, thechar: gunichar,
                                 error: pointer): TGIOStatus{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_write_unichar".}
proc channel_seek_position*(channel: PGIOChannel, offset: gint64,
                                 theType: TGSeekType, error: pointer): TGIOStatus{.
    cdecl, dynlib: gliblib, importc: "g_io_channel_seek_position".}
proc g_io_channel_new_file*(filename: cstring, mode: cstring, error: pointer): PGIOChannel{.
    cdecl, dynlib: gliblib, importc: "g_io_channel_new_file".}
proc g_io_channel_error_quark*(): TGQuark{.cdecl, dynlib: gliblib,
    importc: "g_io_channel_error_quark".}
proc g_io_channel_error_from_errno*(en: gint): TGIOChannelError{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_error_from_errno".}
proc g_io_channel_unix_new*(fd: int32): PGIOChannel{.cdecl, dynlib: gliblib,
    importc: "g_io_channel_unix_new".}
proc channel_unix_get_fd*(channel: PGIOChannel): gint{.cdecl,
    dynlib: gliblib, importc: "g_io_channel_unix_get_fd".}
const
  G_LOG_LEVEL_USER_SHIFT* = 8

