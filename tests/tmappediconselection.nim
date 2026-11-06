# Real IconView keyboard selection: isolated virtual display only.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped icon selection tests require an isolated virtual display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc awaitUi(fn: proc (): bool): bool =
  let deadline = epochTime() + 6
  while epochTime() < deadline:
    for i in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    if fn(): return true
    sleep(10)

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
  proc key(display: ptr XDisplay, value: culong, modifier: culong = 0) =
    let code = XKeysymToKeycode(display, value)
    doAssert code != 0
    if modifier != 0: discard XTestFakeKeyEvent(display, cuint(XKeysymToKeycode(display, modifier)), 1, 0)
    discard XTestFakeKeyEvent(display, cuint(code), 1, 0)
    discard XTestFakeKeyEvent(display, cuint(code), 0, 0)
    if modifier != 0: discard XTestFakeKeyEvent(display, cuint(XKeysymToKeycode(display, modifier)), 0, 0)
    discard XSync(display, 0)
  suite "native IconView multiple selection":
    test "Shift range, Ctrl+A, mode transitions and deferred activation teardown":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      var event, error, major, minor: cint
      require XTestQueryExtension(display, addr event, addr error, addr major, addr minor) != 0
      let host = newWindow("Icon selection", 560, 220)
      defer: host.destroy()
      let source = newListStore([cellString, cellPixbuf])
      for text in ["One", "Two λ🙂", "Three", "Four"]:
        discard source.appendRow([cell(text), cell(newPixbuf(32, 32, 0x30a050ff'u32))])
      let view = newIconView(source, 1, 0)
      view.columns = 4
      view.itemWidth = 90
      view.selectionMode = selectionMultiple
      let scroll = newScrolledWindow()
      scroll.add(view)
      host.add(scroll)
      var observations: seq[IconSelection]
      view.onSelectionChanged(proc (value: IconSelection) = observations.add(value))
      var activated = false
      view.onActivated(proc (value: IconActivation) =
        activated = value.row.valid
        host.destroy())
      host.showAll()
      host.present()
      view.focus()
      require awaitUi(proc (): bool = g.toBool(n.is_active(host.raw)) and g.toBool(n.get_mapped(cast[n.PWidget](view.raw))))
      view.cursorPath = treePath(0)
      key(display, 0xff50) # Home: an ordinary navigation establishes a fresh native anchor.
      require awaitUi(proc (): bool = view.selectedIndices == @[0])
      key(display, 0xff53, 0xffe1) # Shift+Right.
      require awaitUi(proc (): bool = view.selectedIndices == @[0, 1])
      key(display, 0x61, 0xffe3) # Ctrl+A.
      require awaitUi(proc (): bool = view.selectedIndices == @[0, 1, 2, 3])
      view.selectionMode = selectionBrowse
      view.selectPath(treePath(2))
      view.selectionMode = selectionMultiple
      check view.selectedIndices.len == 0
      key(display, 0xff50)
      require awaitUi(proc (): bool = view.selectedIndices == @[0])
      key(display, 0xff57, 0xffe1) # Shift+End extends across all items.
      require awaitUi(proc (): bool = view.selectedIndices == @[0, 1, 2, 3])
      require awaitUi(proc (): bool = observations.len > 0 and observations[^1].paths.len == 4)
      check observations[^1].model.value(observations[^1].rows[1].path, 0).stringValue == "Two λ🙂"
      key(display, 0xff0d) # Return invokes real native item activation.
      require awaitUi(proc (): bool = activated)
      check host.isDestroyed and view.isDestroyed
else:
  suite "mapped icon selection":
    test "XTEST keyboard validation requires Unix X11": discard
