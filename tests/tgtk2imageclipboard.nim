# No ownership changes, selection requests, realization or synthesized input.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2pixbuf as p
static:
  doAssert typeof(n.get_pixbuf(default(n.PSelectionData))) is p.PPixbuf
  doAssert not compiles(default(ImageClipboardOffer).destroy())
gtk2.init()
suite "image offer validation without desktop transfers":
  test "empty/stale-free tokens and invalid images reject before publication":
    check not ImageClipboardOffer().active
    ImageClipboardOffer().clear()
    ImageClipboardOffer().clear()
    expect ValueError: discard default(Clipboard).offerImage(default(Pixbuf))
    let clipboard = getClipboard()
    expect ValueError: discard clipboard.offerImage(default(Pixbuf))
  test "synchronous functions reject offers and clearing even empty tokens":
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    let image = newPixbuf(3, 2, 0x12345680'u32)
    var calls, denied = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      try: discard default(Clipboard).offerImage(image)
      except ValueError as error:
        if error.msg == guard: inc denied
      try: ImageClipboardOffer().clear()
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 2
    check image.width == 3 and image.height == 2
    check not g.toBool(n.get_realized(cast[n.PWidget](entry.raw)))
