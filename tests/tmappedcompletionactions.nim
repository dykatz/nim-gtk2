# Native action key/mouse emitters. Explicit isolated-display opt-in only.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Completion action tests require an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc awaitUi(fn: proc (): bool): bool =
  let deadline = epochTime() + 6
  while epochTime() < deadline:
    for i in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    if fn(): return true
    sleep(10)
proc popupExcept(host: n.PWidget): n.PWidget =
  let list = n.window_list_toplevels()
  defer: g.free(list)
  var node = list
  while node != nil:
    let widget = cast[n.PWidget](node.data)
    if widget != host and g.toBool(n.get_mapped(widget)): return widget
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
  proc XTestFakeMotionEvent(display: ptr XDisplay, screen, x, y: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc XTestFakeButtonEvent(display: ptr XDisplay, button: cuint, press: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc key(display: ptr XDisplay, keyval: culong) =
    let code = XKeysymToKeycode(display, keyval)
    doAssert code != 0
    discard XTestFakeKeyEvent(display, cuint(code), 1, 0)
    discard XTestFakeKeyEvent(display, cuint(code), 0, 0)
    discard XSync(display, 0)
  suite "native completion action rows":
    test "action-only mouse popup copies labels and defers teardown past native popdown":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Mouse action", 420, 100)
      defer: host.destroy()
      let entry = newEntry()
      host.add(entry)
      let c = newEntryCompletion(["z rejected"], actions = ["<b>literal &", "Create λ🙂"])
      defer: c.close()
      c.setMatch(proc (input: CompletionMatchInput): bool = false)
      entry.completion = c
      var values: seq[CompletionAction]
      var suggestions = 0
      c.onSelected(proc (value: CompletionSelection) = inc suggestions)
      c.onActionActivated(proc (value: CompletionAction) =
        values.add(value)
        c.close()
        host.destroy())
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      key(display, culong(ord('z')))
      require awaitUi(proc (): bool = popupExcept(cast[n.PWidget](host.raw)) != nil)
      let popup = popupExcept(cast[n.PWidget](host.raw))
      var allocation: n.TAllocation
      require awaitUi(proc (): bool =
        n.get_allocation(popup, addr allocation)
        allocation.height > 20)
      var x, y: g.gint
      discard gd.get_origin(n.get_window(popup), addr x, addr y)
      # Public popup-window geometry only; no private GTK structures or row model.
      discard XTestFakeMotionEvent(display, 0, x + allocation.width div 2, y + allocation.height - 8, 0)
      discard XTestFakeButtonEvent(display, 1, 1, 0)
      discard XTestFakeButtonEvent(display, 1, 0, 0)
      discard XSync(display, 0)
      require awaitUi(proc (): bool = values.len == 1)
      check values[0].index == 1 and values[0].text == "Create λ🙂" and values[0].key == "z"
      check suggestions == 0 and host.isDestroyed and c.closed
    test "inline suggestion-to-action navigation, attached replacement rejection and explicit new session":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Keyboard actions", 420, 100)
      defer: host.destroy()
      let entry = newEntry()
      host.add(entry)
      let c = newEntryCompletion(["alpha", "alpine"], actions = ["Search", "Create"])
      defer: c.close()
      c.inlineSelection = true
      entry.completion = c
      var values: seq[CompletionAction]
      var suggestions = 0
      c.onSelected(proc (value: CompletionSelection) = inc suggestions)
      let token = c.onActionActivated(proc (value: CompletionAction) = values.add(value))
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      entry.insertText("a")
      require awaitUi(proc (): bool = popupExcept(cast[n.PWidget](host.raw)) != nil)
      expect ValueError: c.setActions(["unsafe replacement"])
      key(display, 0xff54)
      require awaitUi(proc (): bool = entry.text == "alpha")
      key(display, 0xff54)
      require awaitUi(proc (): bool = entry.text == "alpine")
      key(display, 0xff54)
      require awaitUi(proc (): bool = entry.text == "a")
      key(display, 0xff0d)
      require awaitUi(proc (): bool = values.len == 1)
      check values[0].index == 0 and values[0].text == "Search" and values[0].key == "a"
      check suggestions == 0 and entry.text == "a" and not c.completionPrefix.available
      c.detach() # Explicit application attachment boundary, not an automatic reset.
      c.setActions(["Replacement"])
      entry.completion = c
      check not token.connected
      c.onActionActivated(proc (value: CompletionAction) =
        values.add(value)
        c.close()
        host.destroy())
      entry.text = ""
      entry.insertText("z")
      require awaitUi(proc (): bool = popupExcept(cast[n.PWidget](host.raw)) != nil)
      key(display, 0xff52) # Native Up wraps directly to the last action.
      key(display, 0xff0d)
      require awaitUi(proc (): bool = values.len == 2)
      check values[1].index == 0 and values[1].text == "Replacement" and values[1].key == "z"
      check host.isDestroyed and c.closed
else:
  suite "mapped completion actions":
    test "XTEST key/mouse coverage requires Unix X11": discard
