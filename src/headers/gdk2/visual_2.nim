# Included by headers/gdk2.nim; do not import directly.
proc TYPE_VISUAL*(): GType =
  result = visual_get_type()

proc VISUAL*(anObject: pointer): PVisual =
  result = cast[PVisual](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_VISUAL()))

proc VISUAL_CLASS*(klass: pointer): PVisualClass =
  result = cast[PVisualClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_VISUAL()))

proc IS_VISUAL*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_VISUAL())

proc IS_VISUAL_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_VISUAL())

proc VISUAL_GET_CLASS*(obj: pointer): PVisualClass =
  result = cast[PVisualClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_VISUAL()))

proc reference*(v: PVisual) =
  discard g_object_ref(v)

proc unref*(v: PVisual) =
  g_object_unref(v)

