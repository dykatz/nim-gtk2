# Included by headers/xkb.nim; do not import directly.
const
  XkbKB_Permanent* = 0x00000080
const
  XkbKB_OpMask* = 0x0000007F
const
  XkbKB_Default* = 0x00000000
const
  XkbKB_Lock* = 0x00000001
const
  XkbKB_RadioGroup* = 0x00000002
const
  XkbKB_Overlay1* = 0x00000003
const
  XkbKB_Overlay2* = 0x00000004
const
  XkbKB_RGAllowNone* = 0x00000080 #
                                  #      Various macros which describe the range of legal keycodes.
                                  #

const
  XkbMinLegalKeyCode* = 8
const
  XkbMaxLegalKeyCode* = 255
const
  XkbMaxKeyCount* = XkbMaxLegalKeyCode - XkbMinLegalKeyCode + 1
const
  XkbPerKeyBitArraySize* = (XkbMaxLegalKeyCode + 1) div 8

