# Included by headers/xkb.nim; do not import directly.
proc XkbCMKeyGroupInfo*(m: PXkbClientMapPtr, k: int16): int8
proc XkbCMKeyNumGroups*(m: PXkbClientMapPtr, k: int16): int8
proc XkbCMKeyGroupWidth*(m: PXkbClientMapPtr, k: int16, g: int8): int8
proc XkbCMKeyGroupsWidth*(m: PXkbClientMapPtr, k: int16): int8
proc XkbCMKeyTypeIndex*(m: PXkbClientMapPtr, k: int16, g: int8): int8
proc XkbCMKeyType*(m: PXkbClientMapPtr, k: int16, g: int8): PXkbKeyTypePtr
proc XkbCMKeyNumSyms*(m: PXkbClientMapPtr, k: int16): int16
proc XkbCMKeySymsOffset*(m: PXkbClientMapPtr, k: int16): int8
  #
  #          Compatibility structures and access macros
  #
