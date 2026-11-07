# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEXT_MARK*(): GType =
  result = text_mark_get_type()

proc TEXT_MARK*(anObject: pointer): PTextMark =
  result = cast[PTextMark](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_TEXT_MARK()))

proc TEXT_MARK_CLASS*(klass: pointer): PTextMarkClass =
  result = cast[PTextMarkClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_TEXT_MARK()))

proc IS_TEXT_MARK*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_TEXT_MARK())

proc IS_TEXT_MARK_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_TEXT_MARK())

proc TEXT_MARK_GET_CLASS*(obj: pointer): PTextMarkClass =
  result = cast[PTextMarkClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_TEXT_MARK()))

proc TYPE_TEXT_CHILD_ANCHOR*(): GType =
  result = text_child_anchor_get_type()

