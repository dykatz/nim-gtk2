# Included by gtk2.nim. Flat models, fixed bindings, plain text, single selection.
type IconView* = object of Container
proc raw*(w: IconView): ptr rawGtk.IconView = cast[ptr rawGtk.IconView](raw(Widget(w)))
proc model*(w: IconView): TreeModel = ownedTreeModel(rawGtk.icon_view_get_model(w.raw))
proc newIconView*(model: TreeModel, pixbufColumn: int, textColumn = -1): IconView =
  checkFlatModel(model.raw)
  if model.columnKind(pixbufColumn) != cellPixbuf:
    raise newException(ValueError, "icon view requires a pixbuf column")
  if textColumn != -1 and model.columnKind(textColumn) != cellString:
    raise newException(ValueError, "icon view text column must contain strings")
  result.state = adoptWidget(rawGtk.icon_view_new_with_model(model.raw))
  rawGtk.icon_view_set_pixbuf_column(result.raw, g.gint(pixbufColumn))
  rawGtk.icon_view_set_text_column(result.raw, g.gint(textColumn))
  rawGtk.icon_view_set_selection_mode(result.raw, rawGtk.SELECTION_SINGLE)
proc checkIconSelection(w: IconView) =
  checkFlatModel(w.model.raw)
  if rawGtk.icon_view_get_selection_mode(w.raw) != rawGtk.SELECTION_SINGLE:
    raise newException(ValueError, "icon view requires native single selection mode")
proc selectedPath*(w: IconView): TreePath =
  checkIconSelection(w)
  let items = rawGtk.icon_view_get_selected_items(w.raw)
  defer:
    var current = items
    while current != nil:
      rawGtk.free(cast[rawGtk.PTreePath](current.data))
      current = current.next
    g.free(items)
  if items != nil: result = copyTreePath(cast[rawGtk.PTreePath](items.data))
proc selectedIndex*(w: IconView): int =
  let path = w.selectedPath
  if path.isRoot: -1 else: path.indices[0]
proc `selectedPath=`*(w: IconView, path: TreePath) =
  checkIconSelection(w)
  if path.isRoot:
    rawGtk.icon_view_unselect_all(w.raw)
    return
  discard pathIter(w.model, path)
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  rawGtk.icon_view_select_path(w.raw, native)
proc `selectedIndex=`*(w: IconView, index: int) =
  if index == -1: w.selectedPath = treePath()
  else: w.selectedPath = treePath(index)
proc onSelectionChanged*(w: IconView, fn: proc () {.closure.}): Connection {.discardable.} =
  checkIconSelection(w)
  connect(w, "selection-changed", fn, after = true)
proc onPathActivated*(w: IconView, fn: proc (path: TreePath) {.closure.}): Connection {.discardable.} =
  checkIconSelection(w)
  connectModelPath(w, "item-activated", fn, deleted = true)
proc onItemActivated*(w: IconView, fn: proc (index: int) {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  w.onPathActivated(proc (path: TreePath) = fn(path.indices[0]))
proc activateRow*(w: IconView, index: int) =
  checkIconSelection(w)
  discard rowIter(w.model, index)
  let native = nativeTreePath(treePath(index))
  defer: rawGtk.free(native)
  rawGtk.icon_view_item_activated(w.raw, native)
proc scrollToRow*(w: IconView, index: int) =
  discard rowIter(w.model, index)
  let native = nativeTreePath(treePath(index))
  defer: rawGtk.free(native)
  rawGtk.icon_view_scroll_to_path(w.raw, native, g.gbool(false), 0, 0)
proc iconAutoSize(value: int): g.gint =
  if value == 0: raise newException(ValueError, "use -1 for automatic icon sizing")
  sizeRequestValue(value)
proc columns*(w: IconView): int = rawGtk.icon_view_get_columns(w.raw).int
proc `columns=`*(w: IconView, value: int) = rawGtk.icon_view_set_columns(w.raw, iconAutoSize(value))
proc itemWidth*(w: IconView): int = rawGtk.icon_view_get_item_width(w.raw).int
proc `itemWidth=`*(w: IconView, value: int) = rawGtk.icon_view_set_item_width(w.raw, iconAutoSize(value))
proc spacing*(w: IconView): int = rawGtk.icon_view_get_spacing(w.raw).int
proc `spacing=`*(w: IconView, value: int) = rawGtk.icon_view_set_spacing(w.raw, checkedInt(value))
proc rowSpacing*(w: IconView): int = rawGtk.icon_view_get_row_spacing(w.raw).int
proc `rowSpacing=`*(w: IconView, value: int) = rawGtk.icon_view_set_row_spacing(w.raw, checkedInt(value))
proc columnSpacing*(w: IconView): int = rawGtk.icon_view_get_column_spacing(w.raw).int
proc `columnSpacing=`*(w: IconView, value: int) = rawGtk.icon_view_set_column_spacing(w.raw, checkedInt(value))
proc margin*(w: IconView): int = rawGtk.icon_view_get_margin(w.raw).int
proc `margin=`*(w: IconView, value: int) = rawGtk.icon_view_set_margin(w.raw, checkedInt(value))
