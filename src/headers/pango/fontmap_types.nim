# Included by headers/pango.nim; do not import directly.
type
  TFontMap* {.pure, final.} = object
  PFontMap* = ptr TFontMap
  TFontMapClass* {.pure, final.} = object
  PFontMapClass* = ptr TFontMapClass
