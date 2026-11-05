# This sends keyboard input to a native completion popup. Never run on a desktop.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped completion tests require an isolated virtual display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
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
  proc XTestQueryExtension(display: ptr XDisplay, event, error, major, minor: ptr cint): cint {.cdecl, dynlib: xtest, importc.}
  proc XTestFakeKeyEvent(display: ptr XDisplay, key: cuint, press: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc key(display: ptr XDisplay, keyval: culong) =
    let code = XKeysymToKeycode(display, keyval)
    doAssert code != 0
    discard XTestFakeKeyEvent(display, cuint(code), 1, 0)
    discard XTestFakeKeyEvent(display, cuint(code), 0, 0)
    discard XSync(display, 0)
  suite "real native completion popup and editable combo":
    test "casefold matching, keyboard selection, copied Unicode and safe observer close":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      var event, error, major, minor: cint
      require XTestQueryExtension(display, addr event, addr error, addr major, addr minor) != 0
      let host = newWindow("Completion", 420, 120)
      defer: host.destroy()
      let entry = newEntry()
      host.add(entry)
      let completion = newEntryCompletion(["Nim λ🙂", "Nimble", "Other"])
      defer: completion.close()
      entry.completion = completion
      var selected: seq[CompletionSelection]
      completion.onSelected(proc (value: CompletionSelection) =
        selected.add(value)
        host.destroy())
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      let before = mappedWindows()
      entry.insertText("nI") # Native normalized case-insensitive prefix matching.
      require awaitUi(proc (): bool = mappedWindows() > before)
      key(display, 0xff54) # Down to first result.
      key(display, 0xff0d) # Return selects it through GTK's real popup handler.
      require awaitUi(proc (): bool = selected.len == 1)
      check selected[0].index == 0 and selected[0].text == "Nim λ🙂"
      check host.isDestroyed and entry.isDestroyed and not completion.attached
    test "completion on an editable combo entry keeps native selection/text state coherent":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Editable combo completion", 420, 120)
      defer: host.destroy()
      let combo = newComboBoxText(["Length", "Width"], editable = true)
      host.add(combo)
      let completion = newEntryCompletion(["Length λ", "Length unit", "Width"])
      defer: completion.close()
      let entry = combo.entry
      entry.completion = completion
      var selected: seq[CompletionSelection]
      var states: seq[ComboTextState]
      completion.onSelected(proc (value: CompletionSelection) = selected.add(value))
      combo.onTextChanged(proc (value: ComboTextState) = states.add(value))
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      let before = mappedWindows()
      entry.insertText("Len")
      require awaitUi(proc (): bool = mappedWindows() > before)
      key(display, 0xff54)
      key(display, 0xff0d)
      require awaitUi(proc (): bool = selected.len == 1 and states.len > 0 and states[^1].text == "Length λ")
      check combo.entryText == "Length λ" and combo.activeIndex == -1
      host.destroy()
      check entry.isDestroyed and not completion.attached
else:
  suite "mapped completion":
    test "XTEST popup validation is only available on Unix X11": discard
