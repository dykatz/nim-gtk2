# Included by headers/xkb.nim; do not import directly.
type
  XkbChangesRec*{.final.} = object   #
                                     #          These data structures are used to construct a keymap from
                                     #          a set of components or to list components in the server
                                     #          database.
                                     #
    device_spec*: int16
    state_changes*: int16
    map*: XkbMapChangesRec
    ctrls*: XkbControlsChangesRec
    indicators*: XkbIndicatorChangesRec
    names*: XkbNameChangesRec
    compat*: XkbCompatChangesRec

  PXkbChangesPtr* = ptr XkbChangesRec
