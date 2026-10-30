# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ACCEL_GROUP*(): GType =
  result = accel_group_get_type()

proc ACCEL_GROUP*(anObject: pointer): PAccelGroup =
  result = cast[PAccelGroup](G_TYPE_CHECK_INSTANCE_CAST(anObject,
      TYPE_ACCEL_GROUP()))

proc ACCEL_GROUP_CLASS*(klass: pointer): PAccelGroupClass =
  result = cast[PAccelGroupClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_ACCEL_GROUP()))

proc IS_ACCEL_GROUP*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_ACCEL_GROUP())

proc IS_ACCEL_GROUP_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_ACCEL_GROUP())

proc ACCEL_GROUP_GET_CLASS*(obj: pointer): PAccelGroupClass =
  result = cast[PAccelGroupClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_ACCEL_GROUP()))

proc accel_flags*(a: PAccelKey): guint =
  result = (a.flag0 and bm_TGtkAccelKey_accel_flags) shr
      bp_TGtkAccelKey_accel_flags

proc set_accel_flags*(a: PAccelKey, `accel_flags`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`accel_flags` shl bp_TGtkAccelKey_accel_flags) and
      bm_TGtkAccelKey_accel_flags)

proc reference*(AccelGroup: PAccelGroup) =
  discard g_object_ref(AccelGroup)

proc unref*(AccelGroup: PAccelGroup) =
  g_object_unref(AccelGroup)

