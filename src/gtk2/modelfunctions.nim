# Included by gtk2.nim. Synchronous functions see copied rows, never native iters.
type
  ModelRow* = object
    path*: TreePath
    values*: seq[CellValue]
  ModelCompare* = proc (a, b: ModelRow): int {.closure.}
  ModelPredicate* = proc (row: ModelRow): bool {.closure.}
  TextCellData* = object
    text*: string
    bold*, italic*, dimmed*, foregroundSet*: bool
    foreground*: Color
  TextCellFunction* = proc (row: ModelRow): TextCellData {.closure.}
  ModelFunctionState = ref object
    active: bool
    compare: ModelCompare
    predicate: ModelPredicate
    present: TextCellFunction
  ModelFunctionConnection* = object
    state: ModelFunctionState
  ModelFunctionSlot = ref object
    nativeRefs: int
    current: ModelFunctionState
    boundColumn: int
  PixbufColumn* = object of ObjectHandle
    boundColumn: int
    renderer: ObjectHandle
const modelFunctionKey = "nim-gtk2-model-function"
const cellFunctionKey = "nim-gtk2-cell-function"

proc deactivateFunction(s: ModelFunctionState) =
  s.active = false
  s.compare = nil
  s.predicate = nil
  s.present = nil
proc connected*(c: ModelFunctionConnection): bool = c.state != nil and c.state.active
proc disconnect*(c: ModelFunctionConnection) =
  requireOutsideModelFunction()
  if c.connected: deactivateFunction(c.state)
