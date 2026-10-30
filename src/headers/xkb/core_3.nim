# Included by headers/xkb.nim; do not import directly.
proc XkbNumGroups*(g: int16): int16
proc XkbOutOfRangeGroupInfo*(g: int16): int16
proc XkbOutOfRangeGroupAction*(g: int16): int16
proc XkbOutOfRangeGroupNumber*(g: int16): int16
proc XkbSetGroupInfo*(g, w, n: int16): int16
proc XkbSetNumGroups*(g, n: int16): int16
  #
  #          Structures and access macros used primarily by the server
  #
