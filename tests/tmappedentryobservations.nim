# Selection observers after native PRIMARY/keyboard/completion emitters finish.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Entry observation tests require an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc awaitUi(fn: proc (): bool): bool =
  let deadline = epochTime() + 6
  while epochTime() < deadline:
    for i in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    if fn(): return true
    sleep(10)
proc popupVisible(host: n.PWidget): bool =
  let list = n.window_list_toplevels()
  defer: g.free(list)
  var node = list
  while node != nil:
    let widget = cast[n.PWidget](node.data)
    if widget != host and g.toBool(n.get_mapped(widget)): return true
    node = node.next
gtk2.init()
when defined(posix) and not defined(macosx):
  type XDisplay {.pure, final, incompleteStruct.} = object
  const xlib = "libX11.so(.6|)"
  const xtest = "libXtst.so(.6|)"
  proc XOpenDisplay(name: cstring): ptr XDisplay {.cdecl, dynlib: xlib, importc.}
  proc XCloseDisplay(display: ptr XDisplay): cint {.cdecl, dynlib: xlib, importc.}
  proc XSync(display: ptr XDisplay, discardEvents: cint): cint {.cdecl, dynlib: xlib, importc.}
  proc XKeysymToKeycode(display: ptr XDisplay, key: culong): uint8 {.cdecl, dynlib: xlib, importc.}
  proc XTestFakeKeyEvent(display: ptr XDisplay, key: cuint, press: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc press(display: ptr XDisplay, keyval: culong, down: bool) =
    let code = XKeysymToKeycode(display, keyval)
    doAssert code != 0
    discard XTestFakeKeyEvent(display, cuint(code), cint(ord(down)), 0)
    discard XSync(display, 0)
  proc key(display: ptr XDisplay, keyval: culong) =
    press(display, keyval, true)
    press(display, keyval, false)
  suite "native Entry selection observation timing":
    test "PRIMARY gain/loss finishes before callbacks, loss callback can destroy owner":
      let primary = getClipboard(clipboardPrimary)
      defer: primary.clear()
      let host = newWindow("PRIMARY observations", 430, 100)
      defer: host.destroy()
      let entry = newEntry("λ🙂abc")
      host.add(entry)
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      entry.cursorOffset = 0
      var values: seq[EntrySelection]
      let token = entry.onSelectionChanged(proc (value: EntrySelection) =
        values.add(value)
        if value.hasSelection:
          doAssert n.get_owner(primary.raw) == cast[g.PGObject](entry.raw)
        else:
          doAssert n.get_owner(primary.raw) != cast[g.PGObject](entry.raw)
          host.destroy())
      entry.selectRange(4, 1)
      check values.len == 0
      require awaitUi(proc (): bool = values.len == 1)
      check values[0].anchor == 4 and values[0].cursor == 1
      primary.setText("independent isolated offer")
      require awaitUi(proc (): bool = values.len == 2)
      check not values[1].hasSelection and values[1].cursor == 1
      check host.isDestroyed and not token.connected
    test "real Shift-Left notifications coalesce; focus roundtrip deduplicates reverse selection":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Observed reverse selection", 440, 160)
      defer: host.destroy()
      let box = newVBox()
      host.add(box)
      let entry = newEntry("λ🙂AB")
      let button = newButton("Other focus")
      box.packStart(entry)
      box.packStart(button)
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      entry.cursorOffset = 4
      var values: seq[EntrySelection]
      let token = entry.onSelectionChanged(proc (value: EntrySelection) = values.add(value))
      press(display, 0xffe1, true)
      key(display, 0xff51)
      key(display, 0xff51)
      press(display, 0xffe1, false)
      require awaitUi(proc (): bool = values.len >= 1)
      check values.len == 1 and values[0].anchor == 4 and values[0].cursor == 2
      let copied = values[0]
      button.focus()
      entry.focus()
      require awaitUi(proc (): bool = entry.selectionBounds == copied)
      check values.len == 1
      token.disconnect()
      entry.clearSelection()
      require awaitUi(proc (): bool = not entry.hasSelection)
      check values.len == 1
    test "inline preview delivers actual final suffix, then callback safely closes native completion":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Observed preview", 420, 100)
      defer: host.destroy()
      let entry = newEntry()
      host.add(entry)
      let c = newEntryCompletion(["alpha", "alpine"])
      defer: c.close()
      c.inlineSelection = true
      entry.completion = c
      var preview: EntrySelection
      var delivered = false
      let token = entry.onSelectionChanged(proc (value: EntrySelection) =
        if value.hasSelection:
          preview = value
          delivered = true
          c.close()
          host.destroy())
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      entry.insertText("a")
      require awaitUi(proc (): bool = popupVisible(cast[n.PWidget](host.raw)))
      key(display, 0xff54)
      require awaitUi(proc (): bool = delivered)
      check preview.first == 1 and preview.last == 5 and preview.cursor == 5
      check host.isDestroyed and c.closed and not token.connected
else:
  suite "mapped Entry observations":
    test "PRIMARY/XTEST coverage requires Unix X11": discard
