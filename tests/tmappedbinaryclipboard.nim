# Explicit isolated ownership, real native local/foreign byte transfers; no decoding/input.
import std/[os, osproc, streams, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Binary clipboard tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
const mime = "application/vnd.example.clipboard-bytes"
proc drain() =
  for i in 0..<512:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "binary clipboard sources did not settle")
proc awaitUi(predicate: proc (): bool): bool =
  let deadline = epochTime() + 8
  while epochTime() < deadline:
    drain()
    if predicate(): return true
    sleep(10)
type Reply = object
  done, available: bool
  atom: gd.TAtom
  bytes: seq[byte]
proc received(c: n.PClipboard, selection: n.PSelectionData, data: pointer) {.cdecl.} =
  let reply = cast[ptr Reply](data)
  reply.done = true
  let size = n.selection_data_get_length(selection).int
  if size < 0: return
  doAssert n.selection_data_get_target(selection) == reply.atom
  doAssert n.selection_data_get_data_type(selection) == reply.atom
  doAssert n.selection_data_get_format(selection) == 8
  reply.available = true
  reply.bytes = newSeq[byte](size)
  if size > 0:
    doAssert n.selection_data_get_data(selection) != nil
    copyMem(addr reply.bytes[0], n.selection_data_get_data(selection), size)
proc receive(c: gtk2.Clipboard, target = mime): Reply =
  var reply = Reply(atom: gd.atom_intern(target.cstring, g.gbool(false)))
  n.request_contents(c.raw, reply.atom, received, addr reply)
  # Never let a pending native callback outlive this stack fixture on failure.
  if not awaitUi(proc (): bool = reply.done): quit("native binary reply timed out", 1)
  reply
proc largeBytes(): seq[byte] =
  result = newSeq[byte](600_013) # Exceeds GTK2 X11's 262144-byte INCR threshold.
  for i in 0..<result.len: result[i] = byte(i mod 256)
type ReentrantOwner = object
  clipboard: gtk2.Clipboard
  winner: BinaryClipboardOffer
  clears: int
