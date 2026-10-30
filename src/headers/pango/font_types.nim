# Included by headers/pango.nim; do not import directly.
type
  TFont* {.pure, final.} = object
  PFont* = ptr TFont
  TFontFamily* {.pure, final.} = object
  PFontFamily* = ptr TFontFamily
  TFontMetrics* {.pure, final.} = object
  PFontMetrics* = ptr TFontMetrics
  TFontFace* {.pure, final.} = object
  PFontFace* = ptr TFontFace
  TFontFamilyClass* {.pure, final.} = object
  PFontFamilyClass* = ptr TFontFamilyClass
  TFontFaceClass* {.pure, final.} = object
  PFontFaceClass* = ptr TFontFaceClass
  TFontClass* {.pure, final.} = object
  PFontClass* = ptr TFontClass
  TFontDescription* {.pure, final.} = object
  PFontDescription* = ptr TFontDescription
  TStyle* = gint
  PStyle* = ptr TStyle
  TVariant* = gint
  PVariant* = ptr TVariant
  TWeight* = gint
  PWeight* = ptr TWeight
  TStretch* = gint
  PStretch* = ptr TStretch
  TFontMask* = int32
  PFontMask* = ptr TFontMask
