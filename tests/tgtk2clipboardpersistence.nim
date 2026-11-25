# No clipboard claims/requests, realized widgets or file/input work.
import std/unittest
import gtk2
gtk2.init()
suite "explicit clipboard persistence pre-native contracts":
  test "inactive offers reject all manager hints and blocking stores":
    expect ValueError: default(TextClipboardOffer).allowPersistence()
    expect ValueError: default(TextClipboardOffer).store()
    expect ValueError: default(UriClipboardOffer).store()
    expect ValueError: default(BinaryClipboardOffer).store()
    expect ValueError: default(ImageClipboardOffer).store()
    expect ValueError: discard default(Clipboard).supportsPersistence()
    check not default(TextClipboardOffer).active
    expect ValueError: discard getClipboard().offerText("not claimed\0bad")
  test "early pure guards reject before active/handle/native manager operations":
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    let c = getClipboard()
    var calls, denied = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      try: default(TextClipboardOffer).allowPersistence()
      except ValueError as error:
        if error.msg == guard: inc denied
      try: default(BinaryClipboardOffer).store()
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard c.supportsPersistence()
      except ValueError as error:
        if error.msg == guard: inc denied
      try: c.setText("not published")
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls*4
