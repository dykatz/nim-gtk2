# Included by headers/pango.nim; do not import directly.
proc fontset_simple_get_type(): GType{.importc: "pango_fontset_simple_get_type",
                                       cdecl, dynlib: lib.}
proc TYPE_FONTSET_SIMPLE*(): GType =
  result = fontset_simple_get_type()

proc FONTSET_SIMPLE*(anObject: pointer): PFontsetSimple =
  result = cast[PFontsetSimple](G_TYPE_CHECK_INSTANCE_CAST(anObject,
      TYPE_FONTSET_SIMPLE()))

proc IS_FONTSET_SIMPLE*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_FONTSET_SIMPLE())

proc TYPE_FONT_DESCRIPTION*(): GType =
  result = font_description_get_type()

proc TYPE_FONT_METRICS*(): GType =
  result = font_metrics_get_type()

proc TYPE_FONT_FAMILY*(): GType =
  result = font_family_get_type()

