# No selection requests/ownership changes or realized widgets.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
static:
  doAssert not compiles(default(BinaryRequest).destroy())
gtk2.init()
suite "binary request validation without native wires":
  test "empty cancellation and invalid parameters do not start native requests":
    let request = BinaryRequest()
    check not request.pending
    request.cancel()
    request.cancel()
    let c = getClipboard()
    let observer = proc (value: ClipboardBytes) = discard
    for bad in ["", "TARGETS", "text/plain", "application/x-color", "application/a;b=c"]:
      expect ValueError: discard c.requestBinary(bad, observer)
    expect ValueError: discard c.requestBinary("application/octet-stream", nil)
    for bad in [-1, high(g.gint).int]:
      expect ValueError: discard c.requestBinary("application/octet-stream", observer, maxBytes = bad)
    expect ValueError: discard default(Clipboard).requestBinary("application/octet-stream", observer)
    expect ValueError: discard c.requestBinary(default(Widget), "application/octet-stream", observer)
    let owner = newEntry()
    owner.destroy()
    expect ValueError: discard c.requestBinary(owner, "application/octet-stream", observer)
  test "pure functions deny request overloads and even empty cancellation":
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var calls, denied = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      try: discard default(Clipboard).requestBinary("application/octet-stream", proc (value: ClipboardBytes) = discard)
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard default(Clipboard).requestBinary(entry, "application/octet-stream", proc (value: ClipboardBytes) = discard)
      except ValueError as error:
        if error.msg == guard: inc denied
      try: BinaryRequest().cancel()
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 3
    check not g.toBool(n.get_realized(cast[n.PWidget](entry.raw)))
