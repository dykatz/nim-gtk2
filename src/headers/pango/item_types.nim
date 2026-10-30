# Included by headers/pango.nim; do not import directly.
type
  TItem*{.final, pure.} = object
    offset*: gint
    length*: gint
    num_chars*: gint
    analysis*: TAnalysis

  PItem* = ptr TItem
