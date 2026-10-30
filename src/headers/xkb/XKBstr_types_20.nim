# Included by headers/xkb.nim; do not import directly.
type
  XkbSymInterpretRec*{.final.} = object
    sym*: KeySym
    flags*: int8
    match*: int8
    mods*: int8
    virtual_mod*: int8
    act*: XkbAnyAction

