# Included by headers/gdk2.nim; do not import directly.
proc TYPE_GC*(): GType =
  result = gc_get_type()

proc GC*(anObject: pointer): PGC =
  result = cast[PGC](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_GC()))

proc GC_CLASS*(klass: pointer): PGCClass =
  result = cast[PGCClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_GC()))

proc IS_GC*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_GC())

proc IS_GC_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_GC())

proc GC_GET_CLASS*(obj: pointer): PGCClass =
  result = cast[PGCClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_GC()))

proc destroy*(gc: PGC) =
  g_object_unref(G_OBJECT(gc))

