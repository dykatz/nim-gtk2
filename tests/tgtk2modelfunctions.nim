# No windows/popups are mapped. Native cell-data dispatch is public GTK API.
import std/[unittest, strutils]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc source(): ListStore =
  result = newListStore([cellString, cellInt, cellBool])
  for row in [("bbb", 3), ("a", 1), ("cc λ", 2)]:
    discard result.appendRow([cell(row[0]), cell(row[1]), cell(true)])
proc names(m: TreeModel): seq[string] =
  for i in 0..<m.rowCount: result.add(m.value(i, 0).stringValue)
proc apply(c: TextColumn, model: TreeModel, row: int) =
  var iter: n.TTreeIter
  doAssert g.toBool(n.iter_nth_child(model.raw, addr iter, nil, g.gint(row)))
  n.column_cell_set_cell_data(c.raw, model.raw, addr iter, g.gbool(false), g.gbool(false))
proc property(p: pointer, name: cstring): g.TGValue =
  let spec = g.class_find_property(g.G_OBJECT_GET_CLASS(p), name)
  discard g.init(addr result, spec.value_type)
  g.get_property(cast[g.PGObject](p), name, addr result)
proc renderer(c: TextColumn): pointer =
  let cells = n.cell_layout_get_cells(cast[n.PCellLayout](c.raw))
  defer: g.free(cells)
  cells.data
proc text(c: TextColumn): string =
  var v = property(c.renderer(), "text")
  defer: g.unset(addr v)
  $g.get_string(addr v)
proc integer(c: TextColumn, key: cstring): int =
  var v = property(c.renderer(), key)
  defer: g.unset(addr v)
  g.get_int(addr v).int
proc flag(c: TextColumn, key: cstring): bool =
  var v = property(c.renderer(), key)
  defer: g.unset(addr v)
  g.toBool(g.get_boolean(addr v))
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]

