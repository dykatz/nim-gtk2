# Included by headers/gtk2.nim; do not import directly.
type
  TTextLineData = object # Opaque private pointer; remaining layout API audit pending.
  PTextLineData* = ptr TTextLineData

  TTextAttrAppearance*{.final, pure.} = object
    attr*: pango.TAttribute
    appearance*: TTextAppearance

  PTextAttrAppearance* = ptr TTextAttrAppearance
  TTextCursorDisplay*{.final, pure.} = object
    x*: gint
    y*: gint
    height*: gint
    flag0*: guint16

  PTextCursorDisplay* = ptr TTextCursorDisplay
