# Included by headers/xkb.nim; do not import directly.
const
  XkbNoModifier* = 0x000000FF
const
  XkbNoShiftLevel* = 0x000000FF
const
  XkbNoShape* = 0x000000FF
const
  XkbNoIndicator* = 0x000000FF
const
  XkbNoModifierMask* = 0
const
  XkbAllModifiersMask* = 0x000000FF
const
  XkbAllVirtualModsMask* = 0x0000FFFF
const
  XkbNumKbdGroups* = 4
const
  XkbMaxKbdGroup* = XkbNumKbdGroups - 1
const
  XkbMaxMouseKeysBtn* = 4 #
                          #      Group Index and Mask:
                          #       - Indices into the kt_index array of a key type.
                          #       - Mask specifies types to be changed for XkbChangeTypesOfKey
                          #

const
  XkbGroup1Index* = 0
const
  XkbGroup2Index* = 1
const
  XkbGroup3Index* = 2
const
  XkbGroup4Index* = 3
const
  XkbAnyGroup* = 254
const
  XkbAllGroups* = 255
const
  XkbGroup1Mask* = 1 shl 0
const
  XkbGroup2Mask* = 1 shl 1
const
  XkbGroup3Mask* = 1 shl 2
const
  XkbGroup4Mask* = 1 shl 3
const
  XkbAnyGroupMask* = 1 shl 7
const
  XkbAllGroupsMask* = 0x0000000F #
                                 #      BuildCoreState: Given a keyboard group and a modifier state,
                                 #                      construct the value to be reported an event.
                                 #      GroupForCoreState:  Given the state reported in an event,
                                 #                      determine the keyboard group.
                                 #      IsLegalGroup:   Returns TRUE if 'g' is a valid group index.
                                 #

