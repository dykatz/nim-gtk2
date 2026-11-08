# Owns isolated CLIPBOARD/PRIMARY; no launch/file I/O or synthesized input.
import std/[os, osproc, streams, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("URI clipboard tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "URI clipboard sources did not settle")
proc awaitUi(predicate: proc (): bool): bool =
  let deadline = epochTime() + 8
  while epochTime() < deadline:
    drain()
    if predicate(): return true
    sleep(10)
proc settle() =
  for i in 0..<15:
    drain()
    sleep(10)
type CaptureObj = object
  freed, calls: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.freed[]
type Capture = ref CaptureObj
proc watch(c: gtk2.Clipboard, freed, calls: ptr int): UriRequest =
  let capture = Capture(freed: freed, calls: calls)
  c.requestUris(proc (value: ClipboardUris) = inc capture.calls[])
proc watch(c: gtk2.Clipboard, owner: Widget, freed, calls: ptr int): UriRequest =
  let capture = Capture(freed: freed, calls: calls)
  c.requestUris(owner, proc (value: ClipboardUris) = inc capture.calls[])
type Provider = object
  bytes: string
  format, clears: int
  wrongType: bool
proc provide(c: n.PClipboard, selection: n.PSelectionData, info: g.guint, data: pointer) {.cdecl.} =
  let s = cast[ptr Provider](data)
  let name = if s.wrongType: "UTF8_STRING" else: "text/uri-list"
  n.set(selection, gd.atom_intern(name.cstring, g.gbool(false)),
    g.gint(s.format), cast[g.Pguchar](s.bytes.cstring), g.gint(s.bytes.len))
proc clearProvider(c: n.PClipboard, data: pointer) {.cdecl.} = inc cast[ptr Provider](data).clears
proc receive(c: gtk2.Clipboard): ClipboardUris =
  var value: ClipboardUris
  let request = c.requestUris(proc (copied: ClipboardUris) = value = copied)
  doAssert request.pending # Even local replies must defer application callbacks.
  doAssert awaitUi(proc (): bool = not request.pending)
  value
gtk2.init()
if paramCount() == 1 and paramStr(1) == "--uri-peer":
  discard getClipboard().offerUris(["file:///tmp/foreign%20name", "https://example.invalid/%CE%BB"])
  stdout.writeLine("READY")
  stdout.flushFile()
  n.main()
  quit(0)
suite "URI clipboard on an isolated display":
  test "snapshots, duplicates, escaped bytes, no text fallback, available-empty and unavailable":
    let c = getClipboard()
    defer: c.clear()
    var input = @["file:///tmp/a%20b", "urn:example:x", "file:///tmp/a%20b"]
    let offer = c.offerUris(input)
    input[0] = "urn:changed"
    check offer.active
    expect ValueError: discard c.requestUris(nil)
    var received: seq[ClipboardUris]
    let request = c.requestUris(proc (value: ClipboardUris) = received.add(value))
    check request.pending and received.len == 0
    require awaitUi(proc (): bool = not request.pending)
    check received.len == 1 and received[0].kind == urisAvailable
    check received[0].uris == @["file:///tmp/a%20b", "urn:example:x", "file:///tmp/a%20b"]
    expect ValueError: discard c.offerUris(["file:///good", "relative"])
    check offer.active
    check c.receive().uris == received[0].uris
    let plain = c.requestText(proc (value: ClipboardText) = check not value.available)
    require awaitUi(proc (): bool = not plain.pending)
    let empty = c.offerUris([])
    check not offer.active and empty.active
    check c.receive().kind == urisAvailable and c.receive().uris.len == 0
    offer.clear() # Stale token must not clear the replacement.
    check empty.active
    empty.clear()
    empty.clear()
    check not empty.active and c.receive().kind == urisUnavailable
    c.setText("file:///not-a-uri-target")
    check c.receive().kind == urisUnavailable
    let primary = getClipboard(clipboardPrimary)
    defer: primary.clear()
    discard primary.offerUris(["urn:example:primary"])
    check primary.receive().uris == @["urn:example:primary"]
  test "dropped offer/request tokens stay native-pinned; replacement is copied and cancels old ownership":
    let c = getClipboard()
    defer: c.clear()
    block:
      let list = newUriList(["urn:example:kept"])
      discard c.offerUris(list)
    check c.receive().uris == @["urn:example:kept"]
    var calls = 0
    discard c.requestUris(proc (value: ClipboardUris) =
      check value.uris == @["urn:example:kept"]
      inc calls)
    require awaitUi(proc (): bool = calls == 1)
    let old = c.offerUris(["urn:old"])
    c.setText("text replacement")
    check not old.active
    old.clear()
    var text: ClipboardText
    let request = c.requestText(proc (value: ClipboardText) = text = value)
    require awaitUi(proc (): bool = not request.pending)
    check text.text == "text replacement"
  test "native comments/line endings parsed; malformed payloads reject atomically without downgrade":
    let c = getClipboard()
    defer: c.clear()
    var state = Provider(format: 8)
    var target = n.TTargetEntry(target: "text/uri-list", info: 0)
    let cases = ["# comment\r\nfile:///tmp/a%20b\r\n\r\nurn:example:x\n", "# comments only\r\n",
      "relative", "urn:good\r\nfile:///bad space\r\n", "file:///λ", "urn:bad%G0", "urn:a\0urn:b", "\xff", "urn:ok"]
    for i, bytes in cases:
      state.bytes = bytes
      state.wrongType = i == cases.high
      require g.toBool(n.set_with_data(c.raw, addr target, 1, provide, clearProvider, addr state))
      let value = c.receive()
      if i == 0:
        check value.kind == urisAvailable and value.uris == @["file:///tmp/a%20b", "urn:example:x"]
      elif i == 1:
        check value.kind == urisAvailable and value.uris.len == 0
      else:
        check value.kind == urisRejected and value.uris.len == 0 and value.error.len > 0
      c.clear()
      check state.clears == i + 1
    state.bytes = "ab"
    state.format = 16
    state.wrongType = false
    require g.toBool(n.set_with_data(c.raw, addr target, 1, provide, clearProvider, addr state))
    check c.receive().kind == urisRejected
    c.clear() # Provider stack data stays valid through the native clear callback.
  test "cancel and owner destruction promptly release captures, even after synchronous local replies":
    let c = getClipboard()
    defer: c.clear()
    discard c.offerUris(["urn:example:cancel"])
    var freed, calls = 0
    let canceled = watch(c, addr freed, addr calls)
    canceled.cancel()
    canceled.cancel()
    check not canceled.pending and freed == 1
    settle()
    check calls == 0
    let owner = newEntry()
    let owned = watch(c, owner, addr freed, addr calls)
    owner.destroy()
    check freed == 2
    expect ValueError: discard c.requestUris(owner, proc (value: ClipboardUris) = inc calls)
    settle()
    check not owned.pending and calls == 0
    var next: UriRequest
    let first = c.requestUris(proc (value: ClipboardUris) =
      inc calls
      next = c.requestUris(proc (value: ClipboardUris) = inc calls)
      raise newException(ValueError, "expected URI callback error"))
    require awaitUi(proc (): bool = calls == 2)
    check not first.pending and not next.pending
  test "foreign wire cancellation keeps only native bridge pins until the actual reply":
    let c = getClipboard()
    let previous = c.offerUris(["urn:example:previous-owner"])
    let peer = startProcess(getAppFilename(), args = ["--uri-peer"], options = {poUsePath})
    defer:
      if peer.running: peer.terminate()
      discard peer.waitForExit()
      peer.close()
    require peer.outputStream.readLine() == "READY"
    require awaitUi(proc (): bool = not previous.active)
    previous.clear() # No-op after processing native ownership-loss notification.
    var freed, calls = 0
    let canceled = watch(c, addr freed, addr calls)
    canceled.cancel()
    check freed == 1 and not canceled.pending
    let owner = newEntry()
    let owned = watch(c, owner, addr freed, addr calls)
    owner.destroy()
    check freed == 2 and not owned.pending
    let value = c.receive()
    check calls == 0 and value.kind == urisAvailable
    check value.uris == @["file:///tmp/foreign%20name", "https://example.invalid/%CE%BB"]
    settle()
    check calls == 0
