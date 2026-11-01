# Included by headers/gtk2.nim; do not import directly.
proc reorder*(store: PListStore, new_order: Pgint) {.cdecl, dynlib: lib,
    importc: "gtk_list_store_reorder".}
converter toTreeModel*(x: PListStore): PTreeModel = cast[PTreeModel](x)

