# Included by headers/atk.nim; do not import directly.
proc TYPE_GOBJECT_ACCESSIBLE*(): GType =
  result = gobject_accessible_get_type()

proc GOBJECT_ACCESSIBLE*(obj: pointer): PGObjectAccessible =
  result = cast[PGObjectAccessible](G_TYPE_CHECK_INSTANCE_CAST(obj,
      TYPE_GOBJECT_ACCESSIBLE()))

proc GOBJECT_ACCESSIBLE_CLASS*(klass: pointer): PGObjectAccessibleClass =
  result = cast[PGObjectAccessibleClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_GOBJECT_ACCESSIBLE()))

proc IS_GOBJECT_ACCESSIBLE*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_GOBJECT_ACCESSIBLE())

proc IS_GOBJECT_ACCESSIBLE_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_GOBJECT_ACCESSIBLE())

proc GOBJECT_ACCESSIBLE_GET_CLASS*(obj: pointer): PGObjectAccessibleClass =
  result = cast[PGObjectAccessibleClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_GOBJECT_ACCESSIBLE()))

