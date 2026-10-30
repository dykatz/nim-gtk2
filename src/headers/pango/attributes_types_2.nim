# Included by headers/pango.nim; do not import directly.
type
  TAttrLanguage*{.final, pure.} = object
    attr*: TAttribute
    value*: PLanguage

  PAttrLanguage* = ptr TAttrLanguage
  TAttrColor*{.final, pure.} = object
    attr*: TAttribute
    color*: TColor

  PAttrColor* = ptr TAttrColor
  TAttrShape*{.final, pure.} = object
    attr*: TAttribute
    ink_rect*: TRectangle
    logical_rect*: TRectangle

  PAttrShape* = ptr TAttrShape