proc oldGet(c: n.PClipboard, selection: n.PSelectionData, info: g.guint, data: pointer) {.cdecl.} = discard
proc oldClear(c: n.PClipboard, data: pointer) {.cdecl.} =
  let state = cast[ptr ReentrantOwner](data)
  inc state.clears
  state.winner = state.clipboard.offerBinary(mime, [0'u8, 254, 0])
proc receiveSdk(c: gtk2.Clipboard, maxBytes = 16 * 1024 * 1024): ClipboardBytes =
  var value: ClipboardBytes
  let request = c.requestBinary(mime, proc (copied: ClipboardBytes) = value = copied, maxBytes)
  doAssert request.pending
  doAssert awaitUi(proc (): bool = not request.pending)
  value
type
  CaptureObj = object
    freed, calls: ptr int
  Provider = object
    mode, delay: int
    bytes: seq[byte]
proc `=destroy`(capture: var CaptureObj) = inc capture.freed[]
type Capture = ref CaptureObj
proc watch(c: gtk2.Clipboard, freed, calls: ptr int): BinaryRequest =
  let capture = Capture(freed: freed, calls: calls)
  c.requestBinary(mime, proc (value: ClipboardBytes) = inc capture.calls[])
proc watch(c: gtk2.Clipboard, owner: Widget, freed, calls: ptr int): BinaryRequest =
  let capture = Capture(freed: freed, calls: calls)
  c.requestBinary(owner, mime, proc (value: ClipboardBytes) = inc capture.calls[])
proc provide(c: n.PClipboard, selection: n.PSelectionData, info: g.guint, data: pointer) {.cdecl.} =
  let state = cast[ptr Provider](data)
  if state.delay > 0: sleep(state.delay)
  if state.mode == 3: return # Real unavailable native reply, no fabricated cancellation.
  let target = if state.mode in [1, 4]: "application/vnd.example.wrong" else: mime
  let atom = gd.atom_intern(target.cstring, g.gbool(false))
  if state.mode == 2:
    var words = [0x0080'u16, 0xff01'u16]
    n.set(selection, atom, 16, cast[g.Pguchar](addr words[0]), 4)
  else:
    let size = if state.mode == 4: 0 else: state.bytes.len
    let p = if size == 0: nil else: cast[g.Pguchar](addr state.bytes[0])
    n.set(selection, atom, 8, p, g.gint(size))
proc clearProvider(c: n.PClipboard, data: pointer) {.cdecl.} = discard
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc install(c: gtk2.Clipboard, state: var Provider) =
  var target = n.TTargetEntry(target: mime, flags: 0, info: 0)
  doAssert g.toBool(n.set_with_data(c.raw, addr target, 1, provide, clearProvider, addr state))
gtk2.init()
if paramCount() == 1 and paramStr(1) == "--binary-delayed-peer":
  var state = Provider(bytes: largeBytes(), delay: 250)
  getClipboard().install(state)
  stdout.writeLine("READY")
  stdout.flushFile()
  n.main()
  quit(0)
if paramCount() == 1 and paramStr(1) == "--binary-peer":
  var source = largeBytes()
  discard getClipboard().offerBinary(mime, source)
  source[0] = 42
  stdout.writeLine("READY")
  stdout.flushFile()
  n.main()
  quit(0)
suite "opaque binary offers and copied requests on an isolated display":
  test "SDK replies are idle, copied, bounded and distinguish empty/unavailable/rejected":
    let c = getClipboard()
    defer: c.clear()
    discard c.offerBinary(mime, [0'u8, 255, 128, 0])
    let first = c.receiveSdk(4)
    check first.kind == bytesAvailable and first.mime == mime and first.bytes == @[0'u8, 255, 128, 0]
    check c.receiveSdk(3).kind == bytesRejected and c.receiveSdk(0).bytes.len == 0
    discard c.offerBinary(mime, [])
    check c.receiveSdk(0).kind == bytesAvailable and c.receiveSdk(0).bytes.len == 0
    c.setText("no binary fallback")
    check c.receiveSdk().kind == bytesUnavailable
    var provider = Provider(bytes: @[0'u8, 255])
    c.install(provider)
    for mode in 0..4:
      provider.mode = mode
      let value = c.receiveSdk()
      check value.mime == mime
      if mode == 0: check value.kind == bytesAvailable and value.bytes == @[0'u8, 255]
      elif mode == 3: check value.kind == bytesUnavailable
      else: check value.kind == bytesRejected and value.bytes.len == 0 and value.error.len > 0
    c.clear() # Provider's stack storage must not outlive native registration.
    check first.bytes == @[0'u8, 255, 128, 0]
  test "queued cancel/owner destruction release captures; idle observations reenter and contain errors":
    let c = getClipboard()
    defer: c.clear()
    discard c.offerBinary(mime, [0'u8, 255])
    var freed, calls = 0
    let canceled = c.watch(addr freed, addr calls)
    canceled.cancel()
    canceled.cancel()
    check not canceled.pending and freed == 1 and calls == 0
    let owner = newEntry()
    let owned = c.watch(owner, addr freed, addr calls)
    owner.destroy()
    check not owned.pending and freed == 2
    var final = 0
    block:
      let orphan = newEntry()
      g.weak_ref(cast[g.PGObject](orphan.raw), finalized, addr final)
      discard c.watch(orphan, addr freed, addr calls)
    check final == 1 and freed == 3 and calls == 0 # A request must not retain its owner.
    var next: BinaryRequest
    var first: BinaryRequest
    first = c.requestBinary(mime, proc (value: ClipboardBytes) =
      check not first.pending and value.bytes == @[0'u8, 255]
      inc calls
      c.setText("observer replaced ownership")
      next = c.requestBinary(mime, proc (second: ClipboardBytes) =
        check second.kind == bytesUnavailable
        inc calls)
      raise newException(ValueError, "expected binary observer error"))
    require awaitUi(proc (): bool = calls == 2 and not next.pending)
    check freed == 3
    discard c.offerBinary(mime, [1'u8])
    discard c.requestBinary(mime, proc (value: ClipboardBytes) = inc calls)
    require awaitUi(proc (): bool = calls == 3) # Dropped request tokens do not cancel.
    let delivered = c.watch(addr freed, addr calls)
    require awaitUi(proc (): bool = calls == 4 and not delivered.pending)
    check freed == 4 # Retaining a completed token must not retain observer captures.
  test "pending foreign cancellation releases captures before actual delayed/large replies":
    let c = getClipboard()
    let peer = startProcess(getAppFilename(), args = ["--binary-delayed-peer"], options = {poUsePath})
    defer:
      if peer.running: peer.terminate()
      discard peer.waitForExit()
      peer.close()
    require peer.outputStream.readLine() == "READY"
    var freed, calls = 0
    let canceled = c.watch(addr freed, addr calls)
    canceled.cancel()
    check freed == 1 and calls == 0
    let owner = newEntry()
    let owned = c.watch(owner, addr freed, addr calls)
    owner.destroy()
    check freed == 2 and not owned.pending
    let rejected = c.receiveSdk(600_012)
    check rejected.kind == bytesRejected and rejected.bytes.len == 0
    let exact = c.receiveSdk(600_013)
    check exact.kind == bytesAvailable and exact.bytes == largeBytes()
    check freed == 2 and calls == 0

  test "all byte values, independent copies, dropped tokens and exact format/type/length":
    let c = getClipboard()
    defer: c.clear()
    var expected = newSeq[byte](256)
    for i in 0..<256: expected[i] = byte(i)
    block:
      var source = expected
      let value = newBinaryData(mime, source)
      var copy = value.bytes
      copy[0] = 42
      discard c.offerBinary(value)
      source = @[42'u8]
    for repeat in 0..2:
      let value = c.receive()
      check value.available and value.bytes == expected
    check not c.receive("application/octet-stream").available
    let text = c.requestText(proc (value: ClipboardText) = check not value.available)
    require awaitUi(proc (): bool = not text.pending)
    let uris = c.requestUris(proc (value: ClipboardUris) = check value.kind == urisUnavailable)
    require awaitUi(proc (): bool = not uris.pending)
    check not c.receive("image/png").available
  test "empty is available; invalid replacement is atomic; stale clear cannot revoke later offers":
    let c = getClipboard()
    defer: c.clear()
    let old = c.offerBinary(mime, [0'u8, 255])
    for bad in ["TARGETS", "text/plain", "application/x-color", "application/octet-stream;v=1"]:
      expect ValueError: discard c.offerBinary(bad, [1'u8])
    expect ValueError: discard c.offerBinary(default(BinaryData))
    check old.active and c.receive().bytes == @[0'u8, 255]
    let empty = c.offerBinary(mime, [])
    old.clear()
    check not old.active and empty.active
    check c.receive().available and c.receive().bytes.len == 0
    empty.clear()
    empty.clear()
    check not empty.active and not c.receive().available
    let image = c.offerImage(newPixbuf(1, 1, 0x123456ff'u32))
    let binary = c.offerBinary(mime, [0'u8, 1])
    check not image.active and binary.active
    let uri = c.offerUris(["urn:example:replacement"])
    check not binary.active and uri.active and not c.receive().available
    let final = c.offerBinary(mime, [0'u8])
    check not uri.active and final.active
    c.setText("replacement")
    check not final.active and not c.receive().available
  test "native reentrant old clear preserves winner and idempotently releases failed candidate":
    let c = getClipboard()
    defer: c.clear()
    var state = ReentrantOwner(clipboard: c)
    var target = n.TTargetEntry(target: "application/x-example-old-owner", flags: 0, info: 0)
    require g.toBool(n.set_with_data(c.raw, addr target, 1, oldGet, oldClear, addr state))
    try:
      discard c.offerBinary(mime, [99'u8])
      check false
    except ValueError as error:
      check error.msg == "GTK could not claim binary clipboard ownership"
    check state.clears == 1 and state.winner.active
    check c.receive().bytes == @[0'u8, 254, 0]
    state.winner.clear()
    check not state.winner.active and not c.receive().available
  test "foreign large exact replies use native INCR; explicit PRIMARY remains independent":
    let c = getClipboard()
    let primary = getClipboard(clipboardPrimary)
    defer: c.clear()
    defer: primary.clear()
    let prior = c.offerBinary(mime, [1'u8])
    let primaryOffer = primary.offerBinary(mime, [2'u8, 0, 255])
    check primary.receiveSdk().bytes == @[2'u8, 0, 255] and prior.active
    let peer = startProcess(getAppFilename(), args = ["--binary-peer"], options = {poUsePath})
    defer:
      if peer.running: peer.terminate()
      discard peer.waitForExit()
      peer.close()
    require peer.outputStream.readLine() == "READY"
    require awaitUi(proc (): bool = not prior.active)
    prior.clear()
    let value = c.receive()
    check value.available and value.bytes == largeBytes()
    check primaryOffer.active and primary.receive().bytes == @[2'u8, 0, 255]
