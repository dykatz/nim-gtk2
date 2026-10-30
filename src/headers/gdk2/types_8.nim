# Included by headers/gdk2.nim; do not import directly.
proc PIXMAP*(anObject: pointer): PPixmap =
  result = cast[PPixmap](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_PIXMAP()))

