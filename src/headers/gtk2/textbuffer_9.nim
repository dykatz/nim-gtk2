# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEXT_BUFFER*(): GType =
  result = text_buffer_get_type()

proc TEXT_BUFFER*(obj: pointer): PTextBuffer =
  result = cast[PTextBuffer](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_TEXT_BUFFER()))

proc TEXT_BUFFER_CLASS*(klass: pointer): PTextBufferClass =
  result = cast[PTextBufferClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_TEXT_BUFFER()))

proc IS_TEXT_BUFFER*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_TEXT_BUFFER())

proc IS_TEXT_BUFFER_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_TEXT_BUFFER())

proc TEXT_BUFFER_GET_CLASS*(obj: pointer): PTextBufferClass =
  result = cast[PTextBufferClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_TEXT_BUFFER()))

proc modified*(a: PTextBuffer): guint =
  result = (a.TextBufferflag0 and bm_TGtkTextBuffer_modified) shr
      bp_TGtkTextBuffer_modified

proc set_modified*(a: PTextBuffer, `modified`: guint) =
  a.TextBufferflag0 = a.TextBufferflag0 or
      (uint16(`modified` shl bp_TGtkTextBuffer_modified) and
      bm_TGtkTextBuffer_modified)

