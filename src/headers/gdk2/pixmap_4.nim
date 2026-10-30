# Included by headers/gdk2.nim; do not import directly.
proc PIXMAP_CLASS*(klass: pointer): PPixmapObjectClass =
  result = cast[PPixmapObjectClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_PIXMAP()))

proc IS_PIXMAP*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_PIXMAP())

proc IS_PIXMAP_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_PIXMAP())

proc PIXMAP_GET_CLASS*(obj: pointer): PPixmapObjectClass =
  result = cast[PPixmapObjectClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_PIXMAP()))

proc PIXMAP_OBJECT*(anObject: pointer): PPixmapObject =
  result = cast[PPixmapObject](PIXMAP(anObject))

