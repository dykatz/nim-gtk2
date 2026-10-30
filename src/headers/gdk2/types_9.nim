# Included by headers/gdk2.nim; do not import directly.
proc WINDOW*(anObject: pointer): PWindow =
  result = cast[PWindow](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_WINDOW()))

