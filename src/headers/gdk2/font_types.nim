# Included by headers/gdk2.nim; do not import directly.
type
  TFontType* = enum
    FONT_FONT, FONT_FONTSET
  PFontType* = ptr TFontType
  TFont*{.final, pure.} = object
    `type`*: TFontType
    ascent*: gint
    descent*: gint

  PFont* = ptr TFont
