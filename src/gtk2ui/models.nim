# Included by gtk2ui.nim. Typed models and text-cell views.
type
  CellKind* = enum
    cellString, cellInt, cellBool, cellFloat
  CellValue* = object
    case kind*: CellKind
    of cellString: stringValue*: string
    of cellInt: intValue*: int32
    of cellBool: boolValue*: bool
    of cellFloat: floatValue*: float64
  TreeModel* = object of ObjectHandle
  ListStore* = object of TreeModel
  TreeView* = object of Container
  TextColumn* = object of ObjectHandle
    boundColumn: int
  ModelComboBox* = object of ComboBox
  ModelRowCallback = ref object
    fn: proc (row: int) {.closure.}

proc raw*(m: TreeModel): rawGtk.PTreeModel = cast[rawGtk.PTreeModel](nativePointer(m))
proc raw*(m: ListStore): rawGtk.PListStore = cast[rawGtk.PListStore](nativePointer(m))
proc raw*(w: TreeView): rawGtk.PTreeView = cast[rawGtk.PTreeView](raw(Widget(w)))
proc raw*(c: TextColumn): rawGtk.PTreeViewColumn = cast[rawGtk.PTreeViewColumn](nativePointer(c))

proc cell*(value: string): CellValue =
  discard checkedUtf8Text(value)
  CellValue(kind: cellString, stringValue: value)
proc cell*(value: bool): CellValue = CellValue(kind: cellBool, boolValue: value)
proc cell*[T: SomeInteger](value: T): CellValue =
  when T is SomeUnsignedInt:
    if uint64(value) > uint64(high(g.gint)):
      raise newException(ValueError, "model integer must fit a signed gint")
  else:
    if int64(value) < int64(low(g.gint)) or int64(value) > int64(high(g.gint)):
      raise newException(ValueError, "model integer must fit a signed gint")
  CellValue(kind: cellInt, intValue: int32(value))
proc cell*[T: SomeFloat](value: T): CellValue =
  CellValue(kind: cellFloat, floatValue: finite(float64(value)))
proc cellType(kind: CellKind): g.GType =
  case kind
  of cellString: g.G_TYPE_STRING
  of cellInt: g.G_TYPE_INT
  of cellBool: g.G_TYPE_BOOLEAN
  of cellFloat: g.G_TYPE_DOUBLE
proc checkFlatModel(p: rawGtk.PTreeModel) =
  if p == nil: raise newException(ValueError, "widget has no model")
  if (rawGtk.get_flags(p) and rawGtk.TTreeModelFlags(rawGtk.TREE_MODEL_LIST_ONLY)) == 0:
    raise newException(ValueError, "this API requires a flat list model")
proc ownedTreeModel(p: rawGtk.PTreeModel): TreeModel =
  if p == nil: raise newException(ValueError, "widget has no model")
  result.state = adoptObject(p, borrowed = true, cache = true, hasDestroySignal = false)
proc newListStore*(columns: openArray[CellKind]): ListStore =
  if columns.len == 0: raise newException(ValueError, "a list store needs at least one column")
  let count = checkedInt(columns.len)
  var types = newSeq[g.GType](columns.len)
  for i, kind in columns: types[i] = cellType(kind)
  result.state = adoptObject(rawGtk.list_store_newv(count, addr types[0]),
    cache = true, hasDestroySignal = false, sink = false)
proc columnCount*(m: TreeModel): int = rawGtk.get_n_columns(m.raw).int
proc rowCount*(m: TreeModel): int = rawGtk.iter_n_children(m.raw, nil).int
proc columnKind*(m: TreeModel, column: int): CellKind =
  let index = checkedInt(column)
  if column >= m.columnCount: raise newException(ValueError, "model column is out of range")
  let native = rawGtk.get_column_type(m.raw, index)
  for kind in CellKind:
    if native == cellType(kind): return kind
  raise newException(ValueError, "unsupported model column type")
