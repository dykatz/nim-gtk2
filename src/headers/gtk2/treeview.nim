# Included by headers/gtk2.nim; do not import directly.
proc SET_FLAG*(tree_view: PTreeView, flag: guint)
proc UNSET_FLAG*(tree_view: PTreeView, flag: guint)
proc FLAG_SET*(tree_view: PTreeView, flag: guint): bool
proc HEADER_HEIGHT*(tree_view: PTreeView): int32
