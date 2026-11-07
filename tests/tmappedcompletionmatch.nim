# Native filtered popup behavior for copied pure completion predicates.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Custom completion tests require an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc awaitUi(fn: proc (): bool): bool =
  let deadline = epochTime() + 6
  while epochTime() < deadline:
    for i in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    if fn(): return true
    sleep(10)
proc mappedWindows(): int =
  let list = n.window_list_toplevels()
  defer: g.free(list)
  var node = list
  while node != nil:
    if g.toBool(n.get_mapped(cast[n.PWidget](node.data))): inc result
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
  proc key(display: ptr XDisplay, keyval: culong) =
    let code = XKeysymToKeycode(display, keyval)
    doAssert code != 0
    discard XTestFakeKeyEvent(display, cuint(code), 1, 0)
    discard XTestFakeKeyEvent(display, cuint(code), 0, 0)
    discard XSync(display, 0)
  suite "native custom completion popup":
    test "non-prefix match keeps source indices and safe deferred selection":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Custom matching", 400, 100)
      defer: host.destroy()
      let entry = newEntry()
      host.add(entry)
      let c = newEntryCompletion(["not chosen", "beta a", "other"])
      defer: c.close()
      c.popupSingleMatch = true
      var inputs: seq[CompletionMatchInput]
      let token = c.setMatch(proc (input: CompletionMatchInput): bool =
        inputs.add(input)
        input.index == 1)
      entry.completion = c
      var selected: seq[CompletionSelection]
      c.onSelected(proc (value: CompletionSelection) =
        selected.add(value)
        c.clearMatch()
        host.destroy())
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      let before = mappedWindows()
      key(display, culong(ord('a')))
      require awaitUi(proc (): bool = mappedWindows() > before)
      key(display, 0xff54)
      key(display, 0xff0d)
      require awaitUi(proc (): bool = selected.len == 1)
      check selected[0].index == 1 and selected[0].text == "beta a"
      check inputs.len >= 3 and inputs[0].key == "a" and inputs[1].index == 1
      check not token.connected and host.isDestroyed
    test "new fixed model and explicit native-default reset update real popup rows":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Matcher reset", 400, 100)
      defer: host.destroy()
      let entry = newEntry()
      host.add(entry)
      let c = newEntryCompletion(["old", "old other"])
      defer: c.close()
      c.popupSingleMatch = true
      c.setMatch(proc (input: CompletionMatchInput): bool = input.index == 1)
      entry.completion = c
      c.setItems(["apple", "pineapple"])
      var selected: seq[CompletionSelection]
      c.onSelected(proc (value: CompletionSelection) = selected.add(value))
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      let before = mappedWindows()
      entry.insertText("ap")
      require awaitUi(proc (): bool = mappedWindows() > before)
      key(display, 0xff54)
      key(display, 0xff0d)
      require awaitUi(proc (): bool = selected.len == 1)
      check selected[0].index == 1 and entry.text == "pineapple"
      c.clearMatch()
      c.refilter()
      entry.text = ""
      entry.insertText("ap")
      require awaitUi(proc (): bool = mappedWindows() > before)
      key(display, 0xff54)
      key(display, 0xff0d)
      require awaitUi(proc (): bool = selected.len == 2)
      check selected[1].index == 0 and entry.text == "apple" and not c.customMatching
else:
  suite "mapped custom completion":
    test "XTEST keyboard coverage requires Unix X11": discard
