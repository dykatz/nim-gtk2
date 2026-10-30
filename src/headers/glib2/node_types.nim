# Included by headers/glib2.nim; do not import directly.
type
  PGNode* = ptr TGNode
  TGNode*{.final.} = object
    data*: gpointer
    next*: PGNode
    prev*: PGNode
    parent*: PGNode
    children*: PGNode

  TGTraverseFlags* = gint

  PGTraverseFlags* = ptr TGTraverseFlags
