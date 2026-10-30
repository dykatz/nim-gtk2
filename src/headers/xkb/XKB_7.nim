# Included by headers/xkb.nim; do not import directly.
const
  XkbOneLevelIndex* = 0
const
  XkbTwoLevelIndex* = 1
const
  XkbAlphabeticIndex* = 2
const
  XkbKeypadIndex* = 3
const
  XkbLastRequiredType* = XkbKeypadIndex
const
  XkbNumRequiredTypes* = XkbLastRequiredType + 1
const
  XkbMaxKeyTypes* = 255
const
  XkbOneLevelMask* = 1 shl 0
const
  XkbTwoLevelMask* = 1 shl 1
const
  XkbAlphabeticMask* = 1 shl 2
const
  XkbKeypadMask* = 1 shl 3
const
  XkbAllRequiredTypes* = 0x0000000F

