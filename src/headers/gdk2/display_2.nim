# Included by headers/gdk2.nim; do not import directly.
proc TYPE_DISPLAY*(): GType =
  discard
  #result = nil

proc DISPLAY_OBJECT*(anObject: pointer): PDisplay =
  result = cast[PDisplay](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_DISPLAY()))

proc DISPLAY_CLASS*(klass: pointer): PDisplayClass =
  result = cast[PDisplayClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_DISPLAY()))

proc IS_DISPLAY*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_DISPLAY())

proc IS_DISPLAY_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_DISPLAY())

proc DISPLAY_GET_CLASS*(obj: pointer): PDisplayClass =
  result = cast[PDisplayClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_DISPLAY()))

