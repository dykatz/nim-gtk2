# Included by headers/glib2.nim; do not import directly.
const
  G_TRAVERSE_LEAFS* = 1 shl 0
const
  G_TRAVERSE_NON_LEAFS* = 1 shl 1
const
  G_TRAVERSE_ALL* = G_TRAVERSE_LEAFS or G_TRAVERSE_NON_LEAFS
const
  G_TRAVERSE_MASK* = 0x00000003

