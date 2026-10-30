# Included by headers/pango.nim; do not import directly.
type
  TDirection* = enum
    DIRECTION_LTR, DIRECTION_RTL, DIRECTION_TTB_LTR, DIRECTION_TTB_RTL
  PDirection* = ptr TDirection
