# Explicitly trusted tiny PNG fixtures only, both raw offer probes and SDK image requests.
import std/[os, osproc, streams, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/gdk2pixbuf as p
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Image clipboard tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "image clipboard sources did not settle")
proc awaitUi(predicate: proc (): bool): bool =
  let deadline = epochTime() + 8
  while epochTime() < deadline:
    drain()
    if predicate(): return true
    sleep(10)
type Reply = object
  done, available: bool
  width, height: int
  pixels: seq[uint32]
proc received(c: n.PClipboard, selection: n.PSelectionData, data: pointer) {.cdecl.} =
  let reply = cast[ptr Reply](data)
  reply.done = true
  if n.selection_data_get_length(selection) < 0: return
  doAssert n.selection_data_get_format(selection) == 8
  let image = n.get_pixbuf(selection) # Transfer full; decode ONLY our own tiny PNG fixtures.
  doAssert image != nil
  defer: g.g_object_unref(image)
  reply.available = true
  reply.width = p.get_width(image).int
  reply.height = p.get_height(image).int
  let bytes = cast[ptr UncheckedArray[uint8]](p.get_pixels(image))
  let channels = p.get_n_channels(image).int
  for y in 0..<reply.height:
    for x in 0..<reply.width:
      let i = y * p.get_rowstride(image).int + x * channels
      let alpha = if channels == 4: bytes[i+3] else: 255'u8
      reply.pixels.add((bytes[i].uint32 shl 24) or (bytes[i+1].uint32 shl 16) or
        (bytes[i+2].uint32 shl 8) or alpha.uint32)
proc receive(c: gtk2.Clipboard): Reply =
  var reply: Reply
  n.request_contents(c.raw, gd.atom_intern("image/png", g.gbool(false)), received, addr reply)
  doAssert awaitUi(proc (): bool = reply.done)
  reply
type ReentrantOwner = object
  clipboard: gtk2.Clipboard
  winner: ImageClipboardOffer
  clears: int
proc oldGet(c: n.PClipboard, selection: n.PSelectionData, info: g.guint, data: pointer) {.cdecl.} =
  discard # This old target is never requested; real GTK clear invokes oldClear below.
