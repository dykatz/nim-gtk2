# Included by headers/gtk2.nim; do not import directly.
proc FLAG_SET*(tree_view: PTreeView, flag: guint): bool =
  result = ((tree_view.priv.flags) and (flag)) == flag

proc HEADER_HEIGHT*(tree_view: PTreeView): int32 =
  var if_local1: int32
  if FLAG_SET(tree_view, TREE_VIEW_HEADERS_VISIBLE):
    if_local1 = tree_view.priv.header_height
  else:
    if_local1 = 0
  result = if_local1

