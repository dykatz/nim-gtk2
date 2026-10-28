# Requires a display; creates hidden widgets only, without a main loop.
import std/unittest
import gtk2ui
import gtk2 as rawGtk
import glib2 as g

static:
  doAssert typeof(newCheckButton().raw) is rawGtk.PCheckButton
  doAssert typeof(newRadioButton().raw) is rawGtk.PRadioButton
  doAssert typeof(newSpinner().raw) is ptr rawGtk.Spinner
  doAssert typeof(newAspectFrame().raw) is rawGtk.PAspectFrame
  doAssert compiles(newRadioButton().onClicked(proc () = discard))
  doAssert not compiles(newProgressBar().onClicked(proc () = discard))
  doAssert not compiles(newDrawingArea().onToggled(proc () = discard))
  doAssert not compiles(newExpander().packStart(newLabel()))

proc nativeBool(w: gtk2ui.Widget, name: cstring): bool =
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_BOOLEAN)
  defer: g.unset(addr value)
  g.get_property(cast[g.PGObject](w.raw), name, addr value)
  g.toBool(g.get_boolean(addr value))

proc nativeFloat(w: gtk2ui.Widget, name: cstring): g.gfloat =
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_FLOAT)
  defer: g.unset(addr value)
  g.get_property(cast[g.PGObject](w.raw), name, addr value)
  g.get_float(addr value)

gtk2ui.init()

