import std/[strutils, unittest]
import gtk2
import headers/gtk2 as rawGtk
import headers/glib2 as g

static:
  doAssert typeof(newColorSelection().raw) is rawGtk.PColorSelection
  doAssert typeof(newColorSelectionDialog().raw) is rawGtk.PColorSelectionDialog
  doAssert typeof(newFontSelection().raw) is rawGtk.PFontSelection
  doAssert typeof(newFontSelectionDialog().raw) is rawGtk.PFontSelectionDialog
proc drainUi() =
  for i in 0..<128:
    if rawGtk.events_pending() == 0: return
    discard rawGtk.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "unexpected continuously pending UI source")
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CaptureObj = object
  released, calls: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.released[]
type Capture = ref CaptureObj
proc track(w: gtk2.ColorSelection, released, calls: ptr int): Connection =
  let capture = Capture(released: released, calls: calls)
  w.onColorChanged(proc (value: Color) = inc capture.calls[])
proc track(w: gtk2.FontSelection, released, calls: ptr int): Connection =
  let capture = Capture(released: released, calls: calls)
  w.onFontChanged(proc (value: string) = inc capture.calls[])
proc temporaryColor(parent: gtk2.Window, released, calls, gone: ptr int) =
  let panel = newColorSelection(useAlpha = true)
  parent.add(panel)
  g.weak_ref(cast[g.PGObject](panel.raw), finalized, gone)
  discard track(panel, released, calls)
  panel.color = rgba16(111, 222, 333, 444)
proc temporaryFont(parent: gtk2.Window, released, calls, gone: ptr int) =
  let panel = newFontSelection()
  parent.add(panel)
  g.weak_ref(cast[g.PGObject](panel.raw), finalized, gone)
  discard track(panel, released, calls)
  panel.fontName = "Sans 18"

