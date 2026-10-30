# Included by headers/xkb.nim; do not import directly.
proc XkbActionSetCtrls*(a: PXkbCtrlsAction, c: int8)
proc XkbActionCtrls*(a: PXkbCtrlsAction): int16
