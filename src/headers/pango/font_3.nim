# Included by headers/pango.nim; do not import directly.
proc FONT_FAMILY*(anObject: pointer): PFontFamily =
  result = cast[PFontFamily](G_TYPE_CHECK_INSTANCE_CAST(anObject,
      TYPE_FONT_FAMILY()))

proc IS_FONT_FAMILY*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_FONT_FAMILY())

proc FONT_FAMILY_CLASS*(klass: pointer): PFontFamilyClass =
  result = cast[PFontFamilyClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_FONT_FAMILY()))

proc IS_FONT_FAMILY_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_FONT_FAMILY())

proc GET_CLASS*(obj: PFontFamily): PFontFamilyClass =
  result = cast[PFontFamilyClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_FONT_FAMILY()))

proc TYPE_FONT_FACE*(): GType =
  result = font_face_get_type()

proc FONT_FACE*(anObject: pointer): PFontFace =
  result = cast[PFontFace](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_FONT_FACE()))

proc IS_FONT_FACE*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_FONT_FACE())

proc FONT_FACE_CLASS*(klass: pointer): PFontFaceClass =
  result = cast[PFontFaceClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_FONT_FACE()))

proc IS_FONT_FACE_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_FONT_FACE())

proc FONT_FACE_GET_CLASS*(obj: pointer): PFontFaceClass =
  result = cast[PFontFaceClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_FONT_FACE()))

proc TYPE_FONT*(): GType =
  result = font_get_type()

proc FONT*(anObject: pointer): PFont =
  result = cast[PFont](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_FONT()))

proc IS_FONT*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_FONT())

proc FONT_CLASS*(klass: pointer): PFontClass =
  result = cast[PFontClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_FONT()))

proc IS_FONT_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_FONT())

proc GET_CLASS*(obj: PFont): PFontClass =
  result = cast[PFontClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_FONT()))

proc TYPE_FONT_MAP*(): GType =
  result = font_map_get_type()

