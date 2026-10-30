# Included by gtk2.nim. Read-only proxies and boxed stable row references.
type
  SortOrder* = enum
    sortAscending, sortDescending
  TreeModelSort* = object of TreeModel
  TreeModelFilter* = object of TreeModel
  RowReferenceStateObj = object
    p: rawGtk.PTreeRowReference
  RowReferenceState = ref RowReferenceStateObj
  TreeRowReference* = object
    state: RowReferenceState
  ReorderedCallback = ref object
    fn: proc (parent: TreePath, order: seq[int]) {.closure.}

proc `=destroy`(s: var RowReferenceStateObj) =
  if s.p != nil: rawGtk.reference_free(s.p)
proc raw*(m: TreeModelSort): rawGtk.PTreeModelSort = cast[rawGtk.PTreeModelSort](nativePointer(m))
proc raw*(m: TreeModelFilter): ptr rawGtk.TreeModelFilter = cast[ptr rawGtk.TreeModelFilter](nativePointer(m))
proc raw*(r: TreeRowReference): rawGtk.PTreeRowReference =
  if r.state == nil: raise newException(ValueError, "row reference is uninitialized")
  r.state.p

proc newTreeRowReference*(model: TreeModel, path: TreePath): TreeRowReference =
  discard pathIter(model, path)
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  new(result.state)
  result.state.p = rawGtk.row_reference_new(model.raw, native)
  if result.state.p == nil: raise newException(ValueError, "GTK could not reference this row")
proc valid*(r: TreeRowReference): bool =
  r.state != nil and g.toBool(rawGtk.reference_valid(r.state.p))
proc path*(r: TreeRowReference): TreePath =
  if not r.valid: raise newException(ValueError, "row reference no longer identifies a row")
  let native = rawGtk.reference_get_path(r.raw)
  if native == nil: raise newException(ValueError, "GTK could not resolve the referenced row")
  defer: rawGtk.free(native)
  copyTreePath(native)
proc model*(r: TreeRowReference): TreeModel = ownedTreeModel(rawGtk.reference_get_model(r.raw))

proc childModel*(m: TreeModelSort): TreeModel = ownedTreeModel(rawGtk.sort_get_model(m.raw))
proc childModel*(m: TreeModelFilter): TreeModel = ownedTreeModel(rawGtk.tree_model_filter_get_model(m.raw))
proc sortBy*(m: TreeModelSort, column: int, order = sortAscending) =
  if m.columnKind(column) == cellPixbuf:
    raise newException(ValueError, "pixbuf columns cannot be sorted")
  rawGtk.set_sort_column_id(cast[rawGtk.PTreeSortable](m.raw), g.gint(column), rawGtk.TSortType(ord(order)))
proc newTreeModelSort*(child: TreeModel, column: int, order = sortAscending): TreeModelSort =
  if child.columnKind(column) == cellPixbuf:
    raise newException(ValueError, "pixbuf columns cannot be sorted")
  result.state = adoptObject(rawGtk.sort_new(child.raw), cache = true,
    hasDestroySignal = false, sink = false)
  result.sortBy(column, order)
proc sortConfiguration(m: TreeModelSort): tuple[column: int, order: SortOrder] =
  var column: g.gint
  var order: rawGtk.TSortType
  if not g.toBool(rawGtk.get_sort_column_id(cast[rawGtk.PTreeSortable](m.raw), addr column, addr order)):
    raise newException(ValueError, "sort proxy has no supported column sort configured")
  (column.int, SortOrder(order))
proc sortColumn*(m: TreeModelSort): int = m.sortConfiguration.column
proc sortOrder*(m: TreeModelSort): SortOrder = m.sortConfiguration.order
proc newTreeModelFilter*(child: TreeModel, visibleColumn: int): TreeModelFilter =
  if child.columnKind(visibleColumn) != cellBool:
    raise newException(ValueError, "filter visibility column must be boolean")
  result.state = adoptObject(rawGtk.tree_model_filter_new(child.raw, nil), cache = true,
    hasDestroySignal = false, sink = false)
  rawGtk.tree_model_filter_set_visible_column(result.raw, g.gint(visibleColumn))
proc refilter*(m: TreeModelFilter) = rawGtk.tree_model_filter_refilter(m.raw)

proc toChildPath*(m: TreeModelSort, path: TreePath): TreePath =
  discard pathIter(m, path)
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  let converted = rawGtk.tree_model_sort_convert_path_to_child_path(m.raw, native)
  if converted == nil: raise newException(ValueError, "proxy path has no child position")
  defer: rawGtk.free(converted)
  copyTreePath(converted)
proc fromChildPath*(m: TreeModelSort, path: TreePath): TreePath =
  discard pathIter(m.childModel, path)
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  let converted = rawGtk.tree_model_sort_convert_child_path_to_path(m.raw, native)
  if converted == nil: return treePath()
  defer: rawGtk.free(converted)
  copyTreePath(converted)
proc toChildPath*(m: TreeModelFilter, path: TreePath): TreePath =
  discard pathIter(m, path)
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  let converted = rawGtk.tree_model_filter_convert_path_to_child_path(m.raw, native)
  if converted == nil: raise newException(ValueError, "proxy path has no child position")
  defer: rawGtk.free(converted)
  copyTreePath(converted)
proc fromChildPath*(m: TreeModelFilter, path: TreePath): TreePath =
  discard pathIter(m.childModel, path)
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  let converted = rawGtk.tree_model_filter_convert_child_path_to_path(m.raw, native)
  if converted == nil: return treePath() # Hidden row/ancestor: no proxy position.
  defer: rawGtk.free(converted)
  copyTreePath(converted)

proc releaseReorderedCallback(data: pointer, closure: g.PGClosure) {.cdecl.} =
  GC_unref(cast[ReorderedCallback](data))
proc reorderedThunk(instance: pointer, path: rawGtk.PTreePath, iter: rawGtk.PTreeIter,
                    order: ptr g.gint, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let fn = cast[ReorderedCallback](data).fn
    try:
      let parent = copyTreePath(path)
      let count = rawGtk.iter_n_children(cast[rawGtk.PTreeModel](instance), iter).int
      if count > 0 and order == nil: raise newException(ValueError, "GTK returned a nil reorder array")
      var copied = newSeq[int](count)
      let indices = cast[ptr UncheckedArray[g.gint]](order)
      for i in 0 ..< count: copied[i] = indices[i].int
      fn(parent, copied)
    except Exception as error: reportSignalError(error)
proc onRowsReordered*(m: TreeModel, fn: proc (parent: TreePath, order: seq[int]) {.closure.}): Connection {.discardable.} =
  let p = m.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let callback = ReorderedCallback(fn: fn)
  GC_ref(callback)
  let id = g.g_signal_connect_data(p, "rows-reordered", cast[g.TGCallback](reorderedThunk),
    cast[pointer](callback), releaseReorderedCallback, g.G_CONNECT_AFTER)
  m.state.handlers.add(id)
  Connection(state: m.state, id: id)
