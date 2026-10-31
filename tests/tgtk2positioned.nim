import std/unittest
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert typeof(newLayout().raw) is rawGtk.PLayout
  doAssert typeof(newHandleBox().raw) is rawGtk.PHandleBox

proc drainUi() =
  for i in 0..<128:
    if rawGtk.events_pending() == 0: return
    discard rawGtk.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "unexpected continuously pending UI source")
proc emit(w: gtk2.HandleBox, signal: cstring, child: Widget) =
  # Signals only: does not start a drag, detach, realize or map any windows.
  g.g_signal_emit_by_name(w.raw, signal, child.raw)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CaptureObj = object
  released, calls: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.released[]
type Capture = ref CaptureObj
proc track(w: gtk2.HandleBox, released, calls: ptr int): Connection =
  let c = Capture(released: released, calls: calls)
  w.onChildDetached(proc (child: Widget) = inc c.calls[])

gtk2.init()
suite "Layout and HandleBox (hidden)":
  test "canvas dimensions, signed positions, membership and owning aliases":
    let layout = newLayout(1200, 900)
    defer: layout.destroy()
    check layout.dimensions == (1200, 900)
    let a = newButton("A")
    let b = newLabel("B")
    layout.put(a, 23, 45)
    layout.put(b, -11, 15)
    check layout.childCount == 2
    check layout.position(a) == (23, 45)
    check layout.position(b) == (-11, 15)
    let alias = layout.childAt(0)
    check alias.raw == cast[rawGtk.PWidget](a.raw)
    layout.move(a, -100, 200)
    check layout.position(a) == (-100, 200)
    layout.setSize(2000, 1600)
    check layout.dimensions == (2000, 1600)
    check layout.horizontalAdjustment.upper == 2000.0
    check layout.verticalAdjustment.upper == 1600.0
    expect ValueError: layout.put(a, 0, 0)
    expect ValueError: layout.put(layout, 0, 0)
    expect ValueError: layout.move(newLabel(), 0, 0)
    expect ValueError: discard layout.childAt(-1)
    expect ValueError: discard layout.childAt(2)
    let window = newWindow()
    defer: window.destroy()
    expect ValueError: layout.put(window, 0, 0)
    let child = newFrame("Nested")
    layout.put(child, 0, 0)
    expect ValueError: child.add(layout)
    layout.remove(a)
    check not alias.isDestroyed
    expect ValueError: discard layout.position(a)
    layout.put(a, 0, 0)
    layout.destroy()
    check alias.isDestroyed and a.isDestroyed and child.isDestroyed

  test "geometry validation is atomic and preserves C widths":
    expect ValueError: discard newLayout(-1, 100)
    expect ValueError: discard newLayout(100, -1)
    let layout = newLayout(0, 0)
    defer: layout.destroy()
    check layout.dimensions == (0, 0)
    layout.setSize(high(cint).int, high(cint).int)
    check layout.dimensions == (high(cint).int, high(cint).int)
    layout.setSize(640, 480)
    expect ValueError: layout.setSize(123, -1)
    check layout.dimensions == (640, 480)
    let item = newLabel("position")
    layout.put(item, low(cint).int, high(cint).int)
    check layout.position(item) == (low(cint).int, high(cint).int)
    when sizeof(int) > sizeof(cint):
      let overflow = high(cint).int + 1
      expect ValueError: discard newLayout(overflow, 10)
      expect ValueError: layout.setSize(10, overflow)
      expect ValueError: layout.move(item, 17, overflow)
      check layout.position(item) == (low(cint).int, high(cint).int)
      let other = newLabel("unparented")
      defer: other.destroy()
      expect ValueError: layout.put(other, overflow, 0)
      check rawGtk.get_parent(cast[rawGtk.PWidget](other.raw)) == nil

  test "adjustment constructors/getters retain ownership and native scrolling uses no Viewport":
    let h = newAdjustment()
    let v = newAdjustment()
    let layout = newLayout(h, v, 800, 600)
    defer: layout.destroy()
    check layout.horizontalAdjustment.raw == h.raw
    check layout.verticalAdjustment.raw == v.raw
    let retained = layout.horizontalAdjustment
    let replacement = newAdjustment()
    layout.horizontalAdjustment = replacement
    check layout.horizontalAdjustment.raw == replacement.raw
    check retained.raw == h.raw
    h.value = 12
    check retained.value == 12
    let scroller = newScrolledWindow()
    defer: scroller.destroy()
    scroller.add(layout)
    check rawGtk.get_child(cast[rawGtk.PBin](scroller.raw)) == cast[rawGtk.PWidget](layout.raw)
    check layout.horizontalAdjustment.raw == scroller.horizontalAdjustment.raw
    check layout.verticalAdjustment.raw == scroller.verticalAdjustment.raw
    let scrolling = layout.verticalAdjustment
    scroller.destroy()
    check layout.isDestroyed
    check not scrolling.isDestroyed and not h.isDestroyed and not v.isDestroyed
    expect ValueError: discard layout.dimensions
    expect ValueError: discard newLayout(gtk2.Adjustment(), v)

  test "handle properties include native automatic snapping, not private bitfields":
    let box = newHandleBox()
    defer: box.destroy()
    check not box.hasChild and box.child.isDestroyed
    check not box.childDetached
    check box.snapEdge == snapAutomatic
    check box.handlePosition == handleLeft and box.shadow == shadowOut
    for edge in SnapEdge:
      box.snapEdge = edge
      check box.snapEdge == edge
    for position in HandlePosition:
      box.handlePosition = position
      check box.handlePosition == position
    for style in ShadowStyle:
      box.shadow = style
      check box.shadow == style
    box.snapEdge = snapAutomatic
    check cast[cint](rawGtk.get_snap_edge(box.raw)) == -1
    let custom = newHandleBox(handleTop, shadowIn, snapBottom)
    defer: custom.destroy()
    check custom.handlePosition == handleTop and custom.shadow == shadowIn
    check custom.snapEdge == snapBottom

  test "single-child parenting, removal and shared destruction state":
    let box = newHandleBox()
    defer: box.destroy()
    let bar = newToolbar()
    bar.append(newToolButton("Open"))
    box.add(bar)
    let alias = box.child
    check box.hasChild and alias.raw == cast[rawGtk.PWidget](bar.raw)
    let extra = newLabel("extra")
    defer: extra.destroy()
    expect ValueError: box.add(extra)
    expect ValueError: box.add(box)
    expect ValueError: box.add(bar)
    box.remove(bar)
    check not box.hasChild and not alias.isDestroyed
    let item = newToolItem()
    bar.append(item)
    expect ValueError: item.add(bar)
    box.add(bar)
    box.destroy()
    check alias.isDestroyed and bar.isDestroyed and item.isDestroyed
    expect ValueError: discard box.child
    expect ValueError: discard box.onChildAttached(proc (child: Widget) = discard)

  test "attachment observers defer, coalesce and disconnect safely":
    let box = newHandleBox()
    defer: box.destroy()
    let child = newLabel("child")
    box.add(child)
    var attached, detached = 0
    var self: Connection
    self = box.onChildAttached(proc (snapshot: Widget) =
      inc attached
      check snapshot.raw == cast[rawGtk.PWidget](child.raw)
      self.disconnect())
    let connection = box.onChildDetached(proc (snapshot: Widget) = inc detached)
    emit(box, "child-attached", child)
    emit(box, "child-attached", child)
    emit(box, "child-detached", child)
    check attached == 0 and detached == 0
    drainUi()
    check attached == 1 and detached == 1
    check not self.connected
    emit(box, "child-detached", child)
    connection.disconnect()
    drainUi()
    check detached == 1
    expect ValueError: discard box.onChildAttached(nil)
    expect ValueError: discard box.onChildDetached(nil)

  test "queued child snapshots own a reference; destroyed children are not delivered":
    let box = newHandleBox()
    defer: box.destroy()
    var delivered: Widget
    box.onChildDetached(proc (snapshot: Widget) = delivered = snapshot)
    var gone = 0
    block:
      let temporary = newLabel("temporary")
      g.weak_ref(cast[g.PGObject](temporary.raw), finalized, addr gone)
      box.add(temporary)
      emit(box, "child-detached", temporary)
      box.remove(temporary)
    check gone == 0
    drainUi()
    check not delivered.isDestroyed
    delivered.destroy()
    delivered = gtk2.Widget()
    check gone == 1
    let child = newLabel("destroyed before delivery")
    box.add(child)
    emit(box, "child-detached", child)
    child.destroy()
    drainUi()
    check delivered.isDestroyed

  test "idle observers contain exceptions and may destroy their own parent":
    let box = newHandleBox()
    defer: box.destroy()
    let child = newLabel("child")
    box.add(child)
    box.onChildDetached(proc (snapshot: Widget) =
      box.destroy()
      raise newException(ValueError, "expected handlebox callback error"))
    emit(box, "child-detached", child)
    check not box.isDestroyed
    drainUi()
    check box.isDestroyed and child.isDestroyed

  test "destruction cancels queued observers and releases real captures and native objects":
    var released, calls, gone = 0
    block:
      let box = newHandleBox()
      let layout = newLayout()
      let child = newButton("child")
      box.add(layout)
      layout.put(child, 1, 2)
      for p in [cast[pointer](box.raw), cast[pointer](layout.raw), cast[pointer](child.raw)]:
        g.weak_ref(cast[g.PGObject](p), finalized, addr gone)
      let connection = track(box, addr released, addr calls)
      emit(box, "child-detached", layout)
      box.destroy()
      check not connection.connected
      check released == 1
      drainUi()
      check calls == 0
    check gone == 3
