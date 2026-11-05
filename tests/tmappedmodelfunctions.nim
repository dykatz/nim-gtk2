# Native tree-view sizing/painting, only on an explicitly isolated display.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped model-function tests require an isolated virtual display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc awaitUi(fn: proc (): bool): bool =
  let deadline = epochTime() + 6
  while epochTime() < deadline:
    for i in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    if fn(): return true
    sleep(10)

gtk2.init()
suite "native model function rendering":
  test "custom sort/filter, dynamic text styles, pixbufs and safe native traversal":
    let host = newWindow("Model functions", 520, 260)
    defer: host.destroy()
    let source = newListStore([cellString, cellInt, cellPixbuf])
    let icon = newPixbuf(12, 12, 0x30a050ff'u32)
    discard source.appendRow([cell("Nim λ🙂"), cell(95), cell(icon)])
    discard source.appendRow([cell("Other"), cell(40), cell(Pixbuf())])
    var minimum = 0
    let filtered = newTreeModelFilter(source, proc (row: ModelRow): bool = row.values[1].intValue >= minimum)
    let sorted = newTreeModelSort(filtered, proc (a, b: ModelRow): int = cmp(a.values[1].intValue, b.values[1].intValue))
    defer:
      filtered.functionConnection.disconnect()
      sorted.functionConnection.disconnect()
    let bookmark = newTreeRowReference(source, treePath(0))
    let view = newTreeView(sorted)
    discard view.appendPixbufColumn("Icon", 2)
    let column = view.appendTextColumn("Name", 0)
    defer: column.clearCellData()
    var calls = 0
    var highlighted = false
    var sawHighlight = false
    var sawUnicode = false
    var rejected = false
    column.setCellData(proc (row: ModelRow): TextCellData =
      inc calls
      if row.values[0].stringValue == "Nim λ🙂": sawUnicode = true
      if highlighted: sawHighlight = true
      try: host.destroy()
      except ValueError: rejected = true
      TextCellData(text: row.values[0].stringValue, bold: highlighted,
        foregroundSet: highlighted, foreground: rgba16(30000, 0, 50000)))
    let scroll = newScrolledWindow()
    scroll.add(view)
    host.add(scroll)
    host.showAll()
    require awaitUi(proc (): bool = calls > 0 and sawUnicode and rejected)
    check not host.isDestroyed
    check sorted.value(0, 0).stringValue == "Other"
    minimum = 60
    filtered.refilter()
    require awaitUi(proc (): bool = sorted.rowCount == 1)
    check sorted.value(0, 0).stringValue == "Nim λ🙂" and bookmark.path == treePath(0)
    highlighted = true
    column.refreshCells()
    require awaitUi(proc (): bool = sawHighlight)
    minimum = 0
    filtered.refilter()
    let newer = sorted.setCompare(proc (a, b: ModelRow): int = cmp(a.values[1].intValue, b.values[1].intValue), sortDescending)
    require awaitUi(proc (): bool = sorted.rowCount == 2 and sorted.value(0, 0).stringValue == "Nim λ🙂")
    source.removeRow(1)
    require awaitUi(proc (): bool = sorted.rowCount == 1)
    check bookmark.valid
    newer.disconnect()
    column.clearCellData()
    host.destroy()
    check host.isDestroyed
