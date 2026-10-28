# Hidden widgets only. No popups, visible windows or GTK main loop.
import std/unittest
import gtk2ui
import gtk2 as rawGtk
import glib2 as g

static:
  doAssert typeof(newTreeModelSort(newListStore([cellInt]), 0).raw) is rawGtk.PTreeModelSort
  doAssert typeof(newTreeModelFilter(newListStore([cellBool]), 0).raw) is ptr rawGtk.TreeModelFilter
  doAssert typeof(newTreeRowReference(newListStore([cellInt]), treePath(0)).raw) is rawGtk.PTreeRowReference
  doAssert sizeof(rawGtk.PTreeRowReference) == sizeof(pointer)

proc finalizedCallback(data: pointer, obj: g.PGObject) {.cdecl.} =
  cast[ptr bool](data)[] = true

proc runTests() =
  gtk2ui.init()
  suite "gtk2ui proxies and stable row references":
    test "sort proxies preserve source order and support all scalar kinds":
      let source = newListStore([cellString, cellInt, cellBool, cellFloat])
      discard source.appendRow([cell("Bravo"), cell(20), cell(false), cell(2.0)])
      discard source.appendRow([cell("Alpha"), cell(10), cell(true), cell(1.0)])
      discard source.appendRow([cell("Charlie"), cell(30), cell(true), cell(3.0)])
      let sorted = newTreeModelSort(source, 1)
      check sorted.isFlat
      check sorted.rowCount == 3
      check sorted.sortColumn == 1
      check sorted.sortOrder == sortAscending
      check sorted.value(0, 0).stringValue == "Alpha"
      check source.value(0, 0).stringValue == "Bravo"
      check sorted.toChildPath(treePath(0)) == treePath(1)
      check sorted.fromChildPath(treePath(0)) == treePath(1)
      sorted.sortBy(1, sortDescending)
      check sorted.value(0, 1).intValue == 30
      sorted.sortBy(0)
      check sorted.value(0, 0).stringValue == "Alpha"
      sorted.sortBy(2)
      check not sorted.value(0, 2).boolValue
      sorted.sortBy(3, sortDescending)
      check sorted.value(0, 3).floatValue == 3.0
      check sorted.childModel.value(0, 0).stringValue == "Bravo"
      # Exercise the corrected native gboolean result as well as path conversion.
      var childIter, proxyIter: rawGtk.TTreeIter
      require g.toBool(rawGtk.iter_nth_child(gtk2ui.TreeModel(source).raw, addr childIter, nil, 0))
      check g.toBool(rawGtk.tree_model_sort_convert_child_iter_to_iter(sorted.raw, addr proxyIter, addr childIter))

    test "boolean filtering reacts to source edits and composes with sorting":
      let source = newListStore([cellString, cellInt, cellBool])
      discard source.appendRow([cell("Three"), cell(3), cell(true)])
      discard source.appendRow([cell("Hidden"), cell(2), cell(false)])
      discard source.appendRow([cell("One"), cell(1), cell(true)])
      let filtered = newTreeModelFilter(source, 2)
      let sorted = newTreeModelSort(filtered, 1)
      check filtered.rowCount == 2
      check sorted.rowCount == 2
      check sorted.value(0, 0).stringValue == "One"
      check filtered.fromChildPath(treePath(1)).isRoot
      check filtered.toChildPath(treePath(1)) == treePath(2)
      let displayed = treePath(0)
      let sourcePath = filtered.toChildPath(sorted.toChildPath(displayed))
      check sourcePath == treePath(2)
      source.setValue(sourcePath.indices[0], 0, cell("Renamed"))
      check sorted.value(0, 0).stringValue == "Renamed"
      source.setValue(1, 2, cell(true))
      check filtered.rowCount == 3
      check sorted.rowCount == 3
      check not filtered.fromChildPath(treePath(1)).isRoot
      source.setValue(0, 2, cell(false))
      filtered.refilter()
      check filtered.rowCount == 2
      check filtered.childModel.rowCount == 3
      let view = newTreeView(sorted)
      let combo = newComboBox(sorted)
      defer: view.destroy()
      defer: combo.destroy()
      discard view.appendTextColumn("Name", 0)
      view.selectedIndex = 0
      combo.activeIndex = 0
      check view.model.value(0, 0).stringValue == "Renamed"
      check combo.itemCount == 2
      source.setValue(2, 2, cell(false))
      check sorted.rowCount == 1
      check view.selectedIndex == -1
      check combo.activeIndex == -1

    test "hierarchical proxies sort siblings and hide descendants of invisible ancestors":
      let source = newTreeStore([cellString, cellInt, cellBool])
      let root = source.appendRow([cell("Root"), cell(0), cell(true)])
      let high = source.appendRow([cell("High"), cell(20), cell(true)], parent = root)
      let low = source.appendRow([cell("Low"), cell(10), cell(true)], parent = root)
      let hidden = source.appendRow([cell("Hidden parent"), cell(1), cell(false)])
      let hiddenChild = source.appendRow([cell("Visible flag but hidden ancestor"), cell(1), cell(true)], parent = hidden)
      let filtered = newTreeModelFilter(source, 2)
      let sorted = newTreeModelSort(filtered, 1)
      check not sorted.isFlat
      check sorted.rowCount == 1
      check sorted.childCount(root) == 2
      check sorted.value(treePath(0, 0), 0).stringValue == "Low"
      check sorted.toChildPath(treePath(0, 0)) == low
      check sorted.fromChildPath(high) == treePath(0, 1)
      check filtered.fromChildPath(hidden).isRoot
      check filtered.fromChildPath(hiddenChild).isRoot
      let view = newTreeView(sorted)
      defer: view.destroy()
      discard view.appendTextColumn("Tree", 0)
      view.selectedPath = treePath(0, 0)
      check view.selectedPath == treePath(0, 0)
      expect ValueError: discard newComboBox(sorted)

    test "stable source references survive shifts, while removed rows invalidate aliases":
      let source = newListStore([cellString])
      discard source.appendRow([cell("First")])
      discard source.appendRow([cell("Tracked")])
      let reference = newTreeRowReference(source, treePath(1))
      let alias = reference
      check reference.valid
      source.insertRow(0, [cell("Inserted")])
      check reference.path == treePath(2)
      source.removeRow(0)
      check alias.path == treePath(1)
      source.removeRow(1)
      check not reference.valid
      check not alias.valid
      expect ValueError: discard reference.path
      check reference.model.rowCount == 1
      check not gtk2ui.TreeRowReference().valid
      expect ValueError: discard gtk2ui.TreeRowReference().path
      expect ValueError: discard gtk2ui.TreeRowReference().raw

    test "proxy references track reorder and filtering does not resurrect hidden rows":
      let source = newListStore([cellString, cellInt, cellBool])
      discard source.appendRow([cell("Tracked"), cell(20), cell(true)])
      discard source.appendRow([cell("Other"), cell(10), cell(true)])
      let filtered = newTreeModelFilter(source, 2)
      let sorted = newTreeModelSort(filtered, 1)
      let sourceRef = newTreeRowReference(source, treePath(0))
      let proxyRef = newTreeRowReference(sorted, sorted.fromChildPath(filtered.fromChildPath(sourceRef.path)))
      check proxyRef.path == treePath(1)
      sorted.sortBy(1, sortDescending)
      check proxyRef.path == treePath(0)
      source.setValue(0, 2, cell(false))
      check sourceRef.valid
      check not proxyRef.valid
      source.setValue(0, 2, cell(true))
      check not proxyRef.valid
      let tree = newTreeStore([cellString])
      let parent = tree.appendRow([cell("Parent")])
      let child = tree.appendRow([cell("Child")], parent = parent)
      let childRef = newTreeRowReference(tree, child)
      tree.removeRow(parent)
      check not childRef.valid

    test "reorder callbacks copy arrays and paths, self-disconnect and contain errors":
      let source = newListStore([cellInt])
      for number in [3, 1, 2]: discard source.appendRow([cell(number)])
      let sorted = newTreeModelSort(source, 0)
      check sorted.rowCount == 3
      let anchor = newTreeRowReference(sorted, treePath(0))
      require anchor.valid # Keep this cache level referenced so GTK emits reorders.
      var orders: seq[seq[int]]
      var parents: seq[gtk2ui.TreePath]
      var once: Connection
      once = sorted.onRowsReordered(proc (parent: gtk2ui.TreePath, order: seq[int]) =
        once.disconnect()
        parents.add(parent)
        orders.add(order))
      sorted.sortBy(0, sortDescending)
      require parents.len == 1
      check parents[0].isRoot
      check orders == @[@[2, 1, 0]]
      sorted.sortBy(0)
      check orders == @[@[2, 1, 0]]
      sorted.onRowsReordered(proc (parent: gtk2ui.TreePath, order: seq[int]) =
        raise newException(ValueError, "expected reorder callback error"))
      sorted.onRowsReordered(proc (parent: gtk2ui.TreePath, order: seq[int]) = orders.add(order))
      sorted.sortBy(0, sortDescending)
      check orders.len == 2
      sorted.disconnectSignals()
      let tree = newTreeStore([cellInt])
      let root = tree.appendRow([cell(0)])
      discard tree.appendRow([cell(2)], parent = root)
      discard tree.appendRow([cell(1)], parent = root)
      let sortedTree = newTreeModelSort(tree, 0)
      check sortedTree.childCount(root) == 2
      let childAnchor = newTreeRowReference(sortedTree, treePath(0, 0))
      require childAnchor.valid
      sortedTree.onRowsReordered(proc (parent: gtk2ui.TreePath, order: seq[int]) = parents.add(parent))
      sortedTree.sortBy(0, sortDescending)
      check root in parents
      sortedTree.disconnectSignals()

    test "bad columns, missing paths and virtual roots fail before GTK":
      let source = newListStore([cellString, cellBool])
      discard source.appendRow([cell("One"), cell(true)])
      expect ValueError: discard newTreeModelSort(source, -1)
      expect ValueError: discard newTreeModelSort(source, 2)
      expect ValueError: discard newTreeModelFilter(source, 0)
      expect ValueError: discard newTreeModelFilter(source, 2)
      let sorted = newTreeModelSort(source, 0)
      let filtered = newTreeModelFilter(source, 1)
      expect ValueError: sorted.sortBy(2)
      expect ValueError: discard sorted.toChildPath(treePath())
      expect ValueError: discard sorted.fromChildPath(treePath(3))
      expect ValueError: discard filtered.toChildPath(treePath(3))
      expect ValueError: discard filtered.fromChildPath(treePath())
      expect ValueError: discard newTreeRowReference(source, treePath())
      expect ValueError: discard newTreeRowReference(source, treePath(3))
      expect ValueError: discard sorted.onRowsReordered(nil)
      expect ValueError: discard sorted.onDestroy(proc () = discard)
      check sorted.sortColumn == 0
      check sorted.rowCount == 1

    test "boxed references retain models and proxy handles/getters do not steal references":
      var finalized = false
      proc holdModel(flag: pointer) =
        var reference: gtk2ui.TreeRowReference
        block:
          let source = newListStore([cellInt])
          discard source.appendRow([cell(1)])
          g.weak_ref(cast[g.PGObject](source.raw), finalizedCallback, flag)
          reference = newTreeRowReference(source, treePath(0))
        check not cast[ptr bool](flag)[]
        check reference.model.value(reference.path, 0).intValue == 1
      holdModel(addr finalized)
      check finalized
      var flags: array[3, bool]
      proc releaseChain(flags: ptr array[3, bool]) =
        let source = newListStore([cellInt, cellBool])
        discard source.appendRow([cell(1), cell(true)])
        let filter = newTreeModelFilter(source, 1)
        let sorter = newTreeModelSort(filter, 0)
        g.weak_ref(cast[g.PGObject](source.raw), finalizedCallback, addr flags[][0])
        g.weak_ref(cast[g.PGObject](filter.raw), finalizedCallback, addr flags[][1])
        g.weak_ref(cast[g.PGObject](sorter.raw), finalizedCallback, addr flags[][2])
        let child = sorter.childModel
        check child.rowCount == 1
        let view = newTreeView(sorter)
        view.destroy()
        check sorter.value(0, 0).intValue == 1
      releaseChain(addr flags)
      for done in flags: check done
      var graphFlags: array[4, bool]
      proc makeGraph(flags: ptr array[4, bool]): rawGtk.PWindow =
        let source = newListStore([cellInt, cellBool])
        discard source.appendRow([cell(2), cell(true)])
        discard source.appendRow([cell(1), cell(true)])
        let filter = newTreeModelFilter(source, 1)
        let sorter = newTreeModelSort(filter, 0)
        let anchor = newTreeRowReference(sorter, treePath(0))
        let window = newWindow()
        window.add(newTreeView(sorter))
        result = window.raw
        for i, obj in [cast[g.PGObject](source.raw), cast[g.PGObject](filter.raw),
                       cast[g.PGObject](sorter.raw), cast[g.PGObject](result)]:
          g.weak_ref(obj, finalizedCallback, addr flags[][i])
        sorter.onRowsReordered(proc (parent: gtk2ui.TreePath, order: seq[int]) =
          if anchor.valid: window.title = $sorter.rowCount)
        window.onDestroy(proc () = sorter.disconnectSignals())
        sorter.sortBy(0, sortDescending)
      let native = makeGraph(addr graphFlags)
      rawGtk.destroy(cast[rawGtk.PWidget](native))
      for done in graphFlags: check done

runTests()
