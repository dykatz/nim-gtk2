# Included by headers/gdk2.nim; do not import directly.
const
  CURRENT_TIME*:guint = 0
const
  PARENT_RELATIVE*:guint = 1
const
  OK* = 0
const
  ERROR* = - (1)
const
  ERROR_PARAM* = - (2)
const
  ERROR_FILE* = - (3)
const
  ERROR_MEM* = - (4)
const
  SHIFT_MASK*:guint = 1 shl 0
const
  LOCK_MASK*:guint = 1 shl 1
const
  CONTROL_MASK*:guint = 1 shl 2
const
  MOD1_MASK*:guint = 1 shl 3
const
  MOD2_MASK*:guint = 1 shl 4
const
  MOD3_MASK*:guint = 1 shl 5
const
  MOD4_MASK*:guint = 1 shl 6
const
  MOD5_MASK*:guint = 1 shl 7
const
  BUTTON1_MASK*:guint = 1 shl 8
const
  BUTTON2_MASK*:guint = 1 shl 9
const
  BUTTON3_MASK*:guint = 1 shl 10
const
  BUTTON4_MASK*:guint = 1 shl 11
const
  BUTTON5_MASK*:guint = 1 shl 12
const
  RELEASE_MASK*:guint = 1 shl 30
const
  MODIFIER_MASK*:guint = ord(RELEASE_MASK) or 0x00001FFF
