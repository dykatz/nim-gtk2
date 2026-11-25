# GTK's native same-widget row MOVE mode, configured before realization.
const rowDragKey = "nim-gtk2-native-row-drag"

proc rowDragReorderEnabled*(w: TreeView): bool =
  ## Reports the native mode, not whether a particular drop would be accepted.
  g.toBool(rawGtk.get_reorderable(w.raw))

proc rowDragReorderEnabled*(w: IconView): bool =
  ## Reports the native mode, not whether a particular drop would be accepted.
  g.toBool(rawGtk.icon_view_get_reorderable(w.raw))

proc prepareRowDrag(w: rawGtk.PWidget, m: rawGtk.PTreeModel,
                    icon, enabled: bool): bool =
  if g.toBool(rawGtk.get_realized(w)):
    raise newException(ValueError, "configure row drag before view realization")
  let kind = g.G_OBJECT_TYPE(w)
  if kind != (if icon: rawGtk.icon_view_get_type() else: rawGtk.tree_view_get_type()):
    raise newException(ValueError, "row drag requires an ordinary TreeView or IconView")
  if m == nil or (g.G_OBJECT_TYPE(m) != rawGtk.list_store_get_type() and
      (icon or g.G_OBJECT_TYPE(m) != rawGtk.tree_store_get_type())):
    raise newException(ValueError, "row drag requires a direct native ListStore or TreeStore (ListStore only for IconView)")
  const unsortedColumn = -2.gint # GTK_TREE_SORTABLE_UNSORTED_SORT_COLUMN_ID
  var column: g.gint
  discard rawGtk.get_sort_column_id(cast[rawGtk.PTreeSortable](m), addr column, nil)
  if column != unsortedColumn:
    raise newException(ValueError, "row drag requires an unsorted model")
  let obj = cast[g.PGObject](w)
  if enabled and g.get_data(obj, rowDragKey) != nil: return false
  if enabled or rawGtk.drag_source_get_target_list(w) != nil or
      rawGtk.drag_dest_get_target_list(w) != nil:
    raise newException(ValueError, "view already has a native drag/drop site")
  # Set before the native setter can emit notify::reorderable. Only a marker;
  # GTK itself owns the sites, model row references, and active protocol state.
  g.set_data(obj, rowDragKey, w)
  true

proc enableRowDragReorder*(w: TreeView) =
  ## Enable same-view native MOVE for an unsorted direct ListStore or TreeStore.
  let p = w.raw
  let widget = cast[rawGtk.PWidget](p)
  if prepareRowDrag(widget, rawGtk.get_model(p), false, w.rowDragReorderEnabled):
    discard g.g_object_ref(widget)
    defer: g.g_object_unref(widget)
    rawGtk.set_reorderable(p, g.gbool(true))

proc enableRowDragReorder*(w: IconView) =
  ## Enable same-view native MOVE for an unsorted direct ListStore.
  let p = w.raw
  let widget = cast[rawGtk.PWidget](p)
  if prepareRowDrag(widget, rawGtk.icon_view_get_model(p), true, w.rowDragReorderEnabled):
    discard g.g_object_ref(widget)
    defer: g.g_object_unref(widget)
    rawGtk.icon_view_set_reorderable(p, g.gbool(true))
