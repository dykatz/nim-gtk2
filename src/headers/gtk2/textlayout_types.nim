# Included by headers/gtk2.nim; do not import directly.
type
  PTextLineData* = ptr TTextLineData
  TTextLineData*{.final, pure.} = object
    view_id*: gpointer
    next*: PTextLineData
    height*: gint
    flag0*: uint32

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
