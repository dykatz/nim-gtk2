# Included by headers/atk.nim; do not import directly.
proc TYPE_OBJECT_FACTORY*(): GType =
  result = object_factory_get_type()

proc OBJECT_FACTORY*(obj: pointer): PObjectFactory =
  result = cast[PObjectFactory](G_TYPE_CHECK_INSTANCE_CAST(obj,
      TYPE_OBJECT_FACTORY()))

proc OBJECT_FACTORY_CLASS*(klass: pointer): PObjectFactoryClass =
  result = cast[PObjectFactoryClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_OBJECT_FACTORY()))

proc IS_OBJECT_FACTORY*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_OBJECT_FACTORY())

proc IS_OBJECT_FACTORY_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_OBJECT_FACTORY())

proc OBJECT_FACTORY_GET_CLASS*(obj: pointer): PObjectFactoryClass =
  result = cast[PObjectFactoryClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_OBJECT_FACTORY()))

