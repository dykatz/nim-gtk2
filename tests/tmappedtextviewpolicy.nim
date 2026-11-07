# Explicit isolated-display opt-in: actual XTEST editing/focus, no SDK fake typing.
import std/[os, times, unittest]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("TextView policy tests require an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
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
ui.init()
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
  suite "native TextView policies":
    test "overwrite/Insert/selection/readonly remain GTK editing, not private flag writes":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("TextView overwrite", 440, 150)
      defer: host.destroy()
      let buffer = newTextBuffer("λ🙂AB")
      let view = newTextView(buffer)
      host.add(view)
      host.showAll()
      host.present()
      view.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](view.raw))))
      buffer.cursorOffset = 2
      key(display, culong(ord('x')))
      require awaitUi(proc (): bool = buffer.text == "λ🙂xAB")
      view.overwriteMode = true
      buffer.cursorOffset = 1
      key(display, culong(ord('y')))
      require awaitUi(proc (): bool = buffer.text == "λyxAB")
      buffer.cursorOffset = 2
      key(display, 0xff63)
      require awaitUi(proc (): bool = not view.overwriteMode)
      key(display, culong(ord('z')))
      require awaitUi(proc (): bool = buffer.text == "λyzxAB")
      view.overwriteMode = true
      buffer.selectRange(1, 3)
      key(display, culong(ord('q')))
      require awaitUi(proc (): bool = buffer.text == "λqxAB")
      view.editable = false
      key(display, culong(ord('x')))
      settle()
      check buffer.text == "λqxAB"
      buffer.insertText(0, "P") # Readonly is not a ban on explicit buffer edits.
      check buffer.text == "PλqxAB" and not view.editable
    test "hidden caret still permits editing, Tab inserts or moves native focus":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("TextView Tab policy", 440, 180)
      defer: host.destroy()
      let box = newVBox()
      let view = newTextView("AB")
      let next = newButton("Next focus")
      box.packStart(view)
      box.packStart(next, packShrink)
      host.add(box)
      view.cursorVisible = false
      host.showAll()
      host.present()
      view.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](view.raw))))
      view.buffer.cursorOffset = 1
      view.acceptsTab = true
      key(display, 0xff09)
      require awaitUi(proc (): bool = view.buffer.text == "A\tB")
      view.acceptsTab = false
      key(display, 0xff09)
      require awaitUi(proc (): bool = g.toBool(n.is_focus(cast[n.PWidget](next.raw))))
      check view.buffer.text == "A\tB" and not view.cursorVisible
else:
  suite "mapped TextView policy":
    test "native XTEST keyboard coverage requires Unix X11": discard
