# Included by headers/gdk2.nim; do not import directly.
type
  TVisualClass* = object of TGObjectClass
  PVisualClass* = ptr TVisualClass
  TVisualType* = enum
    VISUAL_STATIC_GRAY, VISUAL_GRAYSCALE, VISUAL_STATIC_COLOR,
    VISUAL_PSEUDO_COLOR, VISUAL_TRUE_COLOR, VISUAL_DIRECT_COLOR
  PVisualType* = ptr TVisualType
