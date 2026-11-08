# Real XTEST/XDND only, on an explicitly opted-in isolated display. No fake signals.
import std/[os, times]
when defined(posix) and not defined(macosx):
  import std/[osproc, streams, strutils, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Binary DnD tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
const mime = "application/vnd.example.binary-pad"
proc drain() =
  for i in 0..<512:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "binary DnD sources did not settle")
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
proc largeBytes(): seq[byte] =
  result = newSeq[byte](600_013)
  for i in 0..<result.len: result[i] = byte(i mod 256)
type Stats = object
  ends, accepted, rejected, deletes, dataSignals: int
proc ended(instance: pointer, context: gd.PDragContext, data: pointer) {.cdecl.} =
  let s = cast[ptr Stats](data)
  inc s.ends
  if g.toBool(gd.drag_drop_succeeded(context)): inc s.accepted
  else: inc s.rejected
proc failed(instance: pointer, context: gd.PDragContext, reason: cint, data: pointer): g.gboolean {.cdecl.} =
  g.gbool(true) # Only suppress native failure animation, never native warnings.
proc deleteTap(instance: pointer, context: gd.PDragContext, data: pointer) {.cdecl.} = inc cast[ptr Stats](data).deletes
proc dataTap(instance: pointer, context: gd.PDragContext, selection: n.PSelectionData,
    info, time: g.guint, data: pointer) {.cdecl.} = inc cast[ptr Stats](data).dataSignals
proc observe(w: gtk2.Widget, stats: ptr Stats) =
  discard g.g_signal_connect_data(w.raw, "drag-end", cast[g.TGCallback](ended), stats, nil, g.TGConnectFlags(0))
  discard g.g_signal_connect_data(w.raw, "drag-failed", cast[g.TGCallback](failed), stats, nil, g.TGConnectFlags(0))
  discard g.g_signal_connect_data(w.raw, "drag-data-delete", cast[g.TGCallback](deleteTap), stats, nil, g.TGConnectFlags(0))
  discard g.g_signal_connect_data(w.raw, "drag-data-get", cast[g.TGCallback](dataTap), stats, nil, g.TGConnectFlags(0))
