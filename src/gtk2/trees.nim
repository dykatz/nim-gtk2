# Included by gtk2.nim. Paths are copied positions, never persistent iterators.
type
  TreePath* = object
    parts: seq[int]
  TreeStore* = object of TreeModel
  ModelPathCallback = ref object
    fn: proc (path: TreePath) {.closure.}

proc raw*(m: TreeStore): rawGtk.PTreeStore = cast[rawGtk.PTreeStore](nativePointer(m))
proc treePath*(indices: varargs[int]): TreePath =
  discard checkedInt(indices.len)
  result.parts = newSeq[int](indices.len)
  for i, index in indices:
    discard checkedInt(index)
    result.parts[i] = index
proc depth*(path: TreePath): int = path.parts.len
proc isRoot*(path: TreePath): bool = path.depth == 0
proc indices*(path: TreePath): seq[int] =
  result = newSeq[int](path.depth)
  for i, index in path.parts: result[i] = index
proc `==`*(a, b: TreePath): bool = a.parts == b.parts
proc `$`*(path: TreePath): string =
  for i, index in path.parts:
    if i > 0: result.add(':')
    result.add($index)
proc childPath*(parent: TreePath, index: int): TreePath =
  discard checkedInt(index)
  discard checkedInt(parent.depth + 1)
  result.parts = newSeq[int](parent.depth + 1)
  for i, part in parent.parts: result.parts[i] = part
  result.parts[^1] = index
proc parentPath*(path: TreePath): TreePath =
  if path.isRoot: raise newException(ValueError, "the virtual root has no parent")
  result.parts = newSeq[int](path.depth - 1)
  for i in 0 ..< result.depth: result.parts[i] = path.parts[i]
proc nativeTreePath(path: TreePath): rawGtk.PTreePath =
  result = rawGtk.tree_path_new()
  for index in path.parts: rawGtk.append_index(result, g.gint(index))
proc copyTreePath(path: rawGtk.PTreePath): TreePath =
  if path == nil: raise newException(ValueError, "GTK returned a nil tree path")
  let count = rawGtk.get_depth(path).int
  result.parts = newSeq[int](count)
  let data = cast[ptr UncheckedArray[g.gint]](rawGtk.get_indices(path))
  for i in 0 ..< count: result.parts[i] = data[i].int
proc isFlat*(m: TreeModel): bool =
  (rawGtk.get_flags(m.raw) and rawGtk.TTreeModelFlags(rawGtk.TREE_MODEL_LIST_ONLY)) != 0
proc hasRow*(m: TreeModel, path: TreePath): bool =
  discard m.raw
  if path.isRoot or (m.isFlat and path.depth != 1): return false
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  var iter: rawGtk.TTreeIter
  g.toBool(rawGtk.get_iter(m.raw, addr iter, native))
proc pathIter(m: TreeModel, path: TreePath): rawGtk.TTreeIter =
  if path.isRoot: raise newException(ValueError, "the virtual root is not a row")
  if m.isFlat and path.depth != 1:
    raise newException(ValueError, "flat models only have one-level paths")
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  if not g.toBool(rawGtk.get_iter(m.raw, addr result, native)):
    raise newException(ValueError, "tree path does not identify an existing row")
proc childCount*(m: TreeModel, parent = treePath()): int =
  var iter: rawGtk.TTreeIter
  var p: rawGtk.PTreeIter
  if not parent.isRoot:
    iter = pathIter(m, parent)
    p = addr iter
  rawGtk.iter_n_children(m.raw, p).int
proc value*(m: TreeModel, path: TreePath, column: int): CellValue =
  var iter = pathIter(m, path)
  iterValue(m, iter, column)

proc newTreeStore*(columns: openArray[CellKind]): TreeStore =
  if columns.len == 0: raise newException(ValueError, "a tree store needs at least one column")
  let count = checkedInt(columns.len)
  var types = newSeq[g.GType](columns.len)
  for i, kind in columns: types[i] = cellType(kind)
  result.state = adoptObject(rawGtk.tree_store_newv(count, addr types[0]),
    cache = true, hasDestroySignal = false, sink = false)
proc writeTreeRow(m: TreeStore, path: TreePath, position: int,
                  values: openArray[CellValue], insert: bool) =
  checkRow(m, values)
  if insert: discard checkedInt(position)
  var columns = newSeq[g.gint](values.len)
  var native = newSeq[g.TGValue](values.len)
  for i, value in values:
    columns[i] = g.gint(i)
    initCell(value, native[i])
  defer:
    for value in native.mitems: g.unset(addr value)
  # Resolve only after preparing values: allocation/finalizers must not leave
  # a stale parent or row iterator waiting across the preparation phase.
  var iter, parent: rawGtk.TTreeIter
  var p: rawGtk.PTreeIter
  if insert:
    if not path.isRoot:
      parent = pathIter(m, path)
      p = addr parent
    if position > rawGtk.iter_n_children(TreeModel(m).raw, p).int:
      raise newException(ValueError, "child insertion index is out of range")
    rawGtk.insert_with_valuesv(m.raw, addr iter, p, g.gint(position),
      addr columns[0], addr native[0], g.gint(values.len))
  else:
    iter = pathIter(m, path)
    rawGtk.set_valuesv(m.raw, addr iter, addr columns[0], addr native[0], g.gint(values.len))
