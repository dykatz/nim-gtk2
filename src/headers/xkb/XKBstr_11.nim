# Included by headers/xkb.nim; do not import directly.
proc XkbBuildCoreState*(m, g: int): int
proc XkbGroupForCoreState*(s: int): int
proc XkbIsLegalGroup*(g: int): bool
  #
  #      GroupsWrap values:
  #       - The 'groupsWrap' field of an XkbControlsRec specifies the
  #         treatment of out of range groups.
  #       - Bits 6 and 7 of the group info field of a key symbol map
  #         specify the interpretation of out of range groups for the
  #         corresponding key.
  #