proc oldClear(c: n.PClipboard, data: pointer) {.cdecl.} =
  let state = cast[ptr ReentrantOwner](data)
  inc state.clears
  state.winner = state.clipboard.offerImage(newPixbuf(1, 1, 0x987654ff'u32))
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CaptureObj = object
  freed, calls: ptr int
proc `=destroy`(capture: var CaptureObj) = inc capture.freed[]
type Capture = ref CaptureObj
proc watch(c: gtk2.Clipboard, freed, calls: ptr int): ImageRequest =
  let capture = Capture(freed: freed, calls: calls)
  c.requestImage(true, proc (value: ClipboardImage) = inc capture.calls[])
proc watch(c: gtk2.Clipboard, owner: gtk2.Widget, freed, calls: ptr int): ImageRequest =
  let capture = Capture(freed: freed, calls: calls)
  c.requestImage(owner, true, proc (value: ClipboardImage) = inc capture.calls[])
proc imagePixels(image: Pixbuf): seq[uint32] =
  let bytes = cast[ptr UncheckedArray[uint8]](p.get_pixels(image.raw))
  let channels = p.get_n_channels(image.raw).int
  for y in 0..<image.height:
    for x in 0..<image.width:
      let i = y * p.get_rowstride(image.raw).int + x * channels
      let alpha = if channels == 4: bytes[i+3] else: 255'u8
      result.add((bytes[i].uint32 shl 24) or (bytes[i+1].uint32 shl 16) or
        (bytes[i+2].uint32 shl 8) or alpha.uint32)
proc slowImage(c: n.PClipboard, selection: n.PSelectionData, info: g.guint, data: pointer) {.cdecl.} =
  sleep(250)
  doAssert g.toBool(n.set_pixbuf(selection, cast[p.PPixbuf](data)))
proc clearSlowImage(c: n.PClipboard, data: pointer) {.cdecl.} = discard
proc rawImageDone(c: n.PClipboard, image: p.PPixbuf, data: pointer) {.cdecl.} =
  doAssert image != nil and p.get_width(image) == 2 and p.get_height(image) == 3
  cast[ptr bool](data)[] = true
proc settle() =
  for i in 0..<12:
    drain()
    sleep(10)
gtk2.init()
if paramCount() == 1 and paramStr(1) == "--delayed-image-peer":
  let fixture = newPixbuf(2, 3, 0xabcdef80'u32)
  let nativeFixture = fixture.raw
  discard g.g_object_ref(nativeFixture) # Raw provider data is not retained by GTK.
  defer: g.g_object_unref(nativeFixture)
  var target = n.TTargetEntry(target: "image/png", flags: 0, info: 0)
  doAssert g.toBool(n.set_with_data(getClipboard().raw, addr target, 1, slowImage, clearSlowImage, nativeFixture))
  stdout.writeLine("READY")
  stdout.flushFile()
  n.main()
  quit(0)
if paramCount() == 1 and paramStr(1) == "--image-peer":
  let source = newPixbuf(2, 3, 0xabcdef80'u32)
  discard getClipboard().offerImage(source)
  p.fill(source.raw, 0x00000000'u32)
  stdout.writeLine("READY")
  stdout.flushFile()
  n.main()
  quit(0)
suite "copied image offers on an isolated display (writable PNG required)":
  test "private pixel snapshot survives mutation, alias release, token drop and repeated requests":
    let c = getClipboard()
    defer: c.clear()
    var freed = 0
    block:
      let source = newPixbuf(3, 2, 0x11223380'u32)
      g.weak_ref(cast[g.PGObject](source.raw), finalized, addr freed)
      discard c.offerImage(source) # Native pin survives token loss.
      p.fill(source.raw, 0x998877ff'u32)
    check freed == 1 # Offer must not keep the mutable source alive.
    for repeat in 0..2:
      let value = c.receive()
      check value.available and value.width == 3 and value.height == 2
      check value.pixels == @[0x11223380'u32, 0x11223380'u32, 0x11223380'u32,
                             0x11223380'u32, 0x11223380'u32, 0x11223380'u32]
    let text = c.requestText(proc (value: ClipboardText) = check not value.available)
    require awaitUi(proc (): bool = not text.pending)
    let uris = c.requestUris(proc (value: ClipboardUris) = check value.kind == urisUnavailable)
    require awaitUi(proc (): bool = not uris.pending)
  test "atomic invalid input, replacement, stale clear, idempotent clear and no image fallback":
    let c = getClipboard()
    defer: c.clear()
    let image = newPixbuf(1, 1, 0xff010200'u32)
    let old = c.offerImage(image)
    expect ValueError: discard c.offerImage(default(Pixbuf))
    check old.active and c.receive().pixels == @[0xff010200'u32]
    let next = c.offerImage(newPixbuf(2, 1, 0x445566ff'u32))
    check not old.active and next.active
    old.clear()
    check next.active and c.receive().pixels == @[0x445566ff'u32, 0x445566ff'u32]
    next.clear()
    next.clear()
    check not next.active and not c.receive().available
    c.setText("not an image")
    check not c.receive().available
    let last = c.offerImage(image)
    let uri = c.offerUris(["urn:example:replacement"])
    check not last.active and uri.active and not c.receive().available
    let final = c.offerImage(image)
    check not uri.active and final.active
    c.setText("text replaces the final image")
    check not final.active and not c.receive().available
  test "native reentrant old clear wins; failed candidate clear is safe and cannot revoke winner":
    let c = getClipboard()
    defer: c.clear()
    var state = ReentrantOwner(clipboard: c)
    var target = n.TTargetEntry(target: "application/x-nim-gtk2-old-image-owner", flags: 0, info: 0)
    require g.toBool(n.set_with_data(c.raw, addr target, 1, oldGet, oldClear, addr state))
    try:
      discard c.offerImage(newPixbuf(2, 2, 0x010203ff'u32))
      check false
    except ValueError as error:
      check error.msg == "GTK could not claim image clipboard ownership"
    check state.clears == 1 and state.winner.active
    check c.receive().pixels == @[0x987654ff'u32]
    state.winner.clear()
    check not state.winner.active and not c.receive().available
  test "primary is explicit and independent; foreign owners encode copied pixels and notify loss":
    let c = getClipboard()
    let primary = getClipboard(clipboardPrimary)
    defer: c.clear()
    defer: primary.clear()
    let prior = c.offerImage(newPixbuf(1, 1, 0x123456ff'u32))
    let primaryOffer = primary.offerImage(newPixbuf(1, 1, 0x654321ff'u32))
    check primary.receive().pixels == @[0x654321ff'u32] and prior.active
    let peer = startProcess(getAppFilename(), args = ["--image-peer"], options = {poUsePath})
    defer:
      if peer.running: peer.terminate()
      discard peer.waitForExit()
      peer.close()
    require peer.outputStream.readLine() == "READY"
    require awaitUi(proc (): bool = not prior.active)
    prior.clear() # Notification processed; stale token must not clear the foreign owner.
    let value = c.receive()
    check value.available and value.width == 2 and value.height == 3
    for pixel in value.pixels: check pixel == 0xabcdef80'u32
    check value.pixels.len == 6 and primaryOffer.active
    check primary.receive().pixels == @[0x654321ff'u32]

suite "explicit trusted image requests on isolated tiny fixtures":
  test "local receipt always delivers at idle; exact/zero/exceeded copy limits and retained pixels":
    let c = getClipboard()
    defer: c.clear()
    let offer = c.offerImage(newPixbuf(3, 2, 0x11223380'u32))
    var seen: seq[ClipboardImage]
    var requests: seq[ImageRequest]
    for limit in [6, 5, 0]:
      requests.add(c.requestImage(true, proc (value: ClipboardImage) = seen.add(value), maxPixels = limit))
      check seen.len == 0 and requests[^1].pending
    offer.clear() # Queued copies are independent of native publication and decoded callback storage.
    require awaitUi(proc (): bool = seen.len == 3)
    check seen[0].kind == imageAvailable and seen[0].error == ""
    check seen[0].image.width == 3 and seen[0].image.height == 2 and seen[0].image.hasAlpha
    check imagePixels(seen[0].image) == @[0x11223380'u32, 0x11223380'u32, 0x11223380'u32,
      0x11223380'u32, 0x11223380'u32, 0x11223380'u32]
    for i in 1..2:
      check seen[i].kind == imageRejected and seen[i].image.isEmpty
      check seen[i].error == "image clipboard reply exceeds maxPixels"
    for request in requests: check not request.pending
    p.fill(seen[0].image.raw, 0x987654ff'u32) # Delivered handles are application-owned/mutable.
    check imagePixels(seen[0].image)[0] == 0x987654ff'u32
  test "trust refusal, nil callback, default/absent data and no plain text or URI fallback":
    let c = getClipboard()
    defer: c.clear()
    discard c.offerImage(newPixbuf(1, 1))
    expect ValueError: discard c.requestImage(false, proc (value: ClipboardImage) = discard)
    expect ValueError: discard c.requestImage(true, nil)
    for mode in 0..2:
      case mode
      of 0: c.clear()
      of 1: c.setText("not an image")
      else: discard c.offerUris(["urn:example:not-an-image"])
      var calls = 0
      let request = c.requestImage(true, proc (value: ClipboardImage) =
        check value.kind == imageUnavailable and value.image.isEmpty and value.error == ""
        inc calls)
      check calls == 0
      require awaitUi(proc (): bool = calls == 1)
      check not request.pending
  test "queued cancellation, dropped tokens, completed-token captures and weak owner disposal":
    let c = getClipboard()
    defer: c.clear()
    discard c.offerImage(newPixbuf(1, 2, 0xabcdef80'u32))
    var freed, calls = 0
    let canceled = c.watch(addr freed, addr calls)
    check freed == 0 and calls == 0
    canceled.cancel()
    canceled.cancel()
    check freed == 1 and not canceled.pending
    settle()
    check calls == 0
    let completed = c.watch(addr freed, addr calls)
    require awaitUi(proc (): bool = calls == 1)
    check not completed.pending and freed == 2 # Retaining tokens must not retain observers.
    block: discard c.watch(addr freed, addr calls)
    require awaitUi(proc (): bool = calls == 2)
    check freed == 3
    var finalizedOwners = 0
    var bound: ImageRequest
    block:
      let owner = newDrawingArea()
      g.weak_ref(cast[g.PGObject](owner.raw), finalized, addr finalizedOwners)
      bound = c.watch(owner, addr freed, addr calls)
    check finalizedOwners == 1 and not bound.pending and freed == 4
    settle()
    check calls == 2
    let owner = newEventBox()
    let request = c.watch(owner, addr freed, addr calls)
    owner.destroy()
    check not request.pending and freed == 5
    settle()
    check calls == 2
  test "observer detaches before reentrant GTK/owner destruction and contained exceptions":
    let c = getClipboard()
    defer: c.clear()
    discard c.offerImage(newPixbuf(1, 1, 0x123456ff'u32))
    let owner = newDrawingArea()
    var request: ImageRequest
    var first, second = 0
    var retained: Pixbuf
    request = c.requestImage(owner, true, proc (value: ClipboardImage) =
      check not request.pending
      retained = value.image
      inc first
      owner.destroy()
      discard c.offerImage(newPixbuf(2, 1, 0x98765480'u32))
      discard c.requestImage(true, proc (later: ClipboardImage) =
        check later.kind == imageAvailable and later.image.width == 2
        inc second)
      raise newException(ValueError, "expected image observer error"))
    require awaitUi(proc (): bool = first == 1 and second == 1)
    check imagePixels(retained) == @[0x123456ff'u32]
    request.cancel()
  test "explicit PRIMARY is independent and copied foreign images drain after cancellation/disposal":
    let c = getClipboard()
    let primary = getClipboard(clipboardPrimary)
    defer: c.clear()
    defer: primary.clear()
    discard primary.offerImage(newPixbuf(1, 1, 0x12345680'u32))
    var primaryCalls = 0
    discard primary.requestImage(true, proc (value: ClipboardImage) =
      check value.kind == imageAvailable and imagePixels(value.image) == @[0x12345680'u32]
      inc primaryCalls)
    require awaitUi(proc (): bool = primaryCalls == 1)
    for mode in 0..3:
      c.clear()
      let peer = startProcess(getAppFilename(), args = ["--delayed-image-peer"], options = {poUsePath})
      defer:
        if peer.running: peer.terminate()
        discard peer.waitForExit()
        peer.close()
      require peer.outputStream.readLine() == "READY"
      settle()
      var freed, calls, finalizedOwners = 0
      var request: ImageRequest
      if mode == 0:
        request = c.requestImage(true, proc (value: ClipboardImage) =
          check value.kind == imageAvailable and value.image.width == 2 and value.image.height == 3
          check imagePixels(value.image) == @[0xabcdef80'u32, 0xabcdef80'u32, 0xabcdef80'u32,
            0xabcdef80'u32, 0xabcdef80'u32, 0xabcdef80'u32]
          inc calls)
      elif mode == 1:
        request = c.watch(addr freed, addr calls)
        request.cancel()
      else:
        block:
          let owner = newDrawingArea()
          g.weak_ref(cast[g.PGObject](owner.raw), finalized, addr finalizedOwners)
          request = c.watch(owner, addr freed, addr calls)
          if mode == 2: owner.destroy()
        check finalizedOwners == 1
      if mode == 0:
        require awaitUi(proc (): bool = calls == 1)
        check not request.pending
      else:
        check not request.pending and freed == 1 and calls == 0
      var spyDone = false
      n.request_image(c.raw, rawImageDone, addr spyDone) # Ordered second real reply drains first wire.
      if not awaitUi(proc (): bool = spyDone):
        quit("trusted image native reply timed out", 1) # Never leave callback pointing at expired stack.
      settle()
      if mode != 0: check calls == 0 and freed == 1
