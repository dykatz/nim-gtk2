# Included by headers/pango.nim; do not import directly.
proc CONTEXT*(anObject: pointer): PContext =
  result = cast[PContext](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_CONTEXT()))

