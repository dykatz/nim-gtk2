# Included by headers/pango.nim; do not import directly.
proc ASCENT*(rect: TRectangle): int32 =
  result = -rect.y

proc DESCENT*(rect: TRectangle): int32 =
  result = (rect.y) + (rect.height)

proc LBEARING*(rect: TRectangle): int32 =
  result = rect.x

proc RBEARING*(rect: TRectangle): int32 =
  result = (rect.x) + (rect.width)

proc TYPE_LANGUAGE*(): GType =
  result = language_get_type()

proc to_string*(language: PLanguage): cstring =
  result = cast[cstring](language)

proc PIXELS*(d: int): int =
  if d >= 0:
    result = (d + (SCALE div 2)) div SCALE
  else:
    result = (d - (SCALE div 2)) div SCALE

proc TYPE_COLOR*(): GType =
  result = color_get_type()

proc TYPE_ATTR_LIST*(): GType =
  result = attr_list_get_type()

