# Included by headers/atk.nim; do not import directly.
proc TYPE_RELATION*(): GType =
  result = relation_get_type()

proc RELATION*(obj: pointer): PRelation =
  result = cast[PRelation](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_RELATION()))

proc RELATION_CLASS*(klass: pointer): PRelationClass =
  result = cast[PRelationClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_RELATION()))

proc IS_RELATION*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_RELATION())

proc IS_RELATION_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_RELATION())

proc RELATION_GET_CLASS*(obj: pointer): PRelationClass =
  result = cast[PRelationClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_RELATION()))

