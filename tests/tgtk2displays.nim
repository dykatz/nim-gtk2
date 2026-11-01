import std/unittest
import gtk2
import headers/gtk2 as native
import headers/glib2 as g
import headers/gdk2 as gd

static:
  doAssert typeof(newHSV().raw) is ptr native.HSV
  doAssert typeof(newCellView().raw) is ptr native.CellView
  doAssert typeof(newOffscreenWindow().raw) is ptr native.OffscreenWindow
proc drain() =
  for i in 0..<256:
    if native.events_pending() == 0: return
    discard native.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "UI sources did not settle")
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CaptureObj = object
  freed, calls: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.freed[]
type Capture = ref CaptureObj
proc watchHSV(w: gtk2.HSV, freed, calls: ptr int): Connection =
  let capture = Capture(freed: freed, calls: calls)
  w.onChanged(proc (value: HSVState) = inc capture.calls[])
proc watchOffscreen(w: gtk2.OffscreenWindow, freed, calls: ptr int): Connection =
  let capture = Capture(freed: freed, calls: calls)
  w.onSnapshot(proc (image: Pixbuf) = inc capture.calls[])
proc realizeHidden(w: gtk2.OffscreenWindow, width = 40, height = 24) =
  var allocation = native.TAllocation(width: g.gint(width), height: g.gint(height))
  native.size_allocate(gtk2.Widget(w).raw, addr allocation)
  native.realize(gtk2.Widget(w).raw)
  doAssert not g.toBool(native.WIDGET_MAPPED(w.raw))
proc damage(w: gtk2.OffscreenWindow) =
  # A genuine C-allocated GdkEvent avoids guessing the native union size.
  let event = gd.event_new(gd.DAMAGE)
  defer: gd.free(event)
  let expose = cast[gd.PEventExpose](event)
  expose.window = cast[gd.PWindow](g.g_object_ref(native.get_window(gtk2.Widget(w).raw)))
  expose.area = gd.TRectangle(width: 10, height: 10)
  expose.region = gd.region_rectangle(addr expose.area)
  var handled = g.gbool(false)
  g.g_signal_emit_by_name(w.raw, "damage-event", event, addr handled)
  doAssert not g.toBool(handled)
proc temporaryHSV(freed, calls: ptr int): ptr native.HSV =
  let w = newHSV()
  discard g.g_object_ref(w.raw)
  discard watchHSV(w, freed, calls)
  w.color = hsvColor(0.5, 1, 1)
  w.raw
proc temporaryCell(model: gtk2.TreeModel): ptr native.CellView =
  let w = newCellView(model, 0)
  discard g.g_object_ref(w.raw)
  w.raw

