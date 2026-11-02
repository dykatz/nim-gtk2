# Rendering resources and signals are exercised without mapping ANY widget.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/cairo as cairo

proc drain() =
  for i in 0..<512:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "extension event sources did not settle")
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CaptureObj = object
  freed: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.freed[]
type Capture = ref CaptureObj
proc watchDraw(w: DrawingArea, freed: ptr int) =
  let capture = Capture(freed: freed)
  w.onDraw(proc (c: DrawContext, info: DrawInfo) = discard capture.freed)
proc watchMotion(w: DrawingArea, freed: ptr int) =
  let capture = Capture(freed: freed)
  w.onMotion(proc (event: MotionEvent): bool =
    discard capture.freed
    false)
proc renderer(column: n.PTreeViewColumn): n.PCellRenderer =
  let list = n.cell_layout_get_cells(cast[n.PCellLayout](column))
  defer: g.free(list)
  doAssert list != nil and list.next == nil
  cast[n.PCellRenderer](list.data)
proc edited(column: TextColumn, path, text: cstring) =
  g.g_signal_emit_by_name(renderer(column.raw), "edited", path, text)
proc toggled(column: ToggleColumn, path: cstring) =
  g.g_signal_emit_by_name(renderer(column.raw), "toggled", path)
proc expose(area: DrawingArea, x = 2, y = 3, width = 4, height = 5): bool =
  let event = gd.event_new(gd.EXPOSE)
  defer: gd.free(event)
  let e = cast[gd.PEventExpose](event)
  e.window = cast[gd.PWindow](g.g_object_ref(n.get_window(gtk2.Widget(area).raw)))
  e.area = gd.TRectangle(x: g.gint(x), y: g.gint(y), width: g.gint(width), height: g.gint(height))
  e.region = gd.region_rectangle(addr e.area)
  var handled = g.gbool(false)
  g.g_signal_emit_by_name(area.raw, "expose-event", event, addr handled)
  g.toBool(handled)
proc realizeHidden(area: DrawingArea, host: gtk2.OffscreenWindow) =
  host.add(area)
  var a = n.TAllocation(width: 40, height: 30)
  n.size_allocate(gtk2.Widget(host).raw, addr a)
  n.size_allocate(gtk2.Widget(area).raw, addr a)
  n.realize(gtk2.Widget(area).raw)
  doAssert not g.toBool(n.WIDGET_MAPPED(host.raw))
  doAssert not g.toBool(n.WIDGET_MAPPED(area.raw))

