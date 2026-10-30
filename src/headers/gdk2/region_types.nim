# Included by headers/gdk2.nim; do not import directly.
type
  TFillRule* = enum
    EVEN_ODD_RULE, WINDING_RULE
  PFillRule* = ptr TFillRule
  TOverlapType* = enum
    OVERLAP_RECTANGLE_IN, OVERLAP_RECTANGLE_OUT, OVERLAP_RECTANGLE_PART
  POverlapType* = ptr TOverlapType
