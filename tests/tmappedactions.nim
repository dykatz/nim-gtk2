# Real accelerator dispatch needs isolated focus/keyboard input, never a desktop.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped action tests require an isolated virtual display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc settle() =
  for i in 0..<25:
    for step in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    sleep(10)
proc awaitUi(fn: proc (): bool): bool =
  let until = epochTime() + 6
  while epochTime() < until:
    settle()
    if fn(): return true

gtk2.init()
suite "mapped shared command proxies":
  test "native menu/toolbar state and shortcut labels; teardown cancels queued command work":
    let window = newWindow("Actions", 500, 160)
    defer: window.destroy()
    let root = newVBox()
    window.add(root)
    let menu = newMenu()
    let heading = newMenuItem("Commands")
    let bar = newMenuBar()
    bar.append(heading)
    heading.submenu = menu
    root.packStart(bar, packShrink)
    let toolbar = newToolbar()
    root.packStart(toolbar, packShrink)
    let group = newActionGroup("mapped")
    let shortcuts = newAccelGroup()
    defer:
      group.disconnectSignals()
      shortcuts.clearShortcuts()
    shortcuts.attach(window)
    let a = newToggleAction("pin", "_Pin")
    a.important = true
    group.add(a)
    let item = a.createMenuItem() # Exercise registration after proxy construction.
    let tool = a.createToolItem()
    menu.append(item)
    toolbar.append(tool)
    shortcuts.bindShortcut(a, "<Control>p")
    var values: seq[bool]
    a.onToggled(proc (active: bool) = values.add(active))
    window.showAll()
    settle()
    let label = cast[n.PAccelLabel](n.get_child(cast[n.PBin](item.raw)))
    require n.IS_ACCEL_LABEL(label)
    discard n.refetch(label)
    var requested: n.TRequisition
    n.size_request(cast[n.PWidget](label), addr requested)
    check n.get_accel_width(label) > 0
    item.activate()
    check a.active and tool.active
    require awaitUi(proc (): bool = values.len == 1)
    check values == @[true]
    group.sensitive = false
    check not item.sensitive
    check not window.activateShortcut(parseShortcut("<Control>p"))
    group.sensitive = true
    a.visible = false
    check not g.toBool(n.get_visible(cast[n.PWidget](tool.raw)))
    check not g.toBool(n.get_visible(cast[n.PWidget](item.raw)))
    window.showAll()
    check not g.toBool(n.get_visible(cast[n.PWidget](tool.raw)))
    check not g.toBool(n.get_visible(cast[n.PWidget](item.raw)))
    a.visible = true
    shortcuts.unbindShortcut(a)
    discard n.refetch(label)
    n.size_request(cast[n.PWidget](label), addr requested)
    check n.get_accel_width(label) == 0
    shortcuts.bindShortcut(a, "<Control>p")
    var late = 0
    a.onActivate(proc () = inc late)
    a.activate()
    group.disconnectSignals()
    window.destroy()
    settle()
    check late == 0

when defined(posix) and not defined(macosx):
  type XDisplay {.pure, final, incompleteStruct.} = object
  const xlib = "libX11.so(.6|)"
  const xtest = "libXtst.so(.6|)"
  proc XOpenDisplay(name: cstring): ptr XDisplay {.cdecl, dynlib: xlib, importc.}
  proc XCloseDisplay(display: ptr XDisplay): cint {.cdecl, dynlib: xlib, importc.}
  proc XSync(display: ptr XDisplay, discardEvents: cint): cint {.cdecl, dynlib: xlib, importc.}
  proc XKeysymToKeycode(display: ptr XDisplay, key: culong): uint8 {.cdecl, dynlib: xlib, importc.}
  proc XTestFakeKeyEvent(display: ptr XDisplay, key: cuint, press: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  suite "XTEST keyboard shortcuts":
    test "real Ctrl+O dispatches a shared command with an Entry focused, callback may destroy its window":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let window = newWindow("Keyboard command", 320, 100)
      defer: window.destroy()
      let entry = newEntry("unchanged")
      window.add(entry)
      let a = newAction("open", "Open")
      let shortcuts = newAccelGroup()
      defer:
        a.disconnectSignals()
        shortcuts.clearShortcuts()
      shortcuts.bindShortcut(a, "<Control>o")
      shortcuts.attach(window)
      var calls = 0
      a.onActivate(proc () =
        inc calls
        window.destroy())
      window.showAll()
      window.present()
      entry.focus()
      settle()
      require g.toBool(n.is_focus(cast[n.PWidget](entry.raw)))
      let control = XKeysymToKeycode(display, 0xffe3)
      let letter = XKeysymToKeycode(display, culong('o'.ord))
      require control != 0 and letter != 0
      discard XTestFakeKeyEvent(display, cuint(control), 1, 0)
      discard XTestFakeKeyEvent(display, cuint(letter), 1, 0)
      discard XTestFakeKeyEvent(display, cuint(letter), 0, 0)
      discard XTestFakeKeyEvent(display, cuint(control), 0, 0)
      discard XSync(display, 0)
      require awaitUi(proc (): bool = calls == 1)
      check window.isDestroyed and entry.isDestroyed
