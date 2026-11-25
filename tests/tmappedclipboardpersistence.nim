# Real X11 manager handoff; explicit isolated DISPLAY only. Never replaces an existing manager.
import std/[os, osproc, streams, strutils, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
when not defined(windows) and not defined(macosx):
  when defined(solaris):
    {.passC: staticExec("PKG_CONFIG_PATH=/usr/lib/64/pkgconfig:$PKG_CONFIG_PATH pkg-config --cflags gtk+-2.0").}
    {.passL: staticExec("PKG_CONFIG_PATH=/usr/lib/64/pkgconfig:$PKG_CONFIG_PATH pkg-config --libs gtk+-2.0").}
  else:
    {.passC: staticExec("pkg-config --cflags gtk+-2.0").}
    {.passL: staticExec("pkg-config --libs gtk+-2.0").}
  {.passL: "-lX11".}
  {.compile: "headers/clipboard_manager.c".}
  proc manager(reject: cint): cint {.cdecl, importc: "nim_gtk2_test_manager".}
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Clipboard persistence requires isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
proc awaitUi(predicate: proc (): bool): bool =
  let deadline = epochTime()+8
  while epochTime() < deadline:
    drain()
    if predicate(): return true
    sleep(5)
proc largeBytes(): seq[byte] =
  result = newSeq[byte](600013)
  for i in 0..<result.len: result[i] = byte(i mod 256)
const mime = "application/vnd.example.persist"
proc targetsReceived(c: n.PClipboard, value: n.PSelectionData, data: pointer) {.cdecl.} =
  let state = cast[ptr tuple[done, save: bool]](data)
  var atoms: ptr gd.TAtom
  var count: g.gint
  if g.toBool(n.get_targets(value, addr atoms, addr count)):
    defer: g.g_free(atoms)
    let list = cast[ptr UncheckedArray[gd.TAtom]](atoms)
    for i in 0..<count.int:
      if list[i] == gd.atom_intern("SAVE_TARGETS", g.gbool(false)): state.save = true
  state.done = true
proc hasSaveTargets(c: gtk2.Clipboard): bool =
  var state: tuple[done, save: bool]
  n.request_contents(c.raw, gd.atom_intern("TARGETS", g.gbool(false)), targetsReceived, addr state)
  if not awaitUi(proc (): bool = state.done): quit("TARGETS timed out", 1)
  state.save
type StoreWatch = object
  offer: TextClipboardOffer
  denied, ran: int
proc nestedStore(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let watch = cast[ptr StoreWatch](data)
    inc watch.ran
    try: watch.offer.store()
    except ValueError as error:
      if error.msg == "clipboard persistence is already in progress": inc watch.denied
    try: watch.offer.allowPersistence()
    except ValueError as error:
      if error.msg == "clipboard persistence is already in progress": inc watch.denied
    watch.offer.clear() # Native ownership loss during store must not free its clipboard pin.
    g.gbool(false)
proc protocolLine(peer: Process): string =
  while true:
    result = peer.outputStream.readLine()
    if not result.startsWith("Xlib:"): return
    stderr.writeLine(result) # Forward native diagnostics, separate from fixture protocol lines.
proc stop(peer: Process) =
  peer.terminate()
  discard peer.waitForExit()
  peer.close()
proc quitIdle(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    gtk2.quit()
    g.gbool(false)
gtk2.init()
when not defined(windows) and not defined(macosx):
  if paramCount() == 1 and paramStr(1).startsWith("--manager"):
    quit(manager(if paramStr(1) == "--manager-ignore": 2 elif paramStr(1) == "--manager-reject": 1 else: 0))
  if paramCount() == 1 and paramStr(1) == "--timeout-probe":
    # Diagnostic task, not a simulated timeout/expected-failure replacement of native semantics.
    let peer = startProcess(getAppFilename(), args = ["--manager-ignore"], options = {poUsePath, poStdErrToStdOut})
    if peer.protocolLine() != "MANAGER_READY": quit(2)
    let source = startProcess(getAppFilename(), args = ["--source-text"], options = {poUsePath, poStdErrToStdOut})
    let report = source.outputStream.readAll()
    stdout.write(report)
    let code = source.waitForExit()
    source.close()
    peer.stop()
    quit(if code == 0: 0 else: 1)
if paramCount() == 1 and paramStr(1).startsWith("--source-"):
  let c = getClipboard()
  case paramStr(1)
  of "--source-text": c.offerText("persistent λ text").store()
  of "--source-empty": c.offerText("").store()
  of "--source-auto":
    c.offerText("persistent λ text").allowPersistence()
    discard g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](quitIdle), nil, nil)
    n.main() # Real gtk_main exit runs native store-all for explicitly authorized targets.
  of "--source-uri": c.offerUris(["file:///persisted%20path", "https://example.invalid/"]).store()
  of "--source-binary": c.offerBinary(mime, largeBytes()).store()
  of "--source-image": c.offerImage(newPixbuf(2, 3, 0x1280ff7f'u32)).store()
  else: quit(2)
  stdout.writeLine("RETURNED")
  stdout.flushFile()
  quit(0)
suite "native clipboard manager persistence":
  test "no manager/no success result, default text is not implicitly storable, PRIMARY/inactive reject":
    let c = getClipboard()
    defer: c.clear()
    check not c.supportsPersistence()
    c.setText("ephemeral")
    check not c.hasSaveTargets()
    let text = c.offerText("explicit")
    check not c.hasSaveTargets()
    text.store() # Native unsupported no-op after explicit permission; not a false success flag.
    check text.active and c.hasSaveTargets()
    let replacement = c.offerText("new owner")
    check not text.active and not c.hasSaveTargets()
    expect ValueError: text.store()
    let primary = getClipboard(clipboardPrimary)
    let offer = primary.offerText("not a manager selection")
    defer: offer.clear()
    check not primary.supportsPersistence()
    expect ValueError: offer.allowPersistence()
    expect ValueError: offer.store()
    check replacement.active
  when not defined(windows) and not defined(macosx):
    test "real rejecting manager returns no guarantee and keeps source active":
      let peer = startProcess(getAppFilename(), args = ["--manager-reject"], options = {poUsePath, poStdErrToStdOut})
      defer: peer.stop()
      require peer.protocolLine() == "MANAGER_READY"
      let c = getClipboard()
      let offer = c.offerText("manager refuses")
      defer: offer.clear()
      check c.supportsPersistence()
      offer.store()
      check offer.active
      check peer.outputStream.readLine() == "REJECTED"
      var watch = StoreWatch(offer: c.offerText("clear during native nested store"))
      discard g.g_idle_add_full(g.G_PRIORITY_HIGH, cast[pointer](nestedStore), addr watch, nil)
      watch.offer.store()
      require awaitUi(proc (): bool = watch.ran == 1)
      check watch.denied == 2 and not watch.offer.active
      check peer.outputStream.readLine() == "REJECTED"
      let last = c.offerText("guard recovered")
      last.store()
      check last.active
      check peer.outputStream.readLine() == "REJECTED"
      last.clear()
    test "real manager caches exact authorized targets/INCR and serves after source process exit":
      let peer = startProcess(getAppFilename(), args = ["--manager"], options = {poUsePath, poStdErrToStdOut})
      defer: peer.stop()
      require peer.protocolLine() == "MANAGER_READY"
      let c = getClipboard()
      require c.supportsPersistence()
      for kind in ["text", "empty", "auto", "uri", "binary", "image"]:
        let source = startProcess(getAppFilename(), args = ["--source-" & kind], options = {poUsePath, poStdErrToStdOut})
        let report = source.outputStream.readAll()
        stdout.write(report) # Keep child/native diagnostics visible.
        check source.waitForExit() == 0
        source.close()
        check "RETURNED" in report
        let hints = peer.outputStream.readLine()
        let saved = peer.outputStream.readLine()
        check hints.startsWith("HINTS ") and saved.startsWith("SAVED ")
        check "SAVE_TARGETS" notin hints and "TARGETS " notin hints
        case kind
        of "text", "empty", "auto":
          check "UTF8_STRING" in hints
          var done = false
          var value: ClipboardText
          discard c.requestText(proc (v: ClipboardText) = (value = v; done = true))
          require awaitUi(proc (): bool = done)
          check value.available and value.text == (if kind == "empty": "" else: "persistent λ text")
        of "uri":
          check hints == "HINTS 1 text/uri-list"
          var done = false
          var value: ClipboardUris
          discard c.requestUris(proc (v: ClipboardUris) = (value = v; done = true))
          require awaitUi(proc (): bool = done)
          check value.kind == urisAvailable and value.uris == @["file:///persisted%20path", "https://example.invalid/"]
        of "binary":
          check hints == "HINTS 1 " & mime
          var done = false
          var value: ClipboardBytes
          discard c.requestBinary(mime, proc (v: ClipboardBytes) = (value = v; done = true))
          require awaitUi(proc (): bool = done)
          check value.kind == bytesAvailable and value.bytes == largeBytes()
        of "image":
          check "image/png" in hints
          var done = false
          var value: ClipboardImage
          discard c.requestImage(true, proc (v: ClipboardImage) = (value = v; done = true), maxPixels = 6)
          require awaitUi(proc (): bool = done)
          check value.kind == imageAvailable and value.image.width == 2 and value.image.height == 3
          check value.image.rgbaPixels().bytes[0..<4] == @[0x12'u8, 0x80, 0xff, 0x7f]
        else: discard
