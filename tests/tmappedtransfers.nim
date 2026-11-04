# This suite owns the isolated display's CLIPBOARD/PRIMARY and drives XTEST input.
import std/[os, osproc, streams, times, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd

if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mapped transfer tests require an isolated virtual display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "transfer sources did not settle")
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
proc watch(c: gtk2.Clipboard, freed, calls: ptr int): TextRequest =
  let capture = Capture(freed: freed, calls: calls)
  c.requestText(proc (value: ClipboardText) = inc capture.calls[])

type Provider = object
  mode, clears: int
proc provide(c: n.PClipboard, selection: n.PSelectionData, info: g.guint, data: pointer) {.cdecl.} =
  let state = cast[ptr Provider](data)
  if state.mode == 0:
    if info == 2: discard n.set_text(selection, "café", -1) # STRING fallback only.
  else:
    let bytes = if state.mode == 1: "\xffx" else: "a\0b"
    n.set(selection, gd.atom_intern("UTF8_STRING", g.gbool(false)), 8,
      cast[g.Pguchar](bytes.cstring), g.gint(bytes.len))
proc clearProvider(c: n.PClipboard, data: pointer) {.cdecl.} = inc cast[ptr Provider](data).clears

gtk2.init()
if paramCount() == 1 and paramStr(1) == "--clipboard-peer":
  let c = getClipboard()
  c.setText("foreign λ🙂")
  stdout.writeLine("READY")
  stdout.flushFile()
  n.main()
  quit(0)

suite "asynchronous clipboard on an isolated display":
  test "copied Unicode, empty vs unavailable, no synchronous application callbacks":
    let c = getClipboard()
    defer: c.clear()
    check c.raw == getClipboard().raw
    expect ValueError: c.setText("bad\0text")
    expect ValueError: c.setText("\xff")
    c.setText("λ🙂 text")
    var values: seq[ClipboardText]
    let request = c.requestText(proc (value: ClipboardText) = values.add(value))
    check request.pending and values.len == 0
    require awaitUi(proc (): bool = not request.pending)
    check values.len == 1 and values[0].available and values[0].text == "λ🙂 text"
    c.setText("")
    let empty = c.requestText(proc (value: ClipboardText) = values.add(value))
    require awaitUi(proc (): bool = not empty.pending)
    check values[1].available and values[1].text == ""
    c.clear()
    let missing = c.requestText(proc (value: ClipboardText) = values.add(value))
    require awaitUi(proc (): bool = not missing.pending)
    check not values[2].available
    let primary = getClipboard(clipboardPrimary)
    defer: primary.clear()
    primary.setText("primary λ")
    let p = primary.requestText(proc (value: ClipboardText) = values.add(value))
    require awaitUi(proc (): bool = not p.pending)
    check values[3].text == "primary λ"
  test "cancellation releases captures, owner destruction cancels, callbacks can reenter/throw":
    let c = getClipboard()
    defer: c.clear()
    c.setText("cancel")
    var freed, calls = 0
    let request = watch(c, addr freed, addr calls)
    request.cancel()
    request.cancel()
    check freed == 1 and not request.pending
    settle()
    check calls == 0
    let owner = newEntry()
    let owned = c.requestText(owner, proc (value: ClipboardText) = inc calls)
    owner.destroy()
    settle()
    check not owned.pending and calls == 0
    var again: TextRequest
    let first = c.requestText(proc (value: ClipboardText) =
      inc calls
      again = c.requestText(proc (value: ClipboardText) = inc calls)
      raise newException(ValueError, "expected clipboard callback error"))
    require awaitUi(proc (): bool = calls == 2)
    check not first.pending and not again.pending
  test "a foreign clipboard owner replies asynchronously; cancellation cannot free native callback data early":
    let peer = startProcess(getAppFilename(), args = ["--clipboard-peer"], options = {poUsePath})
    defer:
      if peer.running: peer.terminate()
      discard peer.waitForExit()
      peer.close()
    require peer.outputStream.readLine() == "READY"
    let c = getClipboard()
    var freed, calls = 0
    let canceled = watch(c, addr freed, addr calls)
    canceled.cancel()
    check freed == 1
    var value: ClipboardText
    let live = c.requestText(proc (text: ClipboardText) = value = text)
    require awaitUi(proc (): bool = not live.pending)
    check value.available and value.text == "foreign λ🙂" and calls == 0
  test "STRING fallback and malformed/NUL UTF-8 payload rejection before native decoding":
    let c = getClipboard()
    defer: c.clear()
    var state: Provider
    var targets = [n.TTargetEntry(target: "UTF8_STRING", info: 0),
      n.TTargetEntry(target: "COMPOUND_TEXT", info: 1), n.TTargetEntry(target: "STRING", info: 2)]
    for mode in 0..2:
      state.mode = mode
      require g.toBool(n.set_with_data(c.raw, addr targets[0], 3, provide, clearProvider, addr state))
      var value: ClipboardText
      let request = c.requestText(proc (text: ClipboardText) = value = text)
      require awaitUi(proc (): bool = not request.pending)
      if mode == 0: check value.available and value.text == "café"
      else: check not value.available
      c.clear()
      check state.clears == mode + 1
  test "Entry copy/cut/paste respects hidden/read-only state and owner destruction":
    let c = getClipboard()
    defer: c.clear()
    let source = newEntry("λ🙂")
    let target = newEntry("before")
    defer:
      source.destroy()
      target.destroy()
    source.selectAll()
    check source.copySelection(c)
    target.selectAll()
    let paste = target.pasteClipboard(c)
    require awaitUi(proc (): bool = not paste.pending)
    check target.text == "λ🙂"
    source.textVisible = false
    check not source.copySelection(c) and not source.cutSelection(c)
    source.textVisible = true
    source.editable = false
    check not source.cutSelection(c)
    source.editable = true
    check source.cutSelection(c) and source.text == ""
    target.editable = false
    c.setText("no write")
    let readonly = target.pasteClipboard(c)
    require awaitUi(proc (): bool = not readonly.pending)
    check target.text == "λ🙂"
    let doomed = newEntry()
    let pending = doomed.pasteClipboard(c)
    doomed.destroy()
    settle()
    check not pending.pending
    let fragile = newEntry("delete this selection")
    fragile.selectAll()
    fragile.onChanged(proc () = fragile.destroy())
    let interrupted = fragile.pasteClipboard(c)
    require awaitUi(proc (): bool = not interrupted.pending)
    check fragile.isDestroyed # Selection deletion must not be followed by insertion.
  test "TextView plaintext skips hidden text, retains readonly tags and rejects document replacement":
    let c = getClipboard()
    defer: c.clear()
    let b = newTextBuffer("public secret")
    let view = newTextView(b)
    defer: view.destroy()
    let hidden = b.createTag()
    hidden.invisible = true
    b.applyTag(hidden, 7, 13)
    b.selectRange(0, 13)
    check view.copySelection(c)
    var value: ClipboardText
    let copy = c.requestText(proc (text: ClipboardText) = value = text)
    require awaitUi(proc (): bool = not copy.pending)
    check value.text == "public "
    b.text = "abcdef"
    let lock = b.createTag()
    lock.editable = false
    b.applyTag(lock, 2, 4)
    b.selectRange(0, 6)
    check view.cutSelection(c)
    check b.text == "cd"
    b.cursorOffset = 1
    c.setText("protected")
    let protected = view.pasteClipboard(c)
    require awaitUi(proc (): bool = not protected.pending)
    check b.text == "cd"
    b.text = "old document"
    let replacement = newTextBuffer("new document")
    let stale = view.pasteClipboard(c)
    view.buffer = replacement
    require awaitUi(proc (): bool = not stale.pending)
    check b.text == "old document" and replacement.text == "new document"