proc overrideData(instance: pointer, context: gd.PDragContext, selection: n.PSelectionData,
    info, time: g.guint, data: pointer) {.cdecl.} =
  let mode = cast[ptr int](data)[]
  if mode == 1:
    let target = gd.atom_intern("application/vnd.example.wrong", g.gbool(false))
    let bytes = [0'u8, 255]
    n.set(selection, target, 8, cast[g.Pguchar](unsafeAddr bytes[0]), 2)
  elif mode == 2:
    var words = [0x0080'u16, 0xff01'u16]
    n.set(selection, gd.atom_intern(mime, g.gbool(false)), 16, cast[g.Pguchar](addr words[0]), 4)
proc delayData(instance: pointer, context: gd.PDragContext, selection: n.PSelectionData,
    info, time: g.guint, data: pointer) {.cdecl.} = sleep(600)
type CaptureObj = object
  freed: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.freed[]
type Capture = ref CaptureObj
proc watch(w: gtk2.Widget, freed, policyFreed, calls, policyCalls: ptr int): BinaryDropSite =
  let observerCapture = Capture(freed: freed)
  let policyCapture = Capture(freed: policyFreed)
  let observer = proc (value: BinaryDrop) =
    discard observerCapture.freed
    inc calls[]
  let accept: BinaryDropPredicate = proc (value: BinaryDrop): bool =
    discard policyCapture.freed
    inc policyCalls[]
    true
  w.onBinaryDrop(mime, observer, accept = accept)
type CancelState = object
  site: BinaryDropSite
  widget: gtk2.Widget
  destroy: bool
  wasDraining, binaryBlocked, textBlocked, uriBlocked, unrealized: bool
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
    try: discard s.widget.onBinaryDrop(mime, proc (value: BinaryDrop) = discard)
    except ValueError: s.binaryBlocked = true
    try: discard s.widget.onTextDrop(proc (value: TextDrop) = discard)
    except ValueError: s.textBlocked = true
    try: discard s.widget.onUriDrop(proc (value: UriDrop) = discard)
    except ValueError: s.uriBlocked = true
  if s.destroy: s.widget.destroy()
  g.gbool(false)
proc beforeDrop(instance: pointer, context: gd.PDragContext, x, y: g.gint,
    time: g.guint32, data: pointer): g.gboolean {.cdecl.} =
  discard g.g_idle_add_full(g.G_PRIORITY_HIGH_IDLE, cast[pointer](cancelIdle), data, nil)
  g.gbool(false)
gtk2.init()
if paramCount() == 1 and paramStr(1) == "--binary-drag-peer":
  let host = newWindow("Foreign binary source", 180, 120)
  let pad = newEventBox()
  host.add(pad)
  discard pad.enableBinaryDrag(mime, largeBytes())
  discard g.g_signal_connect_data(pad.raw, "drag-data-get", cast[g.TGCallback](delayData), nil, nil, g.TGConnectFlags(0))
  n.move(host.raw, 20, 20)
  host.showAll()
  settle()
  let p = point(pad)
  stdout.writeLine("READY " & $p.x & " " & $p.y)
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
  proc motion(display: ptr XDisplay, p: tuple[x, y: cint]) =
    discard XTestFakeMotionEvent(display, -1, p.x, p.y, 0)
    discard XSync(display, 0)
    settle()
  proc startDrag(display: ptr XDisplay, p: tuple[x, y: cint]) =
    motion(display, p)
    discard XTestFakeButtonEvent(display, 1, 1, 0)
    discard XSync(display, 0)
    settle()
    motion(display, (p.x + 25, p.y + 10))
  proc releaseAt(display: ptr XDisplay, p: tuple[x, y: cint]) =
    motion(display, p)
    motion(display, (p.x + 5, p.y + 5))
    discard XTestFakeButtonEvent(display, 1, 0, 0)
    discard XSync(display, 0)
  let display = XOpenDisplay(nil)
  doAssert display != nil
  var event, error, major, minor: cint
  doAssert XTestQueryExtension(display, addr event, addr error, addr major, addr minor) != 0
  suite "binary COPY-only genuine XTEST/XDND pads":
    test "begin snapshots, independent policy input, empty COPY and reentrant post-finish observation":
      let host = newWindow("Binary pads", 420, 140)
      defer: host.destroy()
      let row = newHBox(spacing = 30)
      host.add(row)
      let source = newEventBox()
      let dest = newEventBox()
      for pad in [source, dest]:
        pad.setSizeRequest(150, 100)
        row.packStart(pad)
      let drag = source.enableBinaryDrag(mime, [0'u8, 255, 128, 0])
      var stats: Stats
      var policies, denied = 0
      var seen: seq[BinaryDrop]
      var retained: BinaryDrop
      var site: BinaryDropSite
      const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
      var accept: BinaryDropPredicate = proc (value: BinaryDrop): bool =
        inc policies
        retained = value
        var changed = value
        if changed.bytes.len > 0: changed.bytes[0] = 42
        check value.mime == mime and value.time != 0 and value.x >= 0 and value.y >= 0
        try: discard dest.raw
        except ValueError as error:
          if error.msg == guard: inc denied
        try: site.disconnect()
        except ValueError as error:
          if error.msg == guard: inc denied
        try: drag.data = newBinaryData(mime, [])
        except ValueError as error:
          if error.msg == guard: inc denied
        true
      let observer = proc (value: BinaryDrop) =
        seen.add(value)
        check retained.bytes == value.bytes and policies == seen.len
        if seen.len == 3:
          site.disconnect()
          dest.destroy()
          raise newException(ValueError, "expected binary drop observer error")
      let fixedAccept = accept
      site = dest.onBinaryDrop(mime, observer, maxBytes = 4, accept = accept)
      accept = proc (value: BinaryDrop): bool = false # Fixed attachment identity.
      observe(source, addr stats)
      host.showAll()
      settle()
      startDrag(display, point(source))
      drag.data = newBinaryData(mime, [7'u8])
      releaseAt(display, point(dest))
      require awaitUi(proc (): bool = seen.len == 1 and stats.ends == 1)
      check seen[0].bytes == @[0'u8, 255, 128, 0]
      startDrag(display, point(source))
      releaseAt(display, point(dest))
      require awaitUi(proc (): bool = seen.len == 2 and stats.ends == 2)
      check seen[1].bytes == @[7'u8]
      drag.data = newBinaryData(mime, [])
      site.disconnect()
      site = dest.onBinaryDrop(mime, observer, maxBytes = 0, accept = fixedAccept)
      startDrag(display, point(source))
      releaseAt(display, point(dest))
      require awaitUi(proc (): bool = seen.len == 3 and stats.ends == 3)
      check seen[2].bytes.len == 0 and stats.accepted == 3 and stats.deletes == 0
      check policies == 3 and denied == 9 and not site.connected and dest.isDestroyed
    test "bounds, native wrong type/format, policy false/error/guard and target/action/source cancellation":
      for mode in 0..9:
        let host = newWindow("Binary rejection", 420, 140)
        defer: host.destroy()
        let row = newHBox(spacing = 30)
        host.add(row)
        let source = newEventBox()
        let dest = newEventBox()
        for pad in [source, dest]:
          pad.setSizeRequest(150, 100)
          row.packStart(pad)
        var drag: BinaryDragSource
        var nativeMode = mode
        if mode in [5, 6, 8]:
          let targetName = if mode == 5: "UTF8_STRING" elif mode == 8: "application/vnd.example.other" else: mime
          var target = n.TTargetEntry(target: targetName.cstring, flags: 0, info: 0)
          n.drag_source_set(source.raw, gd.TModifierType(gd.BUTTON1_MASK), addr target, 1,
            if mode == 6: gd.ACTION_MOVE else: gd.ACTION_COPY)
        else: drag = source.enableBinaryDrag(mime, [0'u8, 255, 128, 0])
        if mode in [1, 2]:
          discard g.g_signal_connect_data(source.raw, "drag-data-get", cast[g.TGCallback](overrideData), addr nativeMode, nil, g.TGConnectFlags(0))
        var calls, policies = 0
        let accept: BinaryDropPredicate = proc (value: BinaryDrop): bool =
          inc policies
          if mode == 4: raise newException(ValueError, "expected binary drop policy error")
          if mode == 9: discard getClipboard() # Uncaught checked access error rejects.
          false
        discard dest.onBinaryDrop(mime, proc (value: BinaryDrop) = inc(calls),
          maxBytes = (if mode == 0: 3 else: 4), accept = accept)
        var stats: Stats
        observe(source, addr stats)
        host.showAll()
        settle()
        startDrag(display, point(source))
        if mode == 7: drag.disconnect()
        releaseAt(display, point(dest))
        require awaitUi(proc (): bool = stats.ends == 1)
        settle()
        check calls == 0 and stats.deletes == 0
        if mode in [3, 4, 9]: check policies == 1 and stats.rejected == 1
        else: check policies == 0
        if mode in [0, 1, 2, 7]: check stats.rejected == 1
    test "queued cancel drops captures only after native successful finish":
      let host = newWindow("Queued binary cancel", 420, 140)
      defer: host.destroy()
      let row = newHBox(spacing = 30)
      host.add(row)
      let source = newEventBox()
      let dest = newEventBox()
      for pad in [source, dest]:
        pad.setSizeRequest(150, 100)
        row.packStart(pad)
      discard source.enableBinaryDrag(mime, [0'u8])
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
    test "foreign INCR bytes and pending disconnect/destroy drain before binary/text/URI replacement":
      for mode in 0..2:
        let host = newWindow("Foreign binary destination", 220, 140)
        defer: host.destroy()
        let dest = newEventBox()
        host.add(dest)
        n.move(host.raw, 550, 20)
        var state = CancelState(widget: dest, destroy: mode == 2)
        var freed, policyFreed, calls, policies = 0
        var seen: seq[BinaryDrop]
        if mode == 0:
          state.site = dest.onBinaryDrop(mime, proc (value: BinaryDrop) = seen.add(value), maxBytes = 600_013)
        else:
          discard g.g_signal_connect_data(dest.raw, "drag-drop", cast[g.TGCallback](beforeDrop), addr state, nil, g.TGConnectFlags(0))
          state.site = dest.watch(addr freed, addr policyFreed, addr calls, addr policies)
        host.showAll()
        settle()
        let peer = startProcess(getAppFilename(), args = ["--binary-drag-peer"], options = {poUsePath})
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
          check seen[0].mime == mime and seen[0].bytes == largeBytes()
          state.site.disconnect()
        else:
          require awaitUi(proc (): bool = state.wasDraining)
          check freed == 1 and policyFreed == 1 and calls == 0 and policies == 0
          check state.binaryBlocked and state.textBlocked and state.uriBlocked and state.unrealized
          require awaitUi(proc (): bool = not state.site.draining)
          check calls == 0 and not state.site.connected
          if mode == 2: check dest.isDestroyed
          else:
            discard dest.onBinaryDrop(mime, proc (value: BinaryDrop) = inc calls)
            settle()
            check calls == 0
  discard XCloseDisplay(display)
else:
  echo "Native binary DnD input regressions require X11/XTEST; no synthetic signal fallback."
