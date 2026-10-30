# Included by headers/xkb.nim; do not import directly.
proc XkbKeyKeyTypeIndex*(d: PXkbDescPtr, k: int16, g: int8): int8
proc XkbKeyKeyType*(d: PXkbDescPtr, k: int16, g: int8): PXkbKeyTypePtr
proc XkbKeyGroupWidth*(d: PXkbDescPtr, k: int16, g: int8): int8
proc XkbKeyGroupsWidth*(d: PXkbDescPtr, k: int16): int8
proc XkbKeyGroupInfo*(d: PXkbDescPtr, k: int16): int8
proc XkbKeyNumGroups*(d: PXkbDescPtr, k: int16): int8
proc XkbKeyNumSyms*(d: PXkbDescPtr, k: int16): int16
proc XkbKeySym*(d: PXkbDescPtr, k: int16, n: int16): KeySym
proc XkbKeySymEntry*(d: PXkbDescPtr, k: int16, sl: int16, g: int8): KeySym
proc XkbKeyAction*(d: PXkbDescPtr, k: int16, n: int16): PXkbAction
proc XkbKeyActionEntry*(d: PXkbDescPtr, k: int16, sl: int16, g: int8): int8
proc XkbKeyHasActions*(d: PXkbDescPtr, k: int16): bool
proc XkbKeyNumActions*(d: PXkbDescPtr, k: int16): int16
proc XkbKeyActionsPtr*(d: PXkbDescPtr, k: int16): PXkbAction
proc XkbKeycodeInRange*(d: PXkbDescPtr, k: int16): bool
proc XkbNumKeys*(d: PXkbDescPtr): int8
  #
  #          The following structures can be used to track changes
  #          to a keyboard device
  #
