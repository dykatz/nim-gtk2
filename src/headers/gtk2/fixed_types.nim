# Included by headers/gtk2.nim; do not import directly.
type
  TFixed* = object of TContainer
    children*: PGList

  PFixed* = ptr TFixed
  TFixedChild*{.final, pure.} = object
    widget*: PWidget
    x*: gint
    y*: gint

  PFixedChild* = ptr TFixedChild
