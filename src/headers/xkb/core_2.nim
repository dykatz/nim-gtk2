# Included by headers/xkb.nim; do not import directly.
proc XkbModLocks*(s: PXkbStatePtr): int8
proc XkbStateMods*(s: PXkbStatePtr): int16
proc XkbGroupLock*(s: PXkbStatePtr): int8
proc XkbStateGroup*(s: PXkbStatePtr): int16
proc XkbStateFieldFromRec*(s: PXkbStatePtr): int
proc XkbGrabStateFromRec*(s: PXkbStatePtr): int
