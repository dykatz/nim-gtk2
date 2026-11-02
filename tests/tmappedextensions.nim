# Explicit opt-in: these tests map offscreen widget trees and an actual editor.
import std/[os, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/gdk2pixbuf as pix
import headers/cairo as cairo

if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped extension tests require an isolated virtual display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "mapped extension sources did not settle")
proc pixel(image: Pixbuf, x, y: int): tuple[r, g, b: uint8] =
  let data = cast[ptr UncheckedArray[uint8]](pix.get_pixels(image.raw))
  let offset = y * pix.get_rowstride(image.raw).int + x * pix.get_n_channels(image.raw).int
  (data[offset], data[offset + 1], data[offset + 2])
proc renderer(column: n.PTreeViewColumn): n.PCellRenderer =
  let list = n.cell_layout_get_cells(cast[n.PCellLayout](column))
  defer: g.free(list)
  cast[n.PCellRenderer](list.data)
proc editingStarted(instance: pointer, editable: n.PCellEditable, path: cstring, data: pointer) {.cdecl.} =
  cast[ptr n.PEntry](data)[] = cast[n.PEntry](g.g_object_ref(editable))

gtk2.init()
suite "mapped rendering and actual inline editing on an isolated display":
  test "offscreen snapshots contain Cairo output and partial redraw preserves other pixels":
    let host = newOffscreenWindow()
    defer: host.destroy()
    let area = newDrawingArea(60, 40)
    host.add(area)
    var color = rgba16(65535, 0, 0)
    var calls = 0
    var clips: seq[tuple[x1, y1, x2, y2: float64]]
    area.onDraw(proc (c: DrawContext, info: DrawInfo) =
      inc calls
      var x1, y1, x2, y2: float64
      cairo.clipExtents(c.raw, x1, y1, x2, y2)
      clips.add((x1, y1, x2, y2))
      c.setSource(color)
      c.paint())
    host.showAll()
    drain()
    require calls > 0
    let original = host.pixbuf
    check original.pixel(5, 5) == (255'u8, 0'u8, 0'u8)
    color = rgba16(0, 0, 65535)
    area.queueDrawArea(20, 20, 5, 5)
    drain()
    let updated = host.pixbuf
    check updated.pixel(22, 22) == (0'u8, 0'u8, 255'u8)
    check updated.pixel(5, 5) == (255'u8, 0'u8, 0'u8)
    check original.pixel(22, 22) == (255'u8, 0'u8, 0'u8)
    check clips[^1] == (20.0, 20.0, 25.0, 25.0)

  test "destroying an actual drawable during rendering stops propagation safely":
    let host = newWindow("Destroy during paint", 100, 100)
    defer: host.destroy()
    let area = newDrawingArea(80, 80)
    host.add(area)
    var calls = 0
    area.onDraw(proc (c: DrawContext, info: DrawInfo) =
      inc calls
      c.setSource(rgba16(0, 65535, 0))
      c.paint()
      area.destroy()
      expect ValueError: c.paint())
    host.showAll()
    drain()
    check calls == 1 and area.isDestroyed

  test "native GtkEntry editor produces a copied deferred edit and commits explicitly":
    let store = newListStore([cellString])
    discard store.appendRow([cell("before")])
    let host = newWindow("Inline editing test", 300, 120)
    defer: host.destroy()
    let view = newTreeView(store)
    host.add(view)
    let column = view.appendTextColumn("Name", 0)
    column.editable = true
    var seen: seq[TextEdit]
    column.onEdited(proc (edit: TextEdit) =
      seen.add(edit)
      if edit.row.valid:
        store.setValue(edit.row.path.indices[0], edit.column, cell(edit.text)))
    var editor: n.PEntry
    let rawRenderer = renderer(column.raw)
    let nativeSignal = g.g_signal_connect_data(rawRenderer, "editing-started",
      cast[g.TGCallback](editingStarted), addr editor, nil, g.TGConnectFlags(0))
    defer:
      if g.g_signal_handler_is_connected(rawRenderer, nativeSignal):
        g.g_signal_handler_disconnect(rawRenderer, nativeSignal)
      if editor != nil: g.g_object_unref(editor)
    expect ValueError: view.startEditing(column, treePath(0)) # Not mapped yet.
    host.showAll()
    drain()
    view.startEditing(column, treePath(0))
    require editor != nil
    n.set_text(editor, "λ🙂 edited")
    g.g_signal_emit_by_name(editor, "activate")
    check seen.len == 0 and store.value(0, 0).stringValue == "before"
    drain()
    check seen.len == 1 and seen[0].text == "λ🙂 edited"
    check store.value(0, 0).stringValue == "λ🙂 edited"