proc releaseFunctionRoot(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: GC_unref(cast[ModelFunctionSlot](data))
proc releaseNativeFunction(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let slot = cast[ModelFunctionSlot](data)
    dec slot.nativeRefs
    if slot.nativeRefs == 0: deactivateFunction(slot.current)
    GC_unref(slot)
proc retainNativeFunction(slot: ModelFunctionSlot) =
  inc slot.nativeRefs
  GC_ref(slot)
proc installFunctionRoot(p: pointer, key: cstring, slot: ModelFunctionSlot) =
  GC_ref(slot)
  g.set_data_full(cast[g.PGObject](p), key, cast[pointer](slot), releaseFunctionRoot)
proc functionSlot(p: pointer, key: cstring): ModelFunctionSlot =
  result = cast[ModelFunctionSlot](g.get_data(cast[g.PGObject](p), key))
  if result == nil or result.nativeRefs == 0:
    raise newException(ValueError, "object has no SDK model function")
proc functionConnection*(m: TreeModel): ModelFunctionConnection =
  ModelFunctionConnection(state: functionSlot(m.raw, modelFunctionKey).current)
proc functionConnection*(c: TextColumn): ModelFunctionConnection =
  ModelFunctionConnection(state: functionSlot(c.raw, cellFunctionKey).current)
proc copyModelRow(model: rawGtk.PTreeModel, iter: rawGtk.PTreeIter): ModelRow =
  let m = ownedTreeModel(model)
  let path = rawGtk.get_path(model, iter)
  if path == nil: raise newException(ValueError, "model function row has no path")
  defer: rawGtk.free(path)
  result.path = copyTreePath(path)
  var copy = iter[]
  for column in 0..<m.columnCount: result.values.add(iterValue(m, copy, column))
proc compareRows(model: rawGtk.PTreeModel, a, b: rawGtk.PTreeIter,
                 data: pointer): g.gint {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let state = cast[ModelFunctionSlot](data).current
      if not state.active: return 0
      let left = copyModelRow(model, a)
      let right = copyModelRow(model, b)
      var value: int
      inc modelFunctionDepth
      try: value = state.compare(left, right)
      finally: dec modelFunctionDepth
      result = if value < 0: -1 else: (if value > 0: 1 else: 0)
    except Exception as error: reportSignalError(error)
proc visibleRow(model: rawGtk.PTreeModel, iter: rawGtk.PTreeIter,
                data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      let state = cast[ModelFunctionSlot](data).current
      if not state.active: return g.gbool(true)
      let row = copyModelRow(model, iter)
      inc modelFunctionDepth
      try: result = g.gbool(state.predicate(row))
      finally: dec modelFunctionDepth
    except Exception as error:
      reportSignalError(error)
      result = g.gbool(false)
proc checkFunctionSchema(child: TreeModel) =
  for i in 0..<child.columnCount: discard child.columnKind(i)
proc setCompare*(m: TreeModelSort, fn: ModelCompare, order = sortAscending): ModelFunctionConnection {.discardable.} =
  let p = m.raw
  if fn == nil: raise newException(ValueError, "comparison cannot be nil")
  checkFunctionSchema(m.childModel)
  let slot = ModelFunctionSlot(current: ModelFunctionState(active: true, compare: fn))
  # GTK2 ignores order changes while DEFAULT is selected; leave it first.
  rawGtk.set_sort_column_id(cast[rawGtk.PTreeSortable](p), -2, rawGtk.TSortType(ord(order)))
  installFunctionRoot(p, modelFunctionKey, slot)
  retainNativeFunction(slot)
  rawGtk.set_default_sort_func(cast[rawGtk.PTreeSortable](p), compareRows,
    cast[pointer](slot), releaseNativeFunction)
  rawGtk.set_sort_column_id(cast[rawGtk.PTreeSortable](p), -1, rawGtk.TSortType(ord(order)))
  ModelFunctionConnection(state: slot.current)
proc newTreeModelSort*(child: TreeModel, fn: ModelCompare, order = sortAscending): TreeModelSort =
  if fn == nil: raise newException(ValueError, "comparison cannot be nil")
  checkFunctionSchema(child)
  result.state = adoptObject(rawGtk.sort_new(child.raw), cache = true,
    hasDestroySignal = false, sink = false)
  discard result.setCompare(fn, order)
proc resort*(m: TreeModelSort) =
  let p = m.raw
  let slot = functionSlot(p, modelFunctionKey)
  if m.sortColumn != -1: raise newException(ValueError, "resort requires the custom default comparison to be selected")
  # The public setter sorts even when its callback is unchanged. Keep the old
  # native data pin valid through GTK's destroy-then-replace sequence.
  retainNativeFunction(slot)
  rawGtk.set_default_sort_func(cast[rawGtk.PTreeSortable](p), compareRows,
    cast[pointer](slot), releaseNativeFunction)
proc newTreeModelFilter*(child: TreeModel, fn: ModelPredicate): TreeModelFilter =
  if fn == nil: raise newException(ValueError, "predicate cannot be nil")
  checkFunctionSchema(child)
  result.state = adoptObject(rawGtk.tree_model_filter_new(child.raw, nil), cache = true,
    hasDestroySignal = false, sink = false)
  let slot = ModelFunctionSlot(current: ModelFunctionState(active: true, predicate: fn))
  installFunctionRoot(result.raw, modelFunctionKey, slot)
  retainNativeFunction(slot)
  rawGtk.tree_model_filter_set_visible_func(result.raw, visibleRow, cast[pointer](slot), releaseNativeFunction)
proc setPredicate*(m: TreeModelFilter, fn: ModelPredicate): ModelFunctionConnection {.discardable.} =
  let slot = functionSlot(m.raw, modelFunctionKey)
  if fn == nil: raise newException(ValueError, "predicate cannot be nil")
  deactivateFunction(slot.current)
  slot.current = ModelFunctionState(active: true, predicate: fn)
  ModelFunctionConnection(state: slot.current)

proc applyTextCell(renderer: ObjectHandle, value: TextCellData) =
  discard checkedUtf8Text(value.text)
  if value.foregroundSet and value.foreground.alpha != 65535:
    raise newException(ValueError, "cell foreground does not support alpha")
  let p = nativePointer(renderer)
  var text = typedProperty(p, "text")
  defer: g.unset(addr text)
  g.set_string(addr text, value.text.cstring)
  g.set_property(cast[g.PGObject](p), "text", addr text)
  setIntegerProperty(renderer, "weight", if value.bold: 700 else: 400)
  setIntegerProperty(renderer, "style", if value.italic: 2 else: 0, true)
  setBooleanProperty(renderer, "weight-set", value.bold)
  setBooleanProperty(renderer, "style-set", value.italic)
  setBooleanProperty(renderer, "sensitive", not value.dimmed)
  if value.foregroundSet:
    var color = typedProperty(p, "foreground-gdk")
    defer: g.unset(addr color)
    var native = TColor(red: value.foreground.red, green: value.foreground.green, blue: value.foreground.blue)
    g.set_boxed(addr color, addr native)
    g.set_property(cast[g.PGObject](p), "foreground-gdk", addr color)
  setBooleanProperty(renderer, "foreground-set", value.foregroundSet)
proc presentCell(column: rawGtk.PTreeViewColumn, cell: rawGtk.PCellRenderer,
                 model: rawGtk.PTreeModel, iter: rawGtk.PTreeIter, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    var fallback: TextCellData
    try:
      let slot = cast[ModelFunctionSlot](data)
      let state = slot.current
      let row = copyModelRow(model, iter)
      fallback.text = row.values[slot.boundColumn].stringValue
      var value = fallback
      if state.active:
        inc modelFunctionDepth
        try: value = state.present(row)
        finally: dec modelFunctionDepth
      let renderer = ObjectHandle(state: adoptObject(cell, borrowed = true))
      try: applyTextCell(renderer, value)
      except Exception as error:
        reportSignalError(error)
        applyTextCell(renderer, fallback)
    except Exception as error:
      reportSignalError(error)
      try: applyTextCell(ObjectHandle(state: adoptObject(cell, borrowed = true)), fallback)
      except Exception as nested: reportSignalError(nested)
proc setCellData*(c: TextColumn, fn: TextCellFunction): ModelFunctionConnection {.discardable.} =
  let p = c.raw
  if fn == nil: raise newException(ValueError, "cell function cannot be nil")
  let slot = ModelFunctionSlot(boundColumn: c.boundColumn,
    current: ModelFunctionState(active: true, present: fn))
  installFunctionRoot(p, cellFunctionKey, slot)
  retainNativeFunction(slot)
  rawGtk.column_set_cell_data_func(p, cast[rawGtk.PCellRenderer](nativePointer(c.renderer)),
    presentCell, cast[pointer](slot), releaseNativeFunction)
  ModelFunctionConnection(state: slot.current)
proc refreshCells*(c: TextColumn) = rawGtk.column_queue_resize(c.raw)
proc clearCellData*(c: TextColumn) =
  let p = c.raw
  let slot = cast[ModelFunctionSlot](g.get_data(cast[g.PGObject](p), cellFunctionKey))
  if slot == nil or slot.nativeRefs == 0: return
  applyTextCell(c.renderer, TextCellData())
  rawGtk.column_set_cell_data_func(p, cast[rawGtk.PCellRenderer](nativePointer(c.renderer)), nil, nil, nil)
  g.set_data(cast[g.PGObject](p), cellFunctionKey, nil)

proc raw*(c: PixbufColumn): rawGtk.PTreeViewColumn = cast[rawGtk.PTreeViewColumn](nativePointer(c))
proc newPixbufColumn*(title: string, modelColumn: int): PixbufColumn =
  let text = checkedUtf8Text(title)
  let index = checkedInt(modelColumn)
  result.state = adoptObject(rawGtk.tree_view_column_new())
  result.boundColumn = modelColumn
  result.renderer.state = adoptObject(rawGtk.cell_renderer_pixbuf_new())
  let renderer = cast[rawGtk.PCellRenderer](nativePointer(result.renderer))
  rawGtk.column_pack_start(result.raw, renderer, g.gbool(false))
  rawGtk.column_add_attribute(result.raw, renderer, "pixbuf", index)
  rawGtk.column_set_title(result.raw, text)
proc appendColumn*(w: TreeView, column: PixbufColumn) =
  if rawGtk.column_get_tree_view(column.raw) != nil:
    raise newException(ValueError, "column is already attached to a tree view")
  if w.model.columnKind(column.boundColumn) != cellPixbuf:
    raise newException(ValueError, "pixbuf columns require a pixbuf model column")
  discard rawGtk.append_column(w.raw, column.raw)
proc appendPixbufColumn*(w: TreeView, title: string, modelColumn: int): PixbufColumn =
  result = newPixbufColumn(title, modelColumn)
  w.appendColumn(result)
proc disconnectSignals*(c: PixbufColumn) =
  disconnectObjectSignals(c.renderer)
  disconnectObjectSignals(c)
proc title*(c: PixbufColumn): string = $rawGtk.column_get_title(c.raw)
proc `title=`*(c: PixbufColumn, value: string) = rawGtk.column_set_title(c.raw, checkedUtf8Text(value))
proc visible*(c: PixbufColumn): bool = g.toBool(rawGtk.column_get_visible(c.raw))
proc `visible=`*(c: PixbufColumn, value: bool) = rawGtk.column_set_visible(c.raw, g.gbool(value))
proc resizable*(c: PixbufColumn): bool = g.toBool(rawGtk.column_get_resizable(c.raw))
proc `resizable=`*(c: PixbufColumn, value: bool) = rawGtk.column_set_resizable(c.raw, g.gbool(value))
