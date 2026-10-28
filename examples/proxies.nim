## Sorting/filtering without mutating source order, plus a stable source bookmark.
## Build: nim c --path:src examples/proxies.nim
import gtk2ui

proc main() =
  gtk2ui.init()
  let window = newWindow("gtk2ui sorted and filtered rows", 660, 420)
  defer: window.destroy()
  window.borderWidth = 10
  let layout = newVBox(spacing = 8)
  window.add(layout)
  let source = newListStore([cellString, cellString, cellInt, cellBool])
  for row in [("Nim", 95), ("Python", 85), ("C", 90), ("Example", 40)]:
    discard source.appendRow([cell(row[0]), cell($row[1]), cell(row[1]), cell(true)])
  let filtered = newTreeModelFilter(source, 3)
  let sorted = newTreeModelSort(filtered, 2, sortDescending)
  let combo = newComboBox(sorted)
  layout.packStart(combo, packShrink)
  let view = newTreeView(sorted)
  discard view.appendTextColumn("Name", 0)
  discard view.appendTextColumn("Score", 1)
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
    for row in 0 ..< source.rowCount:
      source.setValue(row, 3, cell(not highOnly.active or source.value(row, 2).intValue >= 60))
    refresh()
  ascending.onClicked do ():
    sorted.sortBy(2, sortAscending)
    refresh()
  descending.onClicked do ():
    sorted.sortBy(2, sortDescending)
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
