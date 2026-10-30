# Included by headers/gdk2.nim; do not import directly.
proc KEYMAP*(anObject: pointer): PKeymap =
  result = cast[PKeymap](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_KEYMAP()))

proc KEYMAP_CLASS*(klass: pointer): PKeymapClass =
  result = cast[PKeymapClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_KEYMAP()))

proc IS_KEYMAP*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_KEYMAP())

proc IS_KEYMAP_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_KEYMAP())

proc KEYMAP_GET_CLASS*(obj: pointer): PKeymapClass =
  result = cast[PKeymapClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_KEYMAP()))

