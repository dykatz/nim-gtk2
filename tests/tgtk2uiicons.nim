import std/[unittest, os, tempfiles]
import gtk2ui
import headers/gtk2 as rawGtk
import headers/gdk2pixbuf as pb
import headers/glib2 as g

proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = cast[ptr bool](data)[] = true

proc runTests() =
  gtk2ui.init()
  suite "gtk2ui pixbufs and icon views":
    test "owned RGBA buffers, copies, scaling and checked dimensions":
      let image = newPixbuf(8, 6, 0x12345678'u32)
      check image.width == 8
      check image.height == 6
      check image.hasAlpha
      let pixels = cast[ptr UncheckedArray[uint8]](pb.get_pixels(image.raw))
      check @[pixels[0], pixels[1], pixels[2], pixels[3]] == @[0x12'u8, 0x34, 0x56, 0x78]
      let duplicate = image.copy()
      check duplicate.raw != image.raw
      check duplicate.width == 8
      for interpolation in Interpolation:
        let small = image.scaled(4, 3, interpolation)
        check small.width == 4
        check small.height == 3
      expect ValueError: discard newPixbuf(0, 2)
      expect ValueError: discard newPixbuf(-1, 2)
      expect ValueError: discard newPixbuf(high(g.gint).int, 2)
      expect ValueError: discard image.scaled(0, 2)
      expect ValueError: discard image.scaled(high(g.gint).int, 2)
      check gtk2ui.Pixbuf().isEmpty
      expect ValueError: discard gtk2ui.Pixbuf().width
      expect ValueError: discard image.onDestroy(proc () = discard)

    test "file loading copies native errors and owns loaded RGB pixels":
      let (file, path) = createTempFile("gtk2ui-pixbuf-", ".ppm")
      file.close()
      defer: removeFile(path)
      writeFile(path, "P6\n2 1\n255\n" & "\xff\x00\x00\x00\xff\x00")
      let loaded = loadPixbuf(path)
      check loaded.width == 2
      check loaded.height == 1
      check not loaded.hasAlpha
      writeFile(path, "not an image")
      try:
        discard loadPixbuf(path)
        check false
      except gtk2ui.PixbufError as error:
        check error.domain != 0
        check error.msg.len > 0
      expect gtk2ui.PixbufError: discard loadPixbuf(path & ".missing")
      expect ValueError: discard loadPixbuf("bad\0file")

    test "image and model getters retain pixbufs, null cells remain explicit":
      var flag = false
      proc keepPixels(flag: pointer): gtk2ui.Pixbuf =
        let pixels = newPixbuf(5, 7, 0x102030ff'u32)
        g.weak_ref(cast[g.PGObject](pixels.raw), finalized, flag)
        let widget = newImage(pixels)
        result = widget.pixbuf
        check result.raw == pixels.raw
        widget.pixbuf = gtk2ui.Pixbuf()
        check widget.storageKind == imageEmpty
        check widget.pixbuf.isEmpty
        widget.destroy()
        let wrong = newImageFromIcon("document-open")
        expect ValueError: discard wrong.pixbuf
        wrong.destroy()
      proc releasePixels(flag: pointer) =
        let kept = keepPixels(flag)
        check not cast[ptr bool](flag)[]
        check kept.height == 7
      releasePixels(addr flag)
      check flag
      let store = newListStore([cellString, cellPixbuf])
      let pixels = newPixbuf(4, 4)
      discard store.appendRow([cell("First"), cell(pixels)])
      discard store.appendRow([cell("None"), cell(gtk2ui.Pixbuf())])
      check store.columnKind(1) == cellPixbuf
      check store.value(0, 1).pixbufValue.raw == pixels.raw
      check store.value(1, 1).pixbufValue.isEmpty
      let kept = store.value(0, 1).pixbufValue
      store.setValue(0, 1, cell(gtk2ui.Pixbuf()))
      store.clear()
      check kept.width == 4
      let tree = newTreeStore([cellPixbuf])
      let row = tree.appendRow([cell(pixels)])
      check tree.value(row, 0).pixbufValue.width == 4
      expect ValueError: discard newTreeModelSort(store, 1)
      let sorted = newTreeModelSort(store, 0)
      expect ValueError: sorted.sortBy(1)
      check sorted.sortColumn == 0

    test "icon view uses plain text and native scrolling with checked single selection":
      let source = newListStore([cellString, cellPixbuf])
      for name in ["<b>Literal</b>", "Second", "Third"]:
        discard source.appendRow([cell(name), cell(newPixbuf(16, 16))])
      let view = newIconView(source, 1, 0)
      let scroll = newScrolledWindow()
      scroll.add(view)
      defer: scroll.destroy()
      check rawGtk.get_parent(cast[rawGtk.PWidget](view.raw)) == cast[rawGtk.PWidget](scroll.raw)
      check rawGtk.icon_view_get_markup_column(view.raw) == -1
      check view.model.rowCount == 3
      check view.selectedIndex == -1
      var selections = 0
      view.onSelectionChanged(proc () = inc selections)
      view.selectedIndex = 1
      check view.selectedPath == treePath(1)
      check selections == 1
      view.selectedPath = treePath()
      check view.selectedIndex == -1
      check selections == 2
      view.selectedPath = treePath(2)
      view.scrollToRow(2)
      view.columns = 2
      view.itemWidth = 80
      view.spacing = 4
      view.rowSpacing = 5
      view.columnSpacing = 6
      view.margin = 7
      check view.columns == 2
      check view.itemWidth == 80
      check view.spacing == 4
      check view.rowSpacing == 5
      check view.columnSpacing == 6
      check view.margin == 7
      view.columns = -1
      view.itemWidth = -1
      check view.columns == -1
      source.removeRow(2)
      check view.selectedIndex == -1
      expect ValueError: view.selectedIndex = -2
      expect ValueError: view.selectedIndex = 8
      expect ValueError: view.selectedPath = treePath(0, 0)
      expect ValueError: view.columns = 0
      expect ValueError: view.itemWidth = -2
      expect ValueError: view.spacing = -1
      expect ValueError: view.scrollToRow(9)
      expect ValueError: discard view.onSelectionChanged(nil)
      rawGtk.icon_view_set_selection_mode(view.raw, rawGtk.SELECTION_MULTIPLE)
      expect ValueError: discard view.selectedIndex
      expect ValueError: view.selectedIndex = 0
      rawGtk.icon_view_set_selection_mode(view.raw, rawGtk.SELECTION_SINGLE)

    test "icon view composes with proxies and validates fixed bindings before GTK":
      let source = newListStore([cellString, cellPixbuf, cellBool])
      discard source.appendRow([cell("Zulu"), cell(newPixbuf(8, 8)), cell(true)])
      discard source.appendRow([cell("Alpha"), cell(gtk2ui.Pixbuf()), cell(true)])
      let filtered = newTreeModelFilter(source, 2)
      let sorted = newTreeModelSort(filtered, 0)
      let view = newIconView(sorted, 1, 0)
      defer: view.destroy()
      view.selectedIndex = 0
      check view.model.value(view.selectedIndex, 0).stringValue == "Alpha"
      source.setValue(1, 2, cell(false))
      check view.selectedIndex == -1
      check view.model.rowCount == 1
      let iconsOnly = newIconView(source, 1)
      iconsOnly.destroy()
      expect ValueError: discard newIconView(source, 0)
      expect ValueError: discard newIconView(source, 1, 2)
      expect ValueError: discard newIconView(source, -1)
      expect ValueError: discard newIconView(source, 1, -2)
      let tree = newTreeStore([cellPixbuf])
      expect ValueError: discard newIconView(tree, 0)
      expect ValueError: source.setRow(0, [cell("Bad"), cell(3), cell(true)])
      check source.value(0, 0).stringValue == "Zulu"

    test "activation copies paths, self-disconnects, contains errors and permits destruction":
      let source = newListStore([cellPixbuf])
      discard source.appendRow([cell(newPixbuf(8, 8))])
      let view = newIconView(source, 0)
      var paths: seq[gtk2ui.TreePath]
      var once: Connection
      once = view.onPathActivated(proc (path: gtk2ui.TreePath) =
        paths.add(path)
        once.disconnect())
      view.activateRow(0)
      view.activateRow(0)
      check paths == @[treePath(0)]
      view.onItemActivated(proc (index: int) =
        raise newException(ValueError, "expected icon activation error"))
      var activated = -1
      view.onItemActivated(proc (index: int) = activated = index)
      view.activateRow(0)
      check activated == 0
      expect ValueError: view.activateRow(3)
      expect ValueError: discard view.onItemActivated(nil)
      expect ValueError: discard view.onPathActivated(nil)
      let closer = view.onItemActivated(proc (index: int) = view.destroy())
      view.activateRow(0)
      check view.isDestroyed
      check not closer.connected
      check source.rowCount == 1

    test "model-held pixels outlive constructors and all retained graph objects finalize":
      var flags: array[4, bool]
      proc makeGraph(flags: ptr array[4, bool]): rawGtk.PWindow =
        let pixels = newPixbuf(8, 8)
        let source = newListStore([cellString, cellPixbuf])
        discard source.appendRow([cell("Tile"), cell(pixels)])
        let view = newIconView(source, 1, 0)
        let window = newWindow()
        window.add(view)
        result = window.raw
        for i, obj in [cast[g.PGObject](pixels.raw), cast[g.PGObject](source.raw),
                       cast[g.PGObject](view.raw), cast[g.PGObject](window.raw)]:
          g.weak_ref(obj, finalized, addr flags[][i])
        view.onItemActivated(proc (index: int) = window.title = source.value(index, 0).stringValue)
        view.onSelectionChanged(proc () = window.title = $view.selectedIndex)
      let native = makeGraph(addr flags)
      rawGtk.destroy(cast[rawGtk.PWidget](native))
      for done in flags: check done
      var pixelGone = false
      proc holdByModel(flag: pointer): ListStore =
        let pixels = newPixbuf(9, 9)
        g.weak_ref(cast[g.PGObject](pixels.raw), finalized, flag)
        result = newListStore([cellPixbuf])
        discard result.appendRow([cell(pixels)])
      let holder = holdByModel(addr pixelGone)
      check not pixelGone
      check holder.value(0, 0).pixbufValue.height == 9
      holder.clear()
      check pixelGone

runTests()
