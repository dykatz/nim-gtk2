# Included by headers/xkb.nim; do not import directly.
proc XkbPtrActionX*(a: PXkbPtrAction): int16
proc XkbPtrActionY*(a: PXkbPtrAction): int16
proc XkbSetPtrActionX*(a: PXkbPtrAction, x: int8)
proc XkbSetPtrActionY*(a: PXkbPtrAction, y: int8)
