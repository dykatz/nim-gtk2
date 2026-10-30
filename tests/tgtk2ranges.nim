# Hidden widgets only; GTK must have a display but no window is shown.
import std/unittest
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert typeof(newHScale().raw) is rawGtk.PHScale
  doAssert typeof(newVScale().raw) is rawGtk.PVScale
  doAssert typeof(newHScrollbar().raw) is rawGtk.PHScrollbar
  doAssert typeof(newVScrollbar().raw) is rawGtk.PVScrollbar
  doAssert typeof(newArrow().raw) is rawGtk.PArrow
  doAssert compiles(newVScale().onValueChanged(proc (value: float64) = discard))
  doAssert not compiles(newArrow().onValueChanged(proc (value: float64) = discard))
  doAssert not compiles(newHScrollbar().addMark(5))
  doAssert not compiles(newVScale().add(newLabel()))

type CaptureObj = object
  released: ptr int
type Capture = ref CaptureObj
proc `=destroy`(value: var CaptureObj) = inc value.released[]
proc tracked(w: gtk2.Range, released: ptr int): Connection =
  let capture = Capture(released: released)
  w.onValueChanged(proc (value: float64) = discard capture.released)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]

proc drainUi() =
  for i in 0..<128:
    if rawGtk.events_pending() == 0: return
    discard rawGtk.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "unexpected continuously pending UI source")

