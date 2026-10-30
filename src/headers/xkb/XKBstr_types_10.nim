# Included by headers/xkb.nim; do not import directly.
type
  XkbCtrlsAction*{.final.} = object
    theType*: int8
    flags*: int8
    ctrls3*: int8
    ctrls2*: int8
    ctrls1*: int8
    ctrls0*: int8

  PXkbCtrlsAction* = ptr XkbCtrlsAction
