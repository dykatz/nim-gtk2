## Hierarchical TreeStore with copied paths, editing and expansion.
## Build: nim c --path:src examples/trees.nim
import gtk2ui

proc main() =
  gtk2ui.init()
  let window = newWindow("gtk2ui tree explorer", 620, 420)
  defer: window.destroy()
  window.borderWidth = 10
  let layout = newVBox(spacing = 8)
  window.add(layout)
  let store = newTreeStore([cellString, cellInt])
  let source = store.appendRow([cell("Source"), cell(1)])
  let bindings = store.appendRow([cell("Bindings"), cell(2)], parent = source)
  discard store.appendRow([cell("GTK2"), cell(3)], parent = bindings)
  discard store.appendRow([cell("GLib"), cell(4)], parent = bindings)
  discard store.appendRow([cell("Examples"), cell(5)], parent = source)
  discard store.appendRow([cell("Documentation"), cell(6)])

  let view = newTreeView(store)
  let column = view.appendTextColumn("Project items", 0)
  column.resizable = true
  let scroll = newScrolledWindow()
  scroll.add(view)
  layout.packStart(scroll)
  let actions = newHBox(spacing = 6)
  let name = newEntry("New item")
  let add = newButton("Add child/root")
  let rename = newButton("Rename")
  let remove = newButton("Remove subtree")
  actions.packStart(name)
  actions.packStart(add, packShrink)
  actions.packStart(rename, packShrink)
  actions.packStart(remove, packShrink)
  layout.packStart(actions, packShrink)
  let expansion = newHBox(spacing = 6)
  let expand = newButton("Expand all")
  let collapse = newButton("Collapse all")
  let clearSelection = newButton("Clear selection")
  expansion.packStart(expand, packShrink)
  expansion.packStart(collapse, packShrink)
  expansion.packStart(clearSelection, packShrink)
  layout.packStart(expansion, packShrink)
  let status = newLabel()
  layout.packStart(status, packShrink)

  proc refresh() =
    let path = view.selectedPath
    if path.isRoot:
      status.text = $store.rowCount & " roots; no selection (Add creates a root)"
    elif store.hasRow(path):
      status.text = "Path " & $path & ": " & store.value(path, 0).stringValue &
        "; " & $store.childCount(path) & " children"

  view.onSelectionChanged(proc () = refresh())
  view.onPathActivated(proc (path: TreePath) =
    status.text = "Activated " & $path & ": " & store.value(path, 0).stringValue)
  store.onPathChanged(proc (path: TreePath) = refresh())
  window.onDestroy(proc () = store.disconnectSignals())
  defer: store.disconnectSignals()
  var nextId = 7
  add.onClicked do ():
    let path = store.appendRow([cell(name.text), cell(nextId)], parent = view.selectedPath)
    inc nextId
    view.selectedPath = path
    refresh()
  rename.onClicked do ():
    let path = view.selectedPath
    if not path.isRoot: store.setValue(path, 0, cell(name.text))
  remove.onClicked do ():
    let path = view.selectedPath
    if not path.isRoot: store.removeRow(path)
    refresh()
  expand.onClicked(proc () = view.expandAll())
  collapse.onClicked(proc () = view.collapseAll())
  clearSelection.onClicked(proc () = view.selectedPath = treePath())
  view.selectedPath = treePath(0, 0, 0)
  refresh()
  window.run()

when isMainModule:
  main()