gtk2.init()
suite "cell views, HSV and offscreen windows (never mapped)":
  test "normalized HSV and native RGB conversion, including endpoints and alpha":
    let red = hsvColor(0, 1, 1).toColor()
    check red == rgba16(65535, 0, 0)
    check hsvColor(1, 1, 1).toColor() == red
    check hsvColor(0.5, 1, 1).toColor(123) == rgba16(0, 65535, 65535, 123)
    check hsvColor(0.8, 0, 0.5).toColor() == rgba16(32768, 32768, 32768)
    let hsv = rgba16(0, 65535, 0, 12).toHSV()
    check abs(hsv.hue - 1.0/3) < 1e-12 and hsv.saturation == 1 and hsv.value == 1
    for color in [rgba16(0, 0, 0), rgba16(65535, 65535, 65535), rgba16(100, 20000, 64000)]:
      check color.toHSV().toColor() == color
    for invalid in [-0.1, 1.1, Inf, NegInf, NaN]:
      expect ValueError: discard hsvColor(invalid, 0, 0)
      expect ValueError: discard hsvColor(0, invalid, 0)
      expect ValueError: discard HSVColor(hue: 0, saturation: 0, value: invalid).toColor()
      expect ValueError: discard newHSV(HSVColor(hue: invalid))

  test "HSV geometry is atomic, checked before GTK including signed overflow":
    let w = newHSV(hsvColor(0.5, 1, 1), 101, 20)
    defer: w.destroy()
    check w.color == hsvColor(0.5, 1, 1) and not w.isAdjusting
    check w.metrics == HSVMetrics(diameter: 101, ringWidth: 20)
    w.metrics = HSVMetrics(diameter: 61, ringWidth: 30)
    for bad in [HSVMetrics(diameter: 0, ringWidth: 0), HSVMetrics(diameter: 5, ringWidth: 3),
        HSVMetrics(diameter: 100, ringWidth: -1), HSVMetrics(diameter: high(cint).int, ringWidth: high(cint).int)]:
      expect ValueError: w.metrics = bad
      check w.metrics == HSVMetrics(diameter: 61, ringWidth: 30)
    expect ValueError: discard newHSV(diameter = 20, ringWidth = 10)
    expect ValueError: w.color = HSVColor(hue: NaN)
    check w.color == hsvColor(0.5, 1, 1)
    check not g.toBool(native.WIDGET_MAPPED(w.raw))

  test "HSV idle observations coalesce, deduplicate, reenter and contain exceptions":
    let w = newHSV()
    defer: w.destroy()
    var seen: seq[HSVState]
    w.onChanged(proc (value: HSVState) = seen.add(value))
    w.color = hsvColor(0.2, 1, 1)
    w.color = hsvColor(0.4, 1, 1)
    check seen.len == 0
    drain()
    check seen.len == 1 and seen[0].color == hsvColor(0.4, 1, 1) and not seen[0].adjusting
    w.color = w.color # Native emits even for the same value; observer deduplicates.
    drain()
    check seen.len == 1
    var reentered = 0
    let reentry = w.onChanged(proc (value: HSVState) =
      inc reentered
      if reentered == 1: w.color = hsvColor(0.3, 1, 1))
    w.color = hsvColor(0.25, 1, 1)
    drain()
    check reentered == 2
    reentry.disconnect()
    var connection: Connection
    connection = w.onChanged(proc (value: HSVState) =
      connection.disconnect()
      w.destroy()
      raise newException(ValueError, "expected HSV callback error"))
    w.color = hsvColor(0.6, 1, 1)
    drain()
    check w.isDestroyed and not connection.connected
    expect ValueError: discard newHSV().onChanged(nil) # Empty callback rejected.

  test "HSV cancellation releases captures, including native ownership without Nim state":
    let w = newHSV()
    defer: w.destroy()
    var freed, calls = 0
    let cancel = watchHSV(w, addr freed, addr calls)
    w.color = hsvColor(0.5, 1, 1)
    cancel.disconnect()
    drain()
    check freed == 1 and calls == 0
    let pending = watchHSV(w, addr freed, addr calls)
    w.color = hsvColor(0.2, 1, 1)
    w.destroy()
    drain()
    check not pending.connected and freed == 2 and calls == 0
    let pointer = temporaryHSV(addr freed, addr calls)
    native.destroy(cast[native.PWidget](pointer))
    g.g_object_unref(pointer)
    drain()
    check freed == 3 and calls == 0

  test "static cell text is plain UTF-8, image getters own aliases and modes can change":
    let w = newCellView("<b>Café</b>")
    defer: w.destroy()
    check w.text == "<b>Café</b>" # Never interpreted as markup.
    expect ValueError: w.text = "bad\0text"
    expect ValueError: w.text = "\xff"
    check w.text == "<b>Café</b>"
    let image = newPixbuf(8, 6, 0x0080ffff'u32)
    w.pixbuf = image
    let alias = w.pixbuf
    check alias.raw == image.raw
    expect ValueError: discard w.text
    w.text = "New content"
    check w.text == "New content" and alias.width == 8
    expect ValueError: discard w.pixbuf
    expect ValueError: discard w.model
    expect ValueError: w.displayedPath = treePath()
    w.pixbuf = Pixbuf()
    check w.pixbuf.isEmpty
    w.backgroundColor = rgba16(65535, 0, 0, 0) # Native background is RGB, not alpha.
    w.clearBackground()
    let empty = newCellView(Pixbuf())
    defer: empty.destroy()
    check empty.pixbuf.isEmpty

  test "static renderer and model references release on replacement/finalization":
    var imageGone, modelGone, viewGone = 0
    block:
      let w = newCellView()
      g.weak_ref(cast[g.PGObject](w.raw), finalized, addr viewGone)
      block:
        let image = newPixbuf(4, 4)
        g.weak_ref(cast[g.PGObject](image.raw), finalized, addr imageGone)
        w.pixbuf = image
      check imageGone == 0
      w.text = "Release static image"
      check imageGone == 1
      block:
        let model = newListStore([cellString])
        g.weak_ref(cast[g.PGObject](gtk2.TreeModel(model).raw), finalized, addr modelGone)
        w.setModel(model, 0)
        discard model.appendRow([cell("pending update")])
      check modelGone == 0
      w.text = "Stop model watches and pending idle"
      drain()
      check modelGone == 1
      w.destroy()
    check viewGone == 1

  test "fixed model cells own their model; row reference tracks insertion/deletion":
    let model = newListStore([cellString, cellPixbuf, cellInt])
    let image = newPixbuf(8, 6)
    discard model.appendRow([cell("one"), cell(image), cell(1)])
    discard model.appendRow([cell("A longer café title"), cell(Pixbuf()), cell(2)])
    let w = newCellView(model, 0, 1)
    defer: w.destroy()
    check w.model.raw == gtk2.TreeModel(model).raw and w.displayedPath.isRoot
    w.displayedRow = 1
    check w.displayedRow == 1
    let saved = w.displayedPath
    let size = w.rowSize(treePath(1))
    check size.width > 0 and size.height > 0 and w.displayedRow == 1
    model.insertRow(0, [cell("inserted"), cell(image), cell(3)])
    check w.displayedRow == 2 and saved == treePath(1)
    var order = [g.gint(2), g.gint(0), g.gint(1)]
    native.reorder(model.raw, addr order[0])
    check w.displayedRow == 0
    model.setValue(0, 0, cell("updated"))
    drain() # Coalesced automatic native redraw/resize after model signals finish.
    model.removeRow(0)
    check w.displayedPath.isRoot and w.displayedRow == -1
    expect ValueError: w.displayedRow = -2
    expect ValueError: w.displayedRow = 20
    expect ValueError: discard w.rowSize(treePath())
    expect ValueError: discard w.rowSize(treePath(20))
    expect ValueError: w.setModel(model, 2)
    expect ValueError: w.setModel(model, 0, 2)
    check w.model.raw == gtk2.TreeModel(model).raw
    expect ValueError: discard newCellView(model, -1)
    expect ValueError: discard newCellView(model, 0, -2)
    w.displayedRow = 0
    w.displayedRow = -1
    check w.displayedPath.isRoot
    w.setModel(model, 0)
    check w.displayedPath.isRoot
    model.setValue(0, 0, cell("pending"))
    w.text = "Replaced before idle" # Must cancel old model delivery.
    drain()
    check w.text == "Replaced before idle"

  test "tree and proxy paths, view/model native finalization and temporary wrappers":
    let tree = newTreeStore([cellString])
    let parent = tree.appendRow([cell("parent")])
    let child = tree.appendRow([cell("child")], parent)
    let w = newCellView(tree, 0)
    defer: w.destroy()
    w.displayedPath = child
    check w.displayedPath == treePath(0, 0)
    expect ValueError: w.displayedRow = 0
    check w.rowSize(child).height > 0
    let proxy = newTreeModelSort(tree, 0)
    w.setModel(proxy, 0)
    w.displayedPath = child
    check w.displayedPath == child
    var modelGone, viewGone = 0
    block:
      let model = newListStore([cellString])
      g.weak_ref(cast[g.PGObject](gtk2.TreeModel(model).raw), finalized, addr modelGone)
      let pointer = temporaryCell(model)
      g.weak_ref(cast[g.PGObject](pointer), finalized, addr viewGone)
      discard model.appendRow([cell("pending")])
      native.destroy(cast[native.PWidget](pointer))
      g.g_object_unref(pointer)
      drain()
      check viewGone == 1
    check modelGone == 1

  test "offscreen snapshots are nullable before realization, transfer-full thereafter":
    expect ValueError: discard newOffscreenWindow(0, 20)
    let w = newOffscreenWindow(40, 24)
    defer: w.destroy()
    check w.pixbuf.isEmpty
    expect ValueError: gtk2.Window(w).present()
    expect ValueError: gtk2.Window(w).run()
    expect ValueError: gtk2.Window(w).modal = true
    let onscreen = newWindow()
    defer: onscreen.destroy()
    expect ValueError: onscreen.transientFor = w
    expect ValueError: gtk2.Window(w).transientFor = onscreen
    let child = newLabel("Offscreen content")
    w.add(child)
    let other = newLabel("extra")
    defer: other.destroy()
    expect ValueError: gtk2.Bin(w).add(other)
    let host = newVBox()
    defer: host.destroy()
    expect ValueError: host.packStart(w)
    w.realizeHidden()
    let first = w.pixbuf
    let second = w.pixbuf
    check not first.isEmpty and first.width == 40 and first.height == 24
    check first.raw != second.raw # Native getter produces independent pixbufs.
    native.unrealize(gtk2.Widget(w).raw)
    check w.pixbuf.isEmpty and first.width == 40
    w.destroy()
    check first.width == 40 and second.height == 24 and child.isDestroyed
    expect ValueError: discard w.pixbuf

  test "offscreen damage snapshots are copied at idle, coalesced, cancelable and safe to destroy":
    let w = newOffscreenWindow()
    defer: w.destroy()
    expect ValueError: discard w.onSnapshot(nil)
    w.realizeHidden()
    var seen: seq[Pixbuf]
    let observation = w.onSnapshot(proc (image: Pixbuf) = seen.add(image))
    w.damage()
    w.damage()
    check seen.len == 0
    drain()
    check seen.len == 1 and seen[0].width == 40
    w.damage()
    drain()
    check seen.len == 2 and seen[0].raw != seen[1].raw
    observation.disconnect()
    var freed, calls = 0
    let canceled = watchOffscreen(w, addr freed, addr calls)
    w.damage()
    canceled.disconnect()
    drain()
    check freed == 1 and calls == 0
    let next = newOffscreenWindow()
    next.realizeHidden()
    let pending = watchOffscreen(next, addr freed, addr calls)
    next.damage()
    next.destroy()
    drain()
    check freed == 2 and calls == 0 and not pending.connected
    var destroyer: Connection
    destroyer = w.onSnapshot(proc (image: Pixbuf) =
      destroyer.disconnect()
      w.destroy())
    w.damage()
    drain()
    check w.isDestroyed and not destroyer.connected and seen[0].width == 40
