# No mapped windows. StatusIcon constructors deliberately NOT run here: native
# GTK may map a private tray window even when visible=false is requested.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g

static:
  doAssert typeof(newInvisible().raw) is n.PInvisible
  doAssert typeof(newStatusIcon().raw) is n.PStatusIcon
  when defined(windows) or defined(macosx):
    doAssert not declared(gtk2.Plug)
    doAssert not declared(gtk2.Socket)
    doAssert not declared(gtk2.EmbedId)
proc drain() =
  for i in 0..<256:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "desktop sources did not settle")
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]

gtk2.init()
suite "desktop infrastructure (never mapped)":
  test "abstract Misc alignment/padding on labels, images and arrows":
    let label = newLabel("Aligned")
    let image = newImage()
    let arrow = newArrow()
    defer:
      label.destroy()
      image.destroy()
      arrow.destroy()
    for widget in [gtk2.Misc(label), gtk2.Misc(image), gtk2.Misc(arrow)]:
      widget.setAlignment(0.25, 0.75)
      widget.setPadding(65535, 9)
      check widget.alignment == (0.25, 0.75) and widget.padding == (65535, 9)
      expect ValueError: widget.setPadding(1, 65536)
      expect ValueError: widget.setAlignment(0.5, NaN)
      check widget.alignment == (0.25, 0.75) and widget.padding == (65535, 9)
  test "Invisible realizes without mapping, retains screens and rejects parenting":
    let screen = defaultScreen()
    let w = newInvisible(screen)
    defer: w.destroy()
    check w.screen.raw == screen.raw
    w.screen = screen
    check g.toBool(n.get_realized(gtk2.Widget(w).raw))
    check not g.toBool(n.WIDGET_MAPPED(w.raw))
    let box = newVBox()
    defer: box.destroy()
    expect ValueError: box.packStart(w)
    expect ValueError: w.screen = gtk2.Screen()
    expect ValueError: discard newInvisible(gtk2.Screen())
    w.destroy()
    expect ValueError: discard w.screen
    check not screen.isDestroyed
    var gone = 0
    block:
      let temporary = newInvisible()
      g.weak_ref(cast[g.PGObject](temporary.raw), finalized, addr gone)
      temporary.destroy()
    check gone == 1

when defined(posix) and not defined(macosx):
  static:
    doAssert sizeof(EmbedId) == 4
    doAssert typeof(newPlug().raw) is n.PPlug
    doAssert typeof(newSocket().raw) is n.PSocket
  suite "X11 plug and socket infrastructure (never mapped)":
    test "embedding IDs are exact unsigned 32-bit values, zero is a sentinel":
      check embedId(0).isEmpty
      check $embedId(high(uint32)) == "4294967295"
      expect ValueError: discard embedId(-1)
      expect ValueError: discard embedId(high(uint32).uint64 + 1)
    test "sockets must be anchored in an onscreen hierarchy and reject own/empty IDs":
      let socket = newSocket()
      defer: socket.destroy()
      check not socket.hasPlug
      expect ValueError: discard socket.id
      expect ValueError: discard newPlug(socket)
      let host = newWindow()
      defer: host.destroy()
      host.add(socket)
      check not socket.id.isEmpty
      check not g.toBool(n.WIDGET_MAPPED(host.raw))
      check not g.toBool(n.WIDGET_MAPPED(socket.raw))
      expect ValueError: socket.addId(embedId(0))
      expect ValueError: socket.addId(socket.id)
      let offscreen = newOffscreenWindow()
      defer: offscreen.destroy()
      let other = newSocket()
      offscreen.add(other)
      expect ValueError: discard other.id
    test "local plugs are tracked without mapping; removal keeps sockets reusable":
      let host = newWindow()
      defer: host.destroy()
      let socket = newSocket()
      host.add(socket)
      var added, removed = 0
      socket.onPlugAdded(proc () = inc added)
      socket.onPlugRemoved(proc () = inc removed)
      let plug = newPlug(socket)
      defer: plug.destroy()
      check plug.isEmbedded and socket.hasPlug
      check added == 0
      drain()
      check added == 1
      expect ValueError: discard newPlug(socket)
      expect ValueError: gtk2.Container(socket).remove(plug)
      check not g.toBool(n.WIDGET_MAPPED(plug.raw))
      plug.destroy()
      drain()
      check not socket.isDestroyed and not socket.hasPlug and removed == 1
      let second = newPlug(socket)
      defer: second.destroy()
      check second.isEmbedded and socket.hasPlug
      check not g.toBool(n.WIDGET_MAPPED(host.raw))
      check not g.toBool(n.WIDGET_MAPPED(second.raw))
    test "addId embeds an already-realized local plug and emits deferred embedded":
      let host = newWindow()
      defer: host.destroy()
      let socket = newSocket()
      host.add(socket)
      let plug = newPlug()
      defer: plug.destroy()
      var embedded = 0
      let connection = plug.onEmbedded(proc () = inc embedded)
      socket.addId(plug.id)
      check plug.isEmbedded and socket.hasPlug and embedded == 0
      drain()
      check embedded == 1 and connection.connected
      check not g.toBool(n.WIDGET_MAPPED(host.raw))
      check not g.toBool(n.WIDGET_MAPPED(plug.raw))
      connection.disconnect()
    test "plug IDs realize without showing and observers can destroy the socket safely":
      let plug = newPlug()
      defer: plug.destroy()
      check not plug.isEmbedded and not plug.id.isEmpty
      check not g.toBool(n.WIDGET_MAPPED(plug.raw))
      let host = newWindow()
      defer: host.destroy()
      let socket = newSocket()
      host.add(socket)
      var connection: Connection
      connection = socket.onPlugRemoved(proc () =
        connection.disconnect()
        socket.destroy()
        raise newException(ValueError, "expected socket observer error"))
      let local = newPlug(socket)
      local.destroy()
      drain()
      check socket.isDestroyed and not connection.connected
      expect ValueError: discard socket.onPlugRemoved(nil)
