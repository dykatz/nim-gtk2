# Hidden fixed-layout IconView selection/ownership tests: never maps a window.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc store(): ListStore =
  result = newListStore([cellString, cellPixbuf, cellBool])
  for text in ["Zulu", "Alpha", "Beta", "Delta"]:
    discard result.appendRow([cell(text), cell(Pixbuf()), cell(true)])
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = cast[ptr bool](data)[] = true
proc unparentedObserver(done: ptr bool) =
  let view = newIconView(store(), 1, 0)
  g.weak_ref(cast[g.PGObject](view.raw), finalized, done)
  view.onSelectionChanged(proc (value: IconSelection) = discard)
ui.init()
suite "IconView multiple selection (unmapped)":
  test "checked modes, validated atomic assignment, sorted copies and duplicates":
    let s = store()
    let view = newIconView(s, 1, 0)
    defer: view.destroy()
    check view.selectionMode == selectionSingle
    expect ValueError: view.selectAll()
    expect ValueError: view.selectedIndices = [0, 1]
    view.selectionMode = selectionMultiple
    view.selectedIndices = [3, 1, 1]
    check view.selectedIndices == @[1, 3]
    check view.selectedPaths == @[treePath(1), treePath(3)]
    let copy = view.selectedPaths
    expect ValueError: view.selectedIndices = [0, 99]
    expect ValueError: view.selectedIndices = [-1]
    expect ValueError: view.selectedPaths = [treePath(0), treePath(1, 0)]
    check view.selectedIndices == @[1, 3]
    expect ValueError: discard view.selectedIndex
    expect ValueError: view.selectedPath = treePath(0)
    view.selectPath(treePath(0))
    view.unselectPath(treePath(3))
    check view.pathSelected(treePath(0)) and view.selectedIndices == @[0, 1]
    check copy == @[treePath(1), treePath(3)]
    view.selectAll()
    check view.selectedIndices == @[0, 1, 2, 3]
    view.unselectAll()
    check view.selectedPaths.len == 0
    view.cursorPath = treePath(2)
    check view.cursorPath == treePath(2) and view.selectedPaths.len == 0
    expect ValueError: view.cursorPath = treePath()
    view.selectionMode = selectionNone
    expect ValueError: view.selectPath(treePath(0))
  test "clear-on-transition including browse; same mode preserves native selection":
    let view = newIconView(store(), 1, 0)
    defer: view.destroy()
    for mode in [selectionSingle, selectionBrowse, selectionMultiple, selectionNone]:
      view.selectionMode = selectionSingle
      view.selectedIndex = 2
      if mode == selectionSingle:
        view.selectionMode = mode
        check view.selectedIndices == @[2]
      else:
        view.selectionMode = mode
        check view.selectedIndices.len == 0
    view.selectionMode = selectionBrowse
    view.selectPath(treePath(1))
    expect ValueError: view.unselectAll()
    expect ValueError: view.unselectPath(treePath(1))
    view.selectionMode = selectionMultiple
    check view.selectedIndices.len == 0
    view.selectedIndices = [0, 3]
    view.selectionMode = selectionSingle
    view.selectedIndex = 1
    check view.selectedIndex == 1
  test "coalesced idle payloads own copies/stable rows in the displayed proxy coordinates":
    let s = store()
    let filtered = newTreeModelFilter(s, 2)
    let sorted = newTreeModelSort(filtered, 0)
    let view = newIconView(sorted, 1, 0)
    defer: view.destroy()
    view.selectionMode = selectionMultiple
    var observations: seq[IconSelection]
    var simple = 0
    view.onSelectionChanged(proc (value: IconSelection) = observations.add(value))
    view.onSelectionChanged(proc () = inc simple)
    view.selectedIndices = [0, 3]
    view.selectedIndices = [0, 1]
    check observations.len == 0 and simple == 0
    drain()
    check observations.len == 1 and simple == 1
    let value = observations[0]
    check value.paths == @[treePath(0), treePath(1)] and value.mode == selectionMultiple
    check value.model.value(value.rows[0].path, 0).stringValue == "Alpha"
    check sorted.toChildPath(value.paths[0]) == treePath(1)
    s.setValue(1, 0, cell("Omega λ🙂"))
    check value.paths == @[treePath(0), treePath(1)]
    check value.rows[0].valid and value.model.value(value.rows[0].path, 0).stringValue == "Omega λ🙂"
    s.setValue(1, 2, cell(false))
    check not value.rows[0].valid # Filtered out: proxy reference does not become a source reference.
    view.destroy()
    drain()
  test "activation is per-emission, copied before idle and safe after deletion/destruction":
    let s = store()
    let view = newIconView(s, 1, 0)
    view.selectionMode = selectionMultiple
    var values: seq[IconActivation]
    view.onActivated(proc (value: IconActivation) =
      values.add(value)
      if values.len == 2: view.destroy())
    view.activateRow(0)
    view.activateRow(1)
    s.removeRow(0)
    check values.len == 0
    drain()
    check values.len == 2 and not values[0].row.valid and values[1].row.valid
    check values[1].path == treePath(1) and values[1].row.path == treePath(0)
    check view.isDestroyed
  test "typed observation bridge does not retain an otherwise unowned view":
    var done = false
    unparentedObserver(addr done)
    check done
  test "disconnect/teardown cancel delivery; observers may mutate and throw safely":
    let view = newIconView(store(), 1, 0)
    view.selectionMode = selectionMultiple
    var calls = 0
    let canceled = view.onSelectionChanged(proc (value: IconSelection) = inc calls)
    view.selectAll()
    canceled.disconnect()
    drain()
    check calls == 0
    let once = view.onSelectionChanged(proc (value: IconSelection) =
      inc calls
      view.destroy()
      raise newException(ValueError, "expected icon selection observer error"))
    view.unselectAll()
    drain()
    check calls == 1 and view.isDestroyed and not once.connected
    let other = newIconView(store(), 1)
    other.onSelectionChanged(proc () = inc calls)
    other.selectedIndex = 1
    other.destroy()
    drain()
    check calls == 1
