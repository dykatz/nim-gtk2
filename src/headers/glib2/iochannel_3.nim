# Included by headers/glib2.nim; do not import directly.
proc TGIOChannel_use_buffer*(a: PGIOChannel): guint =
  result = (a.flag0 and bm_TGIOChannel_use_buffer) shr
      bp_TGIOChannel_use_buffer

proc TGIOChannel_set_use_buffer*(a: PGIOChannel, `use_buffer`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`use_buffer` shl bp_TGIOChannel_use_buffer) and
      bm_TGIOChannel_use_buffer)

proc TGIOChannel_do_encode*(a: PGIOChannel): guint =
  result = ((a.flag0 and bm_TGIOChannel_do_encode) shr
      bp_TGIOChannel_do_encode).guint

proc TGIOChannel_set_do_encode*(a: PGIOChannel, `do_encode`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`do_encode` shl bp_TGIOChannel_do_encode) and
      bm_TGIOChannel_do_encode)

proc TGIOChannel_close_on_unref*(a: PGIOChannel): guint =
  result = ((a.flag0 and bm_TGIOChannel_close_on_unref) shr
      bp_TGIOChannel_close_on_unref).guint

proc TGIOChannel_set_close_on_unref*(a: PGIOChannel, `close_on_unref`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`close_on_unref` shl bp_TGIOChannel_close_on_unref) and
      bm_TGIOChannel_close_on_unref)

proc TGIOChannel_is_readable*(a: PGIOChannel): guint =
  result = ((a.flag0 and bm_TGIOChannel_is_readable) shr
      bp_TGIOChannel_is_readable).guint

proc TGIOChannel_set_is_readable*(a: PGIOChannel, `is_readable`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_readable` shl bp_TGIOChannel_is_readable) and
      bm_TGIOChannel_is_readable)

proc TGIOChannel_is_writeable*(a: PGIOChannel): guint =
  result = ((a.flag0 and bm_TGIOChannel_is_writeable) shr
      bp_TGIOChannel_is_writeable).guint

proc TGIOChannel_set_is_writeable*(a: PGIOChannel, `is_writeable`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_writeable` shl bp_TGIOChannel_is_writeable) and
      bm_TGIOChannel_is_writeable)

proc TGIOChannel_is_seekable*(a: PGIOChannel): guint =
  result = ((a.flag0 and bm_TGIOChannel_is_seekable) shr
      bp_TGIOChannel_is_seekable).guint

proc TGIOChannel_set_is_seekable*(a: PGIOChannel, `is_seekable`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_seekable` shl bp_TGIOChannel_is_seekable) and
      bm_TGIOChannel_is_seekable)

proc utf8_next_char*(p: Pguchar): Pguchar =
  result = cast[Pguchar](cast[uint](p) + 1'u) # p + ord((g_utf8_skip + p[] )[] )

