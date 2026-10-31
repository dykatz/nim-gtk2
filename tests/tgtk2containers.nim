# Hidden layout widgets only; no visible toplevel or main loop.
import std/unittest
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert typeof(newAlignment().raw) is rawGtk.PAlignment
  doAssert typeof(newHButtonBox().raw) is rawGtk.PHButtonBox
  doAssert typeof(newVButtonBox().raw) is rawGtk.PVButtonBox
  doAssert typeof(newTable(2, 2).raw) is rawGtk.PTable
  doAssert typeof(newFixed().raw) is rawGtk.PFixed
  doAssert typeof(newEventBox().raw) is rawGtk.PEventBox
  doAssert compiles(newAlignment().add(newLabel()))
  doAssert compiles(newEventBox().add(newLabel()))
  doAssert not compiles(newTable(1, 1).add(newLabel()))
  doAssert not compiles(newFixed().packStart(newLabel()))

proc childUInt(w: gtk2.Container, child: gtk2.Widget, name: cstring): int =
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_UINT)
  defer: g.unset(addr value)
  rawGtk.child_get_property(cast[rawGtk.PContainer](w.raw), child.raw, name, addr value)
  g.get_uint(addr value).int
proc childFlags(w: gtk2.Container, child: gtk2.Widget, name: cstring): int =
  var value: g.TGValue
  discard g.init(addr value, rawGtk.attach_options_get_type())
  defer: g.unset(addr value)
  rawGtk.child_get_property(cast[rawGtk.PContainer](w.raw), child.raw, name, addr value)
  g.get_flags(addr value).int
type CaptureObj = object
  released: ptr int
type Capture = ref CaptureObj
proc `=destroy`(value: var CaptureObj) = inc value.released[]
proc trackButton(w: gtk2.Button, released: ptr int): Connection =
  let capture = Capture(released: released)
  w.onClicked(proc () = discard capture.released)
proc trackContainer(w: gtk2.Container, released: ptr int): Connection =
  let capture = Capture(released: released)
  w.onDestroy(proc () = discard capture.released)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]

