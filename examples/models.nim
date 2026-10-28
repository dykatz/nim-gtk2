## A typed flat model shared by TreeView and model-backed ComboBox.
## Build: nim c --path:src examples/models.nim
import gtk2ui

proc main() =
  gtk2ui.init()
  let window = newWindow("gtk2ui shared list model", 640, 400)
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
  let nameColumn = view.appendTextColumn("Language", 0)
  nameColumn.resizable = true
  discard view.appendTextColumn("Category", 1)
  view.rulesHint = true
  let scroll = newScrolledWindow()
  scroll.add(view)
  layout.packStart(scroll)
  let actions = newHBox(spacing = 6)
  let name = newEntry("New language")
  let add = newButton("Add")
  let rename = newButton("Rename selected")
  let remove = newButton("Remove selected")
  actions.packStart(name)
  actions.packStart(add, packShrink)
  actions.packStart(rename, packShrink)
  actions.packStart(remove, packShrink)
  layout.packStart(actions, packShrink)
  let status = newLabel()
  layout.packStart(status, packShrink)

  proc refresh() =
    let row = view.selectedIndex
    if row < 0:
      status.text = $store.rowCount & " rows; no selection"
    else:
      status.text = store.value(row, 0).stringValue & ": year " &
        $store.value(row, 2).intValue & ", score " & $store.value(row, 4).floatValue

  proc refreshCombo() =
    let row = combo.activeIndex
    comboStatus.text = if row >= 0: "Combo: " & store.value(row, 0).stringValue
                       else: "Combo: no selection"

  # Share data, not selection. Avoid cross-widget selection changes while GTK
  # is still notifying its native model consumers of structural edits.
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
    view.selectedIndex = row
    refresh()
  rename.onClicked do ():
    if view.selectedIndex >= 0: store.setValue(view.selectedIndex, 0, cell(name.text))
  remove.onClicked do ():
    if view.selectedIndex >= 0: store.removeRow(view.selectedIndex)
    refresh()
  combo.activeIndex = 0
  view.selectedIndex = 0
  refresh()
  window.run()

when isMainModule:
  main()
