# Included by headers/gtk2.nim; do not import directly.
proc toggle_segment_check_func*(segPtr: PTextLineSegment, line: PTextLine){.
    cdecl, dynlib: lib, importc: "_gtk_toggle_segment_check_func".}
proc change_node_toggle_count*(node: PTextBTreeNode, info: PTextTagInfo,
                               delta: gint){.cdecl, dynlib: lib,
    importc: "_gtk_change_node_toggle_count".}
