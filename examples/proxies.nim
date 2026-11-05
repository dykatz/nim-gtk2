## Sorting/filtering without mutating source order, plus a stable source bookmark.
## Build: nim c --path:src examples/proxies.nim
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 sorted and filtered rows", 660, 420)
  defer: window.destroy()
  window.borderWidth = 10
  let layout = newVBox(spacing = 8)
  window.add(layout)
  let source = newListStore([cellString, cellString, cellInt, cellBool, cellPixbuf])
  for row in [("Nim", 95), ("Python", 85), ("C", 90), ("Example", 40)]:
    let icon = newPixbuf(12, 12, if row[1] >= 60: 0x30a050ff'u32 else: 0xd08030ff'u32)
    discard source.appendRow([cell(row[0]), cell($row[1]), cell(row[1]), cell(true), cell(icon)])
  var minimum = 0
  let filtered = newTreeModelFilter(source, proc (row: ModelRow): bool =
    row.values[2].intValue >= minimum)
  let compare: ModelCompare = proc (a, b: ModelRow): int =
    result = cmp(a.values[2].intValue, b.values[2].intValue)
    if result == 0: result = cmp(a.values[0].stringValue, b.values[0].stringValue)
  let sorted = newTreeModelSort(filtered, compare, sortDescending)
  defer:
    sorted.functionConnection.disconnect()
    filtered.functionConnection.disconnect()
  let combo = newComboBox(sorted)
  layout.packStart(combo, packShrink)
  let view = newTreeView(sorted)
  discard view.appendPixbufColumn("", 4)
  let name = view.appendTextColumn("Name", 0)
  name.setCellData(proc (row: ModelRow): TextCellData =
    let score = row.values[2].intValue
    TextCellData(text: row.values[0].stringValue, bold: score >= 90,
      italic: score < 60, foregroundSet: score < 60, foreground: rgba16(50000, 15000, 0)))
  discard view.appendTextColumn("Score", 1)
  defer: name.clearCellData()
  let scroll = newScrolledWindow()
  scroll.add(view)
  layout.packStart(scroll)
  let actions = newHBox(spacing = 6)
  let highOnly = newCheckButton("Scores >= 60")
  let ascending = newButton("Ascending")
  let descending = newButton("Descending")
  let remember = newButton("Bookmark selected")
  let remove = newButton("Delete selected")
  actions.packStart(highOnly, packShrink)
  actions.packStart(ascending, packShrink)
  actions.packStart(descending, packShrink)
  actions.packStart(remember, packShrink)
  actions.packStart(remove, packShrink)
  layout.packStart(actions, packShrink)
  let selected = newLabel()
  let bookmarkStatus = newLabel()
  layout.packStart(selected, packShrink)
  layout.packStart(bookmarkStatus, packShrink)
  var bookmark = newTreeRowReference(source, treePath(0))

  proc selectedSource(): TreePath =
    let display = view.selectedPath
    if display.isRoot: treePath()
    else: filtered.toChildPath(sorted.toChildPath(display))
  proc refresh() =
    let display = view.selectedPath
    if display.isRoot:
      selected.text = "No tree selection; " & $sorted.rowCount & " visible rows"
    else:
      let original = selectedSource()
      selected.text = "Display " & $display & " -> source " & $original & ": " &
        source.value(original, 0).stringValue
    bookmarkStatus.text = if bookmark.valid:
      "Stable source bookmark: " & source.value(bookmark.path, 0).stringValue &
        " at " & $bookmark.path
      else: "Bookmarked source row was deleted"

  view.onSelectionChanged(proc () = refresh())
  sorted.onRowsReordered(proc (parent: TreePath, order: seq[int]) = refresh())
  window.onDestroy(proc () = sorted.disconnectSignals())
  defer: sorted.disconnectSignals()
  highOnly.onToggled do ():
    minimum = if highOnly.active: 60 else: 0
    filtered.refilter() # Closure state is not automatically observable by GTK.
    refresh()
  ascending.onClicked do ():
    sorted.setCompare(compare, sortAscending)
    refresh()
  descending.onClicked do ():
    sorted.setCompare(compare, sortDescending)
    refresh()
  remember.onClicked do ():
    let original = selectedSource()
    if not original.isRoot: bookmark = newTreeRowReference(source, original)
    refresh()
  remove.onClicked do ():
    let original = selectedSource()
    if not original.isRoot: source.removeRow(original.indices[0])
    refresh()
  view.selectedIndex = 0
  combo.activeIndex = 0
  refresh()
  window.run()

when isMainModule:
  main()
