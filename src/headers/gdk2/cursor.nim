# Included by headers/gdk2.nim; do not import directly.
const
  CURSOR_IS_PIXMAP* = - (1)
const
  X_CURSOR* = 0
const
  ARROW* = 2
const
  BASED_ARROW_DOWN* = 4
const
  BASED_ARROW_UP* = 6
const
  BOAT* = 8
const
  BOGOSITY* = 10
const
  BOTTOM_LEFT_CORNER* = 12
const
  BOTTOM_RIGHT_CORNER* = 14
const
  BOTTOM_SIDE* = 16
const
  BOTTOM_TEE* = 18
const
  BOX_SPIRAL* = 20
const
  CENTER_PTR* = 22
const
  CIRCLE* = 24
const
  CLOCK* = 26
const
  COFFEE_MUG* = 28
const
  CROSS* = 30
const
  CROSS_REVERSE* = 32
const
  CROSSHAIR* = 34
const
  DIAMOND_CROSS* = 36
const
  DOT* = 38
const
  DOTBOX* = 40
const
  DOUBLE_ARROW* = 42
const
  DRAFT_LARGE* = 44
const
  DRAFT_SMALL* = 46
const
  DRAPED_BOX* = 48
const
  EXCHANGE* = 50
const
  FLEUR* = 52
const
  GOBBLER* = 54
const
  GUMBY* = 56
const
  HAND1* = 58
const
  HAND2* = 60
const
  HEART* = 62
const
  ICON* = 64
const
  IRON_CROSS* = 66
const
  LEFT_PTR* = 68
const
  LEFT_SIDE* = 70
const
  LEFT_TEE* = 72
const
  LEFTBUTTON* = 74
const
  LL_ANGLE* = 76
const
  LR_ANGLE* = 78
const
  MAN* = 80
const
  MIDDLEBUTTON* = 82
const
  MOUSE* = 84
const
  PENCIL* = 86
const
  PIRATE* = 88
const
  PLUS* = 90
const
  QUESTION_ARROW* = 92
const
  RIGHT_PTR* = 94
const
  RIGHT_SIDE* = 96
const
  RIGHT_TEE* = 98
const
  RIGHTBUTTON* = 100
const
  RTL_LOGO* = 102
const
  SAILBOAT* = 104
const
  SB_DOWN_ARROW* = 106
const
  SB_H_DOUBLE_ARROW* = 108
const
  SB_LEFT_ARROW* = 110
const
  SB_RIGHT_ARROW* = 112
const
  SB_UP_ARROW* = 114
const
  SB_V_DOUBLE_ARROW* = 116
const
  SHUTTLE* = 118
const
  SIZING* = 120
const
  SPIDER* = 122
const
  SPRAYCAN* = 124
const
  STAR* = 126
const
  TARGET* = 128
const
  TCROSS* = 130
const
  TOP_LEFT_ARROW* = 132
const
  TOP_LEFT_CORNER* = 134
const
  TOP_RIGHT_CORNER* = 136
const
  TOP_SIDE* = 138
const
  TOP_TEE* = 140
const
  TREK* = 142
const
  UL_ANGLE* = 144
const
  UMBRELLA* = 146
const
  UR_ANGLE* = 148
const
  WATCH* = 150
const
  XTERM* = 152
const
  LAST_CURSOR* = XTERM + 1

proc TYPE_CURSOR*(): GType
proc cursor_get_type*(): GType{.cdecl, dynlib: lib,
                                importc: "gdk_cursor_get_type".}
