# Owns selections on an explicitly isolated virtual display; includes foreign owner.
import std/[os, osproc, streams, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Rich clipboard tests require an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
proc awaitUi(predicate: proc (): bool): bool =
  let deadline = epochTime() + 8
  while epochTime() < deadline:
    drain()
    if predicate(): return true
    sleep(10)
proc codec(): TextFormat = newTextFormat("clipboard-v1", canCreateTags = true)
proc archived(): SerializedText =
  let buffer = newTextBuffer("foreign λ🙂")
  let tag = buffer.createTag("strong")
  tag.bold = true
  buffer.applyTag(tag, 0, 7)
  buffer.insertImage(buffer.characterCount, newPixbuf(3, 2, 0x123456ff'u32))
  buffer.serialize(codec())
type CaptureObj = object
  released, calls: ptr int
proc `=destroy`(value: var CaptureObj) = inc value.released[]
type Capture = ref CaptureObj
proc watched(c: Clipboard, released, calls: ptr int): RichTextRequest =
  let capture = Capture(released: released, calls: calls)
  c.requestRichText(codec(), true, proc (reply: RichClipboardResult) = inc capture.calls[])
type Provider = object
  mode, richCalls, plainCalls: int
proc provide(c: n.PClipboard, selection: n.PSelectionData, info: g.guint, data: pointer) {.cdecl.} =
  let state = cast[ptr Provider](data)
  if info != 0:
    inc state.plainCalls
    discard n.set_text(selection, "fallback", -1)
    return
  inc state.richCalls
  if state.mode == 4: return # Refuse rich target, despite advertising it.
  let mime = gd.atom_intern("application/x-gtk-text-buffer-rich-text;format=clipboard-v1", g.gbool(false))
  let kind = if state.mode == 1: gd.atom_intern("UTF8_STRING", g.gbool(false)) else: mime
  let bytes = if state.mode == 3: "" else: "not native"
  n.set(selection, kind, (if state.mode == 2: 16 else: 8), cast[g.Pguchar](bytes.cstring),
    g.gint(if state.mode == 2: 2 else: bytes.len))
proc clearProvider(c: n.PClipboard, data: pointer) {.cdecl.} = discard
proc install(c: Clipboard, provider: ptr Provider) =
  var targets = [n.TTargetEntry(target: "application/x-gtk-text-buffer-rich-text;format=clipboard-v1", info: 0),
    n.TTargetEntry(target: "UTF8_STRING", info: 1)]
  doAssert g.toBool(n.set_with_data(c.raw, addr targets[0], 2, provide, clearProvider, provider))
gtk2.init()
if paramCount() == 1 and paramStr(1) == "--rich-peer":
  discard getClipboard().offerRichText(archived(), "foreign plain λ🙂") # Dropped token still offers.
  stdout.writeLine("READY")
  stdout.flushFile()
  n.main()
  quit(0)
suite "rich clipboard negotiation on isolated display":
  test "copied snapshots, exact native target, detached document, explicit text-only policy":
    let c = getClipboard()
    defer: c.clear()
    let firstOffer = c.offerRichText(archived(), "old snapshot")
    let offer = c.offerRichText(archived(), "plain λ🙂")
    check not firstOffer.active and offer.active
    var values: seq[RichClipboardResult]
    let request = c.requestRichText(codec(), true, proc (value: RichClipboardResult) = values.add(value))
    check request.pending and values.len == 0
    require awaitUi(proc (): bool = not request.pending)
    check values.len == 1 and values[0].kind == richDocument
    let decoded = values[0].document
    check decoded.text == "foreign λ🙂" and decoded.hasTag(decoded.tag("strong"), 0)
    check decoded.characterCount == 11 # 10 text characters + one pixbuf.
    let plain = c.requestRichText(codec(), false, proc (value: RichClipboardResult) = values.add(value))
    require awaitUi(proc (): bool = not plain.pending)
    check values[^1].kind == richPlainText and values[^1].text == "plain λ🙂"
    let other = c.requestRichText(newTextFormat("other"), true,
      proc (value: RichClipboardResult) = values.add(value))
    require awaitUi(proc (): bool = not other.pending)
    check values[^1].kind == richPlainText
    c.setText("new owner")
    check not offer.active
    offer.clear() # Old token must not clear its replacement.
    let remains = c.requestText(proc (value: ClipboardText) = doAssert value.text == "new owner")
    require awaitUi(proc (): bool = not remains.pending)
  test "rejected rich data is not silently downgraded; no rich request without trust":
    let c = getClipboard()
    defer: c.clear()
    var provider: Provider
    for mode in 0..3:
      provider = Provider(mode: mode)
      install(c, addr provider)
      var value: RichClipboardResult
      let request = c.requestRichText(codec(), true, proc (reply: RichClipboardResult) = value = reply)
      require awaitUi(proc (): bool = not request.pending)
      check value.kind == richRejected and value.error.len > 0
      check provider.richCalls == 1 and provider.plainCalls == 0
      c.clear()
    provider = Provider(mode: 0)
    install(c, addr provider)
    let untrusted = c.requestRichText(codec(), false,
      proc (value: RichClipboardResult) = doAssert value.kind == richPlainText)
    require awaitUi(proc (): bool = not untrusted.pending)
    check provider.richCalls == 0 and provider.plainCalls == 1
    c.clear()
    provider = Provider(mode: 4)
    install(c, addr provider)
    let refused = c.requestRichText(codec(), true,
      proc (value: RichClipboardResult) = doAssert value.kind == richPlainText)
    require awaitUi(proc (): bool = not refused.pending)
    check provider.richCalls == 1 and provider.plainCalls == 1
  test "fixed schema controls rich tag policy independently of the sender":
    let c = getClipboard()
    defer: c.clear()
    discard c.offerRichText(archived(), "plain")
    var value: RichClipboardResult
    let fixed = newTextFormat("clipboard-v1")
    let denied = c.requestRichText(fixed, true, proc (reply: RichClipboardResult) = value = reply)
    require awaitUi(proc (): bool = not denied.pending)
    check value.kind == richRejected
    let schema = newTextBuffer("unchanged")
    let tag = schema.createTag("strong")
    tag.italic = true
    let allowed = c.requestRichText(fixed, true,
      (proc (reply: RichClipboardResult) = value = reply), tagsFrom = schema)
    require awaitUi(proc (): bool = not allowed.pending)
    check value.kind == richDocument and value.document.tag("strong").raw == tag.raw
    check value.document.tag("strong").italic and not value.document.tag("strong").bold
    check schema.text == "unchanged"
  test "empty text differs from unavailable, fallback can be disabled, PRIMARY is separate":
    let c = getClipboard(clipboardPrimary)
    defer: c.clear()
    c.setText("")
    var value: RichClipboardResult
    let empty = c.requestRichText(codec(), true, proc (reply: RichClipboardResult) = value = reply)
    require awaitUi(proc (): bool = not empty.pending)
    check value.kind == richPlainText and value.text == ""
    let missing = c.requestRichText(codec(), true,
      (proc (reply: RichClipboardResult) = value = reply), fallbackToText = false)
    require awaitUi(proc (): bool = not missing.pending)
    check value.kind == richUnavailable
    c.clear()
    let absent = c.requestRichText(codec(), true, proc (reply: RichClipboardResult) = value = reply)
    require awaitUi(proc (): bool = not absent.pending)
    check value.kind == richUnavailable
  test "view ownership cancels edits/replacement/destruction; decoded document is an explicit commit":
    let c = getClipboard()
    defer: c.clear()
    discard c.offerRichText(archived(), "plain")
    let view = newTextView("original")
    var calls = 0
    let canceled = c.requestRichText(view, codec(), true, proc (value: RichClipboardResult) = inc calls)
    canceled.cancel()
    let replaced = c.requestRichText(view, codec(), true, proc (value: RichClipboardResult) = inc calls)
    view.buffer = newTextBuffer("replacement")
    require awaitUi(proc (): bool = not replaced.pending)
    check calls == 0 and view.text == "replacement"
    let edited = c.requestRichText(view, codec(), true, proc (value: RichClipboardResult) = inc calls)
    view.buffer.appendText("!")
    require awaitUi(proc (): bool = not edited.pending)
    let destroyed = c.requestRichText(view, codec(), true, proc (value: RichClipboardResult) = inc calls)
    view.destroy()
    require awaitUi(proc (): bool = not destroyed.pending)
    check calls == 0
    var second: RichTextRequest
    let first = c.requestRichText(codec(), true, proc (value: RichClipboardResult) =
      doAssert value.kind == richDocument
      inc calls
      second = c.requestRichText(codec(), false, proc (reply: RichClipboardResult) = inc calls)
      raise newException(ValueError, "expected rich observer error"))
    require awaitUi(proc (): bool = calls == 2)
    check not first.pending and not second.pending
  test "foreign owner and cancellation while native callback data remains outstanding":
    let c = getClipboard()
    let peer = startProcess(getAppFilename(), args = ["--rich-peer"], options = {poUsePath})
    try:
      require peer.outputStream.readLine() == "READY"
      var value: RichClipboardResult
      let request = c.requestRichText(codec(), true, proc (reply: RichClipboardResult) = value = reply)
      require awaitUi(proc (): bool = not request.pending)
      check value.kind == richDocument and value.document.tag("strong").bold
      var calls, released = 0
      let canceled = watched(c, addr released, addr calls)
      canceled.cancel()
      check released == 1
      for i in 0..<30:
        drain()
        sleep(10)
      check calls == 0 and not canceled.pending
    finally:
      peer.terminate()
      discard peer.waitForExit()
      peer.close()
