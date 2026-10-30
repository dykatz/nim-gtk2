# Included by headers/pango.nim; do not import directly.
proc LAYOUT*(anObject: pointer): PLayout =
  result = cast[PLayout](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_LAYOUT()))

proc LAYOUT_CLASS*(klass: pointer): PLayoutClass =
  result = cast[PLayoutClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_LAYOUT()))

proc IS_LAYOUT*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_LAYOUT())

proc IS_LAYOUT_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_LAYOUT())

proc GET_CLASS*(obj: PLayout): PLayoutClass =
  result = cast[PLayoutClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_LAYOUT()))

proc TYPE_TAB_ARRAY*(): GType =
  result = tab_array_get_type()

