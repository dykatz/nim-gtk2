# Included by headers/glib2.nim; do not import directly.
type
  TGTraverseType* = enum
    G_IN_ORDER, G_PRE_ORDER, G_POST_ORDER, G_LEVEL_ORDER
  PGTraverseType* = ptr TGTraverseType
