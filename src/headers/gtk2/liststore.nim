# Included by headers/gtk2.nim; do not import directly.
converter toTreeModel*(x: PListStore): PTreeModel = cast[PTreeModel](x)

