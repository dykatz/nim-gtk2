# Included by headers/gtk2.nim; do not import directly.
proc TEXT_CHILD_ANCHOR*(anObject: pointer): PTextChildAnchor =
  result = cast[PTextChildAnchor](G_TYPE_CHECK_INSTANCE_CAST(anObject,
      TYPE_TEXT_CHILD_ANCHOR()))

proc TEXT_CHILD_ANCHOR_CLASS*(klass: pointer): PTextChildAnchorClass =
  result = cast[PTextChildAnchorClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_TEXT_CHILD_ANCHOR()))

proc IS_TEXT_CHILD_ANCHOR*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_TEXT_CHILD_ANCHOR())

proc IS_TEXT_CHILD_ANCHOR_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_TEXT_CHILD_ANCHOR())

proc TEXT_CHILD_ANCHOR_GET_CLASS*(obj: pointer): PTextChildAnchorClass =
  result = cast[PTextChildAnchorClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_TEXT_CHILD_ANCHOR()))

