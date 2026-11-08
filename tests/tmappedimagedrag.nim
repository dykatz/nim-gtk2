# Genuine XTEST/XDND on explicitly trusted tiny image fixtures only.
import std/[os, times]
when defined(posix) and not defined(macosx):
  import std/[osproc, streams, strutils, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/gdk2pixbuf as p
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Image DnD tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "image DnD sources did not settle")
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
proc pixels(image: Pixbuf): seq[uint32] =
  let bytes = cast[ptr UncheckedArray[uint8]](p.get_pixels(image.raw))
  let channels = p.get_n_channels(image.raw).int
  for y in 0..<image.height:
    for x in 0..<image.width:
      let i = y * p.get_rowstride(image.raw).int + x * channels
      let alpha = if channels == 4: bytes[i+3] else: 255'u8
      result.add((bytes[i].uint32 shl 24) or (bytes[i+1].uint32 shl 16) or
        (bytes[i+2].uint32 shl 8) or alpha.uint32)
type Stats = object
  ends, accepted, rejected, deletes: int
proc ended(instance: pointer, context: gd.PDragContext, data: pointer) {.cdecl.} =
  let s = cast[ptr Stats](data)
  inc s.ends
  if g.toBool(gd.drag_drop_succeeded(context)): inc s.accepted
  else: inc s.rejected
proc failed(instance: pointer, context: gd.PDragContext, reason: cint, data: pointer): g.gboolean {.cdecl.} =
  g.gbool(true) # Suppress failure animation only, not warnings or native outcome bits.
proc deletionTap(instance: pointer, context: gd.PDragContext, data: pointer) {.cdecl.} = inc cast[ptr Stats](data).deletes
proc observe(w: gtk2.Widget, stats: ptr Stats) =
  discard g.g_signal_connect_data(w.raw, "drag-end", cast[g.TGCallback](ended), stats, nil, g.TGConnectFlags(0))
  discard g.g_signal_connect_data(w.raw, "drag-failed", cast[g.TGCallback](failed), stats, nil, g.TGConnectFlags(0))
  discard g.g_signal_connect_data(w.raw, "drag-data-delete", cast[g.TGCallback](deletionTap), stats, nil, g.TGConnectFlags(0))
