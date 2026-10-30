# Included by headers/gtk2.nim; do not import directly.
type
  TTreeViewDropPosition* = enum
    TREE_VIEW_DROP_BEFORE, TREE_VIEW_DROP_AFTER, TREE_VIEW_DROP_INTO_OR_BEFORE,
    TREE_VIEW_DROP_INTO_OR_AFTER
  PTreeViewDropPosition* = ptr TTreeViewDropPosition
