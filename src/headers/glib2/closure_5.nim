# Included by headers/glib2.nim; do not import directly.
const
  G_SIGNAL_MATCH_ID* = 1 shl 0
const
  G_SIGNAL_MATCH_DETAIL* = 1 shl 1
const
  G_SIGNAL_MATCH_CLOSURE* = 1 shl 2
const
  G_SIGNAL_MATCH_FUNC* = 1 shl 3
const
  G_SIGNAL_MATCH_DATA* = 1 shl 4
const
  G_SIGNAL_MATCH_UNBLOCKED* = 1 shl 5
const
  G_SIGNAL_MATCH_MASK* = 0x0000003F
const
  G_SIGNAL_TYPE_STATIC_SCOPE* = G_TYPE_FLAG_RESERVED_ID_BIT

