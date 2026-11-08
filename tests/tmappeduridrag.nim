# Genuine XTEST/XDND URI transfers; no signal-emitted fake drags or editing.
import std/[os, times]
when defined(posix) and not defined(macosx):
  import std/[osproc, streams, strutils, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("URI DnD tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "URI DnD sources did not settle")
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
  ends, failed, deletes, dataSignals, wireAccepted, wireRejected: int
proc ended(instance: pointer, context: gd.PDragContext, data: pointer) {.cdecl.} =
  let s = cast[ptr Stats](data)
  inc s.ends
  if g.toBool(gd.drag_drop_succeeded(context)): inc s.wireAccepted
  else: inc s.wireRejected
proc failed(instance: pointer, context: gd.PDragContext, reason: cint, data: pointer): g.gboolean {.cdecl.} =
  inc cast[ptr Stats](data).failed
  g.gbool(true) # Test observer suppresses only GTK's failure animation, not warnings.
proc deletionTap(instance: pointer, context: gd.PDragContext, data: pointer) {.cdecl.} = inc cast[ptr Stats](data).deletes
proc dataTap(instance: pointer, context: gd.PDragContext, selection: n.PSelectionData,
    info, time: g.guint, data: pointer) {.cdecl.} = inc cast[ptr Stats](data).dataSignals
proc observe(source: gtk2.Widget, stats: ptr Stats) =
  discard g.g_signal_connect_data(source.raw, "drag-end", cast[g.TGCallback](ended), stats, nil, g.TGConnectFlags(0))
  discard g.g_signal_connect_data(source.raw, "drag-failed", cast[g.TGCallback](failed), stats, nil, g.TGConnectFlags(0))
  discard g.g_signal_connect_data(source.raw, "drag-data-delete", cast[g.TGCallback](deletionTap), stats, nil, g.TGConnectFlags(0))
  discard g.g_signal_connect_data(source.raw, "drag-data-get", cast[g.TGCallback](dataTap), stats, nil, g.TGConnectFlags(0))
proc malformed(instance: pointer, context: gd.PDragContext, selection: n.PSelectionData,
    info, time: g.guint, data: pointer) {.cdecl.} =
  let bytes = "urn:valid\r\nfile:///bad space\r\n"
  n.set(selection, gd.atom_intern("text/uri-list", g.gbool(false)), 8, cast[g.Pguchar](bytes.cstring), g.gint(bytes.len))
proc delayData(instance: pointer, context: gd.PDragContext, selection: n.PSelectionData,
    info, time: g.guint, data: pointer) {.cdecl.} =
  sleep(600) # Foreign producer work; no nested loop.
type CaptureObj = object
  freed: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.freed[]
type Capture = ref CaptureObj
proc watchPolicy(w: gtk2.Widget, freed, policyFreed, calls, policyCalls: ptr int): UriDropSite =
  let observerCapture = Capture(freed: freed)
  let policyCapture = Capture(freed: policyFreed)
  let observer = proc (value: UriDrop) =
    discard observerCapture.freed
    inc calls[]
  let accept: UriDropPredicate = proc (value: UriDrop): bool =
    discard policyCapture.freed
    inc policyCalls[]
    true
  w.onUriDrop(observer, accept = accept)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CancelState = object
  site: UriDropSite
  widget: gtk2.Widget
  destroy: bool
  idle: g.guint
  blocked, textBlocked, wasDraining, unrealizedReceiver: bool
proc cancelIdle(data: pointer): g.gboolean {.cdecl.} =
  let s = cast[ptr CancelState](data)
  s.idle = 0
  s.site.disconnect()
  s.wasDraining = s.site.draining
  if s.wasDraining:
    # Public toplevel enumeration: the independent receiver remains unrealized,
    # on the same screen, while native transfer resources are owned by GTK.
    let windows = n.window_list_toplevels()
    var item = windows
    while item != nil:
      let w = cast[n.PWidget](item.data)
      if not g.toBool(n.get_realized(w)) and
          n.get_screen(w) == n.get_screen(s.widget.raw): s.unrealizedReceiver = true
      item = item.next
    g.free(windows)
    try: discard s.widget.onUriDrop(proc (value: UriDrop) = discard)
    except ValueError: s.blocked = true
    try: discard s.widget.onTextDrop(proc (value: TextDrop) = discard)
    except ValueError: s.textBlocked = true
  if s.destroy: s.widget.destroy()
  g.gbool(false)
proc beforeDrop(instance: pointer, context: gd.PDragContext, x, y: g.gint,
    time: g.guint32, data: pointer): g.gboolean {.cdecl.} =
  let s = cast[ptr CancelState](data)
  s.idle = g.g_idle_add_full(g.G_PRIORITY_HIGH_IDLE, cast[pointer](cancelIdle), data, nil)
  g.gbool(false) # Allow the actual SDK/native drop handler to request the data.

gtk2.init()
if paramCount() == 1 and paramStr(1) == "--uri-drag-peer":
  let host = newWindow("Foreign URI producer", 180, 120)
  let pad = newEventBox()
  pad.add(newLabel("Foreign URI source"))
  host.add(pad)
  discard pad.enableUriDrag(["file:///tmp/foreign%20name", "urn:example:foreign"])
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
  proc startDrag(display: ptr XDisplay, a: tuple[x, y: cint]) =
    motion(display, a)
    discard XTestFakeButtonEvent(display, 1, 1, 0)
    discard XSync(display, 0)
    settle()
    motion(display, (a.x + 25, a.y + 10))
  proc releaseAt(display: ptr XDisplay, b: tuple[x, y: cint]) =
    motion(display, b)
    motion(display, (b.x + 5, b.y + 5))
    discard XTestFakeButtonEvent(display, 1, 0, 0)
    discard XSync(display, 0)
  let display = XOpenDisplay(nil)
  doAssert display != nil
  var event, error, major, minor: cint
  doAssert XTestQueryExtension(display, addr event, addr error, addr major, addr minor) != 0
  suite "URI COPY-only native XTEST/XDND pads":
    test "begin snapshots, ordered duplicates/escaped bytes, idle observations and no DELETE":
      let host = newWindow("URI pads", 420, 140)
      defer: host.destroy()
      let row = newHBox(spacing = 30)
      host.add(row)
      let source = newEventBox()
      let dest = newEventBox()
      source.add(newLabel("URI source"))
      dest.add(newLabel("URI destination"))
      source.setSizeRequest(150, 100)
      dest.setSizeRequest(150, 100)
      row.packStart(source)
      row.packStart(dest)
      let drag = source.enableUriDrag(["file:///tmp/a%20b", "urn:example:x", "urn:example:x"])
      var stats: Stats
      var seen: seq[UriDrop]
      var site: UriDropSite
      site = dest.onUriDrop(proc (value: UriDrop) =
        check stats.dataSignals > 0 # Real source data-get precedes copied idle observation.
        seen.add(value))
      observe(source, addr stats)
      host.showAll()
      settle()
      let a = point(source)
      let b = point(dest)
      startDrag(display, a)
      drag.uris = ["urn:next-drag-only"]
      releaseAt(display, b)
      require awaitUi(proc (): bool = stats.ends == 1 and seen.len == 1)
      check seen[0].uris == @["file:///tmp/a%20b", "urn:example:x", "urn:example:x"]
      check seen[0].x >= 0 and seen[0].y >= 0 and seen[0].time != 0
      check stats.failed == 0 and stats.deletes == 0 and stats.dataSignals == 1
      site.disconnect()
      site = dest.onUriDrop(proc (value: UriDrop) =
        seen.add(value)
        site.disconnect()
        dest.destroy()
        raise newException(ValueError, "expected URI drop observer error"))
      drag.uris = []
      startDrag(display, a)
      releaseAt(display, b)
      require awaitUi(proc (): bool = stats.ends == 2 and seen.len == 2)
      check seen[1].uris.len == 0 and stats.deletes == 0 and stats.failed == 0
      check not site.connected and not site.draining and dest.isDestroyed
    test "fixed acceptance sees independent copies before observation; false/errors reject":
      for mode in 0..4:
        let host = newWindow("URI acceptance", 420, 140)
        defer: host.destroy()
        let row = newHBox(spacing = 30)
        host.add(row)
        let source = newEventBox()
        let dest = newEventBox()
        source.setSizeRequest(150, 100)
        dest.setSizeRequest(150, 100)
        row.packStart(source)
        row.packStart(dest)
        let original = if mode == 3: newUriList([]) else: newUriList(["urn:example:original", "urn:example:original"])
        let drag = source.enableUriDrag(original)
        var stats: Stats
        var policyCalls = 0
        var events: seq[string]
        var saved: UriDrop
        var seen: seq[UriDrop]
        var accept: UriDropPredicate = proc (value: UriDrop): bool =
          inc policyCalls
          events.add("policy")
          check seen.len == 0 and value.uris == original.uris
          check value.x >= 0 and value.y >= 0 and value.time != 0
          saved = value # A persistent copy, not a borrowed GTK selection/context.
          case mode
          of 0:
            var changed = value
            changed.uris[0][0] = 'X'
            changed.uris.add("urn:policy-local")
            check value.uris == original.uris
            true
          of 1: false
          of 2: raise newException(ValueError, "expected URI acceptance exception")
          of 3: value.uris.len > 0 # Valid empty transport can be refused by application policy.
          else:
            drag.uris = ["urn:forbidden-in-policy"] # Uncaught guard error also rejects.
            true
        discard dest.onUriDrop(proc (value: UriDrop) =
          events.add("observer")
          seen.add(value), accept = accept)
        if mode == 0:
          accept = proc (value: UriDrop): bool = false # Caller reassignment cannot replace the attached function.
        observe(source, addr stats)
        host.showAll()
        settle()
        startDrag(display, point(source))
        releaseAt(display, point(dest))
        require awaitUi(proc (): bool = stats.ends == 1)
        settle()
        check policyCalls == 1 and stats.deletes == 0 and stats.dataSignals == 1
        check drag.uris == original.uris # Guard restored even after exceptions; no GUI mutation.
        if mode == 0:
          check stats.wireAccepted == 1 and stats.wireRejected == 0
          check events == @["policy", "observer"] and seen.len == 1
          check seen[0].uris == original.uris and saved.uris == original.uris
          check seen[0].x == saved.x and seen[0].y == saved.y and seen[0].time == saved.time
        else:
          check stats.wireAccepted == 0 and stats.wireRejected == 1
          check events == @["policy"] and seen.len == 0
    test "acceptance guards GTK access and defers final releases, then observer can reenter":
      let host = newWindow("Pure URI acceptance", 420, 140)
      defer: host.destroy()
      let row = newHBox(spacing = 30)
      host.add(row)
      let source = newEventBox()
      let dest = newEventBox()
      source.setSizeRequest(150, 100)
      dest.setSizeRequest(150, 100)
      row.packStart(source)
      row.packStart(dest)
      let drag = source.enableUriDrag(["urn:example:guard"])
      let entry = newEntry("not for synchronous inspection")
      defer: entry.destroy()
      var orphan = newDrawingArea()
      var final, denied, policyCalls, calls = 0
      g.weak_ref(cast[g.PGObject](orphan.raw), finalized, addr final)
      var stats: Stats
      var site: UriDropSite
      const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
      let accept: UriDropPredicate = proc (value: UriDrop): bool =
        inc policyCalls
        try: discard dest.raw
        except ValueError as error:
          if error.msg == guard: inc denied
        try: dest.destroy()
        except ValueError as error:
          if error.msg == guard: inc denied
        try: site.disconnect()
        except ValueError as error:
          if error.msg == guard: inc denied
        try: drag.uris = ["urn:forbidden"]
        except ValueError as error:
          if error.msg == guard: inc denied
        try: discard getClipboard()
        except ValueError as error:
          if error.msg == guard: inc denied
        try: discard entry.text
        except ValueError as error:
          if error.msg == guard: inc denied
        try: gtk2.init()
        except ValueError as error:
          if error.msg == guard: inc denied
        try: gtk2.quit()
        except ValueError as error:
          if error.msg == guard: inc denied
        try: discard dest.onUriDrop(proc (copy: UriDrop) = discard)
        except ValueError as error:
          if error.msg == guard: inc denied
        check newUriList(value.uris).len == 1
        orphan = default(gtk2.DrawingArea) # Ordinary final release must wait beyond pure computation.
        check final == 0
        denied == 9
      site = dest.onUriDrop(proc (value: UriDrop) =
        inc calls
        check drag.uris == @["urn:example:guard"] and entry.text == "not for synchronous inspection"
        site.disconnect()
        dest.destroy(), accept = accept)
      observe(source, addr stats)
      host.showAll()
      settle()
      startDrag(display, point(source))
      releaseAt(display, point(dest))
      require awaitUi(proc (): bool = stats.ends == 1 and calls == 1 and final == 1)
      check policyCalls == 1 and denied == 9 and not site.connected and dest.isDestroyed
      check stats.deletes == 0
    test "malformed URI and text-only or MOVE-only sources are not accepted":
      for mode in 0..3:
        let host = newWindow("Rejected URI transfer", 420, 140)
        defer: host.destroy()
        let row = newHBox(spacing = 30)
        host.add(row)
        let source = newEventBox()
        let dest = newEventBox()
        source.setSizeRequest(150, 100)
        dest.setSizeRequest(150, 100)
        row.packStart(source)
        row.packStart(dest)
        var stats: Stats
        var cancelSource: UriDragSource
        var calls, policyCalls = 0
        let accept: UriDropPredicate = proc (value: UriDrop): bool =
          inc policyCalls
          true
        discard dest.onUriDrop(proc (value: UriDrop) = inc(calls), accept = accept)
        if mode == 0:
          discard source.enableUriDrag(["urn:initial"])
          discard g.g_signal_connect_data(source.raw, "drag-data-get", cast[g.TGCallback](malformed), nil, nil, g.TGConnectFlags(0))
        elif mode == 1: discard source.enableTextDrag("file:///not-a-uri-target")
        elif mode == 2:
          var target = n.TTargetEntry(target: "text/uri-list", flags: 0, info: 0)
          n.drag_source_set(source.raw, gd.TModifierType(gd.BUTTON1_MASK), addr target, 1, gd.ACTION_MOVE)
        else: cancelSource = source.enableUriDrag(["urn:disconnect-after-begin"])
        observe(source, addr stats)
        host.showAll()
        settle()
        startDrag(display, point(source))
        if mode == 3: cancelSource.disconnect()
        releaseAt(display, point(dest))
        require awaitUi(proc (): bool = stats.ends == 1)
        settle()
        checkpoint "mode=" & $mode & " calls=" & $calls & " ends=" & $stats.ends & " failed=" & $stats.failed & " data=" & $stats.dataSignals
        check calls == 0 and policyCalls == 0 and stats.deletes == 0
        # GTK2 reports received XDND Finished as source success, ignoring its bit.
        if mode in [0, 3]: check stats.failed == 0
        else: check stats.failed == 1
        if mode in [0, 3]: check stats.dataSignals == 1
        else: check stats.dataSignals == 0
    test "disconnect cancels an already queued successful observation without retaining captures":
      let host = newWindow("Cancel queued URI observation", 420, 140)
      defer: host.destroy()
      let row = newHBox(spacing = 30)
      host.add(row)
      let source = newEventBox()
      let dest = newEventBox()
      source.setSizeRequest(150, 100)
      dest.setSizeRequest(150, 100)
      row.packStart(source)
      row.packStart(dest)
      discard source.enableUriDrag(["urn:queued-success"])
      var state = CancelState(widget: dest)
      var stats: Stats
      var freed, policyFreed, calls, policyCalls = 0
      discard g.g_signal_connect_data(dest.raw, "drag-drop", cast[g.TGCallback](beforeDrop), addr state, nil, g.TGConnectFlags(0))
      state.site = watchPolicy(dest, addr freed, addr policyFreed, addr calls, addr policyCalls)
      observe(source, addr stats)
      host.showAll()
      settle()
      startDrag(display, point(source))
      releaseAt(display, point(dest))
      require awaitUi(proc (): bool = stats.ends == 1 and not state.site.connected)
      settle()
      check not state.wasDraining and not state.site.draining
      check freed == 1 and policyFreed == 1 and policyCalls == 1
      check calls == 0 and stats.dataSignals == 1 and stats.deletes == 0
    test "foreign data copies normally; pending replies cannot reach replacement sites after cancel/destroy":
      for mode in 0..2:
        let destroy = mode == 2
        let host = newWindow("Foreign URI destination", 220, 140)
        defer: host.destroy()
        let dest = newEventBox()
        host.add(dest)
        n.move(host.raw, 550, 20)
        var state = CancelState(widget: dest, destroy: destroy)
        var freed, policyFreed, calls, policyCalls = 0
        var seen: seq[UriDrop]
        if mode != 0:
          discard g.g_signal_connect_data(dest.raw, "drag-drop", cast[g.TGCallback](beforeDrop), addr state, nil, g.TGConnectFlags(0))
          state.site = watchPolicy(dest, addr freed, addr policyFreed, addr calls, addr policyCalls)
        else:
          let accept: UriDropPredicate = proc (value: UriDrop): bool =
            inc policyCalls
            value.uris.len == 2 and value.uris[1] == "urn:example:foreign"
          state.site = dest.onUriDrop(proc (value: UriDrop) =
            seen.add(value)
            inc(calls), accept = accept)
        host.showAll()
        settle()
        let peer = startProcess(getAppFilename(), args = ["--uri-drag-peer"], options = {poUsePath})
        defer:
          if peer.running: peer.terminate()
          discard peer.waitForExit()
          peer.close()
        let ready = peer.outputStream.readLine().splitWhitespace()
        require ready.len == 3 and ready[0] == "READY"
        let a = (cint(parseInt(ready[1])), cint(parseInt(ready[2])))
        startDrag(display, a)
        releaseAt(display, point(dest))
        if mode == 0:
          require awaitUi(proc (): bool = calls == 1)
          check seen[0].uris == @["file:///tmp/foreign%20name", "urn:example:foreign"] and policyCalls == 1
          state.site.disconnect()
          check not state.site.draining
        else:
          require awaitUi(proc (): bool = state.wasDraining)
          check freed == 1 and policyFreed == 1 and calls == 0 and policyCalls == 0
          check state.blocked and state.textBlocked and state.unrealizedReceiver
          require awaitUi(proc (): bool = not state.site.draining)
          check not state.site.connected and calls == 0
          if destroy: check dest.isDestroyed
          else:
            discard dest.onUriDrop(proc (value: UriDrop) = inc calls)
            settle()
            check calls == 0 # Old reply was consumed before replacement could be installed.
  discard XCloseDisplay(display)
else:
  echo "Native URI DnD input regressions require X11/XTEST; no synthetic signal fallback."
