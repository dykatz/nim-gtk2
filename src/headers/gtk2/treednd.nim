# Included by headers/gtk2.nim; do not import directly.
proc TREE_DRAG_SOURCE*(obj: pointer): PTreeDragSource
proc IS_TREE_DRAG_SOURCE*(obj: pointer): bool
proc TREE_DRAG_SOURCE_GET_IFACE*(obj: pointer): PTreeDragSourceIface
proc tree_drag_source_get_type*(): GType{.cdecl, dynlib: lib,
    importc: "gtk_tree_drag_source_get_type".}
proc source_row_draggable*(drag_source: PTreeDragSource,
                                     path: PTreePath): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_tree_drag_source_row_draggable".}
proc source_drag_data_delete*(drag_source: PTreeDragSource,
                                        path: PTreePath): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_tree_drag_source_drag_data_delete".}
proc source_drag_data_get*(drag_source: PTreeDragSource,
                                     path: PTreePath,
                                     selection_data: PSelectionData): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_drag_source_drag_data_get".}
proc TYPE_TREE_DRAG_DEST*(): GType
proc TREE_DRAG_DEST*(obj: pointer): PTreeDragDest
proc IS_TREE_DRAG_DEST*(obj: pointer): bool
proc TREE_DRAG_DEST_GET_IFACE*(obj: pointer): PTreeDragDestIface
proc tree_drag_dest_get_type*(): GType{.cdecl, dynlib: lib,
                                        importc: "gtk_tree_drag_dest_get_type".}
proc dest_drag_data_received*(drag_dest: PTreeDragDest,
                                        dest: PTreePath,
                                        selection_data: PSelectionData): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_drag_dest_drag_data_received".}
proc dest_row_drop_possible*(drag_dest: PTreeDragDest,
                                       dest_path: PTreePath,
                                       selection_data: PSelectionData): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_drag_dest_row_drop_possible".}
proc tree_set_row_drag_data*(selection_data: PSelectionData,
                             tree_model: PTreeModel, path: PTreePath): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_tree_set_row_drag_data".}
const
  bm_TGtkTreeItem_expanded* = 0x0001'u16
const
  bp_TGtkTreeItem_expanded* = 0'u16

