# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEXT_TAG*(): GType =
  result = text_tag_get_type()

proc TEXT_TAG*(obj: pointer): PTextTag =
  result = cast[PTextTag](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_TEXT_TAG()))

proc TEXT_TAG_CLASS*(klass: pointer): PTextTagClass =
  result = cast[PTextTagClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_TEXT_TAG()))

proc IS_TEXT_TAG*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_TEXT_TAG())

proc IS_TEXT_TAG_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_TEXT_TAG())

proc TEXT_TAG_GET_CLASS*(obj: pointer): PTextTagClass =
  result = cast[PTextTagClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_TEXT_TAG()))

proc TYPE_TEXT_ATTRIBUTES*(): GType =
  result = text_attributes_get_type()
