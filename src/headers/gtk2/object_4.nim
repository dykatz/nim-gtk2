# Included by headers/gtk2.nim; do not import directly.
proc TYPE_OBJECT*(): GType =
  result = gtk2.object_get_type()

proc CHECK_CAST*(instance: pointer, g_type: GType): PGTypeInstance =
  result = G_TYPE_CHECK_INSTANCE_CAST(instance, g_type)

proc CHECK_CLASS_CAST*(g_class: pointer, g_type: GType): pointer =
  result = G_TYPE_CHECK_CLASS_CAST(g_class, g_type)

proc CHECK_GET_CLASS*(instance: pointer, g_type: GType): PGTypeClass =
  result = G_TYPE_INSTANCE_GET_CLASS(instance, g_type)

proc CHECK_TYPE*(instance: pointer, g_type: GType): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(instance, g_type)

proc CHECK_CLASS_TYPE*(g_class: pointer, g_type: GType): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(g_class, g_type)

proc `OBJECT`*(anObject: pointer): PObject =
  result = cast[PObject](CHECK_CAST(anObject, gtk2.TYPE_OBJECT()))

proc OBJECT_CLASS*(klass: pointer): PObjectClass =
  result = cast[PObjectClass](CHECK_CLASS_CAST(klass, gtk2.TYPE_OBJECT()))

proc IS_OBJECT*(anObject: pointer): bool =
  result = CHECK_TYPE(anObject, gtk2.TYPE_OBJECT())

proc IS_OBJECT_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, gtk2.TYPE_OBJECT())

proc OBJECT_GET_CLASS*(anObject: pointer): PObjectClass =
  result = cast[PObjectClass](CHECK_GET_CLASS(anObject, gtk2.TYPE_OBJECT()))

proc OBJECT_TYPE*(anObject: pointer): GType =
  result = G_TYPE_FROM_INSTANCE(anObject)

proc OBJECT_TYPE_NAME*(anObject: pointer): cstring =
  result = g_type_name(OBJECT_TYPE(anObject))

proc OBJECT_FLAGS*(obj: pointer): guint32 =
  result = (gtk2.`OBJECT`(obj)).flags

proc OBJECT_FLOATING*(obj: pointer): gboolean =
  result = ((OBJECT_FLAGS(obj)) and guint32(FLOATING)) != 0'u32

proc OBJECT_SET_FLAGS*(obj: pointer, flag: guint32) =
  gtk2.`OBJECT`(obj).flags = gtk2.`OBJECT`(obj).flags or flag

proc OBJECT_UNSET_FLAGS*(obj: pointer, flag: guint32) =
  gtk2.`OBJECT`(obj).flags = gtk2.`OBJECT`(obj).flags and not (flag)

