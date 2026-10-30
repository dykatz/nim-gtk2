# Included by headers/gtk2.nim; do not import directly.
proc TYPE_FRAME*(): GType =
  result = frame_get_type()

proc FRAME*(obj: pointer): PFrame =
  result = cast[PFrame](CHECK_CAST(obj, TYPE_FRAME()))

proc FRAME_CLASS*(klass: pointer): PFrameClass =
  result = cast[PFrameClass](CHECK_CLASS_CAST(klass, TYPE_FRAME()))

proc IS_FRAME*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_FRAME())

proc IS_FRAME_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_FRAME())

proc FRAME_GET_CLASS*(obj: pointer): PFrameClass =
  result = cast[PFrameClass](CHECK_GET_CLASS(obj, TYPE_FRAME()))

