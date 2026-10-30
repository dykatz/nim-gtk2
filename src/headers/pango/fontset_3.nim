# Included by headers/pango.nim; do not import directly.
proc FONTSET*(anObject: pointer): PFontset =
  result = cast[PFontset](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_FONTSET()))

proc IS_FONTSET*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_FONTSET())

proc FONTSET_CLASS*(klass: pointer): PFontsetClass =
  result = cast[PFontsetClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_FONTSET()))

proc IS_FONTSET_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_FONTSET())

proc GET_CLASS*(obj: PFontset): PFontsetClass =
  result = cast[PFontsetClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_FONTSET()))