gtk2.init()
suite "expanded text buffers":
  test "retaining a tag keeps its definition/table alive, not its original buffer":
    var tag: TextTag
    var buffersGone, tagsGone = 0
    block:
      let b = newTextBuffer("temporary")
      g.weak_ref(cast[g.PGObject](b.raw), finalized, addr buffersGone)
      tag = b.createTag("kept")
      g.weak_ref(cast[g.PGObject](tag.raw), finalized, addr tagsGone)
    check buffersGone == 1 and tagsGone == 0
    tag.bold = true
    check tag.bold
    tag = gtk2.TextTag()
    check tagsGone == 1
  test "owned named/anonymous tags, typed styles, membership, hidden text and corrected search flags":
    let b = newTextBuffer("λ hello λ hello")
    let bold = b.createTag("strong")
    bold.bold = true
    bold.italic = true
    bold.underline = true
    bold.editable = false
    bold.setForeground(rgba16(65535, 0, 0))
    bold.setBackground(rgba16(0, 0, 65535))
    check bold.bold and bold.italic and bold.underline and not bold.editable
    bold.clearBackground()
    b.applyTag(bold, 0, 7)
    check b.hasTag(bold, 0) and not b.hasTag(bold, 7)
    check b.tag("strong").raw == bold.raw
    expect ValueError: discard b.createTag("strong")
    expect ValueError: discard b.createTag("bad\0name")
    expect ValueError: bold.setForeground(rgba16(0, 0, 0, 10))
    let hidden = b.createTag()
    hidden.invisible = true
    b.applyTag(hidden, 2, 7)
    check b.textRange(0, b.characterCount, false) == "λ  λ hello"
    let found = b.findText("hello")
    check found.found and found.first == 2 and found.last == 7
    check b.findText("hello", visibleOnly = true).first == 10
    check b.findText("λ", backwards = true).first == 8
    check not b.findText("missing").found and b.findText("missing").first == -1
    expect ValueError: discard b.findText("")
    expect ValueError: discard b.findText("\xff")
    expect ValueError: discard b.findText("λ", first = 9, last = 2)
    let other = newTextBuffer("other")
    expect ValueError: other.applyTag(bold, 0, 1)
    b.removeTag(bold, 0, 2)
    check not b.hasTag(bold, 0)
    b.removeAllTags(0, b.characterCount)
    check not b.hasTag(hidden, 2)
    b.deleteTag(hidden)
    expect ValueError: b.applyTag(hidden, 0, 1)
    b.deleteTag(bold)
    bold.bold = false # Detached tag still owns its GObject.
    expect ValueError: discard b.tag("strong")
  test "marks track Unicode edits by gravity, reject cross-buffer/deleted/special misuse":
    let b = newTextBuffer("aλb")
    let left = b.createMark(1, "bookmark")
    let right = b.createMark(1, leftGravity = false)
    check left.leftGravity and not right.leftGravity and left.name == "bookmark"
    left.visible = true
    check left.visible and b.mark("bookmark").raw == left.raw
    b.insertText(1, "🙂")
    check left.offset == 1 and right.offset == 2
    b.moveMark(left, 3)
    check left.offset == 3
    expect ValueError: discard b.createMark(0, "bookmark")
    expect ValueError: newTextBuffer().moveMark(left, 0)
    expect ValueError: b.deleteMark(b.mark("insert"))
    b.deleteMark(left)
    check left.deleted
    expect ValueError: discard left.offset
    expect ValueError: b.deleteMark(left)
    var surviving: TextMark
    block:
      let temporary = newTextBuffer("λ")
      surviving = temporary.createMark(1)
    check surviving.deleted
  test "images occupy one character; slice preserves object markers and owns native image":
    let b = newTextBuffer("λ🙂")
    var gone = 0
    block:
      let image = newPixbuf(2, 2)
      g.weak_ref(cast[g.PGObject](image.raw), finalized, addr gone)
      b.insertImage(1, image)
    check gone == 0 and b.characterCount == 3
    check b.text == "λ🙂" and b.slice(0, 3) == "λ\xef\xbf\xbc🙂"
    check not b.findText("λ🙂", textOnly = false).found
    check b.findText("λ🙂", textOnly = true).found
    b.deleteRange(1, 2)
    check gone == 1

