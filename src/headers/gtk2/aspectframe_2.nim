# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ASPECT_FRAME*(): GType =
  result = aspect_frame_get_type()

proc ASPECT_FRAME*(obj: pointer): PAspectFrame =
  result = cast[PAspectFrame](CHECK_CAST(obj, TYPE_ASPECT_FRAME()))

proc ASPECT_FRAME_CLASS*(klass: pointer): PAspectFrameClass =
  result = cast[PAspectFrameClass](CHECK_CLASS_CAST(klass, TYPE_ASPECT_FRAME()))

proc IS_ASPECT_FRAME*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_ASPECT_FRAME())

proc IS_ASPECT_FRAME_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_ASPECT_FRAME())

proc ASPECT_FRAME_GET_CLASS*(obj: pointer): PAspectFrameClass =
  result = cast[PAspectFrameClass](CHECK_GET_CLASS(obj, TYPE_ASPECT_FRAME()))

