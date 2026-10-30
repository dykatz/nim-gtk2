# Included by headers/xkb.nim; do not import directly.
type
  XkbAnyAction*{.final.} = object
    theType*: int8
    data*: array[0..XkbAnyActionDataSize - 1, int8]

  PXkbAnyAction* = ptr XkbAnyAction
