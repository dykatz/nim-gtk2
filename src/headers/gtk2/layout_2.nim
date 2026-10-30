# Included by headers/gtk2.nim; do not import directly.
proc TYPE_LAYOUT*(): GType =
  result = gtk2.layout_get_type()

proc LAYOUT*(obj: pointer): PLayout =
  result = cast[PLayout](CHECK_CAST(obj, gtk2.TYPE_LAYOUT()))

proc LAYOUT_CLASS*(klass: pointer): PLayoutClass =
  result = cast[PLayoutClass](CHECK_CLASS_CAST(klass, gtk2.TYPE_LAYOUT()))

proc IS_LAYOUT*(obj: pointer): bool =
  result = CHECK_TYPE(obj, gtk2.TYPE_LAYOUT())

proc IS_LAYOUT_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, gtk2.TYPE_LAYOUT())

proc LAYOUT_GET_CLASS*(obj: pointer): PLayoutClass =
  result = cast[PLayoutClass](CHECK_GET_CLASS(obj, gtk2.TYPE_LAYOUT()))