when defined(posix) and not defined(macosx):
  # Test-only narrow FFI avoids optional legacy XInput/RECORD bindings. No XTEST
  # input is sent before the explicit display opt-in above.
  type XDisplay {.pure, final, incompleteStruct.} = object
  const xlib = "libX11.so(.6|)"
  const xtest = "libXtst.so(.6|)"
  proc XOpenDisplay(name: cstring): ptr XDisplay {.cdecl, dynlib: xlib, importc.}
  proc XCloseDisplay(display: ptr XDisplay): cint {.cdecl, dynlib: xlib, importc.}
  proc XSync(display: ptr XDisplay, discardEvents: cint): cint {.cdecl, dynlib: xlib, importc.}
  proc XTestQueryExtension(display: ptr XDisplay, event, error, major, minor: ptr cint): cint {.cdecl, dynlib: xtest, importc.}
  proc XTestFakeMotionEvent(display: ptr XDisplay, screen, x, y: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc XTestFakeButtonEvent(display: ptr XDisplay, button: cuint, press: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc point(w: gtk2.Widget): tuple[x, y: cint] =
    var x, y: g.gint
    discard gd.get_origin(n.get_window(w.raw), addr x, addr y)
    (cint(x + 20), cint(y + 20))
  suite "native copy-only text drag/drop driven by XTEST":
    test "real drag captures text at begin, transfers Unicode, finishes once, and observer can disconnect/destroy":
      let display = XOpenDisplay(nil)
      require display != nil
      defer: discard XCloseDisplay(display)
      var event, error, major, minor: cint
      require XTestQueryExtension(display, addr event, addr error, addr major, addr minor) != 0
      let host = newWindow("Text transfer pads", 420, 140)
      defer: host.destroy()
      let row = newHBox(spacing = 30)
      host.add(row)
      let source = newEventBox()
      let dest = newEventBox()
      source.add(newLabel("Drag text"))
      dest.add(newLabel("Drop text"))
      source.setSizeRequest(150, 100)
      dest.setSizeRequest(150, 100)
      row.packStart(source)
      row.packStart(dest)
      let drag = source.enableTextDrag("snapshot λ🙂")
      var seen: seq[TextDrop]
      var site: TextDropSite
      site = dest.onTextDrop(proc (value: TextDrop) =
        seen.add(value)
        site.disconnect()
        dest.destroy()
        raise newException(ValueError, "expected drop observer error"))
      host.showAll()
      settle()
      let a = point(source)
      let b = point(dest)
      discard XTestFakeMotionEvent(display, -1, a.x, a.y, 0)
      discard XTestFakeButtonEvent(display, 1, 1, 0)
      discard XSync(display, 0)
      settle()
      discard XTestFakeMotionEvent(display, -1, a.x + 25, a.y + 10, 0)
      discard XSync(display, 0)
      settle()
      drag.text = "next drag only"
      discard XTestFakeMotionEvent(display, -1, b.x, b.y, 0)
      discard XSync(display, 0)
      settle()
      discard XTestFakeMotionEvent(display, -1, b.x + 5, b.y + 5, 0)
      discard XSync(display, 0)
      settle()
      discard XTestFakeButtonEvent(display, 1, 0, 0)
      discard XSync(display, 0)
      require awaitUi(proc (): bool = seen.len == 1)
      check seen[0].text == "snapshot λ🙂" and seen[0].x >= 0 and seen[0].y >= 0
      check not site.connected and dest.isDestroyed
      drag.disconnect()
      settle()