proc runTests() =
  gtk2.init()
  suite "gtk2 alignment, button boxes, tables, fixed placement and event boxes":
    test "alignment fractions and padding are checked before native mutation":
      let alignment = newAlignment(0.25, 0.75, 1, 0)
      defer: alignment.destroy()
      check alignment.alignment == (0.25, 0.75, 1.0, 0.0)
      alignment.setAlignment(1, 0, 0.5, 0.25)
      check alignment.alignment == (1.0, 0.0, 0.5, 0.25)
      alignment.setPadding(1, 2, 3, 4)
      check alignment.padding == (1, 2, 3, 4)
      let label = newLabel("inside")
      alignment.add(label)
      expect ValueError: alignment.add(newLabel("second"))
      expect ValueError: alignment.setAlignment(0.5, 0.5, NaN, 0)
      expect ValueError: alignment.setAlignment(0, 2, 0, 0)
      check alignment.alignment == (1.0, 0.0, 0.5, 0.25)
      expect ValueError: alignment.setPadding(1, 2, -1, 4)
      expect ValueError: alignment.setPadding(high(g.gint).int, 1, 0, 0)
      check alignment.padding == (1, 2, 3, 4)
      expect ValueError: discard newAlignment(Inf)
      alignment.remove(label)
      check not label.isDestroyed
      let eventBox = newEventBox()
      defer: eventBox.destroy()
      eventBox.add(label)
      check rawGtk.get_parent(label.raw) == cast[rawGtk.PWidget](eventBox.raw)

    test "button boxes inherit checked box packing and per-child secondary grouping":
      let horizontal = newHButtonBox(8, buttonsEnd)
      let vertical = newVButtonBox(12, buttonsStart)
      defer: horizontal.destroy()
      defer: vertical.destroy()
      check horizontal.spacing == 8
      check vertical.spacing == 12
      for box in [gtk2.ButtonBox(horizontal), gtk2.ButtonBox(vertical)]:
        for style in ButtonBoxStyle:
          box.layoutStyle = style
          check box.layoutStyle == style
        let primary = newButton("OK")
        let secondary = newButton("Help")
        box.packStart(primary, packShrink)
        box.packEnd(secondary, packShrink)
        check not box.secondary(primary)
        box.setSecondary(secondary)
        check box.secondary(secondary)
        box.setSecondary(secondary, false)
        check not box.secondary(secondary)
        let stranger = newButton("not packed")
        defer: stranger.destroy()
        expect ValueError: box.packStart(stranger, padding = 65536)
        expect ValueError: box.packEnd(stranger, padding = -1)
        check rawGtk.get_parent(stranger.raw) == nil
        expect ValueError: discard box.secondary(stranger)
        expect ValueError: box.setSecondary(stranger)
        box.packStart(stranger, packShrink, padding = 65535)
        check childUInt(box, stranger, "padding") == 65535
        expect ValueError: box.spacing = -1
        expect ValueError: box.spacing = 32768
        box.spacing = 32767
        check box.spacing == 32767
        box.spacing = 4
        check box.spacing == 4
      expect ValueError: discard newHBox(32768)
      expect ValueError: discard newVBox(-1)
      expect ValueError: discard newHButtonBox(-1)
      expect ValueError: discard newVButtonBox(32768)

    test "table spans, native attachment flags, padding and spacing round-trip":
      let table = newTable(3, 4, homogeneous = true)
      defer: table.destroy()
      check table.dimensions == (3, 4)
      check table.rowCount == 3
      check table.columnCount == 4
      check table.homogeneous
      table.homogeneous = false
      check not table.homogeneous
      let label = newLabel("spanning")
      table.attach(label, 1, 4, 0, 2, xoptions = {attachShrink, attachFill},
        yoptions = {}, xpadding = 7, ypadding = 9)
      check table.cellBounds(label) == (1, 4, 0, 2)
      check childUInt(table, label, "x-padding") == 7
      check childUInt(table, label, "y-padding") == 9
      check childFlags(table, label, "x-options") == 6
      check childFlags(table, label, "y-options") == 0
      table.rowSpacing = 5
      table.columnSpacing = 6
      check table.rowSpacing == 5
      check table.columnSpacing == 6
      table.setRowSpacing(1, 11)
      table.setColumnSpacing(2, 12)
      check table.rowSpacing(1) == 11
      check table.rowSpacing(0) == 5
      check table.columnSpacing(2) == 12
      check table.columnSpacing(0) == 6
      table.resize(5, 6)
      check table.dimensions == (5, 6)
      table.resize(2, 4)
      check table.dimensions == (2, 4)
      expect ValueError: table.resize(1, 4)
      expect ValueError: table.resize(2, 3)
      check table.dimensions == (2, 4)
      let overlap = newLabel("overlap is legal GTK layout")
      table.attach(overlap, 1, 2, 1, 2)
      table.remove(label)
      check not label.isDestroyed
      table.resize(2, 2)
      table.remove(overlap)
      table.resize(1, 1)
      table.attach(label, 0, 1, 0, 1)
      check table.cellBounds(label) == (0, 1, 0, 1)

    test "table validation never partially parents or truncates invalid fields":
      let table = newTable(2, 2)
      defer: table.destroy()
      let child = newLabel()
      defer: child.destroy()
      for bounds in [(-1, 1, 0, 1), (0, 0, 0, 1), (0, 3, 0, 1), (0, 1, 0, 3),
                     (1, 0, 0, 1), (0, 1, -1, 1), (0, 1, 1, 1)]:
        expect ValueError: table.attach(child, bounds[0], bounds[1], bounds[2], bounds[3])
        check rawGtk.get_parent(child.raw) == nil
      expect ValueError: table.attach(child, 0, 1, 0, 1, xpadding = 65536)
      check rawGtk.get_parent(child.raw) == nil
      expect ValueError: table.setRowSpacing(2, 1)
      expect ValueError: table.setColumnSpacing(-1, 1)
      expect ValueError: table.rowSpacing = 65536
      expect ValueError: table.columnSpacing = -1
      expect ValueError: table.setRowSpacing(0, 65536)
      expect ValueError: table.resize(0, 1)
      expect ValueError: discard newTable(1, 65536)
      expect ValueError: discard newTable(-1, 1)
      expect ValueError: discard table.cellBounds(child)
      expect ValueError: table.remove(child)
      check table.dimensions == (2, 2)

    test "fixed placement uses signed coordinates and validates direct membership":
      let fixed = newFixed()
      let other = newFixed()
      defer: fixed.destroy()
      defer: other.destroy()
      let child = newButton("move me")
      fixed.put(child, -15, 25)
      check fixed.position(child) == (-15, 25)
      fixed.move(child, 80, -30)
      check fixed.position(child) == (80, -30)
      expect ValueError: other.move(child, 0, 0)
      expect ValueError: discard other.position(child)
      expect ValueError: fixed.put(child, 0, 0)
      when sizeof(int) > 4:
        expect ValueError: fixed.move(child, high(g.gint).int + 1, 0)
        expect ValueError: fixed.move(child, 0, low(g.gint).int - 1)
        check fixed.position(child) == (80, -30)
      fixed.remove(child)
      other.put(child, 0, 0)
      check not child.isDestroyed
      check other.position(child) == (0, 0)

    test "event box flags, single-child rules and cycles are checked":
      let eventBox = newEventBox(visibleWindow = false, aboveChild = true)
      defer: eventBox.destroy()
      check not eventBox.visibleWindow
      check eventBox.aboveChild
      eventBox.visibleWindow = true
      eventBox.aboveChild = false
      check eventBox.visibleWindow
      check not eventBox.aboveChild
      let fixed = newFixed()
      eventBox.add(fixed)
      expect ValueError: eventBox.add(newLabel())
      expect ValueError: fixed.put(eventBox, 0, 0)
      expect ValueError: fixed.put(fixed, 0, 0)
      let window = newWindow()
      defer: window.destroy()
      expect ValueError: fixed.put(window, 0, 0)
      let table = newTable(1, 1)
      defer: table.destroy()
      expect ValueError: table.attach(window, 0, 1, 0, 1)
      expect ValueError: table.attach(table, 0, 1, 0, 1)

    test "parent ownership survives dropped handles and destruction invalidates aliases":
      var childGone = 0
      let fixed = newFixed()
      proc addTemporary() =
        let button = newButton("temporary")
        g.weak_ref(cast[g.PGObject](button.raw), finalized, addr childGone)
        fixed.put(button, 0, 0)
      addTemporary()
      check childGone == 0
      fixed.destroy()
      check childGone == 1
      let table = newTable(1, 1)
      let retained = newButton()
      var released = 0
      let connection = trackButton(retained, addr released)
      let parentConnection = trackContainer(table, addr released)
      check released == 0
      table.attach(retained, 0, 1, 0, 1)
      let alias = table
      table.destroy()
      check alias.isDestroyed
      check retained.isDestroyed
      check not connection.connected
      check not parentConnection.connected
      check released == 2
      expect ValueError: discard alias.dimensions
      expect ValueError: alias.resize(1, 1)
      let alignment = newAlignment()
      alignment.destroy()
      expect ValueError: discard alignment.padding
      let eventBox = newEventBox()
      eventBox.destroy()
      expect ValueError: eventBox.aboveChild = true
      let buttons = newVButtonBox()
      buttons.destroy()
      expect ValueError: discard buttons.layoutStyle

runTests()
