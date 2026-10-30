# Included by headers/gtk2.nim; do not import directly.
proc CLASS_NAME*(`class`: pointer): cstring =
  result = g_type_name(G_TYPE_FROM_CLASS(`class`))

proc CLASS_TYPE*(`class`: pointer): GType =
  result = G_TYPE_FROM_CLASS(`class`)

proc TYPE_IS_OBJECT*(thetype: GType): gboolean =
  result = g_type_is_a(thetype, gtk2.TYPE_OBJECT())

proc TYPE_IDENTIFIER*(): GType =
  result = identifier_get_type()

proc SIGNAL_FUNC*(f: pointer): TSignalFunc =
  result = cast[TSignalFunc](f)

proc type_name*(thetype: GType): cstring =
  result = g_type_name(thetype)

proc type_from_name*(name: cstring): GType =
  result = g_type_from_name(name)

proc type_parent*(thetype: GType): GType =
  result = g_type_parent(thetype)

proc type_is_a*(thetype, is_a_type: GType): gboolean =
  result = g_type_is_a(thetype, is_a_type)

proc FUNDAMENTAL_TYPE*(thetype: GType): GType =
  result = G_TYPE_FUNDAMENTAL(thetype)

