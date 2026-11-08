# Actual XTEST/XDND and public XFixes/GTK drawable pixel observations only.
import std/[os, times]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
when defined(posix) and not defined(macosx):
  import headers/gdk2pixbuf as p
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Drag icon tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "drag icon events did not settle")
proc settle() =
  for i in 0..<12:
    drain()
    sleep(10)
proc awaitUi(predicate: proc (): bool): bool =
  let deadline = epochTime() + 8
  while epochTime() < deadline:
    drain()
    if predicate(): return true
    sleep(10)
proc point(w: gtk2.Widget): tuple[x, y: cint] =
  var x, y: g.gint
  discard gd.get_origin(n.get_window(w.raw), addr x, addr y)
  (cint(x + 20), cint(y + 20))
type Stats = object
  ends, deletes: int
proc ended(instance: pointer, context: gd.PDragContext, data: pointer) {.cdecl.} = inc cast[ptr Stats](data).ends
proc failed(instance: pointer, context: gd.PDragContext, reason: cint, data: pointer): g.gboolean {.cdecl.} =
  g.gbool(true) # Suppress only failure animation, not native warnings or outcomes.
proc deletionTap(instance: pointer, context: gd.PDragContext, data: pointer) {.cdecl.} = inc cast[ptr Stats](data).deletes
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
gtk2.init()
when defined(posix) and not defined(macosx):
  import std/unittest
  when (defined(illumos) or defined(solaris)) and sizeof(pointer) == 8:
    {.passC: staticExec("PKG_CONFIG_PATH=/usr/lib/64/pkgconfig:$PKG_CONFIG_PATH pkg-config --cflags gtk+-2.0 xfixes").}
    {.passL: staticExec("PKG_CONFIG_PATH=/usr/lib/64/pkgconfig:$PKG_CONFIG_PATH pkg-config --libs gtk+-2.0 xfixes").}
  else:
    {.passC: staticExec("pkg-config --cflags gtk+-2.0 xfixes").}
    {.passL: staticExec("pkg-config --libs gtk+-2.0 xfixes").}
  {.passL: "-lX11".}
  {.compile: "headers/drag_icon_pixels.c".}
  proc pixels(rgba: uint32, windowOnly: cint = 0): cint {.cdecl, importc: "nim_drag_icon_pixels".}
  proc fallbackWidth(): cint {.cdecl, importc: "nim_drag_icon_fallback_width".}
  type XDisplay {.pure, final, incompleteStruct.} = object
  const xlib = "libX11.so(.6|)"
  const xtest = "libXtst.so(.6|)"
  proc XOpenDisplay(name: cstring): ptr XDisplay {.cdecl, dynlib: xlib, importc.}
  proc XCloseDisplay(display: ptr XDisplay): cint {.cdecl, dynlib: xlib, importc.}
  proc XSync(display: ptr XDisplay, discardEvents: cint): cint {.cdecl, dynlib: xlib, importc.}
  proc XTestQueryExtension(display: ptr XDisplay, event, error, major, minor: ptr cint): cint {.cdecl, dynlib: xtest, importc.}
  proc XTestFakeMotionEvent(display: ptr XDisplay, screen, x, y: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc XTestFakeButtonEvent(display: ptr XDisplay, button: cuint, press: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc motion(display: ptr XDisplay, point: tuple[x, y: cint]) =
    discard XTestFakeMotionEvent(display, -1, point.x, point.y, 0)
    discard XSync(display, 0)
    settle()
  proc startDrag(display: ptr XDisplay, point: tuple[x, y: cint]) =
    motion(display, point)
    discard XTestFakeButtonEvent(display, 1, 1, 0)
    discard XSync(display, 0)
    settle()
    motion(display, (point.x + 25, point.y + 10))
  proc releaseAt(display: ptr XDisplay, point: tuple[x, y: cint]) =
    motion(display, point)
    motion(display, (point.x + 5, point.y + 5))
    discard XTestFakeButtonEvent(display, 1, 0, 0)
    discard XSync(display, 0)
  let display = XOpenDisplay(nil)
  doAssert display != nil
  var event, error, major, minor: cint
  doAssert XTestQueryExtension(display, addr event, addr error, addr major, addr minor) != 0
  suite "native copied drag icons, all COPY source families":
    test "caller release/mutation, active/future updates/reset, cursor/window pixels and disconnected contexts":
      for kind in 0..3:
        let host = newWindow("Native copied drag icons", 420, 140)
        defer: host.destroy()
        let row = newHBox(spacing = 30)
        host.add(row)
        let sourcePad = newEventBox()
        let destPad = newEventBox()
        for pad in [sourcePad, destPad]:
          pad.setSizeRequest(150, 100)
          row.packStart(pad)
        var text: TextDragSource
        var uri: UriDragSource
        var binary: BinaryDragSource
        var imageSource: ImageDragSource
        var observations = 0
        case kind
        of 0:
          text = sourcePad.enableTextDrag("icon text λ")
          discard destPad.onTextDrop(proc (value: TextDrop) =
            check value.text == "icon text λ"
            inc observations)
        of 1:
          uri = sourcePad.enableUriDrag(["urn:example:icon"])
          discard destPad.onUriDrop(proc (value: UriDrop) =
            check value.uris == @["urn:example:icon"]
            inc observations)
        of 2:
          binary = sourcePad.enableBinaryDrag("application/vnd.example.icon", [0'u8, 255])
          discard destPad.onBinaryDrop("application/vnd.example.icon", proc (value: BinaryDrop) =
            check value.bytes == @[0'u8, 255]
            inc observations)
        else:
          imageSource = sourcePad.enableImageDrag(newPixbuf(2, 3, 0xabcdef80'u32))
          discard destPad.onImageDrop(true, proc (value: ImageDrop) =
            check value.info.width == 2 and value.info.height == 3 and value.info.hasAlpha
            inc observations)
        proc set(image: Pixbuf) =
          case kind
          of 0: text.setIcon(image)
          of 1: uri.setIcon(image)
          of 2: binary.setIcon(image)
          else: imageSource.setIcon(image)
        proc clear() =
          case kind
          of 0: text.clearIcon()
          of 1: uri.clearIcon()
          of 2: binary.clearIcon()
          else: imageSource.clearIcon()
        proc disconnect() =
          case kind
          of 0: text.disconnect()
          of 1: uri.disconnect()
          of 2: binary.disconnect()
          else: imageSource.disconnect()
        var stats: Stats
        discard g.g_signal_connect_data(sourcePad.raw, "drag-end", cast[g.TGCallback](ended), addr stats, nil, g.TGConnectFlags(0))
        discard g.g_signal_connect_data(sourcePad.raw, "drag-failed", cast[g.TGCallback](failed), nil, nil, g.TGConnectFlags(0))
        discard g.g_signal_connect_data(sourcePad.raw, "drag-data-delete", cast[g.TGCallback](deletionTap), addr stats, nil, g.TGConnectFlags(0))
        const green = 0x19c745ff'u32
        const blue = 0x2963d9ff'u32
        const red = 0xd92153ff'u32
        var originalFreed = 0
        block:
          let original = newPixbuf(40, 32, green)
          g.weak_ref(cast[g.PGObject](original.raw), finalized, addr originalFreed)
          set(original)
          p.fill(original.raw, red)
        check originalFreed == 1
        expect ValueError: set(default(Pixbuf)) # Prior configuration survives until begin.
        host.showAll()
        settle()
        startDrag(display, point(sourcePad))
        require awaitUi(proc (): bool = pixels(green) > 50)
        expect ValueError: set(default(Pixbuf)) # Atomic failure, no native warnings.
        set(newPixbuf(40, 32, blue))
        settle()
        check pixels(green) > 50 and pixels(blue) == 0
        clear()
        settle()
        check pixels(green) > 50 # Native context still owns the old private pixels.
        releaseAt(display, point(destPad))
        require awaitUi(proc (): bool = stats.ends == 1 and observations == 1)
        startDrag(display, point(sourcePad))
        check pixels(green) == 0 and pixels(blue) == 0 # Actual native default.
        releaseAt(display, point(destPad))
        require awaitUi(proc (): bool = stats.ends == 2 and observations == 2)
        set(newPixbuf(40, 32, blue))
        startDrag(display, point(sourcePad))
        require awaitUi(proc (): bool = pixels(blue) > 50)
        let width = fallbackWidth()
        require width > 0 # Explicit test failure if backend cursor limit is too large.
        set(newPixbuf(width.int, 64, red)) # Larger than public maximal cursor width.
        check pixels(blue) > 50 and pixels(red) == 0
        releaseAt(display, point(destPad))
        require awaitUi(proc (): bool = stats.ends == 3 and observations == 3)
        startDrag(display, point(sourcePad))
        require awaitUi(proc (): bool = pixels(red, 1) > 50) # Native popup fallback.
        clear()
        settle()
        check pixels(red) > 50
        releaseAt(display, point(destPad))
        require awaitUi(proc (): bool = stats.ends == 4 and observations == 4)
        startDrag(display, point(sourcePad))
        check pixels(red) == 0 and pixels(blue) == 0
        releaseAt(display, point(destPad))
        require awaitUi(proc (): bool = stats.ends == 5 and observations == 5)
        set(newPixbuf(40, 32, blue))
        startDrag(display, point(sourcePad))
        require awaitUi(proc (): bool = pixels(blue) > 50)
        disconnect()
        settle()
        check pixels(blue) > 50 # No early context icon teardown/native cache repair.
        releaseAt(display, point(destPad))
        require awaitUi(proc (): bool = stats.ends == 6)
        settle()
        check observations == 5 and stats.deletes == 0
        sourcePad.destroy()
        expect ValueError: clear()
  discard XCloseDisplay(display)
else:
  echo "Native drag icon pixel regressions require X11/XTEST/XFixes, no synthetic fallback."