gtk2.init()
suite "standalone color/font panels and nonblocking chooser dialogs (hidden)":
  test "copied current/previous RGBA, palette and native alpha visibility semantics":
    let initial = rgba16(1, 20000, 65535, 32123)
    let panel = newColorSelection(initial, useAlpha = true, hasPalette = true)
    defer: panel.destroy()
    check panel.color == initial and panel.previousColor == initial
    check panel.useAlpha and panel.hasPalette and not panel.isAdjusting
    let previous = rgba16(12345, 23456, 34567, 45678)
    panel.previousColor = previous
    panel.color = rgba16(100, 200, 300, 400)
    check panel.previousColor == previous
    check panel.color == rgba16(100, 200, 300, 400)
    panel.useAlpha = false
    check panel.color.alpha == 65535 and panel.previousColor.alpha == 65535
    panel.useAlpha = true
    check panel.color.alpha == 400 and panel.previousColor.alpha == 45678
    panel.hasPalette = false
    check not panel.hasPalette
    panel.destroy()
    expect ValueError: discard panel.color
    expect ValueError: panel.previousColor = initial

  test "color observers defer/coalesce, copy values, and observe effective opacity changes":
    let panel = newColorSelection(useAlpha = true)
    defer: panel.destroy()
    var values: seq[Color]
    panel.onColorChanged(proc (value: Color) = values.add(value))
    let one = rgba16(1234, 3456, 5678, 7890)
    let two = rgba16(65535, 11111, 22222, 33333)
    panel.color = one
    panel.color = two
    check values.len == 0
    drainUi()
    check values == @[two]
    panel.color = two
    drainUi()
    check values == @[two]
    panel.useAlpha = false
    drainUi()
    check values.len == 2 and values[^1].alpha == 65535
    panel.previousColor = one
    drainUi()
    check values.len == 2
    panel.destroy()
    check values[0] == two

  test "font descriptions are copied/freed and setters require an anchored panel":
    let panel = newFontSelection()
    defer: panel.destroy()
    let original = panel.fontName
    check original.len > 0
    check not panel.setFontName("Sans 12")
    expect ValueError: panel.fontName = "Sans 12"
    for invalid in ["", "\xff", "Sans\0 10"]:
      expect ValueError: discard panel.setFontName(invalid)
    expect ValueError: panel.previewText = "\xff"
    let window = newWindow()
    defer: window.destroy()
    window.add(panel) # Screen anchoring does not realize or map the window.
    check panel.setFontName("Sans 14")
    check panel.fontName.contains("14")
    panel.previewText = "A preview: café <not markup>"
    check panel.previewText == "A preview: café <not markup>"
    let selected = panel.fontName
    for i in 0..<100: check panel.fontName == selected
    panel.destroy()
    check selected.contains("14") and original.len > 0
    expect ValueError: discard panel.previewText

  test "font observers see both native user-list changes and programmatic changes":
    let window = newWindow()
    defer: window.destroy()
    let panel = newFontSelection()
    window.add(panel)
    panel.fontName = "Sans 14"
    var names: seq[string]
    panel.onFontChanged(proc (value: string) = names.add(value))
    panel.fontName = "Sans 18"
    panel.fontName = "Sans 20"
    check names.len == 0
    drainUi()
    check names == @[panel.fontName]
    check names[0].contains("20")
    panel.fontName = panel.fontName
    drainUi()
    check names.len == 1
    # This drives a private GTK size-list selection, not the SDK font setter.
    # GTK2 omits notify::font-name on this path, so that signal alone is insufficient.
    let list = rawGtk.get_size_list(panel.raw)
    let path = rawGtk.tree_path_new_from_string("0")
    rawGtk.set_cursor(cast[rawGtk.PTreeView](list), path, nil, g.gbool(false))
    rawGtk.free(path)
    drainUi()
    check names.len == 2
    check names[^1] == panel.fontName and names[^1] != names[0]

  test "direct color dialogs forward selections without exposing managed child widgets":
    let parent = newWindow()
    defer: parent.destroy()
    let color = rgba16(60000, 40000, 20000, 10000)
    let dialog = newColorSelectionDialog(parent, "Color %s café", color, useAlpha = true,
      hasPalette = true, modal = true)
    defer: dialog.destroy()
    check dialog.title == "Color %s café"
    expect ValueError: dialog.title = "\xff"
    check dialog.modal and dialog.destroyWithParent
    check rawGtk.get_transient_for(cast[rawGtk.PWindow](dialog.raw)) == parent.raw
    check dialog.color == color and dialog.previousColor == color
    check dialog.useAlpha and dialog.hasPalette
    check not dialog.showHelp
    let help = rawGtk.get_widget_for_response(cast[rawGtk.PDialog](dialog.raw), cint(responseHelp))
    check g.toBool(rawGtk.get_no_show_all(help))
    rawGtk.show_all(rawGtk.get_action_area(cast[rawGtk.PDialog](dialog.raw)))
    check not dialog.showHelp # Must stay hidden even if the action area is shown.
    dialog.showHelp = true
    check dialog.showHelp and not g.toBool(rawGtk.get_no_show_all(help))
    dialog.showHelp = false
    var changed: seq[Color]
    dialog.onColorChanged(proc (value: Color) = changed.add(value))
    dialog.color = rgba16(11, 22, 33, 44)
    drainUi()
    check changed == @[rgba16(11, 22, 33, 44)]
    var responses: seq[ResponseId]
    dialog.onResponse(proc (id: ResponseId) =
      responses.add(id)
      if id == responseOk: check dialog.color == rgba16(11, 22, 33, 44))
    dialog.respond(responseCancel)
    check not dialog.isDestroyed # Responses do not close or roll back automatically.
    dialog.respond(responseOk)
    check responses == @[responseCancel, responseOk]
    parent.destroy()
    check dialog.isDestroyed

  test "direct font dialogs own copied strings and preserve the hidden Apply button":
    let dialog = newFontSelectionDialog("Font %n café")
    defer: dialog.destroy()
    check dialog.title == "Font %n café" and not dialog.showApply
    expect ValueError: dialog.title = "bad\0title"
    let apply = rawGtk.get_widget_for_response(cast[rawGtk.PDialog](dialog.raw), cint(responseApply))
    check g.toBool(rawGtk.get_no_show_all(apply))
    rawGtk.show_all(rawGtk.get_action_area(cast[rawGtk.PDialog](dialog.raw)))
    check not dialog.showApply
    dialog.showApply = true
    check dialog.showApply
    dialog.showApply = false
    check dialog.setFontName("Sans 14")
    dialog.previewText = "Copied preview"
    check dialog.previewText == "Copied preview"
    var names: seq[string]
    dialog.onFontChanged(proc (value: string) = names.add(value))
    dialog.fontName = "Sans 18"
    drainUi()
    check names == @[dialog.fontName]
    var accepted: string
    dialog.onResponse(proc (id: ResponseId) =
      if id == responseOk:
        accepted = dialog.fontName
        dialog.destroy())
    dialog.respond(responseOk)
    check dialog.isDestroyed and accepted.contains("18")
    check names[0] == accepted

  test "validation fails before allocating dialogs and transient ownership is checked":
    expect ValueError: discard newColorSelectionDialog("\xff")
    expect ValueError: discard newFontSelectionDialog("bad\0title")
    expect ValueError: discard newColorSelectionDialog(gtk2.Window())
    expect ValueError: discard newFontSelectionDialog(gtk2.Window())
    let parent = newWindow()
    defer: parent.destroy()
    let dialog = newFontSelectionDialog(parent, destroyWithParent = false)
    defer: dialog.destroy()
    expect ValueError: parent.transientFor = dialog
    parent.destroy()
    check not dialog.isDestroyed
    dialog.clearTransientFor()

  test "observers self-disconnect, contain exceptions and safely destroy owners":
    let color = newColorSelection(useAlpha = true)
    defer: color.destroy()
    var connection: Connection
    var calls = 0
    connection = color.onColorChanged(proc (value: Color) =
      inc calls
      connection.disconnect()
      color.destroy()
      raise newException(ValueError, "expected chooser color callback error"))
    color.color = rgba16(12, 34, 56, 78)
    check not color.isDestroyed
    drainUi()
    check calls == 1 and color.isDestroyed and not connection.connected
    let font = newFontSelectionDialog()
    defer: font.destroy()
    font.onFontChanged(proc (value: string) =
      font.destroy()
      raise newException(ValueError, "expected chooser font callback error"))
    font.fontName = "Sans 32"
    drainUi()
    check font.isDestroyed
    let other = newColorSelection()
    defer: other.destroy()
    let unparented = newFontSelection()
    defer: unparented.destroy()
    expect ValueError: discard other.onColorChanged(nil)
    expect ValueError: discard unparented.onFontChanged(nil)

  test "reentrant live changes schedule another idle delivery without recursion":
    let panel = newColorSelection(useAlpha = true)
    defer: panel.destroy()
    var colors: seq[Color]
    let first = rgba16(100, 200, 300, 400)
    let second = rgba16(400, 300, 200, 100)
    panel.onColorChanged(proc (value: Color) =
      colors.add(value)
      if colors.len == 1: panel.color = second)
    panel.color = first
    drainUi()
    check colors == @[first, second]
    let dialog = newFontSelectionDialog()
    defer: dialog.destroy()
    var names: seq[string]
    dialog.onFontChanged(proc (value: string) =
      names.add(value)
      if names.len == 1: dialog.fontName = "Sans 22")
    dialog.fontName = "Sans 20"
    drainUi()
    check names.len == 2 and names[0].contains("20") and names[1].contains("22")

  test "disconnecting font observers removes private watches; unparented observers do not self-retain":
    var released, calls, gone = 0
    let window = newWindow()
    defer: window.destroy()
    let panel = newFontSelection()
    window.add(panel)
    let connection = track(panel, addr released, addr calls)
    connection.disconnect()
    check released == 1
    panel.fontName = "Sans 24"
    drainUi()
    check calls == 0
    block:
      let font = newFontSelection()
      let color = newColorSelection()
      g.weak_ref(cast[g.PGObject](font.raw), finalized, addr gone)
      g.weak_ref(cast[g.PGObject](color.raw), finalized, addr gone)
      discard track(font, addr released, addr calls)
      discard track(color, addr released, addr calls)
      # No parent, self-captures, or retained Connection: last handle may dispose.
    check gone == 2 and released == 3

  test "disconnect/destruction cancel idle work and release heap captures and native panels":
    var released, calls, gone = 0
    block:
      let color = newColorSelection()
      let connection = track(color, addr released, addr calls)
      color.color = rgba16(111, 222, 333)
      connection.disconnect()
      check released == 1
      drainUi()
      check calls == 0
      color.destroy()
    for useFont in [false, true]:
      let parent = newWindow()
      if useFont: temporaryFont(parent, addr released, addr calls, addr gone)
      else: temporaryColor(parent, addr released, addr calls, addr gone)
      parent.destroy() # Temporary wrapper states are already gone.
      drainUi()
    check released == 3 and calls == 0 and gone == 2
    block:
      let color = newColorSelectionDialog()
      let font = newFontSelectionDialog()
      g.weak_ref(cast[g.PGObject](color.raw), finalized, addr gone)
      g.weak_ref(cast[g.PGObject](font.raw), finalized, addr gone)
      color.onColorChanged(proc (value: Color) = inc calls)
      font.onFontChanged(proc (value: string) = inc calls)
      color.color = rgba16(1000, 2000, 3000)
      font.fontName = "Sans 32"
      color.destroy()
      font.destroy()
      drainUi()
    check calls == 0 and gone == 4
