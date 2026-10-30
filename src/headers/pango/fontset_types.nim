# Included by headers/pango.nim; do not import directly.
type
  TFontSet* {.pure, final.} = object
  PFontset* = ptr TFontset
  TFontsetClass {.pure, final.} = object
  PFontsetClass* = ptr TFontSetClass
