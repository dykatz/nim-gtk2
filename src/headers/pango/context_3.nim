# Included by headers/pango.nim; do not import directly.
proc CONTEXT_CLASS*(klass: pointer): PContextClass =
  result = cast[PContextClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_CONTEXT()))

proc IS_CONTEXT*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_CONTEXT())

proc IS_CONTEXT_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_CONTEXT())

