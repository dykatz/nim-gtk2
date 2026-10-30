# Included by headers/xkb.nim; do not import directly.
type
  XkbServerMapRec*{.final.} = object
    num_acts*: int16
    size_acts*: int16
    acts*: ptr array[0..0xfff, XkbAction]
    behaviors*: PXkbBehavior
    key_acts*: PWord
    explicit*: PByte
    vmods*: array[0..XkbNumVirtualMods - 1, int8]
    vmodmap*: PWord

