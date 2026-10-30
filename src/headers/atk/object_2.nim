# Included by headers/atk.nim; do not import directly.
proc TYPE_OBJECT*(): GType =
  result = object_get_type()

proc `OBJECT`*(obj: pointer): PObject =
  result = cast[PObject](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_OBJECT()))

proc OBJECT_CLASS*(klass: pointer): PObjectClass =
  result = cast[PObjectClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_OBJECT()))

proc IS_OBJECT*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_OBJECT())

proc IS_OBJECT_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_OBJECT())

proc OBJECT_GET_CLASS*(obj: pointer): PObjectClass =
  result = cast[PObjectClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_OBJECT()))

proc TYPE_IMPLEMENTOR*(): GType =
  result = implementor_get_type()

proc IS_IMPLEMENTOR*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_IMPLEMENTOR())

proc IMPLEMENTOR*(obj: pointer): PImplementor =
  result = PImplementor(G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_IMPLEMENTOR()))

proc IMPLEMENTOR_GET_IFACE*(obj: pointer): PImplementorIface =
  result = cast[PImplementorIface](G_TYPE_INSTANCE_GET_INTERFACE(obj,
      TYPE_IMPLEMENTOR()))

