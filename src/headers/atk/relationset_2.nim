# Included by headers/atk.nim; do not import directly.
proc TYPE_RELATION_SET*(): GType =
  result = relation_set_get_type()

proc RELATION_SET*(obj: pointer): PRelationSet =
  result = cast[PRelationSet](G_TYPE_CHECK_INSTANCE_CAST(obj,
      TYPE_RELATION_SET()))

proc RELATION_SET_CLASS*(klass: pointer): PRelationSetClass =
  result = cast[PRelationSetClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_RELATION_SET()))

proc IS_RELATION_SET*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_RELATION_SET())

proc IS_RELATION_SET_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_RELATION_SET())

proc RELATION_SET_GET_CLASS*(obj: pointer): PRelationSetClass =
  result = cast[PRelationSetClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_RELATION_SET()))

