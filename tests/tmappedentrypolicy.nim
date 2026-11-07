# Native default-key activation and text policies: isolated-display opt-in only.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Entry policy tests require an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc awaitUi(fn: proc (): bool): bool =
  let deadline = epochTime() + 6
  while epochTime() < deadline:
    for i in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    if fn(): return true
    sleep(10)
proc settle() =
  let endTime = epochTime() + 0.4
  doAssert awaitUi(proc (): bool = epochTime() >= endTime)
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
  proc key(display: ptr XDisplay, keyval: culong) =
    let code = XKeysymToKeycode(display, keyval)
    doAssert code != 0
    discard XTestFakeKeyEvent(display, cuint(code), 1, 0)
    discard XTestFakeKeyEvent(display, cuint(code), 0, 0)
    discard XSync(display, 0)
  suite "native Entry limit/default policy":
    test "Return uses the application's native default response only when enabled/sensitive":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let dialog = newDialog("Explicit default activation")
      defer: dialog.destroy()
      let entry = newEntry("λ🙂")
      entry.maxLength = 3
      entry.widthChars = 16
      entry.alignment = 0.75
      dialog.packStart(entry)
      discard dialog.addButton("_Apply", responseOk)
      dialog.defaultResponse = responseOk
      var responses, activations = 0
      dialog.onResponse(proc (id: ResponseId) =
        doAssert id == responseOk
        inc responses)
      entry.onActivate(proc () = inc activations) # Not a substitute default action.
      dialog.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      entry.cursorOffset = 2
      key(display, culong(ord('a')))
      require awaitUi(proc (): bool = entry.text == "λ🙂a")
      key(display, culong(ord('b')))
      settle()
      check entry.text == "λ🙂a" and entry.characterCount == 3
      entry.activatesDefault = false
      key(display, 0xff0d)
      require awaitUi(proc (): bool = activations == 1)
      settle()
      check responses == 0
      entry.activatesDefault = true
      dialog.setResponseSensitive(responseOk, false)
      key(display, 0xff0d)
      require awaitUi(proc (): bool = activations == 2)
      settle()
      check responses == 0
      dialog.setResponseSensitive(responseOk, true)
      key(display, 0xff0d)
      require awaitUi(proc (): bool = responses == 1)
      check activations == 3 and entry.activatesDefault
    test "native long completion truncates, without inventing an atomic validation commit":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Limited completion", 430, 100)
      defer: host.destroy()
      let entry = newEntry()
      entry.maxLength = 4
      host.add(entry)
      let c = newEntryCompletion(["alpha", "alpine"])
      defer: c.close()
      entry.completion = c
      var selected = 0
      c.onSelected(proc (value: CompletionSelection) = inc selected)
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      entry.insertText("a")
      require awaitUi(proc (): bool = popupVisible(cast[n.PWidget](host.raw)))
      key(display, 0xff54)
      key(display, 0xff0d)
      require awaitUi(proc (): bool = entry.text == "alph")
      settle()
      check selected == 0 # Existing onSelected exact-text/staleness check.
    test "mapped combo truncation observers can close beyond the native buffer setter":
      let host = newWindow("Truncation teardown", 440, 100)
      defer: host.destroy()
      let combo = newComboBoxText(["λ🙂abc"], editable = true)
      combo.activeIndex = 0
      host.add(combo)
      let child = combo.entry
      host.showAll()
      host.present()
      child.focus()
      require awaitUi(proc (): bool = g.toBool(n.get_mapped(cast[n.PWidget](child.raw))))
      var seen = 0
      combo.onChanged(proc () =
        doAssert child.maxLength == 2 and child.text == "λ🙂"
        inc seen
        host.destroy())
      child.maxLength = 2
      check seen == 0
      require awaitUi(proc (): bool = seen == 1)
      check host.isDestroyed and child.isDestroyed
else:
  suite "mapped Entry policy":
    test "XTEST default-key coverage requires Unix X11": discard
