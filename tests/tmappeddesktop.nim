# Native StatusIcon constructors and foreign embedding may map windows.
# Run ONLY on an isolated virtual display with explicit opt-in, never a desktop.
import std/[os, osproc, strutils, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g

if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped desktop tests require an isolated virtual display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "desktop event sources did not settle")
proc awaitUi(predicate: proc (): bool): bool =
  let deadline = epochTime() + 8
  while epochTime() < deadline:
    drain()
    if predicate(): return true
    sleep(10)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CaptureObj = object
  freed, calls: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.freed[]
type Capture = ref CaptureObj
proc watch(s: gtk2.StatusIcon, freed, calls: ptr int): Connection =
  let capture = Capture(freed: freed, calls: calls)
  s.onActivate(proc () = inc capture.calls[])
proc temporaryIcon(freed, calls: ptr int): n.PStatusIcon =
  let s = newStatusIcon()
  discard g.g_object_ref(s.raw)
  discard watch(s, freed, calls)
  g.g_signal_emit_by_name(s.raw, "activate")
  s.raw

when defined(posix) and not defined(macosx):
  if paramCount() == 2 and paramStr(1) == "--embed-peer":
    gtk2.init()
    let plug = newPlug(embedId(parseBiggestUInt(paramStr(2))))
    defer: plug.destroy()
    plug.add(newLabel("Foreign XEmbed peer"))
    plug.run()
    quit(0)

gtk2.init()
suite "desktop object lifetime on an isolated virtual display":
  test "tray settings, native scalar return, transfer-full tooltip and owning pixbuf aliases":
    let s = newStatusIcon()
    defer: s.close()
    check not s.visible
    check s.storageKind == imageEmpty
    s.title = "Desktop café"
    s.tooltipText = "Plain <b>tooltip</b> café"
    s.hasTooltip = true
    s.setName("nim-gtk2-test")
    check s.title == "Desktop café" and s.tooltipText == "Plain <b>tooltip</b> café"
    check s.hasTooltip
    check s.screen.raw == defaultScreen().raw
    s.screen = defaultScreen()
    let image = newPixbuf(8, 6, 0x00ffffff'u32)
    s.pixbuf = image
    let alias = s.pixbuf
    check alias.raw == image.raw and alias.width == 8
    s.setFromIcon("dialog-information")
    check s.storageKind == imageIconName and s.iconName == "dialog-information"
    expect ValueError: discard s.pixbuf
    s.setFromStock("gtk-dialog-info")
    check s.storageKind == imageStock and s.stockId == "gtk-dialog-info"
    s.pixbuf = Pixbuf()
    check s.pixbuf.isEmpty
    expect ValueError: s.title = "bad\0title"
    expect ValueError: s.tooltipText = "\xff"
    expect ValueError: s.setFromIcon("")
    expect ValueError: discard newStatusIconFromIcon("\xff")
    s.visible = true
    drain()
    discard s.geometry # Safe with no tray manager; availability is not guaranteed.
    s.visible = false
    # Exercise corrected raw string constructor signatures without SDK wrappers.
    let raw = n.status_icon_new_from_icon_name("dialog-information")
    n.status_icon_set_visible(raw, g.gbool(false))
    check n.status_icon_get_storage_type(raw) == n.IMAGE_ICON_NAME
    g.g_object_unref(raw)
    s.close()
    check s.isDestroyed and alias.width == 8
    expect ValueError: discard s.title

  test "queued activation/popup/size, unsigned time, and native scaling remains enabled":
    let s = newStatusIcon()
    defer: s.close()
    var activated = 0
    var popups: seq[StatusPopup]
    var sizes: seq[int]
    s.onActivate(proc () = inc activated)
    s.onPopupMenu(proc (value: StatusPopup) = popups.add(value))
    s.onSizeChanged(proc (size: int) = sizes.add(size))
    g.g_signal_emit_by_name(s.raw, "activate")
    g.g_signal_emit_by_name(s.raw, "popup-menu", g.guint(3), g.guint32(0xfedcba98'u32))
    var handled = g.gbool(true)
    g.g_signal_emit_by_name(s.raw, "size-changed", g.gint(24), addr handled)
    check not g.toBool(handled)
    check activated == 0 and popups.len == 0 and sizes.len == 0
    drain()
    check activated == 1 and popups.len == 1
    check popups[0].button == 3 and popups[0].time == 0xfedcba98'u32
    check 24 in sizes
    var changed = 0
    s.onEmbeddedChanged(proc (value: bool) = inc changed)
    g.notify(cast[g.PGObject](s.raw), "embedded")
    drain()
    check changed == 0 # Same final state is suppressed; no initial event.

  test "close and plain-GObject final release cancel callbacks and invalidate aliases":
    var freed, calls, gone = 0
    block:
      let s = newStatusIcon()
      let alias = s
      g.weak_ref(cast[g.PGObject](s.raw), finalized, addr gone)
      let cancel = watch(s, addr freed, addr calls)
      g.g_signal_emit_by_name(s.raw, "activate")
      cancel.disconnect()
      drain()
      check freed == 1 and calls == 0
      let pending = watch(s, addr freed, addr calls)
      g.g_signal_emit_by_name(s.raw, "activate")
      s.close()
      drain()
      check freed == 2 and calls == 0 and not pending.connected and alias.isDestroyed
      s.close()
    check gone == 1
    let pointer = temporaryIcon(addr freed, addr calls)
    drain() # Nim state release disconnected it, despite an external native ref.
    check freed == 3 and calls == 0
    n.status_icon_set_visible(pointer, g.gbool(false))
    g.g_object_unref(pointer)
    let s = newStatusIcon()
    defer: s.close()
    var connection: Connection
    connection = s.onActivate(proc () =
      connection.disconnect()
      s.close()
      raise newException(ValueError, "expected status icon callback error"))
    g.g_signal_emit_by_name(s.raw, "activate")
    drain()
    check s.isDestroyed and not connection.connected
    expect ValueError: discard s.onActivate(nil)

when defined(posix) and not defined(macosx):
  suite "actual foreign XEmbed protocol on an isolated virtual display":
    test "a separate process embeds, exits, and leaves a reusable socket":
      let host = newWindow("XEmbed host", 300, 120)
      defer: host.destroy()
      let socket = newSocket()
      host.add(socket)
      var added, removed = 0
      socket.onPlugAdded(proc () = inc added)
      socket.onPlugRemoved(proc () = inc removed)
      host.showAll()
      let peer = startProcess(getAppFilename(), args = ["--embed-peer", $socket.id], options = {poUsePath})
      defer:
        if peer.running: peer.terminate()
        discard peer.waitForExit()
        peer.close()
      require awaitUi(proc (): bool = socket.hasPlug and added == 1)
      peer.terminate()
      discard peer.waitForExit()
      require awaitUi(proc (): bool = not socket.hasPlug and removed == 1)
      check not socket.isDestroyed
      let next = newPlug(socket)
      defer: next.destroy()
      next.add(newLabel("Same-process replacement"))
      next.showAll()
      require awaitUi(proc (): bool = socket.hasPlug and added == 2)
      next.destroy()
      require awaitUi(proc (): bool = not socket.hasPlug and removed == 2)
