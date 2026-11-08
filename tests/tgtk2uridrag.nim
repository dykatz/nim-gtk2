# Configuration only: never realize widgets, request selections or synthesize input.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
type CaptureObj = object
  freed: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.freed[]
type Capture = ref CaptureObj
proc watch(w: Widget, freed: ptr int): UriDropSite =
  let capture = Capture(freed: freed)
  w.onUriDrop(proc (value: UriDrop) = discard capture.freed)
gtk2.init()
suite "URI pad configuration, no native transfers":
  test "copied values, atomic invalid replacement and independent source/destination":
    let pad = newEventBox()
    defer: pad.destroy()
    var input = @["file:///tmp/a%20b", "urn:example:x"]
    let source = pad.enableUriDrag(input)
    input[0] = "urn:changed"
    check source.connected and source.uris == @["file:///tmp/a%20b", "urn:example:x"]
    var copy = source.uris
    copy[0][0] = 'F'
    check source.uris[0] == "file:///tmp/a%20b"
    source.uris = newUriList(["urn:replacement"])
    expect ValueError: source.uris = ["relative"]
    check source.uris == @["urn:replacement"]
    source.uris = []
    check source.uris.len == 0
    let dest = pad.onUriDrop(proc (value: UriDrop) = discard)
    check dest.connected and not dest.draining
    expect ValueError: discard pad.enableUriDrag(["urn:duplicate"])
    expect ValueError: discard pad.enableTextDrag("conflicting source")
    expect ValueError: discard pad.onUriDrop(proc (value: UriDrop) = discard)
    expect ValueError: discard pad.onTextDrop(proc (value: TextDrop) = discard)
    source.disconnect()
    source.disconnect()
    check not source.connected and dest.connected
    expect ValueError: discard source.uris
    expect ValueError: source.uris = ["urn:disconnected"]
    dest.disconnect()
    check not dest.connected and not dest.draining
    discard pad.enableTextDrag("reuse source")
    discard pad.onTextDrop(proc (value: TextDrop) = discard)
    check not g.toBool(n.get_realized(gtk2.Widget(pad).raw))
  test "only ordinary pads, no native sites overwritten, reverse conflicts rejected":
    let entry = newEntry()
    defer: entry.destroy()
    expect ValueError: discard gtk2.Widget(entry).enableUriDrag(["urn:no"])
    expect ValueError: discard gtk2.Widget(entry).onUriDrop(proc (value: UriDrop) = discard)
    let area = newDrawingArea()
    defer: area.destroy()
    expect ValueError: discard area.onUriDrop(nil)
    var target = n.TTargetEntry(target: "text/uri-list", info: 0)
    n.drag_dest_set(gtk2.Widget(area).raw, n.DEST_DEFAULT_ALL, addr target, 1, 2)
    expect ValueError: discard area.onUriDrop(proc (value: UriDrop) = discard)
    n.drag_dest_unset(gtk2.Widget(area).raw)
    let text = area.enableTextDrag("text")
    expect ValueError: discard area.enableUriDrag(["urn:no"])
    text.disconnect()
    let dest = area.onTextDrop(proc (value: TextDrop) = discard)
    expect ValueError: discard area.onUriDrop(proc (value: UriDrop) = discard)
    dest.disconnect()
    discard area.onUriDrop(proc (value: UriDrop) = discard)
  test "dropped tokens do not cancel; destroy/disconnect release captures and weak widget refs":
    var freed, final = 0
    block:
      let pad = newDrawingArea()
      g.weak_ref(cast[g.PGObject](pad.raw), gone, addr final)
      discard watch(pad, addr freed)
      discard pad.enableUriDrag(["urn:kept-until-destroy"])
    check freed == 1 and final == 1
    let pad = newEventBox()
    defer: pad.destroy()
    let site = watch(pad, addr freed)
    site.disconnect()
    check freed == 2
    let next = watch(pad, addr freed)
    pad.destroy()
    check freed == 3 and not next.connected and not next.draining
    UriDragSource().disconnect()
    UriDropSite().disconnect()
  test "synchronous model functions cannot configure/disconnect/access mutable URI sites":
    let pad = newEventBox()
    defer: pad.destroy()
    let source = pad.enableUriDrag(["urn:original"])
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var denied, calls = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      try: discard source.uris
      except ValueError as error:
        if error.msg == guard: inc denied
      try: source.uris = ["urn:no"]
      except ValueError as error:
        if error.msg == guard: inc denied
      try: source.disconnect()
      except ValueError as error:
        if error.msg == guard: inc denied
      try: UriDropSite().disconnect()
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard pad.onUriDrop(proc (value: UriDrop) = discard)
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 5
    check source.connected and source.uris == @["urn:original"]
