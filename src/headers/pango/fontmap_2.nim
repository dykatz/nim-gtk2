# Included by headers/pango.nim; do not import directly.
proc FONT_MAP*(anObject: pointer): PFontmap =
  result = cast[PFontmap](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_FONT_MAP()))

proc IS_FONT_MAP*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_FONT_MAP())

proc FONT_MAP_CLASS*(klass: pointer): PFontMapClass =
  result = cast[PFontMapClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_FONT_MAP()))

proc IS_FONT_MAP_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_FONT_MAP())

proc GET_CLASS*(obj: PFontMap): PFontMapClass =
  result = cast[PFontMapClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_FONT_MAP()))

