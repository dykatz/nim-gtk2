# Real icon press/release input on an explicitly isolated display only.
import std/[os, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Entry icon tests require an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc awaitUi(fn: proc (): bool): bool =
  let deadline = epochTime() + 6
  while epochTime() < deadline:
    for i in 0..<512:
      if n.events_pending() == 0: break
      discard n.main_iteration_do(g.gbool(false))
    if fn(): return true
    sleep(10)
proc settle() =
  let endTime = epochTime() + 0.25
  doAssert awaitUi(proc (): bool = epochTime() >= endTime)
gtk2.init()
when defined(posix) and not defined(macosx):
  type XDisplay {.pure, final, incompleteStruct.} = object
  const xlib = "libX11.so(.6|)"
  const xtest = "libXtst.so(.6|)"
  proc XOpenDisplay(name: cstring): ptr XDisplay {.cdecl, dynlib: xlib, importc.}
  proc XCloseDisplay(display: ptr XDisplay): cint {.cdecl, dynlib: xlib, importc.}
  proc XSync(display: ptr XDisplay, discardEvents: cint): cint {.cdecl, dynlib: xlib, importc.}
  proc XTestFakeMotionEvent(display: ptr XDisplay, screen, x, y: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc XTestFakeButtonEvent(display: ptr XDisplay, button: cuint, press: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc point(display: ptr XDisplay, entry: Entry, position: n.TEntryIconPosition) =
    let window = n.entry_get_icon_window(entry.raw, position) # Public GTK2.20 API.
    doAssert window != nil
    var x, y, width, height: g.gint
    discard gd.get_origin(window, addr x, addr y)
    gd.get_size(cast[gd.PDrawable](window), addr width, addr height)
    doAssert width > 0 and height > 0
    discard XTestFakeMotionEvent(display, 0, x + width div 2, y + height div 2, 0)
    discard XSync(display, 0)
  proc click(display: ptr XDisplay) =
    discard XTestFakeButtonEvent(display, 1, 1, 0)
    discard XTestFakeButtonEvent(display, 1, 0, 0)
    discard XSync(display, 0)
  suite "native Entry icons":
    test "real primary/secondary events and inert policy; no implicit text edit":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Icon policy", 450, 100)
      defer: host.destroy()
      let entry = newEntry("unchanged λ🙂")
      host.add(entry)
      for pos in [iconPrimary, iconSecondary]: entry.setIcon(pos, newPixbuf(16, 16, 0x2288ffff'u32))
      entry.setIconTooltip(iconSecondary, "<b>literal &")
      var values: seq[EntryIconEvent]
      var hideNext = false
      let token = entry.onIconEvent(proc (value: EntryIconEvent) =
        values.add(value)
        if hideNext and value.event.kind == buttonPress: host.hide())
      host.showAll()
      host.present()
      require awaitUi(proc (): bool = g.toBool(n.get_mapped(cast[n.PWidget](entry.raw))))
      point(display, entry, n.ENTRY_ICON_PRIMARY)
      click(display)
      require awaitUi(proc (): bool = values.len >= 2)
      check values.len == 2 and values[0].position == iconPrimary
      check values[0].event.kind == buttonPress and values[1].event.kind == buttonRelease
      check values[0].event.button == 1 and values[0].event.x >= 0
      check entry.text == "unchanged λ🙂"
      entry.setIconActivatable(iconSecondary, false)
      point(display, entry, n.ENTRY_ICON_SECONDARY)
      click(display)
      settle()
      check values.len == 2
      entry.setIconActivatable(iconSecondary, true)
      entry.setIconSensitive(iconSecondary, false)
      click(display)
      settle()
      check values.len == 2
      entry.setIconSensitive(iconSecondary, true)
      click(display)
      require awaitUi(proc (): bool = values.len >= 4)
      check values.len == 4 and values[2].position == iconSecondary and entry.text == "unchanged λ🙂"
      hideNext = true
      point(display, entry, n.ENTRY_ICON_PRIMARY)
      click(display)
      require awaitUi(proc (): bool = not g.toBool(n.get_mapped(cast[n.PWidget](host.raw))))
      settle()
      check values.len == 5
      check values[^1].event.kind == buttonPress
      check token.connected
    test "press observation can replace icon; next release observation can destroy combo owner":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      let host = newWindow("Icon callback teardown", 440, 100)
      defer: host.destroy()
      let combo = newComboBoxText(["secret λ🙂"], editable = true)
      combo.activeIndex = 0
      let entry = combo.entry
      entry.editable = false
      entry.textVisible = false
      entry.setIcon(iconSecondary, newPixbuf(16, 16, 0xff8822ff'u32))
      host.add(combo)
      var presses, releases = 0
      let token = entry.onIconEvent(proc (value: EntryIconEvent) =
        if value.event.kind == buttonPress:
          inc presses
          entry.setIcon(iconSecondary, newPixbuf(16, 16, 0x22ff88ff'u32))
        elif value.event.kind == buttonRelease:
          inc releases
          host.destroy())
      host.showAll()
      host.present()
      require awaitUi(proc (): bool = g.toBool(n.get_mapped(cast[n.PWidget](entry.raw))))
      point(display, entry, n.ENTRY_ICON_SECONDARY)
      discard XTestFakeButtonEvent(display, 1, 1, 0)
      discard XSync(display, 0)
      require awaitUi(proc (): bool = presses == 1)
      # Native press handling finished before replacement, not a simulated click.
      discard XTestFakeButtonEvent(display, 1, 0, 0)
      discard XSync(display, 0)
      require awaitUi(proc (): bool = releases == 1)
      check host.isDestroyed and entry.isDestroyed and not token.connected
else:
  suite "mapped Entry icons":
    test "XTEST pointer coverage requires Unix X11": discard
