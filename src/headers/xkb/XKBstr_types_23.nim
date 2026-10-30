# Included by headers/xkb.nim; do not import directly.
type
  XkbIndicatorRec*{.final.} = object
    phys_indicators*: int32
    maps*: array[0..XkbNumIndicators - 1, XkbIndicatorMapRec]

