# No clipboard ownership or selection requests: disabled rich + disabled fallback.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
type CaptureObj = object
  released: ptr int
proc `=destroy`(value: var CaptureObj) = inc value.released[]
type Capture = ref CaptureObj
proc watched(c: Clipboard, format: TextFormat, released: ptr int): RichTextRequest =
  let capture = Capture(released: released)
  c.requestRichText(format, false, proc (value: RichClipboardResult) = discard capture.released,
    fallbackToText = false)
gtk2.init()
suite "rich clipboard state/validation without desktop transfers":
  test "explicit no-trust/no-fallback is idle unavailable, never synchronous":
    let c = getClipboard()
    let format = newTextFormat()
    var calls = 0
    let request = c.requestRichText(format, false, proc (value: RichClipboardResult) =
      inc calls
      doAssert value.kind == richUnavailable and value.document.isDestroyed
      raise newException(ValueError, "expected rich clipboard observer error"), fallbackToText = false)
    check calls == 0 and request.pending
    drain()
    check calls == 1 and not request.pending
  test "cancel drops captures immediately and is idempotent":
    var released = 0
    let request = watched(getClipboard(), newTextFormat(), addr released)
    request.cancel()
    request.cancel()
    check released == 1 and not request.pending
    drain()
    check released == 1
    default(RichTextRequest).cancel()
    check not default(RichClipboardOffer).active
    default(RichClipboardOffer).clear()
  test "view destruction, editing and replacement suppress delivery":
    let c = getClipboard()
    let format = newTextFormat()
    var calls = 0
    let view = newTextView("old")
    let editing = c.requestRichText(view, format, false,
      (proc (value: RichClipboardResult) = inc calls), fallbackToText = false)
    view.buffer.appendText("edited")
    check not editing.pending
    let replacing = c.requestRichText(view, format, false,
      (proc (value: RichClipboardResult) = inc calls), fallbackToText = false)
    view.buffer = newTextBuffer("replacement")
    drain()
    check not replacing.pending and calls == 0
    let destroying = c.requestRichText(view, format, false,
      (proc (value: RichClipboardResult) = inc calls), fallbackToText = false)
    view.destroy()
    drain()
    check not destroying.pending and calls == 0
  test "reject invalid formats, callbacks, owners, schemas and offer text before ownership":
    let c = getClipboard()
    let format = newTextFormat(canCreateTags = true)
    let text = newTextBuffer("native").serialize(format)
    expect ValueError: discard c.offerRichText(default(SerializedText), "")
    expect ValueError: discard c.offerRichText(text, "bad\0plain")
    expect ValueError: discard c.offerRichText(text, "\xff")
    expect ValueError: discard c.requestRichText(format, true, nil)
    expect ValueError:
      discard c.requestRichText(default(TextView), format, true, proc (value: RichClipboardResult) = discard)
    expect ValueError:
      discard c.requestRichText(format, true, (proc (value: RichClipboardResult) = discard), tagsFrom = newTextBuffer())
