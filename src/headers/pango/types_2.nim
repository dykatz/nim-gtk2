# Included by headers/pango.nim; do not import directly.
proc ASCENT*(rect: TRectangle): int32
proc DESCENT*(rect: TRectangle): int32
proc LBEARING*(rect: TRectangle): int32
proc RBEARING*(rect: TRectangle): int32
proc TYPE_LANGUAGE*(): GType
