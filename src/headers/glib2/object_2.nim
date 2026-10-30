# Included by headers/glib2.nim; do not import directly.
const
  G_E* = 2.71828
const
  G_LN2* = 0.693147
const
  G_LN10* = 2.30259
const
  G_PI* = 3.14159
const
  G_PI_2* = 1.57080
const
  G_PI_4* = 0.785398
const
  G_SQRT2* = 1.41421
const
  G_LITTLE_ENDIAN* = 1234
const
  G_BIG_ENDIAN* = 4321
const
  G_PDP_ENDIAN* = 3412

proc GUINT16_SWAP_LE_BE_CONSTANT*(val: guint16): guint16
proc GUINT32_SWAP_LE_BE_CONSTANT*(val: guint32): guint32
