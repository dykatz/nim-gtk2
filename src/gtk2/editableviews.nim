# Included by gtk2.nim. Edits are observations, never implicit model mutations.
type
  TreeSelectionMode* = enum selectionNone, selectionSingle, selectionBrowse, selectionMultiple
  TextEdit* = object
    row*: TreeRowReference
    path*: TreePath # Positional snapshot at emission; row.path tracks later changes.
    column*: int
    text*: string
  ToggleEdit* = object
    row*: TreeRowReference
    path*: TreePath
    column*: int
    active*: bool # Model value at emission, NOT a suggested new value.
  ToggleColumn* = object of ObjectHandle
    boundColumn: int
    renderer: ObjectHandle
  CellEditBinding[T] = ref object
    column: rawGtk.PTreeViewColumn # Borrowed until column destruction disconnects us.
    index: int
    queue: RecentBinding[T]

proc editable*(c: TextColumn): bool =
  discard c.raw
  booleanProperty(c.renderer, "editable")
proc `editable=`*(c: TextColumn, value: bool) =
  discard c.raw
  setBooleanProperty(c.renderer, "editable", value)
proc parseCellPath(text: cstring): TreePath =
  if text == nil or text[0] == '\0': raise newException(ValueError, "empty edited cell path")
  var n = 0
  var digits = false
  for ch in $text:
    if ch == ':':
      if not digits: raise newException(ValueError, "invalid edited cell path")
      result.parts.add(n)
      n = 0
      digits = false
    elif ch in {'0'..'9'}:
      let digit = ord(ch) - ord('0')
      if n > (high(g.gint).int - digit) div 10:
        raise newException(ValueError, "edited cell path exceeds gint")
      n = n * 10 + digit
      digits = true
    else: raise newException(ValueError, "invalid edited cell path")
  if not digits: raise newException(ValueError, "invalid edited cell path")
  result.parts.add(n)
proc queueCellEdit[T](path, text: cstring, data: pointer) =
  let binding = cast[CellEditBinding[T]](data)
  let view = rawGtk.column_get_tree_view(binding.column)
  if view == nil: return # Editor can finish after its column has been detached.
  let model = ownedTreeModel(rawGtk.get_model(cast[rawGtk.PTreeView](view)))
  let position = parseCellPath(path)
  if not model.hasRow(position): return # Row deleted before editing completed.
  var value = T(row: newTreeRowReference(model, position), path: position, column: binding.index)
  when T is TextEdit:
    value.text = $text
    discard checkedUtf8Text(value.text)
  else:
    let cell = model.value(position, binding.index)
    if cell.kind != cellBool: raise newException(ValueError, "toggle column model schema changed")
    value.active = cell.boolValue
  queueRecent(cast[pointer](binding.queue), value)