suite "gtk2ui controls and simple containers":
  test "toggle/check buttons inherit text, clicks and tracked closure signals":
    let toggle = newToggleButton("_Toggle", mnemonic = true)
    let checkButton = newCheckButton("_Check", mnemonic = true)
    defer: toggle.destroy()
    defer: checkButton.destroy()
    check not toggle.active
    check toggle.text == "_Toggle"
    checkButton.text = "Check again"
    check checkButton.text == "Check again"
    var calls = 0
    var observed = false
    let connection = checkButton.onToggled(proc () =
      inc calls
      observed = checkButton.active)
    checkButton.active = true
    check calls == 1
    check observed
    checkButton.active = true
    check calls == 1
    checkButton.click()
    check calls == 2
    check not checkButton.active
    checkButton.inconsistent = true
    check checkButton.inconsistent
    connection.disconnect()
    checkButton.active = true
    check calls == 2
    var once: Connection
    once = toggle.onToggled(proc () =
      once.disconnect()
      inc calls)
    toggle.active = true
    toggle.active = false
    check calls == 3

  test "radio groups do not expose or retain borrowed GSLists":
    let first = newRadioButton("First")
    let second = newRadioButton(first, "_Second", mnemonic = true)
    let third = newRadioButton("Third")
    defer: first.destroy()
    defer: second.destroy()
    defer: third.destroy()
    check first.active
    check not second.active
    second.active = true
    check not first.active
    check second.active
    third.joinGroup(second)
    third.joinGroup(first) # Already in this group: a safe no-op.
    third.joinGroup(third)
    third.active = true
    check third.active
    check not first.active
    check not second.active
    second.destroy()
    first.active = true
    check first.active
    check not third.active
    expect ValueError: discard newRadioButton(second, "Destroyed group")
    expect ValueError: third.joinGroup(second)

  test "link properties copy strings without activating a URI":
    let link = newLinkButton("https://example.invalid/", "Website")
    let addressOnly = newLinkButton("https://example.invalid/nim")
    defer: link.destroy()
    defer: addressOnly.destroy()
    check addressOnly.text == "https://example.invalid/nim"
    check link.uri == "https://example.invalid/"
    link.uri = "https://example.invalid/updated"
    link.text = "Updated"
    link.visited = true
    check link.visited
    check link.text == "Updated"
    check link.uri == "https://example.invalid/updated"

  test "progress properties, pulse, and spinner lifecycle":
    let progress = newProgressBar(0.25, "Quarter")
    let spinner = newSpinner()
    defer: progress.destroy()
    defer: spinner.destroy()
    check progress.fraction == 0.25
    check progress.text == "Quarter"
    progress.fraction = 1.0
    progress.pulseStep = 0.2
    check progress.fraction == 1.0
    check progress.pulseStep == 0.2
    progress.pulse()
    progress.text = ""
    check progress.text == ""
    spinner.start()
    check nativeBool(spinner, "active")
    spinner.stop()
    check not nativeBool(spinner, "active")
    spinner.start()
    let copy = spinner
    spinner.destroy()
    check copy.isDestroyed
    expect ValueError: copy.start()
    expect ValueError: copy.stop()

  test "frames and expanders use checked single-child containment":
    let frame = newFrame("Frame")
    let aspect = newAspectFrame("Aspect", ratio = 1.5)
    let expander = newExpander("_Details", mnemonic = true)
    let child = newLabel("Content")
    defer: frame.destroy()
    frame.add(aspect)
    aspect.add(expander)
    expander.add(child)
    frame.text = "Outer"
    aspect.text = "Inner"
    expander.text = "Details"
    check frame.text == "Outer"
    check aspect.text == "Inner"
    check expander.text == "Details"
    frame.setLabelAlignment(0.5, 1.0)
    check frame.labelAlignment == (0.5, 1.0)
    aspect.setAspect(2.0, xalign = 0.0, yalign = 1.0, obeyChild = false)
    check nativeFloat(aspect, "xalign") == 0.0
    check nativeFloat(aspect, "yalign") == 1.0
    check nativeFloat(aspect, "ratio") == 2.0
    check not nativeBool(aspect, "obey-child")
    expander.spacing = 9
    expander.expanded = true
    check expander.spacing == 9
    check expander.expanded
    var activations = 0
    let connection = expander.onActivate(proc () = inc activations)
    g.g_signal_emit_by_name(cast[pointer](expander.raw), "activate")
    check activations == 1
    check not expander.expanded
    expect ValueError: expander.add(newLabel())
    expect ValueError: expander.add(frame)
    frame.destroy()
    check aspect.isDestroyed
    check expander.isDestroyed
    check child.isDestroyed
    check not connection.connected
    expect ValueError: discard aspect.text
    expect ValueError: discard expander.spacing

  test "separators and drawing-area sizing work with ordinary packing":
    let box = newVBox()
    defer: box.destroy()
    let horizontal = newHSeparator()
    let vertical = newVSeparator()
    let drawing = newDrawingArea(200, 100)
    box.packStart(horizontal, packShrink)
    box.packStart(vertical, packShrink)
    box.packStart(drawing)
    check drawing.sizeRequest == (200, 100)
    drawing.setSizeRequest(-1, 80)
    check drawing.sizeRequest == (-1, 80)
    drawing.queueDraw()
    box.destroy()
    check horizontal.isDestroyed
    check vertical.isDestroyed
    check drawing.isDestroyed
    expect ValueError: drawing.queueDraw()

  test "invalid inputs are rejected without GTK warnings":
    for value in [-0.1, 1.1, Inf, NegInf, NaN]:
      expect ValueError: discard newProgressBar(value)
    let progress = newProgressBar()
    let frame = newFrame()
    let expander = newExpander()
    let drawing = newDrawingArea()
    defer: progress.destroy()
    defer: frame.destroy()
    defer: expander.destroy()
    defer: drawing.destroy()
    expect ValueError: progress.fraction = NaN
    expect ValueError: progress.pulseStep = Inf
    expect ValueError: progress.text = "a\0b"
    expect ValueError: frame.setLabelAlignment(0.5, NaN)
    expect ValueError: frame.text = "a\0b"
    expect ValueError: expander.spacing = -1
    expect ValueError: discard newAspectFrame(ratio = NaN)
    expect ValueError: discard newAspectFrame(ratio = 0.0)
    expect ValueError: discard newAspectFrame(xalign = 2.0)
    expect ValueError: discard newDrawingArea(-2, 10)
    expect ValueError: drawing.setSizeRequest(10, -2)
    expect ValueError: discard newToggleButton("a\0b")
    expect ValueError: discard newCheckButton("a\0b")
    expect ValueError: discard newRadioButton("a\0b")
    expect ValueError: discard newLinkButton("a\0b")
    expect ValueError: discard newLinkButton("https://example.invalid/", "a\0b")
    expect ValueError: discard newExpander("a\0b")
    when sizeof(int) > sizeof(g.gint):
      expect ValueError: discard newDrawingArea(high(g.gint).int + 1, 0)

  test "every new widget releases its unparented native reference":
    var finalized: array[12, bool]
    proc finalizedCallback(data: pointer, obj: g.PGObject) {.cdecl.} =
      cast[ptr bool](data)[] = true
    block:
      let widgets = @[
        gtk2ui.Widget(newToggleButton()), gtk2ui.Widget(newCheckButton()),
        gtk2ui.Widget(newRadioButton()), gtk2ui.Widget(newLinkButton("https://example.invalid/")),
        gtk2ui.Widget(newProgressBar()), gtk2ui.Widget(newSpinner()),
        gtk2ui.Widget(newFrame()), gtk2ui.Widget(newAspectFrame()),
        gtk2ui.Widget(newExpander()), gtk2ui.Widget(newHSeparator()),
        gtk2ui.Widget(newVSeparator()), gtk2ui.Widget(newDrawingArea())]
      for i, widget in widgets:
        g.weak_ref(cast[g.PGObject](widget.raw), finalizedCallback, addr finalized[i])
    for done in finalized: check done

  test "inherited signals break cycles and child handles can leave scope":
    let frame = newFrame()
    defer: frame.destroy()
    var finalized = false
    proc finalizedCallback(data: pointer, obj: g.PGObject) {.cdecl.} =
      cast[ptr bool](data)[] = true
    block:
      let button = newCheckButton("Parent-owned")
      g.weak_ref(cast[g.PGObject](button.raw), finalizedCallback, addr finalized)
      button.onToggled(proc () = button.text = "Captured")
      frame.add(button)
    check not finalized
    frame.destroy()
    check finalized
