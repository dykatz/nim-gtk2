# Included by headers/glib2.nim; do not import directly.
proc IS_ROOT*(node: PGNode): bool
proc IS_LEAF*(node: PGNode): bool
proc node_push_allocator*(allocator: PGAllocator){.cdecl, dynlib: gliblib,
    importc: "g_node_push_allocator".}
proc g_node_pop_allocator*(){.cdecl, dynlib: gliblib,
                              importc: "g_node_pop_allocator".}
proc g_node_new*(data: gpointer): PGNode{.cdecl, dynlib: gliblib,
    importc: "g_node_new".}
proc destroy*(root: PGNode){.cdecl, dynlib: gliblib,
                                    importc: "g_node_destroy".}
proc unlink*(node: PGNode){.cdecl, dynlib: gliblib,
                                   importc: "g_node_unlink".}
proc copy*(node: PGNode): PGNode{.cdecl, dynlib: gliblib,
    importc: "g_node_copy".}
proc insert*(parent: PGNode, position: gint, node: PGNode): PGNode{.
    cdecl, dynlib: gliblib, importc: "g_node_insert".}
proc insert_before*(parent: PGNode, sibling: PGNode, node: PGNode): PGNode{.
    cdecl, dynlib: gliblib, importc: "g_node_insert_before".}
proc insert_after*(parent: PGNode, sibling: PGNode, node: PGNode): PGNode{.
    cdecl, dynlib: gliblib, importc: "g_node_insert_after".}
proc prepend*(parent: PGNode, node: PGNode): PGNode{.cdecl,
    dynlib: gliblib, importc: "g_node_prepend".}
proc n_nodes*(root: PGNode, flags: TGTraverseFlags): guint{.cdecl,
    dynlib: gliblib, importc: "g_node_n_nodes".}
proc get_root*(node: PGNode): PGNode{.cdecl, dynlib: gliblib,
    importc: "g_node_get_root".}
proc is_ancestor*(node: PGNode, descendant: PGNode): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_node_is_ancestor".}
proc depth*(node: PGNode): guint{.cdecl, dynlib: gliblib,
    importc: "g_node_depth".}
proc find*(root: PGNode, order: TGTraverseType, flags: TGTraverseFlags,
                  data: gpointer): PGNode{.cdecl, dynlib: gliblib,
    importc: "g_node_find".}
proc append*(parent: PGNode, node: PGNode): PGNode
proc insert_data*(parent: PGNode, position: gint, data: gpointer): PGNode
proc insert_data_before*(parent: PGNode, sibling: PGNode, data: gpointer): PGNode
proc prepend_data*(parent: PGNode, data: gpointer): PGNode
proc append_data*(parent: PGNode, data: gpointer): PGNode
proc traverse*(root: PGNode, order: TGTraverseType,
                      flags: TGTraverseFlags, max_depth: gint,
                      fn: TGNodeTraverseFunc, data: gpointer): guint{.cdecl,
    dynlib: gliblib, importc: "g_node_traverse".}
proc max_height*(root: PGNode): guint{.cdecl, dynlib: gliblib,
    importc: "g_node_max_height".}
proc children_foreach*(node: PGNode, flags: TGTraverseFlags,
                              fn: TGNodeForeachFunc, data: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_node_children_foreach".}
proc reverse_children*(node: PGNode){.cdecl, dynlib: gliblib,
    importc: "g_node_reverse_children".}
proc n_children*(node: PGNode): guint{.cdecl, dynlib: gliblib,
    importc: "g_node_n_children".}
proc nth_child*(node: PGNode, n: guint): PGNode{.cdecl, dynlib: gliblib,
    importc: "g_node_nth_child".}
proc last_child*(node: PGNode): PGNode{.cdecl, dynlib: gliblib,
    importc: "g_node_last_child".}
proc find_child*(node: PGNode, flags: TGTraverseFlags, data: gpointer): PGNode{.
    cdecl, dynlib: gliblib, importc: "g_node_find_child".}
proc child_position*(node: PGNode, child: PGNode): gint{.cdecl,
    dynlib: gliblib, importc: "g_node_child_position".}
proc child_index*(node: PGNode, data: gpointer): gint{.cdecl,
    dynlib: gliblib, importc: "g_node_child_index".}
proc first_sibling*(node: PGNode): PGNode{.cdecl, dynlib: gliblib,
    importc: "g_node_first_sibling".}
proc last_sibling*(node: PGNode): PGNode{.cdecl, dynlib: gliblib,
    importc: "g_node_last_sibling".}
proc prev_sibling*(node: PGNode): PGNode
proc next_sibling*(node: PGNode): PGNode
proc first_child*(node: PGNode): PGNode