proc rowIter(m: TreeModel, row: int): rawGtk.TTreeIter =
  checkFlatModel(m.raw)
  let index = checkedInt(row)
  if not g.toBool(rawGtk.iter_nth_child(m.raw, addr result, nil, index)):
    raise newException(ValueError, "model row is out of range")
proc iterValue(m: TreeModel, iter: var rawGtk.TTreeIter, column: int): CellValue =
  let kind = m.columnKind(column)
  var value: g.TGValue # gtk_tree_model_get_value initializes an unset GValue.
  rawGtk.get_value(m.raw, addr iter, g.gint(column), addr value)
  defer: g.unset(addr value)
  case kind
  of cellString: CellValue(kind: cellString, stringValue: $g.get_string(addr value))
  of cellInt: CellValue(kind: cellInt, intValue: g.get_int(addr value))
  of cellBool: CellValue(kind: cellBool, boolValue: g.toBool(g.get_boolean(addr value)))
  of cellFloat: CellValue(kind: cellFloat, floatValue: g.get_double(addr value))
proc value*(m: TreeModel, row, column: int): CellValue =
  var iter = rowIter(m, row)
  iterValue(m, iter, column)
proc checkCell(m: TreeModel, column: int, value: CellValue) =
  if m.columnKind(column) != value.kind:
    raise newException(ValueError, "cell kind does not match the model column")
  case value.kind
  of cellString: discard checkedUtf8Text(value.stringValue)
  of cellFloat: discard finite(value.floatValue)
  else: discard
proc initCell(value: CellValue, native: var g.TGValue) =
  discard g.init(addr native, cellType(value.kind))
  case value.kind
  of cellString: g.set_string(addr native, value.stringValue.cstring)
  of cellInt: g.set_int(addr native, value.intValue)
  of cellBool: g.set_boolean(addr native, g.gbool(value.boolValue))
  of cellFloat: g.set_double(addr native, value.floatValue)
proc setValue*(m: ListStore, row, column: int, value: CellValue) =
  checkCell(m, column, value)
  var iter = rowIter(m, row)
  var native: g.TGValue
  initCell(value, native)
  defer: g.unset(addr native)
  rawGtk.set_value(m.raw, addr iter, g.gint(column), addr native)
proc checkRow(m: TreeModel, values: openArray[CellValue]) =
  if values.len != m.columnCount:
    raise newException(ValueError, "row must provide exactly one value per column")
  for column, value in values: checkCell(m, column, value)
proc writeRow(m: ListStore, row: int, values: openArray[CellValue], insert: bool) =
  checkRow(m, values) # Validate the whole row before mutating GTK.
  let position = checkedInt(row)
  var columns = newSeq[g.gint](values.len)
  var native = newSeq[g.TGValue](values.len)
  for i, value in values:
    columns[i] = g.gint(i)
    initCell(value, native[i])
  defer:
    for value in native.mitems: g.unset(addr value)
  var iter: rawGtk.TTreeIter
  if insert:
    if row > m.rowCount: raise newException(ValueError, "insertion row is out of range")
    rawGtk.insert_with_valuesv(m.raw, addr iter, position, addr columns[0],
      addr native[0], g.gint(values.len))
  else:
    iter = rowIter(m, row)
    rawGtk.set_valuesv(m.raw, addr iter, addr columns[0], addr native[0], g.gint(values.len))
proc insertRow*(m: ListStore, row: int, values: openArray[CellValue]) = writeRow(m, row, values, true)
proc appendRow*(m: ListStore, values: openArray[CellValue]): int =
  result = m.rowCount
  m.insertRow(result, values)
proc setRow*(m: ListStore, row: int, values: openArray[CellValue]) = writeRow(m, row, values, false)
proc removeRow*(m: ListStore, row: int) =
  var iter = rowIter(m, row)
  discard rawGtk.remove(m.raw, addr iter)
