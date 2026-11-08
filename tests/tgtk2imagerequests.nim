# Validation/purity only: no native requests, realization or clipboard claims.
import std/unittest
import gtk2
import headers/glib2 as g
gtk2.init()
suite "explicitly trusted image request validation":
  test "trust, copy bound, callback, clipboard and owner validation precede all wires":
    let c = getClipboard()
    let fn = proc (value: ClipboardImage) = discard
    expect ValueError: discard c.requestImage(false, fn)
    expect ValueError: discard c.requestImage(true, nil)
    for invalid in [-1, high(g.gint).int div 4 + 1]:
      expect ValueError: discard c.requestImage(true, fn, maxPixels = invalid)
    expect ValueError: discard default(Clipboard).requestImage(true, fn)
    let owner = newDrawingArea()
    owner.destroy()
    expect ValueError: discard c.requestImage(owner, true, fn)
    expect ValueError: discard c.requestImage(default(gtk2.Widget), true, fn)
    var request: ImageRequest
    check not request.pending
    request.cancel()
    request.cancel()
    check default(ClipboardImage).kind == imageUnavailable
    check default(ClipboardImage).image.isEmpty
  test "pure functions reject request/cancel before validation, clipboard access or decoding":
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var calls, denied = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      try: discard default(Clipboard).requestImage(false, nil)
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard default(Clipboard).requestImage(entry, true, nil)
      except ValueError as error:
        if error.msg == guard: inc denied
      try: default(ImageRequest).cancel()
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 3
