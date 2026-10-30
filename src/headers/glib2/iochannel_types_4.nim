# Included by headers/glib2.nim; do not import directly.
type
  PGIOChannel* = ptr TGIOChannel
  PGIOFuncs* = ptr TGIOFuncs
  TGIOFuncs*{.final.} = object
    io_read*: proc (channel: PGIOChannel, buf: cstring, count: gsize,
                    bytes_read: Pgsize, err: pointer): TGIOStatus{.cdecl.}
    io_write*: proc (channel: PGIOChannel, buf: cstring, count: gsize,
                     bytes_written: Pgsize, err: pointer): TGIOStatus{.cdecl.}
    io_seek*: proc (channel: PGIOChannel, offset: gint64, theType: TGSeekType,
                    err: pointer): TGIOStatus{.cdecl.}
    io_close*: proc (channel: PGIOChannel, err: pointer): TGIOStatus{.cdecl.}
    io_create_watch*: proc (channel: PGIOChannel, condition: TGIOCondition): PGSource{.
        cdecl.}
    io_free*: proc (channel: PGIOChannel){.cdecl.}
    io_set_flags*: proc (channel: PGIOChannel, flags: TGIOFlags, err: pointer): TGIOStatus{.
        cdecl.}
    io_get_flags*: proc (channel: PGIOChannel): TGIOFlags{.cdecl.}

  TGIOChannel*{.final.} = object
    ref_count*: guint
    funcs*: PGIOFuncs
    encoding*: cstring
    read_cd*: TGIConv
    write_cd*: TGIConv
    line_term*: cstring
    line_term_len*: guint
    buf_size*: gsize
    read_buf*: PGString
    encoded_read_buf*: PGString
    write_buf*: PGString
    partial_write_buf*: array[0..5, gchar]
    flag0*: guint16
    reserved1*: gpointer
    reserved2*: gpointer


