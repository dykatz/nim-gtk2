# No realized widgets, clipboard ownership changes or selection requests.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
static:
  doAssert typeof(default(n.PSelectionData).get_uris()) is g.PPgchar
  doAssert not compiles(default(UriClipboardOffer).destroy())
gtk2.init()
suite "copied URI lists (no desktop transfers)":
  test "order, duplicates, escapes and tokens are preserved without resolving or opening":
    var source = @["file:///tmp/a%20b", "https://example.invalid/%CE%BB?q=x#part", "urn:example:a", "file:///tmp/a%20b"]
    let value = newUriList(source)
    source[0] = "https://replacement.invalid/"
    var copy = value.uris
    copy[0][0] = 'F'
    copy.add("mailto:test@example.invalid")
    check value.len == 4 and value.uris[0] == "file:///tmp/a%20b"
    check value.uris[1] == "https://example.invalid/%CE%BB?q=x#part"
    check value.uris[2] == "urn:example:a" and value.uris[3] == value.uris[0]
    check newUriList([]).len == 0 and default(UriList).uris.len == 0
  test "relative paths, raw whitespace/IRI bytes, NUL and broken escapes are rejected":
    for bad in ["", "/tmp/a", "../file", "1bad:value", "no-scheme", "https://x/a b", "file:///λ", "https://x/%", "https://x/%G0", "https://x/%0", "file:///x\r\nhttps://evil.invalid/", "https://x/\0", "https://x/\\", "https://x/\xff", "https://x/\"a"]:
      expect ValueError: discard newUriList(["file:///good", bad])
    check newUriList(["x:", "X+1.2-3:opaque", "file:///a%00b"]).len == 3
    # Encoded NUL is preserved as data, never decoded to a native filename here.
  test "empty tokens cancel/clear idempotently; invalid handles never reach native GTK":
    let request = UriRequest()
    check not request.pending and not UriClipboardOffer().active
    request.cancel()
    request.cancel()
    UriClipboardOffer().clear()
    expect ValueError: discard default(Clipboard).offerUris(newUriList(["file:///tmp/a"]))
    expect ValueError: discard default(Clipboard).offerUris(["file:///tmp/a"])
    expect ValueError: discard default(Clipboard).requestUris(nil)
    expect ValueError: discard default(Clipboard).requestUris(default(Widget), proc (value: ClipboardUris) = discard)
  test "pure matching permits copied URI construction but denies clipboard operations":
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var denied, copied = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      copied += newUriList(["urn:example:a"]).len
      try: discard default(Clipboard).offerUris(["urn:example:a"])
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard default(Clipboard).requestUris(proc (value: ClipboardUris) = discard)
      except ValueError as error:
        if error.msg == guard: inc denied
      try: UriRequest().cancel()
      except ValueError as error:
        if error.msg == guard: inc denied
      try: UriClipboardOffer().clear()
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check copied > 0 and denied == copied * 4
    check not g.toBool(n.get_realized(cast[n.PWidget](entry.raw)))