suite "synchronous copied input and scoped drawing (unmapped)":
  test "draw and input bindings do not create implicit native/Nim ownership cycles":
    var freed, gone = 0
    block:
      let area = newDrawingArea()
      g.weak_ref(cast[g.PGObject](area.raw), finalized, addr gone)
      watchDraw(area, addr freed)
      watchMotion(area, addr freed)
    check freed == 2 and gone == 1
  test "Cairo clipping, copied allocation and escaped context invalidation":
    let host = newOffscreenWindow()
    defer: host.destroy()
    let area = newDrawingArea(40, 30)
    area.realizeHidden(host)
    var escaped: DrawContext
    var calls = 0
    let connection = area.onDraw(proc (c: DrawContext, info: DrawInfo) =
      inc calls
      escaped = c
      check info.width == 40 and info.height == 30
      check info.damaged == (2, 3, 4, 5)
      var x1, y1, x2, y2: float64
      cairo.clipExtents(c.raw, x1, y1, x2, y2)
      # An unmapped GdkWindow can have an empty native visibility clip.
      check x2 - x1 <= 4 and y2 - y1 <= 5
      if x2 > x1 and y2 > y1:
        check x1 >= 2 and y1 >= 3 and x2 <= 6 and y2 <= 8
      expect ValueError: c.setLineWidth(0)
      expect ValueError: c.rectangle(0, 0, NaN, 1)
      c.save()
      c.setSource(rgba16(65535, 0, 0))
      c.paint()
      c.restore())
    check not area.expose() and calls == 1
    expect ValueError: escaped.paint()
    connection.disconnect()
    discard area.expose()
    check calls == 1 and not connection.connected
    var self: Connection
    self = area.onDraw(proc (c: DrawContext, info: DrawInfo) =
      self.disconnect()
      area.destroy()
      expect ValueError: c.paint()
      raise newException(ValueError, "expected draw error"))
    check area.expose() and area.isDestroyed
    expect ValueError: discard area.onDraw(nil)
  test "input payloads preserve unsigned state/time and explicit boolean propagation":
    let area = newDrawingArea()
    defer: area.destroy()
    area.canFocus = true
    check area.canFocus
    area.queueDrawArea(0, 0, 0, 0)
    expect ValueError: area.queueDrawArea(0, 0, -1, 1)
    expect ValueError: area.queueDrawArea(high(g.gint).int, 0, 1, 1)
    var snapshot: ButtonEvent
    var self: Connection
    self = area.onButtonPress(proc (e: ButtonEvent): bool =
      snapshot = e
      self.disconnect()
      true)
    let event = gd.event_new(gd.TWO_BUTTON_PRESS)
    defer: gd.free(event)
    let e = cast[gd.PEventButton](event)
    e.x = 1.25
    e.y = 2.5
    e.time = 0xfedcba98'u32
    e.button = 3
    e.state = g.guint(uint32(modifierControl) or 0x80000000'u32)
    var handled = g.gbool(false)
    g.g_signal_emit_by_name(area.raw, "button-press-event", event, addr handled)
    check g.toBool(handled) and not self.connected
    check snapshot.kind == buttonDoublePress and snapshot.x == 1.25
    check snapshot.time == 0xfedcba98'u32 and snapshot.button == 3
    check snapshot.modifiers.has(modifierControl) and uint32(snapshot.modifiers) == e.state
    var key: KeyEvent
    let keyConnection = area.onKeyPress(proc (e: KeyEvent): bool =
      key = e
      false)
    let keyEvent = gd.event_new(gd.KEY_PRESS)
    defer: gd.free(keyEvent)
    cast[gd.PEventKey](keyEvent).keyval = 0x010003bb'u32
    handled = g.gbool(true)
    g.g_signal_emit_by_name(area.raw, "key-press-event", keyEvent, addr handled)
    check not g.toBool(handled) and key.unicode == 0x3bb
    keyConnection.disconnect()
    area.onKeyPress(proc (e: KeyEvent): bool =
      area.destroy()
      raise newException(ValueError, "expected input error"))
    g.g_signal_emit_by_name(area.raw, "key-press-event", keyEvent, addr handled)
    check area.isDestroyed and g.toBool(handled)

  test "motion, release and discrete scroll payloads use their own native layouts":
    let area = newDrawingArea()
    defer: area.destroy()
    var motion: MotionEvent
    var scroll: ScrollEvent
    var release: ButtonEvent
    area.onMotion(proc (e: MotionEvent): bool =
      motion = e
      true)
    area.onScroll(proc (e: ScrollEvent): bool =
      scroll = e
      true)
    area.onButtonRelease(proc (e: ButtonEvent): bool =
      release = e
      true)
    var handled: g.gboolean
    let m = gd.event_new(gd.MOTION_NOTIFY)
    defer: gd.free(m)
    cast[gd.PEventMotion](m).x = 7.5
    cast[gd.PEventMotion](m).is_hint = 1
    g.g_signal_emit_by_name(area.raw, "motion-notify-event", m, addr handled)
    check g.toBool(handled) and motion.x == 7.5 and motion.isHint
    let s = gd.event_new(gd.SCROLL)
    defer: gd.free(s)
    cast[gd.PEventScroll](s).direction = gd.SCROLL_RIGHT
    cast[gd.PEventScroll](s).time = high(uint32)
    g.g_signal_emit_by_name(area.raw, "scroll-event", s, addr handled)
    check g.toBool(handled) and scroll.direction == scrollRight and scroll.time == high(uint32)
    let r = gd.event_new(gd.BUTTON_RELEASE)
    defer: gd.free(r)
    cast[gd.PEventButton](r).button = 2
    g.g_signal_emit_by_name(area.raw, "button-release-event", r, addr handled)
    check g.toBool(handled) and release.kind == buttonRelease and release.button == 2

suite "editable model columns and multiple selection":
  test "hierarchical edits, self-disconnection, exceptions and destruction cancel pending work":
    let store = newTreeStore([cellString])
    let root = store.appendRow([cell("root")])
    let child = store.appendRow([cell("child")], parent = root)
    let view = newTreeView(store)
    defer: view.destroy()
    let c = view.appendTextColumn("Name", 0)
    var calls = 0
    var once: Connection
    once = c.onEdited(proc (e: TextEdit) =
      inc calls
      check e.path == child and e.row.path == child
      store.setValue(e.row.path, e.column, cell(e.text))
      once.disconnect()
      raise newException(ValueError, "expected cell edit error"))
    c.edited("0:0", "λ")
    c.edited("0:0", "canceled")
    drain()
    check calls == 1 and store.value(child, 0).stringValue == "λ"
    c.onEdited(proc (e: TextEdit) = view.destroy())
    c.edited("0:0", "close")
    drain()
    check view.isDestroyed
    let unattached = newTextColumn("Not attached", 0)
    expect ValueError: discard unattached.onEdited(proc (e: TextEdit) = discard)
  test "deferred Unicode edits follow stable rows through insertion and disappear on disconnect":
    let store = newListStore([cellString, cellBool])
    discard store.appendRow([cell("first"), cell(false)])
    let view = newTreeView(store)
    defer: view.destroy()
    let c = view.appendTextColumn("Name", 0)
    c.editable = true
    check c.editable
    var edits: seq[TextEdit]
    let connection = c.onEdited(proc (e: TextEdit) = edits.add(e))
    c.edited("0", "λ🙂")
    store.insertRow(0, [cell("new"), cell(true)])
    check edits.len == 0 and store.value(1, 0).stringValue == "first"
    drain()
    check edits.len == 1 and edits[0].text == "λ🙂" and edits[0].path == treePath(0)
    check edits[0].row.valid and edits[0].row.path == treePath(1)
    store.setValue(edits[0].row.path.indices[0], 0, cell(edits[0].text))
    check store.value(1, 0).stringValue == "λ🙂"
    c.edited("1", "pending")
    connection.disconnect()
    drain()
    check edits.len == 1
    let pending = c.onEdited(proc (e: TextEdit) = edits.add(e))
    c.edited("1", "deleted")
    store.removeRow(1)
    drain()
    check edits.len == 2 and not edits[1].row.valid
    c.edited("0", "cancel on view destroy")
    view.destroy()
    drain()
    check not pending.connected and edits.len == 2
  test "toggle observations snapshot model values and do not mutate implicitly":
    let store = newListStore([cellString, cellBool])
    discard store.appendRow([cell("row"), cell(false)])
    let view = newTreeView(store)
    defer: view.destroy()
    let c = view.appendToggleColumn("Enabled", 1)
    c.title = "Active"
    c.resizable = true
    check c.activatable and c.title == "Active" and c.resizable
    var seen: seq[ToggleEdit]
    c.onToggled(proc (e: ToggleEdit) = seen.add(e))
    c.toggled("0")
    store.setValue(0, 1, cell(true))
    drain()
    check seen.len == 1 and not seen[0].active and store.value(0, 1).boolValue
    c.toggled("0")
    c.disconnectSignals()
    drain()
    check seen.len == 1
    expect ValueError: discard view.appendToggleColumn("Wrong", 0)
  test "checked multiple selection and single-selection guards":
    let store = newListStore([cellString])
    for value in ["a", "b", "c"]: discard store.appendRow([cell(value)])
    let view = newTreeView(store)
    defer: view.destroy()
    expect ValueError: view.selectAll()
    view.selectionMode = selectionMultiple
    var changes = 0
    view.onSelectionChanged(proc () = inc changes)
    view.selectedPaths = [treePath(0), treePath(2)]
    check changes == 0
    drain()
    check view.selectedIndices == @[0, 2] and changes == 1
    view.selectionMode = selectionMultiple # Assigning the same mode preserves rows.
    check view.selectedIndices == @[0, 2]
    expect ValueError: discard view.selectedIndex
    expect ValueError: view.selectedPaths = [treePath(1), treePath(99)]
    check view.selectedIndices == @[0, 2]
    view.selectAll()
    check view.selectedPaths.len == 3
    view.unselectAll()
    check view.selectedPaths.len == 0
    view.selectionMode = selectionSingle
    view.selectedIndex = 1
    check view.selectedIndex == 1
