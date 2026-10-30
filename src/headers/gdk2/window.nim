# Included by headers/gdk2.nim; do not import directly.
const
  WA_TITLE* = 1 shl 1
const
  WA_X* = 1 shl 2
const
  WA_Y* = 1 shl 3
const
  WA_CURSOR* = 1 shl 4
const
  WA_COLORMAP* = 1 shl 5
const
  WA_VISUAL* = 1 shl 6
const
  WA_WMCLASS* = 1 shl 7
const
  WA_NOREDIR* = 1 shl 8
const
  HINT_POS* = 1 shl 0
const
  HINT_MIN_SIZE* = 1 shl 1
const
  HINT_MAX_SIZE* = 1 shl 2
const
  HINT_BASE_SIZE* = 1 shl 3
const
  HINT_ASPECT* = 1 shl 4
const
  HINT_RESIZE_INC* = 1 shl 5
const
  HINT_WIN_GRAVITY* = 1 shl 6
const
  HINT_USER_POS* = 1 shl 7
const
  HINT_USER_SIZE* = 1 shl 8
const
  DECOR_ALL* = 1 shl 0
const
  DECOR_BORDER* = 1 shl 1
const
  DECOR_RESIZEH* = 1 shl 2
const
  DECOR_TITLE* = 1 shl 3
const
  DECOR_MENU* = 1 shl 4
const
  DECOR_MINIMIZE* = 1 shl 5
const
  DECOR_MAXIMIZE* = 1 shl 6
const
  FUNC_ALL* = 1 shl 0
const
  FUNC_RESIZE* = 1 shl 1
const
  FUNC_MOVE* = 1 shl 2
const
  FUNC_MINIMIZE* = 1 shl 3
const
  FUNC_MAXIMIZE* = 1 shl 4
const
  FUNC_CLOSE* = 1 shl 5
const
  GRAVITY_NORTH_WEST* = 1
const
  GRAVITY_NORTH* = 2
const
  GRAVITY_NORTH_EAST* = 3
const
  GRAVITY_WEST* = 4
const
  GRAVITY_CENTER* = 5
const
  GRAVITY_EAST* = 6
const
  GRAVITY_SOUTH_WEST* = 7
const
  GRAVITY_SOUTH* = 8
const
  GRAVITY_SOUTH_EAST* = 9
const
  GRAVITY_STATIC* = 10

proc TYPE_WINDOW*(): GType
