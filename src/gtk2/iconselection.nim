# Included by gtk2.nim. Fixed model/layout, copied idle observations.
type IconSelection* = object
  mode*: TreeSelectionMode # Shared selectionNone/Single/Browse/Multiple values.
  model*: TreeModel
  paths*: seq[TreePath]
  rows*: seq[TreeRowReference]
proc selectionMode*(w: IconView): TreeSelectionMode =
  TreeSelectionMode(rawGtk.icon_view_get_selection_mode(w.raw))
proc `selectionMode=`*(w: IconView, mode: TreeSelectionMode) =
  let p = w.raw
  if w.selectionMode == mode: return
  # BROWSE ignores unselect_all, including the call made by set_mode(NONE).
  # Leave it first using only the public API, then clear selection through NONE.
  if w.selectionMode == selectionBrowse:
    rawGtk.icon_view_set_selection_mode(p, rawGtk.SELECTION_SINGLE)
  if w.isDestroyed: return
  rawGtk.icon_view_set_selection_mode(p, rawGtk.SELECTION_NONE)
  if not w.isDestroyed:
    rawGtk.icon_view_set_selection_mode(p, rawGtk.TSelectionMode(ord(mode)))
  # GtkIconView exposes no public clear-cursor/anchor operation. Do not reset its
  # fixed model or access private anchor_item fields to simulate one.
proc selectedPaths*(w: IconView): seq[TreePath] =
  checkFlatModel(w.model.raw)
  let list = rawGtk.icon_view_get_selected_items(w.raw)
  defer:
    var node = list
    while node != nil:
      rawGtk.free(cast[rawGtk.PTreePath](node.data))
      node = node.next
    g.free(list)
  var node = list
  while node != nil:
    result.add(copyTreePath(cast[rawGtk.PTreePath](node.data)))
    node = node.next
  uiAlgorithm.sort(result, proc (a, b: TreePath): int = cmp(a.parts[0], b.parts[0]))
proc selectedIndices*(w: IconView): seq[int] =
  for path in w.selectedPaths: result.add(path.parts[0])
proc selectedRows*(w: IconView): seq[TreeRowReference] =
  let model = w.model
  for path in w.selectedPaths: result.add(newTreeRowReference(model, path))
proc selection*(w: IconView): IconSelection =
  result.mode = w.selectionMode
  result.model = w.model
  result.paths = w.selectedPaths
  for path in result.paths: result.rows.add(newTreeRowReference(result.model, path))
proc `selectedPaths=`*(w: IconView, paths: openArray[TreePath]) =
  if w.selectionMode != selectionMultiple:
    raise newException(ValueError, "selectedPaths assignment requires multiple icon selection")
  let model = w.model
  var rows: seq[TreeRowReference]
  for path in paths: rows.add(newTreeRowReference(model, path))
  let p = w.raw
  rawGtk.icon_view_unselect_all(p)
  for row in rows:
    if w.isDestroyed: return
    if w.selectionMode != selectionMultiple or w.model.raw != model.raw: return
    if row.valid:
      let path = nativeTreePath(row.path)
      defer: rawGtk.free(path)
      rawGtk.icon_view_select_path(p, path)
proc `selectedIndices=`*(w: IconView, indices: openArray[int]) =
  var paths: seq[TreePath]
  for index in indices: paths.add(treePath(index))
  w.selectedPaths = paths
proc selectAll*(w: IconView) =
  if w.selectionMode != selectionMultiple:
    raise newException(ValueError, "selectAll requires multiple icon selection")
  rawGtk.icon_view_select_all(w.raw)
proc unselectAll*(w: IconView) =
  if w.selectionMode == selectionBrowse:
    raise newException(ValueError, "browse icon selection cannot be cleared; change mode first")
  rawGtk.icon_view_unselect_all(w.raw)
proc pathSelected*(w: IconView, path: TreePath): bool =
  discard pathIter(w.model, path)
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  g.toBool(rawGtk.icon_view_path_is_selected(w.raw, native))
proc selectPath*(w: IconView, path: TreePath) =
  if w.selectionMode == selectionNone: raise newException(ValueError, "icon selection is disabled")
  discard pathIter(w.model, path)
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  rawGtk.icon_view_select_path(w.raw, native)
proc unselectPath*(w: IconView, path: TreePath) =
  if w.selectionMode == selectionBrowse:
    raise newException(ValueError, "browse icon selection cannot be cleared; change mode first")
  discard pathIter(w.model, path)
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  rawGtk.icon_view_unselect_path(w.raw, native)
proc cursorPath*(w: IconView): TreePath =
  var path: rawGtk.PTreePath
  discard rawGtk.icon_view_get_cursor(w.raw, addr path, nil)
  if path != nil:
    defer: rawGtk.free(path)
    result = copyTreePath(path)
proc `cursorPath=`*(w: IconView, path: TreePath) =
  discard pathIter(w.model, path)
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  rawGtk.icon_view_set_cursor(w.raw, native, nil, g.gbool(false))
proc iconSelectionThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueRecent(data, true)
proc connectIconSelection(w: IconView, fn: proc () {.closure.}): Connection =
  if fn == nil: raise newException(ValueError, "selection callback cannot be nil")
  connectRecent(w, "selection-changed", proc (unused: bool) = fn(),
    cast[g.TGCallback](iconSelectionThunk), coalesce = true)
proc onSelectionChanged*(w: IconView, fn: proc (value: IconSelection) {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "selection callback cannot be nil")
  let p = w.raw # Weak: native destruction disconnects/cancels the binding.
  connectRecent(w, "selection-changed", proc (unused: bool) =
    let owner = IconView(state: adoptObject(p, borrowed = true, cache = true))
    fn(owner.selection), cast[g.TGCallback](iconSelectionThunk), coalesce = true)
proc iconActivatedThunk(instance: pointer, path: rawGtk.PTreePath, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let model = ownedTreeModel(rawGtk.icon_view_get_model(cast[ptr rawGtk.IconView](instance)))
      let copy = copyTreePath(path)
      queueRecent(data, IconActivation(path: copy, row: newTreeRowReference(model, copy)))
    except Exception as error: reportSignalError(error)
proc onActivated*(w: IconView, fn: proc (value: IconActivation) {.closure.}): Connection {.discardable.} =
  checkFlatModel(w.model.raw)
  connectRecent(w, "item-activated", fn, cast[g.TGCallback](iconActivatedThunk))
