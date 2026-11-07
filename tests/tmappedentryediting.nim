# Native keyboard editing and displayed PRIMARY text. Isolated opt-in only.
import std/[os, times, strutils, unittest]
import std/unicode as uni
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Entry editing tests require an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc awaitUi(fn: proc (): bool): bool =
  let deadline = epochTime() + 6
  while epochTime() < deadline:
    for i in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    if fn(): return true
    sleep(10)
proc settle() =
  let until = epochTime() + 0.25
  doAssert awaitUi(proc (): bool = epochTime() >= until)
proc primaryText(): ClipboardText =
  var done = false
  var copied: ClipboardText
  let request = getClipboard(clipboardPrimary).requestText(proc (value: ClipboardText) =
    copied = value
    done = true)
  doAssert awaitUi(proc (): bool = done)
  doAssert not request.pending
  copied
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
  suite "native Entry editing/display modes":
    test "typing overwrite, Insert toggle and selection replacement remain GTK behavior":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Native overwrite", 440, 100)
      defer: host.destroy()
      let entry = newEntry("λ🙂AB")
      host.add(entry)
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](entry.raw))))
      entry.cursorOffset = 2
      key(display, culong(ord('x')))
      require awaitUi(proc (): bool = entry.text == "λ🙂xAB")
      entry.overwriteMode = true
      entry.cursorOffset = 1
      key(display, culong(ord('y')))
      require awaitUi(proc (): bool = entry.text == "λyxAB")
      entry.cursorOffset = 2
      key(display, 0xff63) # Native Insert binding toggles overwrite; no SDK simulation.
      require awaitUi(proc (): bool = not entry.overwriteMode)
      key(display, culong(ord('z')))
      require awaitUi(proc (): bool = entry.text == "λyzxAB")
      entry.overwriteMode = true
      entry.selectRange(1, 3)
      key(display, culong(ord('q')))
      require awaitUi(proc (): bool = entry.text == "λqxAB")
      entry.editable = false
      entry.hasFrame = false
      key(display, culong(ord('x')))
      settle()
      check entry.text == "λqxAB" and entry.overwriteMode and not entry.hasFrame
    test "programmatically selected password PRIMARY follows native glyph/default/blank policies":
      let host = newWindow("Native mask policy", 440, 130)
      defer: host.destroy()
      let combo = newComboBoxText(["λ🙂secret"], editable = true)
      combo.activeIndex = 0
      host.add(combo)
      let entry = combo.entry
      entry.textVisible = false
      entry.invisibleChar = 0x2022
      entry.hasFrame = false
      host.showAll()
      host.present()
      entry.focus()
      require awaitUi(proc (): bool = g.toBool(n.get_mapped(cast[n.PWidget](entry.raw))))
      entry.selectRange(0, 2)
      check primaryText().text == "••"
      check not entry.copySelection() # SDK password extraction protection unchanged.
      expect ValueError: discard entry.selectedText
      entry.invisibleChar = 0x2a
      check primaryText().text == "**"
      entry.invisibleChar = 0
      check entry.invisibleCharSet and entry.invisibleChar == 0
      check primaryText().text == "  " # Blank rendering is not an empty PRIMARY reply.
      entry.unsetInvisibleChar()
      check not entry.invisibleCharSet
      let glyph = if entry.invisibleChar == 0: "*" else: uni.toUTF8(uni.Rune(entry.invisibleChar))
      check primaryText().text == glyph.repeat(2)
      check entry.text == "λ🙂secret" and not entry.textVisible
      entry.clearSelection()
      check n.get_owner(getClipboard(clipboardPrimary).raw) == nil
else:
  suite "mapped Entry editing":
    test "XTEST/PRIMARY coverage requires Unix X11": discard
