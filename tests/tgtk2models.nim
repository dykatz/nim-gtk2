# Hidden widgets only; no GTK loop, realization, or popup menus.
import std/unittest
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert typeof(newListStore([cellString]).raw) is rawGtk.PListStore
  doAssert typeof(newTreeView(newListStore([cellString])).raw) is rawGtk.PTreeView
  doAssert typeof(newComboBox(newListStore([cellString]))) is ModelComboBox
  doAssert sizeof(rawGtk.PCellLayout) == sizeof(pointer)
  doAssert not compiles(newListStore([cellString]).destroy())
  doAssert not compiles(newComboBoxText().model = newListStore([cellString]))

proc finalizedCallback(data: pointer, obj: g.PGObject) {.cdecl.} =
  cast[ptr bool](data)[] = true

proc runTests() =
  gtk2.init()
  suite "gtk2 flat models and text-cell views":
    test "typed schemas, copied values, atomic inserts and updates":
      let store = newListStore([cellString, cellInt, cellBool, cellFloat])
      check store.columnCount == 4
      check store.rowCount == 0
      for i, kind in [cellString, cellInt, cellBool, cellFloat]:
        check store.columnKind(i) == kind
      var inserted, changed, deleted: seq[int]
      store.onRowInserted(proc (row: int) =
        inserted.add(row)
        check store.value(row, 0).stringValue.len > 0
        check store.value(row, 1).intValue != 0
        check store.value(row, 2).boolValue
        check store.value(row, 3).floatValue != 0.0)
      store.onRowChanged(proc (row: int) = changed.add(row))
      store.onRowDeleted(proc (row: int) = deleted.add(row))
      check store.appendRow([cell("λ🙂"), cell(-12), cell(true), cell(2.5)]) == 0
      store.insertRow(0, [cell("First"), cell(10), cell(true), cell(1.25)])
      check inserted == @[0, 0]
      let saved = store.value(1, 0)
      store.setRow(1, [cell("Changed"), cell(42), cell(false), cell(3.5)])
      check changed == @[1]
      check saved.stringValue == "λ🙂"
      check store.value(1, 0).stringValue == "Changed"
      check store.value(1, 1).intValue == 42
      check not store.value(1, 2).boolValue
      check store.value(1, 3).floatValue == 3.5
      store.setValue(0, 0, cell("Renamed"))
      check changed == @[1, 0]
      store.removeRow(0)
      check deleted == @[0]
      check store.rowCount == 1
      check store.value(0, 0).stringValue == "Changed"
      store.clear()
      check deleted == @[0, 0]
      check store.rowCount == 0
      store.disconnectSignals()

    test "invalid rows, kinds, strings and indices do not partially mutate models":
      let store = newListStore([cellString, cellInt])
      discard store.appendRow([cell("Kept"), cell(1)])
      expect ValueError: discard newListStore([])
      expect ValueError: discard cell(high(uint64))
      expect ValueError: discard cell(NaN)
      expect ValueError: discard cell("a\0b")
      expect ValueError: discard cell("\xFF")
      expect ValueError: discard store.appendRow([cell("Partial")])
      expect ValueError: discard store.appendRow([cell("Partial"), cell(true)])
      expect ValueError: store.setRow(0, [cell("Partial"), cell(false)])
      expect ValueError: store.setValue(0, 0, CellValue(kind: cellString, stringValue: "\xED\xA0\x80"))
      expect ValueError: store.insertRow(2, [cell("Bad"), cell(2)])
      expect ValueError: store.removeRow(-1)
      expect ValueError: discard store.value(1, 0)
      expect ValueError: discard store.value(0, 2)
      expect ValueError: store.setValue(0, 1, cell("Wrong"))
      expect ValueError: discard store.onRowInserted(nil)
      expect ValueError: discard store.onDestroy(proc () = discard)
      check store.rowCount == 1
      check store.value(0, 0).stringValue == "Kept"
      check store.value(0, 1).intValue == 1
      let floats = newListStore([cellFloat])
      expect ValueError:
        discard floats.appendRow([CellValue(kind: cellFloat, floatValue: NaN)])
      check floats.rowCount == 0

    test "TreeView text columns, native scrolling and shared ComboBox model":
      let store = newListStore([cellString, cellString, cellInt])
      discard store.appendRow([cell("First"), cell("One"), cell(1)])
      discard store.appendRow([cell("Second"), cell("Two"), cell(2)])
      let view = newTreeView(store)
      let scroll = newScrolledWindow()
      let combo = newComboBox(store, 1)
      defer: scroll.destroy()
      defer: combo.destroy()
      scroll.add(view)
      check rawGtk.get_child(cast[rawGtk.PBin](scroll.raw)) == cast[rawGtk.PWidget](view.raw)
      let column = view.appendTextColumn("Name", 0)
      column.resizable = true
      column.title = "Names λ"
      check column.title == "Names λ"
      check column.resizable
      column.visible = false
      check not column.visible
      column.visible = true
      view.headersVisible = false
      view.rulesHint = true
      check not view.headersVisible
      check view.rulesHint
      expect ValueError: view.appendColumn(column)
      expect ValueError: discard view.appendTextColumn("Wrong type", 2)
      expect ValueError: discard view.appendTextColumn("Out of range", 3)
      expect ValueError: discard newComboBox(store, 2)
      check combo.itemCount == 2
      check combo.activeIndex == -1
      var changes = 0
      combo.onChanged(proc () = inc changes)
      combo.activeIndex = 1
      check combo.activeIndex == 1
      check changes == 1
      check combo.model.value(1, 1).stringValue == "Two"
      store.setValue(1, 1, cell("Updated"))
      check view.model.value(1, 1).stringValue == "Updated"
      check combo.model.value(1, 1).stringValue == "Updated"
      view.selectedIndex = 1
      store.removeRow(0)
      check combo.activeIndex == 0
      check view.selectedIndex == 0
      store.removeRow(0)
      check combo.activeIndex == -1
      check view.selectedIndex == -1
      let connection = store.onRowChanged(proc (row: int) = discard)
      view.model.disconnectSignals()
      check not connection.connected
      view.destroy()
      check column.title == "Names λ" # An owned column outlives detachment.
      check store.rowCount == 0

    test "selection, activation callbacks and cleanup on native view destruction":
      let store = newListStore([cellString])
      discard store.appendRow([cell("First")])
      discard store.appendRow([cell("Second")])
      let view = newTreeView(store)
      defer: view.destroy()
      discard view.appendTextColumn("Name", 0)
      check view.selectedIndex == -1
      var changes = 0
      let selection = view.onSelectionChanged(proc () = inc changes)
      view.selectedIndex = 1
      check view.selectedIndex == 1
      check changes == 1
      view.selectedIndex = -1
      check view.selectedIndex == -1
      check changes == 2
      expect ValueError: view.selectedIndex = 2
      expect ValueError: view.selectedIndex = -2
      var rows: seq[int]
      var once: Connection
      once = view.onRowActivated(proc (row: int) =
        once.disconnect()
        rows.add(row))
      view.activateRow(1)
      view.activateRow(0)
      check rows == @[1]
      let throws = view.onRowActivated(proc (row: int) =
        raise newException(ValueError, "expected model activation error"))
      view.onRowActivated(proc (row: int) = rows.add(row))
      view.activateRow(0)
      check rows == @[1, 0]
      throws.disconnect()
      view.destroy()
      check not selection.connected

    test "model callback self-disconnection and error containment":
      let store = newListStore([cellString])
      var once: Connection
      var calls = 0
      once = store.onRowInserted(proc (row: int) =
        once.disconnect()
        inc calls)
      discard store.appendRow([cell("One")])
      discard store.appendRow([cell("Two")])
      check calls == 1
      store.onRowChanged(proc (row: int) =
        raise newException(ValueError, "expected model row error"))
      store.onRowChanged(proc (row: int) = inc calls)
      store.setValue(0, 0, cell("Updated"))
      check calls == 2
      store.disconnectSignals()

    test "selection callbacks can disconnect themselves or destroy the emitting view":
      let store = newListStore([cellString])
      discard store.appendRow([cell("One")])
      let view = newTreeView(store)
      defer: view.destroy()
      var once: Connection
      var calls = 0
      once = view.onSelectionChanged(proc () =
        once.disconnect()
        inc calls)
      view.selectedIndex = 0
      view.selectedIndex = -1
      check calls == 1
      let destroyer = view.onSelectionChanged(proc () = view.destroy())
      view.selectedIndex = 0
      check view.isDestroyed
      check not destroyer.connected

    test "transfer-full stores finalize, borrowed getters retain, and columns own renderers":
      var finalized = false
      proc makeStore(flag: pointer) =
        let store = newListStore([cellString])
        g.weak_ref(cast[g.PGObject](store.raw), finalizedCallback, flag)
        store.onRowChanged(proc (row: int) = discard)
      makeStore(addr finalized)
      check finalized
      var modelFinalized, columnFinalized, rendererFinalized = false
      block:
        let store = newListStore([cellString])
        discard store.appendRow([cell("Retained")])
        let view = newTreeView(store)
        let owning = view.model
        let column = view.appendTextColumn("Name", 0)
        g.weak_ref(cast[g.PGObject](store.raw), finalizedCallback, addr modelFinalized)
        g.weak_ref(cast[g.PGObject](column.raw), finalizedCallback, addr columnFinalized)
        let cells = rawGtk.cell_layout_get_cells(cast[rawGtk.PCellLayout](column.raw))
        require cells != nil
        g.weak_ref(cast[g.PGObject](cells.data), finalizedCallback, addr rendererFinalized)
        g.free(cells)
        view.destroy()
        check owning.value(0, 0).stringValue == "Retained"
        check not modelFinalized
        check column.title == "Name"
      check modelFinalized
      check columnFinalized
      check rendererFinalized
      var capturedColumnFinalized = false
      proc releaseCapturedColumn(flag: pointer) =
        let column = newTextColumn("Captured", 0)
        g.weak_ref(cast[g.PGObject](column.raw), finalizedCallback, flag)
        column.onDestroy(proc () = discard column.title)
        column.disconnectSignals()
      releaseCapturedColumn(addr capturedColumnFinalized)
      check capturedColumnFinalized

    test "explicit model cleanup and automatic selection cleanup release captured trees":
      var modelFinalized, windowFinalized = false
      proc makeTree(modelFlag, windowFlag: pointer): rawGtk.PWindow =
        let store = newListStore([cellString])
        discard store.appendRow([cell("Tree")])
        let window = newWindow()
        let view = newTreeView(store)
        window.add(view)
        result = window.raw
        g.weak_ref(cast[g.PGObject](store.raw), finalizedCallback, modelFlag)
        g.weak_ref(cast[g.PGObject](result), finalizedCallback, windowFlag)
        store.onRowChanged(proc (row: int) = window.title = store.value(row, 0).stringValue)
        view.onSelectionChanged(proc () = window.title = $view.selectedIndex)
        window.onDestroy(proc () = store.disconnectSignals())
        view.selectedIndex = 0
      let native = makeTree(addr modelFinalized, addr windowFinalized)
      rawGtk.destroy(cast[rawGtk.PWidget](native))
      check modelFinalized
      check windowFinalized

runTests()
