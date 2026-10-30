# Included by headers/gtk2.nim; do not import directly.
type
  PTreeDragSource* = pointer
  PTreeDragDest* = pointer
  TTreeDragSourceIface* = object of TGTypeInterface
    row_draggable*: proc (drag_source: PTreeDragSource, path: PTreePath): gboolean{.
        cdecl.}
    drag_data_get*: proc (drag_source: PTreeDragSource, path: PTreePath,
                          selection_data: PSelectionData): gboolean{.cdecl.}
    drag_data_delete*: proc (drag_source: PTreeDragSource, path: PTreePath): gboolean{.
        cdecl.}

  PTreeDragSourceIface* = ptr TTreeDragSourceIface
  TTreeDragDestIface* = object of TGTypeInterface
    drag_data_received*: proc (drag_dest: PTreeDragDest, dest: PTreePath,
                               selection_data: PSelectionData): gboolean{.cdecl.}
    row_drop_possible*: proc (drag_dest: PTreeDragDest, dest_path: PTreePath,
                              selection_data: PSelectionData): gboolean{.cdecl.}

  PTreeDragDestIface* = ptr TTreeDragDestIface