proc clear*(m: ListStore) = rawGtk.clear(m.raw)
proc disconnectSignals*(m: TreeModel) = disconnectObjectSignals(m)

proc flatPathIndex(path: rawGtk.PTreePath): int =
  if path == nil or rawGtk.get_depth(path) != 1:
    raise newException(ValueError, "expected a flat row path")
  rawGtk.get_indices(path)[].int
proc releaseModelRowCallback(data: pointer, closure: g.PGClosure) {.cdecl.} =
  GC_unref(cast[ModelRowCallback](data))
proc modelRowThunk(instance: pointer, path: rawGtk.PTreePath, extra, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let fn = cast[ModelRowCallback](data).fn
    try: fn(flatPathIndex(path))
    except Exception as error: reportSignalError(error)
proc modelDeletedThunk(instance: pointer, path: rawGtk.PTreePath, data: pointer) {.cdecl, gcsafe.} =
  modelRowThunk(instance, path, nil, data)
proc connectModelRow(w: ObjectHandle, name: cstring, fn: proc (row: int) {.closure.},
                     deleted = false): Connection =
  let p = nativePointer(w)
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let callback = ModelRowCallback(fn: fn)
  GC_ref(callback)
  let thunk = if deleted: cast[g.TGCallback](modelDeletedThunk) else: cast[g.TGCallback](modelRowThunk)
  let id = g.g_signal_connect_data(p, name, thunk, cast[pointer](callback),
    releaseModelRowCallback, g.G_CONNECT_AFTER)
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)
proc onRowInserted*(m: TreeModel, fn: proc (row: int) {.closure.}): Connection {.discardable.} =
  checkFlatModel(m.raw)
  connectModelRow(m, "row-inserted", fn)
proc onRowChanged*(m: TreeModel, fn: proc (row: int) {.closure.}): Connection {.discardable.} =
  checkFlatModel(m.raw)
  connectModelRow(m, "row-changed", fn)
proc onRowDeleted*(m: TreeModel, fn: proc (row: int) {.closure.}): Connection {.discardable.} =
  checkFlatModel(m.raw)
  connectModelRow(m, "row-deleted", fn, deleted = true)

proc model*(w: TreeView): TreeModel = ownedTreeModel(rawGtk.get_model(w.raw))
proc model*(w: ComboBox): TreeModel = ownedTreeModel(rawGtk.get_model(cast[rawGtk.PComboBox](raw(Widget(w)))))
proc newTreeView*(model: TreeModel): TreeView =
  result.state = adoptWidget(rawGtk.tree_view_new(model.raw))
proc newTextColumn*(title: string, modelColumn: int): TextColumn =
  let caption = checkedUtf8Text(title)
  let index = checkedInt(modelColumn)
  result.state = adoptObject(rawGtk.tree_view_column_new())
  result.boundColumn = modelColumn
  # Both are GtkObject/InitiallyUnowned: sink our reference, then let the column
  # retain the renderer. No raw renderer pointer escapes the constructor.
  let renderer = ObjectHandle(state: adoptObject(rawGtk.cell_renderer_text_new()))
  let p = cast[rawGtk.PCellRenderer](nativePointer(renderer))
  rawGtk.column_pack_start(result.raw, p, g.gbool(true))
  rawGtk.column_add_attribute(result.raw, p, "text", index)
  rawGtk.column_set_title(result.raw, caption)
proc appendColumn*(w: TreeView, column: TextColumn) =
  if rawGtk.column_get_tree_view(column.raw) != nil:
    raise newException(ValueError, "column is already attached to a tree view")
  if w.model.columnKind(column.boundColumn) != cellString:
    raise newException(ValueError, "text columns require a string model column")
  discard rawGtk.append_column(w.raw, column.raw)
proc appendTextColumn*(w: TreeView, title: string, modelColumn: int): TextColumn =
  result = newTextColumn(title, modelColumn)
  w.appendColumn(result)