proc insertRow*(m: TreeStore, index: int, values: openArray[CellValue],
                parent = treePath()): TreePath =
  result = parent.childPath(index)
  writeTreeRow(m, parent, index, values, true)
proc appendRow*(m: TreeStore, values: openArray[CellValue], parent = treePath()): TreePath =
  m.insertRow(m.childCount(parent), values, parent)
proc setRow*(m: TreeStore, path: TreePath, values: openArray[CellValue]) =
  writeTreeRow(m, path, 0, values, false)
proc setValue*(m: TreeStore, path: TreePath, column: int, value: CellValue) =
  checkCell(m, column, value)
  var iter = pathIter(m, path)
  var native: g.TGValue
  initCell(value, native)
  defer: g.unset(addr native)
  rawGtk.set_value(m.raw, addr iter, g.gint(column), addr native)
proc removeRow*(m: TreeStore, path: TreePath) =
  var iter = pathIter(m, path)
  discard rawGtk.remove(m.raw, addr iter)
proc clear*(m: TreeStore) = rawGtk.clear(m.raw)

proc releaseModelPathCallback(data: pointer, closure: g.PGClosure) {.cdecl.} =
  GC_unref(cast[ModelPathCallback](data))
proc modelPathThunk(instance: pointer, path: rawGtk.PTreePath, extra, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let fn = cast[ModelPathCallback](data).fn
    try: fn(copyTreePath(path))
    except Exception as error: reportSignalError(error)
proc modelPathDeletedThunk(instance: pointer, path: rawGtk.PTreePath, data: pointer) {.cdecl, gcsafe.} =
  modelPathThunk(instance, path, nil, data)
proc connectModelPath(w: ObjectHandle, name: cstring, fn: proc (path: TreePath) {.closure.},
                      deleted = false): Connection =
  let p = nativePointer(w)
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let callback = ModelPathCallback(fn: fn)
  GC_ref(callback)
  let thunk = if deleted: cast[g.TGCallback](modelPathDeletedThunk) else: cast[g.TGCallback](modelPathThunk)
  let id = g.g_signal_connect_data(p, name, thunk, cast[pointer](callback),
    releaseModelPathCallback, g.G_CONNECT_AFTER)
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)
proc onPathInserted*(m: TreeModel, fn: proc (path: TreePath) {.closure.}): Connection {.discardable.} =
  connectModelPath(m, "row-inserted", fn)
proc onPathChanged*(m: TreeModel, fn: proc (path: TreePath) {.closure.}): Connection {.discardable.} =
  connectModelPath(m, "row-changed", fn)
proc onPathDeleted*(m: TreeModel, fn: proc (path: TreePath) {.closure.}): Connection {.discardable.} =
  connectModelPath(m, "row-deleted", fn, deleted = true)

proc selectedPath*(w: TreeView): TreePath =
  var iter: rawGtk.TTreeIter
  var model: rawGtk.PTreeModel
  if not g.toBool(rawGtk.get_selected(singleSelection(w), addr model, addr iter)): return treePath()
  let path = rawGtk.get_path(model, addr iter)
  defer: rawGtk.free(path)
  copyTreePath(path)
proc `selectedPath=`*(w: TreeView, path: TreePath) =
  if path.isRoot:
    rawGtk.unselect_all(singleSelection(w))
    return
  discard pathIter(w.model, path) # Validate before expanding anything.
  if path.depth > 1:
    let parent = nativeTreePath(path.parentPath)
    try: rawGtk.expand_to_path(w.raw, parent)
    finally: rawGtk.free(parent)
  # Expansion can emit callbacks. Resolve again rather than reuse a stale iter.
  var iter = pathIter(w.model, path)
  rawGtk.select_iter(singleSelection(w), addr iter)
proc onPathActivated*(w: TreeView, fn: proc (path: TreePath) {.closure.}): Connection {.discardable.} =
  connectModelPath(w, "row-activated", fn)
proc activateRow*(w: TreeView, path: TreePath) =
  discard pathIter(w.model, path)
  let native = nativeTreePath(path)
  try: rawGtk.row_activated(w.raw, native, nil)
  finally: rawGtk.free(native)
proc expandPath*(w: TreeView, path: TreePath, recursive = false): bool =
  discard pathIter(w.model, path)
  let native = nativeTreePath(path)
  try: result = g.toBool(rawGtk.expand_row(w.raw, native, g.gbool(recursive)))
  finally: rawGtk.free(native)
proc collapsePath*(w: TreeView, path: TreePath): bool =
  discard pathIter(w.model, path)
  let native = nativeTreePath(path)
  try: result = g.toBool(rawGtk.collapse_row(w.raw, native))
  finally: rawGtk.free(native)
proc pathExpanded*(w: TreeView, path: TreePath): bool =
  discard pathIter(w.model, path)
  let native = nativeTreePath(path)
  try: result = g.toBool(rawGtk.row_expanded(w.raw, native))
  finally: rawGtk.free(native)
proc expandAll*(w: TreeView) = rawGtk.expand_all(w.raw)
proc collapseAll*(w: TreeView) = rawGtk.collapse_all(w.raw)
