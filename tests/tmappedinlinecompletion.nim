# Real native inline/popup key handling. Never run against a desktop.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Inline completion tests require an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
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
  suite "native inline completion and selection":
    test "typed common prefix, suffix replacement, readonly and safe activate destruction":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Inline prefix", 400, 100)
      defer: host.destroy()
      let entry = newEntry()
      host.add(entry)
      var activated = 0
      # Registered before attaching completion: must still defer dynamically.
      entry.onActivate(proc () =
        inc activated
        host.destroy())
      let completion = newEntryCompletion(["alphabet", "alphanumeric"])
      defer: completion.close()
      completion.popupCompletion = false
      completion.inlineCompletion = true
      entry.completion = completion
      var values: seq[CompletionInlineState]
      completion.onInlineChanged(proc (value: CompletionInlineState) = values.add(value))
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      entry.editable = false
      key(display, culong(ord('a')))
      discard awaitUi(proc (): bool = true)
      check entry.text == ""
      entry.editable = true
      key(display, culong(ord('a')))
      require awaitUi(proc (): bool = entry.text == "alpha" and values.len > 0)
      check values[^1].kind == inlinePrefix and values[^1].first == 1 and values[^1].last == 5
      key(display, culong(ord('b')))
      require awaitUi(proc (): bool = entry.text == "ab") # Selected suffix replaced, not appended.
      entry.text = ""
      key(display, culong(ord('a')))
      require awaitUi(proc (): bool = entry.text == "alpha")
      key(display, 0xff0d) # Native accept_completion runs before application close.
      require awaitUi(proc (): bool = activated == 1)
      check host.isDestroyed and entry.isDestroyed
    test "native popup preview, copied prefix, Escape restore and final Return selection":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Inline selection", 400, 100)
      defer: host.destroy()
      let entry = newEntry()
      host.add(entry)
      let completion = newEntryCompletion(["alpha", "alpine"])
      defer: completion.close()
      completion.inlineSelection = true
      entry.completion = completion
      var values: seq[CompletionInlineState]
      var selected: seq[CompletionSelection]
      completion.onInlineChanged(proc (value: CompletionInlineState) = values.add(value))
      completion.onSelected(proc (value: CompletionSelection) =
        selected.add(value)
        host.destroy())
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      let before = mappedWindows()
      key(display, culong(ord('a')))
      require awaitUi(proc (): bool = mappedWindows() > before)
      key(display, 0xff54)
      require awaitUi(proc (): bool = entry.text == "alpha" and values.len > 0)
      check values[^1].kind == inlinePreview and values[^1].index == 0
      check values[^1].key == "a" and values[^1].first == 1 and values[^1].last == 5
      let prefix = completion.completionPrefix
      check prefix.available and prefix.text == "a" and selected.len == 0
      key(display, 0xff54)
      require awaitUi(proc (): bool = entry.text == "alpine")
      key(display, 0xff1b)
      require awaitUi(proc (): bool = entry.text == "a" and mappedWindows() == before)
      check not completion.completionPrefix.available and prefix.text == "a"
      for acceptKey in [culong(0xff53), culong(0xff09)]: # Right, Tab keep the native preview.
        entry.text = ""
        entry.focus()
        key(display, culong(ord('a')))
        require awaitUi(proc (): bool = mappedWindows() > before)
        key(display, 0xff54)
        require awaitUi(proc (): bool = entry.text == "alpha")
        key(display, acceptKey)
        require awaitUi(proc (): bool = mappedWindows() == before)
        check entry.text == "alpha" and selected.len == 0
        check not completion.completionPrefix.available
      entry.text = ""
      entry.focus()
      key(display, culong(ord('a')))
      require awaitUi(proc (): bool = mappedWindows() > before)
      key(display, 0xff54)
      key(display, 0xff0d)
      require awaitUi(proc (): bool = selected.len == 1)
      check selected[0].text == "alpha" and host.isDestroyed
    test "Unicode preview reports native character offsets without private-field repairs":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Unicode preview", 400, 100)
      defer: host.destroy()
      let entry = newEntry()
      host.add(entry)
      let completion = newEntryCompletion(["λtest", "λtoast"])
      defer: completion.close()
      completion.inlineSelection = true
      entry.completion = completion
      var values: seq[CompletionInlineState]
      completion.onInlineChanged(proc (value: CompletionInlineState) = values.add(value))
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      let before = mappedWindows()
      entry.insertText("λ")
      require awaitUi(proc (): bool = mappedWindows() > before)
      key(display, 0xff54)
      require awaitUi(proc (): bool = values.len > 0)
      check values[^1].key == "λ" and values[^1].text == "λtest"
      check values[^1].first in [1, 2] and values[^1].last == 5
      if values[^1].first == 2:
        echo "Native GTK2 preview uses byte-length start; optional gtk2-completion-unicode-preview.patch applies"
      key(display, 0xff1b)
      require awaitUi(proc (): bool = entry.text == "λ")
    test "combo changed callback safely destroys a native inline preview emitter":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Combo inline preview", 400, 100)
      defer: host.destroy()
      let combo = newComboBoxText(editable = true)
      let entry = combo.entry
      host.add(combo)
      combo.onChanged(proc () =
        if combo.entryText == "alpha": host.destroy())
      let completion = newEntryCompletion(["alpha", "alpine"])
      defer: completion.close()
      completion.inlineSelection = true
      entry.completion = completion
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      let before = mappedWindows()
      key(display, culong(ord('a')))
      require awaitUi(proc (): bool = mappedWindows() > before)
      key(display, 0xff54)
      require awaitUi(proc (): bool = host.isDestroyed)
      check entry.isDestroyed and not completion.attached
else:
  suite "mapped inline completion":
    test "XTEST keyboard coverage requires Unix X11": discard
