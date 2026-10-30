# Included by headers/glib2.nim; do not import directly.
proc G_ENUM_CLASS*(class: pointer): PGEnumClass =
  result = cast[PGEnumClass](G_TYPE_CHECK_CLASS_CAST(class, G_TYPE_ENUM))

proc G_IS_ENUM_CLASS*(class: pointer): gboolean =
  result = G_TYPE_CHECK_CLASS_TYPE(class, G_TYPE_ENUM)

proc G_ENUM_CLASS_TYPE*(class: pointer): GType =
  result = G_TYPE_FROM_CLASS(class)

proc G_ENUM_CLASS_TYPE_NAME*(class: pointer): cstring =
  result = g_type_name(G_ENUM_CLASS_TYPE(class))

proc G_TYPE_IS_FLAGS*(theType: GType): gboolean =
  result = (G_TYPE_FUNDAMENTAL(theType)) == G_TYPE_FLAGS

proc G_FLAGS_CLASS*(class: pointer): PGFlagsClass =
  result = cast[PGFlagsClass](G_TYPE_CHECK_CLASS_CAST(class, G_TYPE_FLAGS))

proc G_IS_FLAGS_CLASS*(class: pointer): gboolean =
  result = G_TYPE_CHECK_CLASS_TYPE(class, G_TYPE_FLAGS)

proc G_FLAGS_CLASS_TYPE*(class: pointer): GType =
  result = G_TYPE_FROM_CLASS(class)

proc G_FLAGS_CLASS_TYPE_NAME*(class: pointer): cstring =
  result = g_type_name(G_FLAGS_TYPE(cast[uint](class)))

proc G_VALUE_HOLDS_ENUM*(value: pointer): gboolean =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_ENUM)

proc G_VALUE_HOLDS_FLAGS*(value: pointer): gboolean =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_FLAGS)

proc CLAMP*(x, MinX, MaxX: int): int =
  if x < MinX:
    result = MinX
  elif x > MaxX:
    result = MaxX
  else:
    result = x

proc GPOINTER_TO_SIZE*(p: gpointer): gsize =
  result = cast[gsize](p)

proc GSIZE_TO_POINTER*(s: gsize): gpointer =
  result = cast[gpointer](s)

