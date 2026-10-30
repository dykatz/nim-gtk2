# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEXT_TAG_TABLE*(): GType =
  result = text_tag_table_get_type()

proc TEXT_TAG_TABLE*(obj: pointer): PTextTagTable =
  result = cast[PTextTagTable](G_TYPE_CHECK_INSTANCE_CAST(obj,
      TYPE_TEXT_TAG_TABLE()))

proc TEXT_TAG_TABLE_CLASS*(klass: pointer): PTextTagTableClass =
  result = cast[PTextTagTableClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_TEXT_TAG_TABLE()))

proc IS_TEXT_TAG_TABLE*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_TEXT_TAG_TABLE())

proc IS_TEXT_TAG_TABLE_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_TEXT_TAG_TABLE())

proc TEXT_TAG_TABLE_GET_CLASS*(obj: pointer): PTextTagTableClass =
  result = cast[PTextTagTableClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_TEXT_TAG_TABLE()))

