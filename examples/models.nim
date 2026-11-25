## A typed flat model shared by TreeView and model-backed ComboBox.
## Build: nim c --path:src examples/models.nim
import gtk2

proc main() =
  gtk2.init()
  let window = newWindow("gtk2 editable shared list model", 800, 460)
  defer: window.destroy()
  window.borderWidth = 10
  let layout = newVBox(spacing = 8)
  window.add(layout)
  let store = newListStore([cellString, cellString, cellInt, cellBool, cellFloat])
  discard store.appendRow([cell("Nim"), cell("Compiled"), cell(2008), cell(true), cell(9.5)])
  discard store.appendRow([cell("Python"), cell("Interpreted"), cell(1991), cell(true), cell(8.5)])
  discard store.appendRow([cell("C"), cell("Compiled"), cell(1972), cell(true), cell(9.0)])
  let combo = newComboBox(store)
  layout.packStart(combo, packShrink)
  let comboStatus = newLabel()
  layout.packStart(comboStatus, packShrink)
  let view = newTreeView(store)
  view.configureModelRowDrag()
  let shortlist = newListStore([cellString])
  let review = newTreeView(shortlist)
  discard review.appendTextColumn("Shortlist (drop here)", 0)
  review.configureModelRowDrag(source = false, receive = proc (drop: ModelRowDrop): bool =
    if drop.row.values.len == 0 or drop.row.values[0].kind != cellString: return false
    let name = drop.row.values[0].stringValue
    if name.len == 0: return false
    for i in 0..<shortlist.rowCount:
      if shortlist.value(i, 0).stringValue == name: return false
    let at = if drop.hit.isRoot: shortlist.rowCount else: drop.hit.indices[0]
    shortlist.insertRow(at, [cell(name)])
    true)
  let nameColumn = view.appendTextColumn("Language", 0)
  nameColumn.resizable = true
  nameColumn.editable = true
  discard view.appendTextColumn("Category", 1)
  view.appendDrawColumn("Score", 80, 20, proc (c: DrawContext, row: ModelRow, info: CellDrawInfo) =
    let width = max(0.0, info.width.float64 - 8.0)
    let height = max(0.0, info.height.float64 - 8.0)
    let fraction = clamp(row.values[4].floatValue / 10.0, 0.0, 1.0)
    c.setSource(if info.selected: rgba16(48000, 61000, 65535) else: rgba16(9000, 29000, 39000))
    c.rectangle(4, 4, width * fraction, height)
    c.fill())
  let enabledColumn = view.appendToggleColumn("Active", 3)
  nameColumn.onEdited(proc (edit: TextEdit) =
    if edit.row.valid and edit.row.model.raw == store.raw:
      store.setValue(edit.row.path.indices[0], edit.column, cell(edit.text)))
  enabledColumn.onToggled(proc (edit: ToggleEdit) =
    if edit.row.valid and edit.row.model.raw == store.raw:
      let row = edit.row.path.indices[0]
      store.setValue(row, edit.column, cell(not store.value(row, edit.column).boolValue)))
  let multiple = newCheckButton("Multiple selection (mode changes clear selection)")
  layout.packStart(multiple, packShrink)
  layout.packStart(newLabel("Drag a language to the shortlist to copy its name. Duplicates are rejected."), packShrink)
  view.rulesHint = true
  let scroll = newScrolledWindow()
  scroll.add(view)
  let lists = newHBox(spacing = 8)
  lists.packStart(scroll)
  let shortlistScroll = newScrolledWindow()
  shortlistScroll.add(review)
  lists.packStart(shortlistScroll)
  layout.packStart(lists)
  let actions = newHBox(spacing = 6)
  let name = newEntry("New language")
  let add = newButton("Add")
  let inlineEdit = newButton("Edit name inline")
  let rename = newButton("Rename selected")
  let remove = newButton("Remove selected")
  actions.packStart(name)
  actions.packStart(add, packShrink)
  actions.packStart(inlineEdit, packShrink)
  actions.packStart(rename, packShrink)
  actions.packStart(remove, packShrink)
  layout.packStart(actions, packShrink)
  let status = newLabel()
  layout.packStart(status, packShrink)

  proc refresh() =
    let selected = view.selectedIndices
    let row = if selected.len == 0: -1 else: selected[0]
    if row < 0:
      status.text = $store.rowCount & " rows; no selection"
    else:
      status.text = $selected.len & " selected; " & store.value(row, 0).stringValue & ": year " &
        $store.value(row, 2).intValue & ", score " & $store.value(row, 4).floatValue

  proc refreshCombo() =
    let row = combo.activeIndex
    comboStatus.text = if row >= 0: "Combo: " & store.value(row, 0).stringValue
                       else: "Combo: no selection"

  # Share data, not selection. Avoid cross-widget selection changes while GTK
  # is still notifying its native model consumers of structural edits.
  multiple.onToggled(proc () =
    view.selectionMode = if multiple.active: selectionMultiple else: selectionSingle
    refresh())
  combo.onChanged(proc () = refreshCombo())
  view.onSelectionChanged(proc () = refresh())
  view.onRowActivated(proc (row: int) = status.text = "Activated: " & store.value(row, 0).stringValue)
  store.onRowChanged do (row: int):
    refresh()
    refreshCombo()
  # Model callbacks can capture the tree or the model itself; release them on close.
  window.onDestroy(proc () = store.disconnectSignals())
  defer: store.disconnectSignals()
  add.onClicked do ():
    let row = store.appendRow([cell(name.text), cell("Custom"), cell(2026), cell(true), cell(0.0)])
    combo.activeIndex = row
    if view.selectionMode == selectionMultiple: view.selectedPaths = [treePath(row)]
    else: view.selectedIndex = row
    refresh()
  inlineEdit.onClicked(proc () =
    let paths = view.selectedPaths
    if paths.len > 0: view.startEditing(nameColumn, paths[0]))
  rename.onClicked do ():
    for row in view.selectedIndices: store.setValue(row, 0, cell(name.text))
  remove.onClicked do ():
    let rows = view.selectedIndices
    # Delete from the end so earlier positional indices remain valid.
    for i in countdown(rows.high, 0): store.removeRow(rows[i])
    refresh()
  combo.activeIndex = 0
  view.selectedIndex = 0
  refresh()
  window.run()

when isMainModule:
  main()
