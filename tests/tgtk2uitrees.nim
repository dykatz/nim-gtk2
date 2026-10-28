# Hidden tree views only. Paths are value snapshots, not persistent row IDs.
import std/unittest
import gtk2ui
import gtk2 as rawGtk
import glib2 as g

static:
  doAssert typeof(newTreeStore([cellString]).raw) is rawGtk.PTreeStore
  doAssert not compiles(newTreeStore([cellString]).destroy())

proc finalizedCallback(data: pointer, obj: g.PGObject) {.cdecl.} =
  cast[ptr bool](data)[] = true

proc runTests() =
  gtk2ui.init()
  suite "gtk2ui hierarchical trees":
    test "paths own their indices and distinguish the virtual root":
      let path = treePath(1, 2, 3)
      check path.depth == 3
      check $path == "1:2:3"
      check path.parentPath == treePath(1, 2)
      check path.parentPath.childPath(3) == path
      var copied = path.indices
      copied[0] = 99
      check path.indices == @[1, 2, 3]
      check treePath().isRoot
      check treePath(0).parentPath.isRoot
      check gtk2ui.TreePath() == treePath()
      expect ValueError: discard treePath(-1)
      expect ValueError: discard path.childPath(-1)
      expect ValueError: discard treePath().parentPath

    test "typed hierarchical rows, root counts, atomic writes and subtree deletion":
      let store = newTreeStore([cellString, cellInt, cellBool, cellFloat])
      check not store.isFlat
      check store.rowCount == 0
      var inserted, changed, deleted: seq[gtk2ui.TreePath]
      store.onPathInserted(proc (path: gtk2ui.TreePath) =
        inserted.add(path)
        check store.value(path, 0).stringValue.len > 0
        check store.value(path, 1).intValue != 0
        check store.value(path, 2).boolValue
        check store.value(path, 3).floatValue > 0)
      store.onPathChanged(proc (path: gtk2ui.TreePath) = changed.add(path))
      store.onPathDeleted(proc (path: gtk2ui.TreePath) = deleted.add(path))
      let root = store.appendRow([cell("Root"), cell(1), cell(true), cell(1.0)])
      let child = store.appendRow([cell("Child"), cell(2), cell(true), cell(2.0)], parent = root)
      let grandchild = store.appendRow([cell("Grandchild"), cell(3), cell(true), cell(3.0)], parent = child)
      check root == treePath(0)
      check child == treePath(0, 0)
      check grandchild == treePath(0, 0, 0)
      check inserted == @[root, child, grandchild]
      check store.rowCount == 1 # Roots, not all descendants.
      check store.childCount() == 1
      check store.childCount(root) == 1
      check store.childCount(child) == 1
      check store.childCount(grandchild) == 0
      check store.hasRow(grandchild)
      check not store.hasRow(treePath())
      check not store.hasRow(treePath(9))
      check not store.hasRow(treePath(0, 9))
      let copied = store.value(child, 0)
      store.setRow(child, [cell("Changed"), cell(22), cell(false), cell(2.25)])
      check changed == @[child]
      check copied.stringValue == "Child"
      check store.value(child, 1).intValue == 22
      check not store.value(child, 2).boolValue
      store.setValue(grandchild, 0, cell("Renamed"))
      check changed == @[child, grandchild]
      discard store.insertRow(0, [cell("First"), cell(4), cell(true), cell(4.0)], parent = root)
      check store.value(treePath(0, 1, 0), 0).stringValue == "Renamed"
      store.removeRow(treePath(0, 0))
      check deleted == @[treePath(0, 0)]
      check store.value(child, 0).stringValue == "Changed"
      store.removeRow(root)
      check store.rowCount == 0
      check not store.hasRow(grandchild)
      check deleted[^1] == root
      store.disconnectSignals()

    test "path values and signals also work for flat models":
      let store = newListStore([cellString])
      var inserted: seq[gtk2ui.TreePath]
      store.onPathInserted(proc (path: gtk2ui.TreePath) = inserted.add(path))
      discard store.appendRow([cell("Flat")])
      check store.isFlat
      check inserted == @[treePath(0)]
      check store.value(treePath(0), 0).stringValue == "Flat"
      check store.childCount(treePath(0)) == 0
      check not store.hasRow(treePath(0, 0))
      expect ValueError: discard store.value(treePath(0, 0), 0)
      store.disconnectSignals()

    test "hierarchical views expand, select hidden descendants, activate and clear":
      let store = newTreeStore([cellString])
      let root = store.appendRow([cell("Root")])
      let branch = store.appendRow([cell("Branch")], parent = root)
      let leaf = store.appendRow([cell("Leaf")], parent = branch)
      let view = newTreeView(store)
      let scroll = newScrolledWindow()
      defer: scroll.destroy()
      scroll.add(view)
      discard view.appendTextColumn("Hierarchy", 0)
      check rawGtk.get_child(cast[rawGtk.PBin](scroll.raw)) == cast[rawGtk.PWidget](view.raw)
      check view.selectedPath.isRoot
      check not view.pathExpanded(root)
      check view.expandPath(root)
      check view.pathExpanded(root)
      check view.collapsePath(root)
      check not view.pathExpanded(root)
      var changes = 0
      let selection = view.onSelectionChanged(proc () = inc changes)
      view.selectedPath = leaf # Opens ancestors but not the selected row itself.
      check view.selectedPath == leaf
      check view.pathExpanded(root)
      check view.pathExpanded(branch)
      check not view.expandPath(leaf)
      check changes == 1
      var activated: seq[gtk2ui.TreePath]
      view.onPathActivated(proc (path: gtk2ui.TreePath) = activated.add(path))
      view.activateRow(leaf)
      check activated == @[leaf]
      check view.model.value(view.selectedPath, 0).stringValue == "Leaf"
      view.selectedPath = treePath()
      check view.selectedPath.isRoot
      check changes == 2
      view.collapseAll()
      check not view.pathExpanded(root)
      view.expandAll()
      check view.pathExpanded(root)
      check view.pathExpanded(branch)
      view.selectedPath = leaf
      store.removeRow(branch)
      check view.selectedPath.isRoot
      check not store.hasRow(leaf)
      store.clear()
      check store.rowCount == 0
      view.destroy()
      check not selection.connected

    test "flat-only APIs reject hierarchy before native calls or signal registration":
      let store = newTreeStore([cellString])
      let root = store.appendRow([cell("Root")])
      let view = newTreeView(store)
      defer: view.destroy()
      expect ValueError: discard newComboBox(store)
      expect ValueError: discard store.value(0, 0)
      expect ValueError: discard store.onRowInserted(proc (row: int) = discard)
      expect ValueError: discard store.onRowChanged(proc (row: int) = discard)
      expect ValueError: discard store.onRowDeleted(proc (row: int) = discard)
      expect ValueError: discard view.selectedIndex
      expect ValueError: view.selectedIndex = -1
      expect ValueError: view.activateRow(0)
      expect ValueError: discard view.onRowActivated(proc (row: int) = discard)
      view.selectedPath = root
      check view.selectedPath == root

    test "invalid writes and non-row paths are rejected without partial changes":
      let store = newTreeStore([cellString, cellInt])
      let root = store.appendRow([cell("Kept"), cell(1)])
      let view = newTreeView(store)
      defer: view.destroy()
      expect ValueError: discard newTreeStore([])
      expect ValueError: discard store.appendRow([cell("Bad"), cell(false)], parent = root)
      expect ValueError: discard store.insertRow(2, [cell("Bad"), cell(2)], parent = root)
      expect ValueError: discard store.appendRow([cell("Bad"), cell(2)], parent = treePath(9))
      expect ValueError: store.setRow(root, [cell("Bad"), cell(true)])
      expect ValueError: store.setValue(root, 0, CellValue(kind: cellString, stringValue: "\xFF"))
      expect ValueError: store.setValue(root, 2, cell(2))
      expect ValueError: store.removeRow(treePath())
      expect ValueError: store.removeRow(treePath(9))
      expect ValueError: discard store.childCount(treePath(9))
      expect ValueError: discard store.value(treePath(), 0)
      expect ValueError: view.selectedPath = treePath(9)
      expect ValueError: discard view.expandPath(treePath())
      expect ValueError: discard view.collapsePath(treePath(9))
      expect ValueError: view.activateRow(treePath())
      expect ValueError: discard store.onPathInserted(nil)
      expect ValueError: discard view.onPathActivated(nil)
      check store.rowCount == 1
      check store.childCount(root) == 0
      check store.value(root, 0).stringValue == "Kept"

    test "copied path callbacks self-disconnect, contain errors and survive mutations":
      let store = newTreeStore([cellString])
      var paths: seq[gtk2ui.TreePath]
      var once: Connection
      once = store.onPathInserted(proc (path: gtk2ui.TreePath) =
        once.disconnect()
        paths.add(path))
      let root = store.appendRow([cell("Root")])
      discard store.appendRow([cell("Child")], parent = root)
      check paths == @[treePath(0)]
      store.onPathChanged(proc (path: gtk2ui.TreePath) =
        raise newException(ValueError, "expected tree path error"))
      store.onPathChanged(proc (path: gtk2ui.TreePath) = paths.add(path))
      store.setValue(treePath(0, 0), 0, cell("Changed"))
      check paths == @[treePath(0), treePath(0, 0)]
      store.onPathDeleted(proc (path: gtk2ui.TreePath) = paths.add(path))
      store.removeRow(root)
      check paths[^1] == treePath(0)
      check paths[1] == treePath(0, 0) # Native paths are already freed/reused.
      store.disconnectSignals()
      let view = newTreeView(store)
      defer: view.destroy()
      let next = store.appendRow([cell("Next")])
      view.onPathActivated(proc (path: gtk2ui.TreePath) = view.destroy())
      view.activateRow(next)
      check view.isDestroyed

    test "transfer-full ownership, owning model getters, and captured trees finalize":
      var finalized = false
      proc makeStore(flag: pointer) =
        let store = newTreeStore([cellString])
        g.weak_ref(cast[g.PGObject](store.raw), finalizedCallback, flag)
      makeStore(addr finalized)
      check finalized
      let store = newTreeStore([cellString])
      let root = store.appendRow([cell("Retained")])
      let view = newTreeView(store)
      let owning = view.model
      view.destroy()
      check owning.value(root, 0).stringValue == "Retained"
      var windowFinalized, modelFinalized = false
      proc makeTree(windowFlag, modelFlag: pointer): rawGtk.PWindow =
        let store = newTreeStore([cellString])
        let root = store.appendRow([cell("Root")])
        let window = newWindow()
        let view = newTreeView(store)
        window.add(view)
        result = window.raw
        g.weak_ref(cast[g.PGObject](result), finalizedCallback, windowFlag)
        g.weak_ref(cast[g.PGObject](store.raw), finalizedCallback, modelFlag)
        store.onPathChanged(proc (path: gtk2ui.TreePath) = window.title = store.value(path, 0).stringValue)
        view.onSelectionChanged(proc () = window.title = $view.selectedPath)
        window.onDestroy(proc () = store.disconnectSignals())
        view.selectedPath = root
      let native = makeTree(addr windowFinalized, addr modelFinalized)
      rawGtk.destroy(cast[rawGtk.PWidget](native))
      check windowFinalized
      check modelFinalized

runTests()
