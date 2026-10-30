# Included by headers/gtk2.nim; do not import directly.
type
  TTextSearchFlags* = int32
  PTextSearchFlags* = ptr TTextSearchFlags
  TTextIter*{.final, pure.} = object
    dummy1*: gpointer
    dummy2*: gpointer
    dummy3*: gint
    dummy4*: gint
    dummy5*: gint
    dummy6*: gint
    dummy7*: gint
    dummy8*: gint
    dummy9*: gpointer
    dummy10*: gpointer
    dummy11*: gint
    dummy12*: gint
    dummy13*: gint
    dummy14*: gpointer

  PTextIter* = ptr TTextIter