proc overrideData(instance: pointer, context: gd.PDragContext, selection: n.PSelectionData,
    info, time: g.guint, data: pointer) {.cdecl.} =
  let mode = cast[ptr int](data)[]
  if mode == 5:
    let bytes = [1'u8]
    n.set(selection, gd.atom_intern("application/vnd.example.wrong", g.gbool(false)), 8,
      cast[g.Pguchar](unsafeAddr bytes[0]), 1) # Rejected before any decoder sees these bytes.
  elif mode == 9:
    n.set(selection, gd.atom_intern("image/png", g.gbool(false)), 8, nil, 0)
  else:
    var words = [0x0080'u16, 0xff01'u16]
    n.set(selection, gd.atom_intern("image/png", g.gbool(false)), 16, cast[g.Pguchar](addr words[0]), 4)
proc delayData(instance: pointer, context: gd.PDragContext, selection: n.PSelectionData,
    info, time: g.guint, data: pointer) {.cdecl.} = sleep(600)
type CaptureObj = object
  freed: ptr int
proc `=destroy`(capture: var CaptureObj) = inc capture.freed[]
type Capture = ref CaptureObj
proc watch(w: gtk2.Widget, freed, policyFreed, calls, policies: ptr int): ImageDropSite =
  let observerCapture = Capture(freed: freed)
  let policyCapture = Capture(freed: policyFreed)
  let observer = proc (value: ImageDrop) =
    discard observerCapture.freed
    inc calls[]
  let accept: ImageDropPredicate = proc (value: ImageDropInfo): bool =
    discard policyCapture.freed
    inc policies[]
    true
  w.onImageDrop(true, observer, accept = accept)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CancelState = object
  site: ImageDropSite
  widget: gtk2.Widget
  destroy: bool
  wasDraining, imageBlocked, textBlocked, uriBlocked, binaryBlocked, unrealized: bool
proc cancelIdle(data: pointer): g.gboolean {.cdecl.} =
  let s = cast[ptr CancelState](data)
  s.site.disconnect()
  s.wasDraining = s.site.draining
  if s.wasDraining:
    let windows = n.window_list_toplevels()
    var item = windows
    while item != nil:
      let w = cast[n.PWidget](item.data)
      if not g.toBool(n.get_realized(w)) and n.get_screen(w) == n.get_screen(s.widget.raw): s.unrealized = true
      item = item.next
    g.free(windows)
    try: discard s.widget.onImageDrop(true, proc (value: ImageDrop) = discard)
    except ValueError: s.imageBlocked = true
    try: discard s.widget.onTextDrop(proc (value: TextDrop) = discard)
    except ValueError: s.textBlocked = true
    try: discard s.widget.onUriDrop(proc (value: UriDrop) = discard)
    except ValueError: s.uriBlocked = true
    try: discard s.widget.onBinaryDrop("application/octet-stream", proc (value: BinaryDrop) = discard)
    except ValueError: s.binaryBlocked = true
  if s.destroy: s.widget.destroy()
  g.gbool(false)
proc beforeDrop(instance: pointer, context: gd.PDragContext, x, y: g.gint,
    time: g.guint32, data: pointer): g.gboolean {.cdecl.} =
  discard g.g_idle_add_full(g.G_PRIORITY_HIGH_IDLE, cast[pointer](cancelIdle), data, nil)
  g.gbool(false)
gtk2.init()
if paramCount() == 1 and paramStr(1) == "--image-drag-peer":
  let host = newWindow("Foreign trusted image source", 180, 120)
  let pad = newEventBox()
  host.add(pad)
  discard pad.enableImageDrag(newPixbuf(2, 3, 0xabcdef80'u32))
  discard g.g_signal_connect_data(pad.raw, "drag-data-get", cast[g.TGCallback](delayData), nil, nil, g.TGConnectFlags(0))
  n.move(host.raw, 20, 20)
  host.showAll()
  settle()
  let pos = point(pad)
  stdout.writeLine("READY " & $pos.x & " " & $pos.y)
  stdout.flushFile()
  n.main()
  quit(0)
when defined(posix) and not defined(macosx):
  type XDisplay {.pure, final, incompleteStruct.} = object
  const xlib = "libX11.so(.6|)"
  const xtest = "libXtst.so(.6|)"
  proc XOpenDisplay(name: cstring): ptr XDisplay {.cdecl, dynlib: xlib, importc.}
  proc XCloseDisplay(display: ptr XDisplay): cint {.cdecl, dynlib: xlib, importc.}
  proc XSync(display: ptr XDisplay, discardEvents: cint): cint {.cdecl, dynlib: xlib, importc.}
  proc XTestQueryExtension(display: ptr XDisplay, event, error, major, minor: ptr cint): cint {.cdecl, dynlib: xtest, importc.}
  proc XTestFakeMotionEvent(display: ptr XDisplay, screen, x, y: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc XTestFakeButtonEvent(display: ptr XDisplay, button: cuint, press: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc motion(display: ptr XDisplay, pos: tuple[x, y: cint]) =
    discard XTestFakeMotionEvent(display, -1, pos.x, pos.y, 0)
    discard XSync(display, 0)
    settle()
  proc startDrag(display: ptr XDisplay, pos: tuple[x, y: cint]) =
    motion(display, pos)
    discard XTestFakeButtonEvent(display, 1, 1, 0)
    discard XSync(display, 0)
    settle()
    motion(display, (pos.x + 25, pos.y + 10))
  proc releaseAt(display: ptr XDisplay, pos: tuple[x, y: cint]) =
    motion(display, pos)
    motion(display, (pos.x + 5, pos.y + 5))
    discard XTestFakeButtonEvent(display, 1, 0, 0)
    discard XSync(display, 0)
  let display = XOpenDisplay(nil)
  doAssert display != nil
  var event, error, major, minor: cint
  doAssert XTestQueryExtension(display, addr event, addr error, addr major, addr minor) != 0
  suite "explicitly trusted image COPY pads, actual XTEST/XDND":
    test "private caller pixels/begin snapshots, metadata policy, active icon config, idle retained/reentrant results":
      let host = newWindow("Trusted image pads", 420, 140)
      defer: host.destroy()
      let row = newHBox(spacing = 30)
      host.add(row)
      let source = newEventBox()
      let dest = newEventBox()
      for pad in [source, dest]:
        pad.setSizeRequest(150, 100)
        row.packStart(pad)
      var drag: ImageDragSource
      var freed = 0
      block:
        let original = newPixbuf(2, 3, 0x11223380'u32)
        g.weak_ref(cast[g.PGObject](original.raw), finalized, addr freed)
        drag = source.enableImageDrag(original)
        drag.setIcon(original)
        p.fill(original.raw, 0xff000000'u32)
      check freed == 1
      var seen: seq[ImageDrop]
      var site: ImageDropSite
      var retained: ImageDropInfo
      var policies, denied = 0
      const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
      var accept: ImageDropPredicate = proc (value: ImageDropInfo): bool =
        inc policies
        retained = value
        var changed = value
        changed.width = 99
        check value.width != 99 and value.hasAlpha and value.time != 0 and value.x >= 0 and value.y >= 0
        try: discard dest.raw
        except ValueError as error:
          if error.msg == guard: inc denied
        try: site.disconnect()
        except ValueError as error:
          if error.msg == guard: inc denied
        try: drag.setImage(default(Pixbuf))
        except ValueError as error:
          if error.msg == guard: inc denied
        true
      site = dest.onImageDrop(true, proc (value: ImageDrop) =
        check value.info == retained and policies == seen.len + 1
        seen.add(value)
        if seen.len == 2:
          site.disconnect()
          dest.destroy()
          raise newException(ValueError, "expected image drop observer error"),
        maxPixels = 6, accept = accept)
      accept = proc (value: ImageDropInfo): bool = false # Fixed attachment identity.
      var stats: Stats
      observe(source, addr stats)
      host.showAll()
      settle()
      startDrag(display, point(source))
      drag.setImage(newPixbuf(3, 1, 0xabcdef80'u32))
      drag.clearIcon()
      expect ValueError: drag.setImage(default(Pixbuf))
      releaseAt(display, point(dest))
      require awaitUi(proc (): bool = seen.len == 1 and stats.ends == 1)
      check seen[0].info.width == 2 and seen[0].info.height == 3
      check pixels(seen[0].image) == @[0x11223380'u32, 0x11223380'u32, 0x11223380'u32,
        0x11223380'u32, 0x11223380'u32, 0x11223380'u32]
      p.fill(seen[0].image.raw, 0x987654ff'u32)
      startDrag(display, point(source))
      releaseAt(display, point(dest))
      require awaitUi(proc (): bool = seen.len == 2 and stats.ends == 2)
      check seen[1].info.width == 3 and seen[1].info.height == 1
      check pixels(seen[1].image) == @[0xabcdef80'u32, 0xabcdef80'u32, 0xabcdef80'u32]
      check pixels(seen[0].image)[0] == 0x987654ff'u32
      check policies == 2 and denied == 6 and stats.accepted == 2 and stats.deletes == 0
    test "bounds, false/error/guard policy, wrong envelope, text/MOVE targets and source cancellation":
      for mode in 0..10:
        let host = newWindow("Image rejection", 420, 140)
        defer: host.destroy()
        let row = newHBox(spacing = 30)
        host.add(row)
        let source = newEventBox()
        let dest = newEventBox()
        for pad in [source, dest]:
          pad.setSizeRequest(150, 100)
          row.packStart(pad)
        var drag: ImageDragSource
        if mode in [6, 7]:
          var target = n.TTargetEntry(target: (if mode == 6: "UTF8_STRING" else: "image/png"), flags: 0, info: 0)
          n.drag_source_set(source.raw, gd.TModifierType(gd.BUTTON1_MASK), addr target, 1,
            if mode == 7: gd.ACTION_MOVE else: gd.ACTION_COPY)
        else: drag = source.enableImageDrag(newPixbuf(2, 3, 0x11223380'u32))
        var nativeMode = mode
        if mode in [5, 9, 10]:
          discard g.g_signal_connect_data(source.raw, "drag-data-get", cast[g.TGCallback](overrideData), addr nativeMode, nil, g.TGConnectFlags(0))
        var calls, policies = 0
        let accept: ImageDropPredicate = proc (value: ImageDropInfo): bool =
          inc policies
          if mode == 3: raise newException(ValueError, "expected image drop policy error")
          if mode == 4: discard getClipboard()
          false
        discard dest.onImageDrop(true, proc (value: ImageDrop) = inc(calls),
          maxPixels = (if mode == 0: 5 elif mode == 1: 0 else: 6), accept = accept)
        var stats: Stats
        observe(source, addr stats)
        host.showAll()
        settle()
        startDrag(display, point(source))
        if mode == 8: drag.disconnect()
        releaseAt(display, point(dest))
        require awaitUi(proc (): bool = stats.ends == 1)
        settle()
        check calls == 0 and stats.deletes == 0
        if mode in [2, 3, 4]: check policies == 1 and stats.rejected == 1
        else: check policies == 0
        if mode notin [6, 7]: check stats.rejected == 1
    test "queued cancel releases both captures after native success, not a rollback":
      let host = newWindow("Queued image cancel", 420, 140)
      defer: host.destroy()
      let row = newHBox(spacing = 30)
      host.add(row)
      let source = newEventBox()
      let dest = newEventBox()
      for pad in [source, dest]:
        pad.setSizeRequest(150, 100)
        row.packStart(pad)
      discard source.enableImageDrag(newPixbuf(1, 1))
      var state = CancelState(widget: dest)
      discard g.g_signal_connect_data(dest.raw, "drag-drop", cast[g.TGCallback](beforeDrop), addr state, nil, g.TGConnectFlags(0))
      var freed, policyFreed, calls, policies = 0
      state.site = dest.watch(addr freed, addr policyFreed, addr calls, addr policies)
      var stats: Stats
      observe(source, addr stats)
      host.showAll()
      settle()
      startDrag(display, point(source))
      releaseAt(display, point(dest))
      require awaitUi(proc (): bool = stats.ends == 1 and not state.site.connected)
      settle()
      check stats.accepted == 1 and stats.deletes == 0 and policies == 1
      check calls == 0 and freed == 1 and policyFreed == 1 and not state.site.draining
    test "foreign tiny PNG pixels; pending disconnect/destroy skips decode and reserves replacement until drain":
      for mode in 0..2:
        let host = newWindow("Foreign trusted image destination", 220, 140)
        defer: host.destroy()
        let dest = newEventBox()
        host.add(dest)
        n.move(host.raw, 550, 20)
        var state = CancelState(widget: dest, destroy: mode == 2)
        var freed, policyFreed, calls, policies = 0
        var seen: seq[ImageDrop]
        if mode == 0:
          state.site = dest.onImageDrop(true, proc (value: ImageDrop) = seen.add(value), maxPixels = 6)
        else:
          discard g.g_signal_connect_data(dest.raw, "drag-drop", cast[g.TGCallback](beforeDrop), addr state, nil, g.TGConnectFlags(0))
          state.site = dest.watch(addr freed, addr policyFreed, addr calls, addr policies)
        host.showAll()
        settle()
        let peer = startProcess(getAppFilename(), args = ["--image-drag-peer"], options = {poUsePath})
        defer:
          if peer.running: peer.terminate()
          discard peer.waitForExit()
          peer.close()
        let ready = peer.outputStream.readLine().splitWhitespace()
        require ready.len == 3 and ready[0] == "READY"
        startDrag(display, (cint(parseInt(ready[1])), cint(parseInt(ready[2]))))
        releaseAt(display, point(dest))
        if mode == 0:
          require awaitUi(proc (): bool = seen.len == 1)
          check pixels(seen[0].image) == @[0xabcdef80'u32, 0xabcdef80'u32, 0xabcdef80'u32,
            0xabcdef80'u32, 0xabcdef80'u32, 0xabcdef80'u32]
          state.site.disconnect()
        else:
          require awaitUi(proc (): bool = state.wasDraining)
          check freed == 1 and policyFreed == 1 and calls == 0 and policies == 0
          check state.imageBlocked and state.textBlocked and state.uriBlocked and state.binaryBlocked and state.unrealized
          require awaitUi(proc (): bool = not state.site.draining)
          check calls == 0 and not state.site.connected
          if mode == 2: check dest.isDestroyed
          else:
            discard dest.onImageDrop(true, proc (value: ImageDrop) = inc calls)
            settle()
            check calls == 0
  discard XCloseDisplay(display)
else:
  echo "Native image DnD regressions require X11/XTEST, no synthetic fallback."
