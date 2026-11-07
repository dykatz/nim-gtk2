# Explicit isolated display: realized GtkEntry selections can own PRIMARY.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Entry selection tests require an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
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
proc primaryText(): ClipboardText =
  var done = false
  var value: ClipboardText
  let request = getClipboard(clipboardPrimary).requestText(proc (reply: ClipboardText) =
    value = reply
    done = true)
  doAssert awaitUi(proc (): bool = done)
  doAssert not request.pending
  value
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
  suite "realized Entry selections and native input":
    test "PRIMARY is native, clear preserves other owners, readonly/password/combo policy":
      let primary = getClipboard(clipboardPrimary)
      primary.setText("isolated sentinel")
      defer: primary.clear()
      let host = newWindow("Selection ownership", 440, 160)
      defer: host.destroy()
      let box = newVBox()
      host.add(box)
      let entry = newEntry("λ🙂secret")
      box.packStart(entry)
      let combo = newComboBoxText(["λ🙂combo"], editable = true)
      box.packStart(combo)
      combo.activeIndex = 0
      entry.clearSelection()
      check primaryText().text == "isolated sentinel"
      entry.selectRange(0, 2)
      check primaryText().text == "isolated sentinel" # Still unrealized, no claim.
      host.showAll()
      host.present()
      require awaitUi(proc (): bool = g.toBool(n.get_realized(cast[n.PWidget](entry.raw))))
      entry.editable = false
      entry.selectRange(2, 0)
      check n.get_owner(primary.raw) == cast[g.PGObject](entry.raw)
      check primaryText().text == "λ🙂" and entry.selectedText == "λ🙂"
      entry.cursorOffset = 1
      check not entry.hasSelection and n.get_owner(primary.raw) == nil
      primary.setText("other owner again")
      entry.clearSelection()
      check primaryText().text == "other owner again"
      entry.textVisible = false
      entry.selectAll()
      expect ValueError: discard entry.selectedText
      let masked = primaryText()
      check masked.available and masked.text != entry.text and masked.text != "λ🙂secret"
      entry.clearSelection()
      combo.entry.selectRange(2, 0)
      check primaryText().text == "λ🙂" and combo.entry.selectionBounds.cursor == 0
      check n.get_owner(primary.raw) == cast[g.PGObject](combo.entry.raw)
      combo.destroy()
      check n.get_owner(primary.raw) == nil
    test "Shift-Left makes reverse selection and focus preserves its active endpoint":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Reverse selection", 420, 150)
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
      press(display, 0xffe1, true)
      key(display, 0xff51)
      key(display, 0xff51)
      press(display, 0xffe1, false)
      require awaitUi(proc (): bool = entry.selectionBounds.cursor == 2)
      let before = entry.selectionBounds
      check before.anchor == 4 and before.first == 2 and before.last == 4
      check entry.selectedText == "AB"
      button.focus()
      entry.focus()
      check entry.selectionBounds == before
      entry.clearSelection()
    test "cursor helper does not accept/reset native inline preview history":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Preview cursor", 420, 100)
      defer: host.destroy()
      let entry = newEntry()
      host.add(entry)
      let c = newEntryCompletion(["alpha", "alpine"])
      defer: c.close()
      c.inlineSelection = true
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
      require awaitUi(proc (): bool = entry.text == "alpha")
      check entry.selectedText == "lpha"
      entry.cursorOffset = 2
      check not entry.hasSelection and c.completionPrefix.text == "a"
      key(display, 0xff1b)
      require awaitUi(proc (): bool = entry.text == "a")
      check entry.cursorOffset == 1 and selected == 0 and not c.completionPrefix.available
else:
  suite "mapped Entry selection":
    test "PRIMARY/XTEST coverage requires Unix X11": discard