proc runTests() =
  gtk2.init()
  suite "gtk2 ranges, scales, scrollbars and arrows":
    test "both scale orientations expose native adjustment, digits and clamped values":
      let horizontal = newHScale(-10, 10, 0.25)
      let vertical = newVScale(0, 1, 0.01)
      defer: horizontal.destroy()
      defer: vertical.destroy()
      check horizontal.adjustment.lower == -10
      check horizontal.adjustment.upper == 10
      check horizontal.adjustment.stepIncrement == 0.25
      check vertical.adjustment.stepIncrement == 0.01
      horizontal.value = 3.5
      check horizontal.value == 3.5
      horizontal.value = 100
      check horizontal.value == 10
      horizontal.value = -100
      check horizontal.value == -10
      for scale in [gtk2.Scale(horizontal), gtk2.Scale(vertical)]:
        scale.digits = 3
        check scale.digits == 3
        scale.digits = -1
        check scale.digits == -1
        scale.drawValue = false
        check not scale.drawValue
        scale.drawValue = true
        check scale.drawValue
        for position in ValuePosition:
          scale.valuePosition = position
          check scale.valuePosition == position
        scale.addMark(0.5, "<not markup> & literal", valueTop)
        scale.addMark(0.75, "café", valueBottom)
        scale.addMark(0.25)
        var requisition: rawGtk.TRequisition
        rawGtk.size_request(gtk2.Widget(scale).raw, addr requisition) # Force label layout/markup parsing.
        check requisition.width > 0
        scale.clearMarks()
        expect ValueError: scale.digits = -2
        expect ValueError: scale.digits = 65
        expect ValueError: scale.addMark(Inf)
        expect ValueError: scale.addMark(0, "\xff")
        expect ValueError: scale.addMark(0, "bad\0label")

    test "shared adjustments are owned, reusable with spin buttons, and replaceable":
      let shared = newAdjustment(25, 0, 100, 1, 10)
      let horizontal = newHScale(shared)
      let vertical = newVScale(shared)
      let spin = newSpinButton(shared)
      defer: horizontal.destroy()
      defer: vertical.destroy()
      defer: spin.destroy()
      let retained = horizontal.adjustment
      check retained.raw == shared.raw
      horizontal.value = 42
      check vertical.value == 42
      check spin.value == 42
      check retained.value == 42
      let replacement = newAdjustment(0.5, 0, 1, 0.01, 0.1)
      horizontal.adjustment = replacement
      check horizontal.adjustment.raw == replacement.raw
      horizontal.value = 0.75
      check replacement.value == 0.75
      check shared.value == 42
      horizontal.destroy()
      check replacement.value == 0.75
      check not replacement.isDestroyed
      shared.value = 12
      check vertical.value == 12
      check spin.value == 12

    test "scrollbars respect page size and checked bound/increment updates":
      let horizontal = newHScrollbar(value = 20, pageSize = 25)
      let vertical = newVScrollbar()
      defer: horizontal.destroy()
      defer: vertical.destroy()
      check horizontal.adjustment.pageSize == 25
      horizontal.value = 100
      check horizontal.value == 75
      for scrollbar in [gtk2.Scrollbar(horizontal), gtk2.Scrollbar(vertical)]:
        scrollbar.setBounds(-20, 200)
        scrollbar.setIncrements(0.5, 15)
        check scrollbar.adjustment.lower == -20
        check scrollbar.adjustment.upper == 200
        check scrollbar.adjustment.stepIncrement == 0.5
        check scrollbar.adjustment.pageIncrement == 15
        scrollbar.inverted = true
        check scrollbar.inverted
        scrollbar.inverted = false
        check not scrollbar.inverted
        scrollbar.flippable = true
        check scrollbar.flippable
        scrollbar.flippable = false
        check not scrollbar.flippable
        expect ValueError: scrollbar.setBounds(100, 0)
        expect ValueError: scrollbar.setBounds(0, 0)
        expect ValueError: scrollbar.setBounds(0, 5) # Existing page would not fit.
        expect ValueError: scrollbar.setBounds(0, Inf)
        expect ValueError: scrollbar.setIncrements(-1, 1)
        expect ValueError: scrollbar.setIncrements(1, NaN)
        expect ValueError: scrollbar.value = NaN
        check scrollbar.adjustment.lower == -20
        check scrollbar.adjustment.upper == 200
        check scrollbar.adjustment.stepIncrement == 0.5
        check scrollbar.adjustment.pageIncrement == 15
      let retained = horizontal.adjustment
      horizontal.destroy()
      check retained.pageSize == 25
      let shared = newAdjustment(15, 0, 100, 1, 10, 20)
      let a = newHScrollbar(shared)
      let b = newVScrollbar(shared)
      defer: a.destroy()
      defer: b.destroy()
      a.value = 40
      check b.value == 40
      check a.adjustment.raw == shared.raw
      check b.adjustment.raw == shared.raw
      b.adjustment = retained
      check b.adjustment.raw == retained.raw
      b.value = 999
      check b.value == 175

    test "numeric constructors reject invalid input before calling GTK":
      for bounds in [(1.0, 0.0, 1.0), (0.0, 0.0, 1.0), (0.0, 1.0, 0.0),
                     (0.0, 1.0, -1.0), (NaN, 1.0, 1.0), (0.0, Inf, 1.0),
                     (0.0, 1.0, 1e308), (-1e308, 1e308, 1.0)]:
        expect ValueError: discard newHScale(bounds[0], bounds[1], bounds[2])
        expect ValueError: discard newVScale(bounds[0], bounds[1], bounds[2])
      expect ValueError: discard newHScrollbar(pageSize = 101)
      expect ValueError: discard newVScrollbar(pageSize = -1)
      expect ValueError: discard newHScrollbar(value = NaN)
      expect ValueError: discard newVScrollbar(stepIncrement = Inf)
      let dead = newAdjustment()
      dead.destroy()
      expect ValueError: discard newHScale(dead)
      expect ValueError: discard newVScale(dead)
      expect ValueError: discard newHScrollbar(dead)
      expect ValueError: discard newVScrollbar(dead)

    test "value snapshots support exceptions, self-disconnection and destruction":
      let scale = newHScale()
      defer: scale.destroy()
      var snapshots: seq[float64]
      let record = scale.onValueChanged(proc (value: float64) = snapshots.add(value))
      var once: Connection
      once = scale.onValueChanged(proc (value: float64) =
        check value == 10
        once.disconnect()
        raise newException(ValueError, "expected range callback error"))
      scale.value = 10
      check snapshots.len == 0 # Notifications run later, outside GTK input handlers.
      drainUi()
      scale.value = 20
      drainUi()
      check snapshots == @[10.0, 20.0]
      check not once.connected
      record.disconnect()
      scale.value = 30
      drainUi()
      check snapshots.len == 2
      let scrollbar = newVScrollbar()
      let close = scrollbar.onValueChanged(proc (value: float64) =
        scrollbar.destroy()
        check value == 15)
      scrollbar.value = 15
      drainUi()
      check scrollbar.isDestroyed
      check not close.connected
      expect ValueError: discard scale.onValueChanged(nil)
      let shared = newAdjustment(0, 0, 100)
      let vertical = newVScale(shared)
      defer: vertical.destroy()
      var changed = 0
      let connection = vertical.onValueChanged(proc (value: float64) = inc changed)
      shared.value = 50
      drainUi()
      check changed == 1
      check connection.connected
      vertical.destroy()
      shared.value = 60
      drainUi()
      check changed == 1
      check not connection.connected

    test "deferred observers coalesce, follow replacements and cancel pending calls":
      let scale = newHScale()
      defer: scale.destroy()
      let old = scale.adjustment
      var snapshots: seq[float64]
      let connection = scale.onValueChanged(proc (value: float64) = snapshots.add(value))
      scale.value = 10
      scale.value = 20
      check snapshots.len == 0
      drainUi()
      check snapshots == @[20.0]
      let replacement = newAdjustment(30, 0, 100)
      scale.adjustment = replacement
      old.value = 99
      replacement.value = 40
      drainUi()
      check snapshots == @[20.0, 40.0]
      check connection.connected
      scale.value = 50
      connection.disconnect()
      drainUi()
      check snapshots.len == 2
      var calls = 0
      scale.onValueChanged(proc (value: float64) = inc calls)
      scale.value = 60
      scale.destroy()
      drainUi()
      check calls == 0
      let keyboard = newHScale()
      keyboard.onValueChanged(proc (value: float64) = keyboard.destroy())
      g.g_signal_emit_by_name(keyboard.raw, "move-slider", rawGtk.SCROLL_STEP_FORWARD)
      check not keyboard.isDestroyed
      drainUi()
      check keyboard.isDestroyed
      let bounds = newHScale()
      bounds.value = 90
      bounds.onValueChanged(proc (value: float64) = bounds.destroy())
      bounds.setBounds(0, 50)
      drainUi()
      check bounds.isDestroyed

    test "all arrow directions and shadows round-trip through native enum properties":
      let arrow = newArrow()
      defer: arrow.destroy()
      check arrow.direction == arrowDown
      check arrow.shadow == shadowOut
      for direction in ArrowDirection:
        arrow.direction = direction
        check arrow.direction == direction
        check arrow.shadow == shadowOut
      for shadow in ShadowStyle:
        arrow.shadow = shadow
        check arrow.shadow == shadow
        check arrow.direction == arrowNone
      arrow.setArrow(arrowLeft, shadowIn)
      check arrow.direction == arrowLeft
      check arrow.shadow == shadowIn
      check rawGtk.ARROW_NONE == ord(arrowNone)
      arrow.destroy()
      expect ValueError: discard arrow.direction
      expect ValueError: arrow.shadow = shadowNone

    test "destroying widgets releases captures and aliases reject stale access":
      let hscale = newHScale()
      let vscale = newVScale()
      let hscroll = newHScrollbar()
      let vscroll = newVScrollbar()
      var released = 0
      for range in [gtk2.Range(hscale), gtk2.Range(vscale), gtk2.Range(hscroll), gtk2.Range(vscroll)]:
        let alias = range
        let connection = tracked(range, addr released)
        range.destroy()
        check alias.isDestroyed
        check not connection.connected
        expect ValueError: discard alias.value
        expect ValueError: discard alias.adjustment
        expect ValueError: alias.adjustment = newAdjustment()
      check released == 4
      let pending = newHScale()
      discard tracked(pending, addr released)
      pending.value = 10
      pending.destroy()
      check released == 5
      drainUi()
      check released == 5

    test "retained getters preserve adjustments without leaking native widgets":
      var widgetGone, adjustmentGone = 0
      proc keepAdjustment(): Adjustment =
        let scale = newVScale()
        g.weak_ref(cast[g.PGObject](scale.raw), finalized, addr widgetGone)
        result = scale.adjustment
        g.weak_ref(cast[g.PGObject](result.raw), finalized, addr adjustmentGone)
        scale.destroy()
      block:
        let retained = keepAdjustment()
        check widgetGone == 1
        check adjustmentGone == 0
        check retained.upper == 100
      check adjustmentGone == 1

runTests()