ui.init()
suite "copied model functions (never mapped)":
  test "custom compare, order, replacement, explicit resort and stable source references":
    let s = source()
    let bookmark = newTreeRowReference(s, treePath(0))
    var reverse = false
    var seen: seq[ModelRow]
    let compare: ModelCompare = proc (a, b: ModelRow): int =
      seen.add(a)
      let value = cmp(a.values[1].intValue, b.values[1].intValue)
      if reverse: -value else: value
    let sorted = newTreeModelSort(s, compare)
    defer: sorted.functionConnection.disconnect()
    check sorted.names == @["a", "cc λ", "bbb"]
    check sorted.sortColumn == -1 and sorted.sortOrder == sortAscending
    check sorted.toChildPath(treePath(0)) == treePath(1)
    check bookmark.path == treePath(0)
    let token = sorted.functionConnection
    reverse = true
    sorted.resort()
    check token.connected and sorted.names == @["bbb", "cc λ", "a"]
    let newer = sorted.setCompare(compare, sortDescending)
    check not token.connected and newer.connected
    check sorted.sortOrder == sortDescending and sorted.names == @["a", "cc λ", "bbb"]
    s.setValue(1, 1, cell(10))
    check sorted.names == @["cc λ", "bbb", "a"]
    check seen.len > 0 and seen[0].values.len == 3
    sorted.sortBy(0)
    expect ValueError: sorted.resort()
    newer.disconnect()
    newer.disconnect()
    check not newer.connected
  test "predicate closure updates, disconnection and immediate-child proxy coordinates":
    let s = source()
    var minimum = 2
    let filtered = newTreeModelFilter(s, proc (row: ModelRow): bool = row.values[1].intValue >= minimum)
    defer: filtered.functionConnection.disconnect()
    check filtered.names == @["bbb", "cc λ"]
    check filtered.fromChildPath(treePath(1)).isRoot
    minimum = 3
    filtered.refilter()
    check filtered.names == @["bbb"]
    let old = filtered.functionConnection
    let replacement = filtered.setPredicate(proc (row: ModelRow): bool = row.path == treePath(1))
    check not old.connected and replacement.connected
    filtered.refilter()
    check filtered.names == @["a"]
    replacement.disconnect()
    filtered.refilter()
    check filtered.names == s.names
    let columnFilter = newTreeModelFilter(s, 2)
    expect ValueError: discard columnFilter.setPredicate(proc (row: ModelRow): bool = true)
    let sorted = newTreeModelSort(s, 1)
    let nested = newTreeModelFilter(sorted, proc (row: ModelRow): bool = row.path == treePath(0))
    check nested.names == @["a"]
    check nested.toChildPath(treePath(0)) == treePath(0)
    check sorted.toChildPath(treePath(0)) == treePath(1)
  test "hierarchical paths and predicates keep native ancestor semantics":
    let tree = newTreeStore([cellString, cellInt])
    let root = tree.appendRow([cell("root"), cell(1)])
    discard tree.appendRow([cell("child"), cell(2)], root)
    let filtered = newTreeModelFilter(tree, proc (row: ModelRow): bool = row.values[1].intValue > 0)
    check filtered.childCount(treePath(0)) == 1
    check filtered.value(treePath(0, 0), 0).stringValue == "child"
    filtered.setPredicate(proc (row: ModelRow): bool = row.path.depth > 1)
    filtered.refilter()
    check filtered.rowCount == 0
  test "callback exceptions and checked handle reentrancy have deterministic fallbacks":
    let s = source()
    var rejected = false
    let sorted = newTreeModelSort(s, proc (a, b: ModelRow): int =
      try: s.clear()
      except ValueError: rejected = true
      cmp(a.values[1].intValue, b.values[1].intValue))
    check sorted.names == @["a", "cc λ", "bbb"] and rejected and s.rowCount == 3
    let bad = newTreeModelFilter(s, proc (row: ModelRow): bool =
      raise newException(ValueError, "expected predicate error"))
    check bad.rowCount == 0
    let equal = newTreeModelSort(s, proc (a, b: ModelRow): int =
      raise newException(ValueError, "expected comparison error"))
    check equal.names.len == 3
    expect ValueError: discard newTreeModelSort(s, ModelCompare(nil))
    expect ValueError: discard newTreeModelFilter(s, ModelPredicate(nil))
  test "text presentation resets every row; validation/exception/disconnect restore binding":
    let s = source()
    let view = newTreeView(s)
    defer: view.destroy()
    let c = view.appendTextColumn("Name", 0)
    let token = c.setCellData(proc (row: ModelRow): TextCellData =
      TextCellData(text: row.values[0].stringValue.toUpperAscii, bold: row.path == treePath(0),
        italic: row.path == treePath(0), dimmed: row.path == treePath(0),
        foregroundSet: row.path == treePath(0), foreground: rgba16(65535, 0, 0)))
    c.apply(s, 0)
    check c.text == "BBB" and c.integer("weight") == 700 and c.flag("foreground-set") and not c.flag("sensitive")
    c.apply(s, 1)
    check c.text == "A" and c.integer("weight") == 400 and not c.flag("foreground-set") and c.flag("sensitive")
    token.disconnect()
    c.apply(s, 0)
    check c.text == "bbb" and c.integer("weight") == 400
    c.setCellData(proc (row: ModelRow): TextCellData = TextCellData(text: "\xff", bold: true))
    c.apply(s, 0)
    check c.text == "bbb" and c.integer("weight") == 400
    c.setCellData(proc (row: ModelRow): TextCellData =
      view.destroy() # Checked handle access is rejected, not performed.
      TextCellData(text: "unreachable"))
    c.apply(s, 0)
    check not view.isDestroyed and c.text == "bbb"
    c.setCellData(proc (row: ModelRow): TextCellData =
      TextCellData(text: "bad alpha", foregroundSet: true, foreground: rgba16(0, 0, 0, 1)))
    c.apply(s, 0)
    check c.text == "bbb" and not c.flag("foreground-set")
    let latest = c.functionConnection
    c.disconnectSignals()
    check not latest.connected
    c.apply(s, 2)
    check c.text == "cc λ" and c.integer("weight") == 400
  test "pixbuf column checks schema and detached ownership":
    let s = newListStore([cellString, cellPixbuf])
    discard s.appendRow([cell("icon"), cell(Pixbuf())])
    let view = newTreeView(s)
    defer: view.destroy()
    let c = view.appendPixbufColumn("Icon", 1)
    c.resizable = true
    c.visible = false
    c.title = "Picture"
    check c.title == "Picture" and c.resizable and not c.visible
    expect ValueError: view.appendColumn(c)
    expect ValueError: discard view.appendPixbufColumn("wrong", 0)
  test "last ordinary handle drops during a callback release at idle, not in traversal":
    let s = source()
    var widget = newLabel("unparented")
    var finalized = 0
    g.weak_ref(cast[g.PGObject](widget.raw), gone, addr finalized)
    let filtered = newTreeModelFilter(s, proc (row: ModelRow): bool =
      widget = ui.Label()
      doAssert finalized == 0
      true)
    check filtered.rowCount == 3 and finalized == 0
    drain()
    check finalized == 1
  test "captured resources release immediately on explicit disconnection":
    type PayloadObj = object
      finalized: ptr int
      visible: bool
    proc `=destroy`(value: var PayloadObj) =
      if value.finalized != nil: inc value.finalized[]
    type Payload = ref PayloadObj
    proc trackedPredicate(finalized: ptr int): ModelPredicate =
      var payload: Payload
      new(payload)
      payload.finalized = finalized
      payload.visible = true
      result = proc (row: ModelRow): bool = payload.visible
    proc trackedFilter(s: TreeModel, finalized: ptr int): ui.TreeModelFilter =
      newTreeModelFilter(s, trackedPredicate(finalized))
    let s = source()
    var finalized = 0
    let filtered = trackedFilter(s, addr finalized)
    let token = filtered.functionConnection
    check finalized == 0
    check filtered.rowCount == 3
    token.disconnect()
    check finalized == 1
    filtered.refilter()
    check filtered.rowCount == 3
  test "native teardown invalidates retained function connections":
    let s = source()
    var token: ModelFunctionConnection
    block:
      let filtered = newTreeModelFilter(s, proc (row: ModelRow): bool = true)
      token = filtered.functionConnection
      check token.connected
    check not token.connected
    block:
      let sorted = newTreeModelSort(s, proc (a, b: ModelRow): int = cmp(a.values[1].intValue, b.values[1].intValue))
      discard sorted.names
      for i in 0..<8: sorted.resort()
      token = sorted.functionConnection
      check token.connected
    check not token.connected
    let view = newTreeView(s)
    block:
      let column = view.appendTextColumn("Name", 0)
      token = column.setCellData(proc (row: ModelRow): TextCellData = TextCellData(text: row.values[0].stringValue))
    check token.connected # Native view/column ownership survives SDK alias loss.
    view.destroy()
    check not token.connected
