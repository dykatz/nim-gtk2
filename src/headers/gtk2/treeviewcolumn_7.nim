# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TREE_VIEW_COLUMN*(): GType =
  result = tree_view_column_get_type()

proc TREE_VIEW_COLUMN*(obj: pointer): PTreeViewColumn =
  result = cast[PTreeViewColumn](CHECK_CAST(obj, TYPE_TREE_VIEW_COLUMN()))

proc TREE_VIEW_COLUMN_CLASS*(klass: pointer): PTreeViewColumnClass =
  result = cast[PTreeViewColumnClass](CHECK_CLASS_CAST(klass,
      TYPE_TREE_VIEW_COLUMN()))

proc IS_TREE_VIEW_COLUMN*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_TREE_VIEW_COLUMN())

proc IS_TREE_VIEW_COLUMN_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_TREE_VIEW_COLUMN())

proc TREE_VIEW_COLUMN_GET_CLASS*(obj: pointer): PTreeViewColumnClass =
  result = cast[PTreeViewColumnClass](CHECK_GET_CLASS(obj,
      TYPE_TREE_VIEW_COLUMN()))

proc visible*(a: PTreeViewColumn): guint =
  result = (a.TreeViewColumnflag0 and bm_TGtkTreeViewColumn_visible) shr
      bp_TGtkTreeViewColumn_visible

proc set_visible*(a: PTreeViewColumn, `visible`: guint) =
  a.TreeViewColumnflag0 = a.TreeViewColumnflag0 or
      (uint16(`visible` shl bp_TGtkTreeViewColumn_visible) and
      bm_TGtkTreeViewColumn_visible)

proc resizable*(a: PTreeViewColumn): guint =
  result = (a.TreeViewColumnflag0 and bm_TGtkTreeViewColumn_resizable) shr
      bp_TGtkTreeViewColumn_resizable

proc set_resizable*(a: PTreeViewColumn, `resizable`: guint) =
  a.TreeViewColumnflag0 = a.TreeViewColumnflag0 or
      (uint16(`resizable` shl bp_TGtkTreeViewColumn_resizable) and
      bm_TGtkTreeViewColumn_resizable)

proc clickable*(a: PTreeViewColumn): guint =
  result = (a.TreeViewColumnflag0 and bm_TGtkTreeViewColumn_clickable) shr
      bp_TGtkTreeViewColumn_clickable

proc set_clickable*(a: PTreeViewColumn, `clickable`: guint) =
  a.TreeViewColumnflag0 = a.TreeViewColumnflag0 or
      (uint16(`clickable` shl bp_TGtkTreeViewColumn_clickable) and
      bm_TGtkTreeViewColumn_clickable)

proc dirty*(a: PTreeViewColumn): guint =
  result = (a.TreeViewColumnflag0 and bm_TGtkTreeViewColumn_dirty) shr
      bp_TGtkTreeViewColumn_dirty

proc set_dirty*(a: PTreeViewColumn, `dirty`: guint) =
  a.TreeViewColumnflag0 = a.TreeViewColumnflag0 or
      (uint16(`dirty` shl bp_TGtkTreeViewColumn_dirty) and
      bm_TGtkTreeViewColumn_dirty)

proc show_sort_indicator*(a: PTreeViewColumn): guint =
  result = (a.TreeViewColumnflag0 and
      bm_TGtkTreeViewColumn_show_sort_indicator) shr
      bp_TGtkTreeViewColumn_show_sort_indicator

proc set_show_sort_indicator*(a: PTreeViewColumn,
                              `show_sort_indicator`: guint) =
  a.TreeViewColumnflag0 = a.TreeViewColumnflag0 or
      (uint16(`show_sort_indicator` shl
      bp_TGtkTreeViewColumn_show_sort_indicator) and
      bm_TGtkTreeViewColumn_show_sort_indicator)

proc maybe_reordered*(a: PTreeViewColumn): guint =
  result = (a.TreeViewColumnflag0 and bm_TGtkTreeViewColumn_maybe_reordered) shr
      bp_TGtkTreeViewColumn_maybe_reordered

proc set_maybe_reordered*(a: PTreeViewColumn, `maybe_reordered`: guint) =
  a.TreeViewColumnflag0 = a.TreeViewColumnflag0 or
      (uint16(`maybe_reordered` shl bp_TGtkTreeViewColumn_maybe_reordered) and
      bm_TGtkTreeViewColumn_maybe_reordered)

proc reorderable*(a: PTreeViewColumn): guint =
  result = (a.TreeViewColumnflag0 and bm_TGtkTreeViewColumn_reorderable) shr
      bp_TGtkTreeViewColumn_reorderable

proc set_reorderable*(a: PTreeViewColumn, `reorderable`: guint) =
  a.TreeViewColumnflag0 = a.TreeViewColumnflag0 or
      (uint16(`reorderable` shl bp_TGtkTreeViewColumn_reorderable) and
      bm_TGtkTreeViewColumn_reorderable)

proc use_resized_width*(a: PTreeViewColumn): guint =
  result = (a.TreeViewColumnflag0 and bm_TGtkTreeViewColumn_use_resized_width) shr
      bp_TGtkTreeViewColumn_use_resized_width

proc set_use_resized_width*(a: PTreeViewColumn, `use_resized_width`: guint) =
  a.TreeViewColumnflag0 = a.TreeViewColumnflag0 or
      (uint16(`use_resized_width` shl bp_TGtkTreeViewColumn_use_resized_width) and
      bm_TGtkTreeViewColumn_use_resized_width)

proc flags*(a: PRBNode): guint =
  result = (a.flag0 and bm_TGtkRBNode_flags) shr bp_TGtkRBNode_flags

proc set_flags*(a: PRBNode, `flags`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`flags` shl bp_TGtkRBNode_flags) and bm_TGtkRBNode_flags)

proc parity*(a: PRBNode): guint =
  result = (a.flag0 and bm_TGtkRBNode_parity) shr bp_TGtkRBNode_parity

proc set_parity*(a: PRBNode, `parity`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`parity` shl bp_TGtkRBNode_parity) and bm_TGtkRBNode_parity)

proc GET_COLOR*(node: PRBNode): guint =
  if node == nil:
    result = RBNODE_BLACK
  elif (int(flags(node)) and RBNODE_RED) == RBNODE_RED:
    result = RBNODE_RED
  else:
    result = RBNODE_BLACK

proc SET_COLOR*(node: PRBNode, color: guint) =
  if node == nil:
    return
  if ((flags(node) and (color)) != color):
    set_flags(node, flags(node) xor uint32(RBNODE_RED or RBNODE_BLACK))

proc GET_HEIGHT*(node: PRBNode): gint =
  var if_local1: gint
  if node.children != nil:
    if_local1 = node.children.root.offset
  else:
    if_local1 = 0
  result = node.offset -
      ((node.left.offset) + node.right.offset + if_local1)

proc FLAG_SET*(node: PRBNode, flag: guint): bool =
  result = (node != nil) and ((flags(node) and (flag)) == flag)

proc SET_FLAG*(node: PRBNode, flag: guint16) =
  set_flags(node, (flag).uint32 or flags(node))

proc UNSET_FLAG*(node: PRBNode, flag: guint16) =
  set_flags(node, (not (flag).uint32) and flags(node))

