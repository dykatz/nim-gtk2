# Included by headers/pango.nim; do not import directly.
type
  TBlockInfo*{.final, pure.} = object
    data*: Pguchar
    level*: TCoverageLevel

  PBlockInfo* = ptr TBlockInfo