proc textEditedThunk(instance: pointer, path, text: cstring, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: queueCellEdit[TextEdit](path, text, data)
    except Exception as error: reportSignalError(error)
proc toggledThunk(instance: pointer, path: cstring, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: queueCellEdit[ToggleEdit](path, nil, data)
    except Exception as error: reportSignalError(error)
proc releaseCellEdit[T](data: pointer, closure: g.PGClosure) {.cdecl.} =
  let binding = cast[CellEditBinding[T]](data)
  releaseRecentBinding[T](cast[pointer](binding.queue), closure)
  GC_unref(binding)
proc connectCellEdit[T](column: ObjectHandle, p: rawGtk.PTreeViewColumn,
                        renderer: ObjectHandle, index: int, signal: cstring,
                        thunk: g.TGCallback, fn: proc (edit: T) {.closure.}): Connection =
  discard nativePointer(column)
  let r = nativePointer(renderer)
  if fn == nil: raise newException(ValueError, "edit callback cannot be nil")
  let view = rawGtk.column_get_tree_view(p)
  if view == nil: raise newException(ValueError, "attach the column to a view before observing edits")
  let parent = Widget(state: adoptObject(view, borrowed = true, cache = true))
  let pending = RecentBinding[T](fn: fn, active: true)
  let binding = CellEditBinding[T](column: p, index: index, queue: pending)
  GC_ref(pending)
  GC_ref(binding)
  let id = g.g_signal_connect_data(r, signal, thunk, cast[pointer](binding),
    releaseCellEdit[T], g.G_CONNECT_AFTER)
  renderer.state.handlers.add(id)
  let connection = Connection(state: renderer.state, id: id)
  column.onDestroy(proc () = connection.disconnect())
  parent.onDestroy(proc () = connection.disconnect())
  connection
proc onEdited*(c: TextColumn, fn: proc (edit: TextEdit) {.closure.}): Connection {.discardable.} =
  connectCellEdit(c, c.raw, c.renderer, c.boundColumn, "edited", cast[g.TGCallback](textEditedThunk), fn)
proc startEditing*(w: TreeView, c: TextColumn, path: TreePath) =
  let p = w.raw
  if rawGtk.column_get_tree_view(c.raw) != cast[rawGtk.PWidget](p):
    raise newException(ValueError, "editable column is not attached to this view")
  if not c.editable or not g.toBool(rawGtk.get_mapped(cast[rawGtk.PWidget](p))):
    raise newException(ValueError, "startEditing requires an editable column in a mapped view")
  discard pathIter(w.model, path)
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  rawGtk.expand_to_path(p, native)
  if not w.isDestroyed: rawGtk.set_cursor(p, native, c.raw, g.gbool(true))

proc raw*(c: ToggleColumn): rawGtk.PTreeViewColumn = cast[rawGtk.PTreeViewColumn](nativePointer(c))
proc newToggleColumn*(title: string, modelColumn: int): ToggleColumn =
  let text = checkedUtf8Text(title)
  let index = checkedInt(modelColumn)
  result.state = adoptObject(rawGtk.tree_view_column_new())
  result.boundColumn = modelColumn
  result.renderer = ObjectHandle(state: adoptObject(rawGtk.cell_renderer_toggle_new()))
  let p = cast[rawGtk.PCellRenderer](nativePointer(result.renderer))
  rawGtk.column_pack_start(result.raw, p, g.gbool(false))
  rawGtk.column_add_attribute(result.raw, p, "active", index)
  rawGtk.column_set_title(result.raw, text)
proc appendColumn*(w: TreeView, c: ToggleColumn) =
  if rawGtk.column_get_tree_view(c.raw) != nil:
    raise newException(ValueError, "column is already attached to a tree view")
  if w.model.columnKind(c.boundColumn) != cellBool:
    raise newException(ValueError, "toggle columns require a boolean model column")
  discard rawGtk.append_column(w.raw, c.raw)
proc appendToggleColumn*(w: TreeView, title: string, modelColumn: int): ToggleColumn =
  result = newToggleColumn(title, modelColumn)
  w.appendColumn(result)
proc activatable*(c: ToggleColumn): bool =
  discard c.raw
  booleanProperty(c.renderer, "activatable")
proc `activatable=`*(c: ToggleColumn, value: bool) =
  discard c.raw
  setBooleanProperty(c.renderer, "activatable", value)
proc disconnectSignals*(c: ToggleColumn) =
  discard c.raw
  disconnectObjectSignals(c.renderer)
  disconnectObjectSignals(c)
proc onToggled*(c: ToggleColumn, fn: proc (edit: ToggleEdit) {.closure.}): Connection {.discardable.} =
  connectCellEdit(c, c.raw, c.renderer, c.boundColumn, "toggled", cast[g.TGCallback](toggledThunk), fn)
proc title*(c: ToggleColumn): string = $rawGtk.column_get_title(c.raw)
proc `title=`*(c: ToggleColumn, text: string) = rawGtk.column_set_title(c.raw, checkedUtf8Text(text))
proc resizable*(c: ToggleColumn): bool = g.toBool(rawGtk.column_get_resizable(c.raw))
proc `resizable=`*(c: ToggleColumn, value: bool) = rawGtk.column_set_resizable(c.raw, g.gbool(value))
proc visible*(c: ToggleColumn): bool = g.toBool(rawGtk.column_get_visible(c.raw))
proc `visible=`*(c: ToggleColumn, value: bool) = rawGtk.column_set_visible(c.raw, g.gbool(value))

proc selectionMode*(w: TreeView): TreeSelectionMode =
  TreeSelectionMode(rawGtk.get_mode(rawGtk.get_selection(w.raw)))
proc `selectionMode=`*(w: TreeView, mode: TreeSelectionMode) =
  let selection = rawGtk.get_selection(w.raw)
  if rawGtk.get_mode(selection) == rawGtk.TSelectionMode(ord(mode)): return
  # Explicit clear-on-transition policy also discards GTK2's stale MULTIPLE
  # anchor, which otherwise prevents subsequent SINGLE selections from working.
  rawGtk.set_mode(selection, rawGtk.SELECTION_NONE)
  if not w.isDestroyed:
    rawGtk.set_mode(selection, rawGtk.TSelectionMode(ord(mode)))
proc selectedPaths*(w: TreeView): seq[TreePath] =
  var model: rawGtk.PTreeModel
  let list = rawGtk.get_selected_rows(rawGtk.get_selection(w.raw), addr model)
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
proc selectedIndices*(w: TreeView): seq[int] =
  checkFlatModel(w.model.raw)
  for path in w.selectedPaths: result.add(path.parts[0])
proc `selectedPaths=`*(w: TreeView, paths: openArray[TreePath]) =
  if w.selectionMode != selectionMultiple:
    raise newException(ValueError, "selectedPaths assignment requires multiple selection")
  let model = w.model
  var rows: seq[TreeRowReference]
  for path in paths: rows.add(newTreeRowReference(model, path))
  let selection = rawGtk.get_selection(w.raw)
  rawGtk.unselect_all(selection)
  for row in rows:
    if w.isDestroyed: return
    if w.selectionMode != selectionMultiple or w.model.raw != model.raw: return
    if row.valid:
      let path = nativeTreePath(row.path)
      rawGtk.select_path(selection, path)
      rawGtk.free(path)
proc selectAll*(w: TreeView) =
  if w.selectionMode != selectionMultiple:
    raise newException(ValueError, "selectAll requires multiple selection")
  rawGtk.select_all(rawGtk.get_selection(w.raw))
proc unselectAll*(w: TreeView) = rawGtk.unselect_all(rawGtk.get_selection(w.raw))
proc viewSelectionThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueRecent(data, true)
proc connectViewSelection(w: TreeView, fn: proc () {.closure.}): Connection =
  let p = w.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let selection = ObjectHandle(state: adoptObject(rawGtk.get_selection(p), borrowed = true,
    cache = true, hasDestroySignal = false))
  result = connectRecent(selection, "changed", proc (value: bool) = fn(),
    cast[g.TGCallback](viewSelectionThunk), coalesce = true)
  # Selection IDs belong to a DIFFERENT GObject; never put them in view.handlers.
  w.onDestroy(proc () = disconnectObjectSignals(selection))
