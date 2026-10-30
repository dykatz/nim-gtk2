# Included by headers/gtk2.nim; do not import directly.
proc mark_segment_new*(tree: PTextBTree, left_gravity: gboolean, name: cstring): PTextLineSegment{.
    cdecl, dynlib: lib, importc: "_gtk_mark_segment_new".}
proc TYPE_TEXT_CHILD_ANCHOR*(): GType
