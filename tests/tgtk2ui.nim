# Requires a display (use Xvfb on headless hosts). Never opens a visible window
# or enters the GTK main loop.
import std/unittest
import gtk2ui
import gtk2 as rawGtk
import glib2 as g

# Verify the surface can be used without raw casts and unsupported signals
# cannot accidentally be registered on the wrong widget type.
static:
  doAssert not compiles(newLabel().onClicked(proc () = discard))
  doAssert not compiles(newVBox().add(newLabel()))

gtk2ui.init()

suite "gtkmm-inspired Nim API":
  test "properties, packing, closure signals, disconnect and destroy":
    let window = newWindow("Test", 300, 200)
    defer: window.destroy()
    let box = newVBox(spacing = 4)
    let entry = newEntry("before")
    let label = newLabel("λ")
    let button = newButton("Go")
    window.borderWidth = 8
    window.add(box)
    box.packStart(entry, packShrink)
    box.packStart(label, packExpandPadding)
    box.packEnd(button)
    check window.title == "Test"
    check label.text == "λ"
    window.title = "Updated"
    check window.title == "Updated"
    var changes = 0
    entry.onChanged do ():
      inc changes
    entry.text = "after"
    check changes == 1
    var clicks = 0
    let connection = button.onClicked(proc () =
      inc clicks
      label.text = entry.text)
    check connection.connected
    button.click()
    check clicks == 1
    check label.text == "after"
    connection.disconnect()
    connection.disconnect()
    check not connection.connected
    button.click()
    check clicks == 1
    var destroyed = 0
    window.onDestroy(proc () = inc destroyed)
    let alias = window
    window.destroy()
    window.destroy()
    check destroyed == 1
    check alias.isDestroyed
    check button.isDestroyed
    expect ValueError: discard button.text

  test "native destruction invalidates every wrapper copy":
    let button = newButton("raw")
    let alias = button
    rawGtk.destroy(cast[rawGtk.PWidget](button.raw))
    check alias.isDestroyed
    expect ValueError: alias.click()

  test "callbacks may disconnect themselves and may raise":
    let button = newButton()
    defer: button.destroy()
    var connection: Connection
    var count = 0
    connection = button.onClicked(proc () =
      connection.disconnect()
      inc count)
    button.click()
    button.click()
    check count == 1
    button.onClicked(proc () = raise newException(ValueError, "expected test error"))
    button.onClicked(proc () = inc count)
    button.click()
    check count == 2

  test "bad containment and arguments fail before calling GTK":
    let window = newWindow()
    defer: window.destroy()
    let box = newVBox()
    let inner = newVBox()
    window.add(box)
    box.packStart(inner)
    expect ValueError: inner.packStart(box)
    expect ValueError: box.packStart(box)
    expect ValueError: box.packStart(window)
    expect ValueError: window.add(newLabel())
    expect ValueError: discard newVBox(spacing = -1)
    expect ValueError: discard newLabel("a\0b")
    expect ValueError: discard gtk2ui.Widget().raw

  test "destroy breaks self-capturing closure cycles":
    var finalized = false
    proc cycleFinalized(data: pointer, obj: g.PGObject) {.cdecl.} =
      cast[ptr bool](data)[] = true
    var native: rawGtk.PWidget
    block:
      let button = newButton("cycle")
      native = cast[rawGtk.PWidget](button.raw)
      g.weak_ref(cast[g.PGObject](native), cycleFinalized, addr finalized)
      button.onClicked(proc () = button.text = "captured")
    check not finalized
    rawGtk.destroy(native)
    check finalized

  test "child wrappers may leave scope before their parent":
    let window = newWindow()
    defer: window.destroy()
    block:
      let button = newButton("parent-owned")
      window.add(button)
    let child = rawGtk.get_child(cast[rawGtk.PBin](window.raw))
    check child != nil
    check $rawGtk.get_label(cast[rawGtk.PButton](child)) == "parent-owned"

  test "releasing an unparented widget finalizes its native object":
    var finalized = false
    proc nativeFinalized(data: pointer, obj: g.PGObject) {.cdecl.} =
      cast[ptr bool](data)[] = true
    block:
      let button = newButton()
      g.weak_ref(cast[g.PGObject](button.raw), nativeFinalized, addr finalized)
    check finalized
