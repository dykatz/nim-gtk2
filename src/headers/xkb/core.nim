# Included by headers/xkb.nim; do not import directly.
proc XkbcharToInt*(v: int8): int16
proc XkbIntTo2chars*(i: int16, h, L: var int8)
proc Xkb2charsToInt*(h, L: int8): int16
  #
  #          Common data structures and access macros
  #