proc disconnectSignals*(c: TextColumn) = disconnectObjectSignals(c)
proc title*(c: TextColumn): string = $rawGtk.column_get_title(c.raw)
proc `title=`*(c: TextColumn, title: string) = rawGtk.column_set_title(c.raw, checkedUtf8Text(title))
proc resizable*(c: TextColumn): bool = g.toBool(rawGtk.column_get_resizable(c.raw))
proc `resizable=`*(c: TextColumn, value: bool) = rawGtk.column_set_resizable(c.raw, g.gbool(value))
proc visible*(c: TextColumn): bool = g.toBool(rawGtk.column_get_visible(c.raw))
proc `visible=`*(c: TextColumn, value: bool) = rawGtk.column_set_visible(c.raw, g.gbool(value))
proc headersVisible*(w: TreeView): bool = g.toBool(rawGtk.get_headers_visible(w.raw))
proc `headersVisible=`*(w: TreeView, value: bool) = rawGtk.set_headers_visible(w.raw, g.gbool(value))
proc rulesHint*(w: TreeView): bool = g.toBool(rawGtk.get_rules_hint(w.raw))
proc `rulesHint=`*(w: TreeView, value: bool) = rawGtk.set_rules_hint(w.raw, g.gbool(value))
proc singleSelection(w: TreeView): rawGtk.PTreeSelection =
  result = rawGtk.get_selection(w.raw)
  if rawGtk.get_mode(result) != rawGtk.SELECTION_SINGLE:
    raise newException(ValueError, "this API requires single selection mode")
proc selectedIndex*(w: TreeView): int =
  checkFlatModel(w.model.raw)
  var iter: rawGtk.TTreeIter
  var model: rawGtk.PTreeModel
  if not g.toBool(rawGtk.get_selected(singleSelection(w), addr model, addr iter)): return -1
  let path = rawGtk.get_path(model, addr iter)
  defer: rawGtk.free(path)
  flatPathIndex(path)
proc `selectedIndex=`*(w: TreeView, row: int) =
  checkFlatModel(w.model.raw)
  let selection = singleSelection(w)
  if row == -1: rawGtk.unselect_all(selection)
  else:
    var iter = rowIter(w.model, row)
    rawGtk.select_iter(selection, addr iter)
proc onSelectionChanged*(w: TreeView, fn: proc () {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let selection = ObjectHandle(state: adoptObject(singleSelection(w), borrowed = true,
    cache = true, hasDestroySignal = false))
  result = connect(selection, "changed", fn, after = true)
  # Selection IDs belong to a DIFFERENT GObject; never put them in view.handlers.
  w.onDestroy(proc () = disconnectObjectSignals(selection))
proc onRowActivated*(w: TreeView, fn: proc (row: int) {.closure.}): Connection {.discardable.} =
  checkFlatModel(w.model.raw)
  connectModelRow(w, "row-activated", fn)
proc activateRow*(w: TreeView, row: int) =
  let model = w.model
  var iter = rowIter(model, row)
  let path = rawGtk.get_path(model.raw, addr iter)
  defer: rawGtk.free(path)
  rawGtk.row_activated(w.raw, path, nil)

proc newComboBox*(model: TreeModel, textColumn = 0): ModelComboBox =
  if model.columnKind(textColumn) != cellString:
    raise newException(ValueError, "combo text column must be a string column")
  checkFlatModel(model.raw)
  result.state = adoptWidget(rawGtk.comboBox_new_with_model(model.raw))
  let renderer = ObjectHandle(state: adoptObject(rawGtk.cell_renderer_text_new()))
  let p = cast[rawGtk.PCellRenderer](nativePointer(renderer))
  let layout = cast[rawGtk.PCellLayout](raw(Widget(result)))
  rawGtk.cell_layout_pack_start(layout, p, g.gbool(true))
  rawGtk.cell_layout_add_attribute(layout, p, "text", g.gint(textColumn))
