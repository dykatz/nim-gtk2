# Included by headers/xkb.nim; do not import directly.
const
  XkbNumModifiers* = 8
const
  XkbNumVirtualMods* = 16
const
  XkbNumIndicators* = 32
const
  XkbMaxRadioGroups* = 32
const
  XkbAllRadioGroupsMask* = 0xFFFFFFFF
const
  XkbMaxShiftLevel* = 63
const
  XkbMaxSymsPerKey* = XkbMaxShiftLevel * XkbNumKbdGroups
const
  XkbRGMaxMembers* = 12
const
  XkbActionMessageLength* = 6
const
  XkbKeyNameLength* = 4
const
  XkbMaxRedirectCount* = 8
const
  XkbGeomPtsPerMM* = 10
const
  XkbGeomMaxColors* = 32
const
  XkbGeomMaxLabelColors* = 3
const
  XkbGeomMaxPriority* = 255

