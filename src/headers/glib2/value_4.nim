# Included by headers/glib2.nim; do not import directly.
proc HOLDS_CHAR*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_CHAR)

proc HOLDS_UCHAR*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_UCHAR)

proc HOLDS_BOOLEAN*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_BOOLEAN)

proc HOLDS_INT*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_INT)

proc HOLDS_UINT*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_UINT)

proc HOLDS_LONG*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_LONG)

proc HOLDS_ULONG*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_ULONG)

proc HOLDS_INT64*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_INT64)

proc HOLDS_UINT64*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_UINT64)

proc HOLDS_FLOAT*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_FLOAT)

proc HOLDS_DOUBLE*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_DOUBLE)

proc HOLDS_STRING*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_STRING)

proc HOLDS_POINTER*(value: PGValue): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_POINTER)

proc G_TYPE_IS_BOXED*(theType: GType): gboolean =
  result = (G_TYPE_FUNDAMENTAL(theType)) == G_TYPE_BOXED

proc HOLDS_BOXED*(value: PGValue): gboolean =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_BOXED)

proc G_TYPE_CLOSURE*(): GType =
  result = g_closure_get_type()

proc G_TYPE_VALUE*(): GType =
  result = g_value_get_type()

proc G_TYPE_VALUE_ARRAY*(): GType =
  result = g_value_array_get_type()

proc G_TYPE_GSTRING*(): GType =
  result = g_gstring_get_type()

proc g_thread_init*(vtable: pointer) {.
  cdecl, dynlib: gobjectlib, importc: "g_thread_init".}

