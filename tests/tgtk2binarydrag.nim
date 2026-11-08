# Configuration only: no realization, ownership changes, requests or input.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
const mime = "application/vnd.example.binary-pad"
type CaptureObj = object
  freed: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.freed[]
type Capture = ref CaptureObj
proc watch(w: gtk2.Widget, freed, policyFreed: ptr int): BinaryDropSite =
  let observation = Capture(freed: freed)
  let policy = Capture(freed: policyFreed)
  let accept: BinaryDropPredicate = proc (value: BinaryDrop): bool =
    discard policy.freed
    true
  let observer = proc (value: BinaryDrop) = discard observation.freed
  w.onBinaryDrop(mime, observer, accept = accept)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
gtk2.init()
suite "unrealized binary COPY pad configuration":
  test "immutable copied source values, fixed MIME and atomic invalid updates":
    let pad = newDrawingArea()
    defer: pad.destroy()
    var input = @[0'u8, 255, 128]
    let source = pad.enableBinaryDrag(mime, input)
    input[0] = 42
    var copy = source.data.bytes
    copy[0] = 42
    check source.data.bytes == @[0'u8, 255, 128]
    expect ValueError: source.data = newBinaryData("application/octet-stream", [1'u8])
    expect ValueError: source.data = default(BinaryData)
    check source.data.bytes == @[0'u8, 255, 128]
    source.data = newBinaryData(mime, [])
    check source.data.len == 0
    let site = pad.onBinaryDrop(mime, proc (value: BinaryDrop) = discard, maxBytes = 0)
    check site.connected and source.connected and not site.draining
    check not g.toBool(n.get_realized(cast[n.PWidget](pad.raw)))
    source.disconnect()
    site.disconnect()
    site.disconnect()
    check not source.connected and not site.connected and not site.draining
    expect ValueError: discard source.data
  test "validation, exact pad types, independent directions and text/URI/native conflicts":
    let pad = newEventBox()
    defer: pad.destroy()
    let observer = proc (value: BinaryDrop) = discard
    expect ValueError: discard pad.enableBinaryDrag(default(BinaryData))
    expect ValueError: discard pad.onBinaryDrop("text/plain", observer)
    expect ValueError: discard pad.onBinaryDrop(mime, nil)
    for bad in [-1, high(g.gint).int]:
      expect ValueError: discard pad.onBinaryDrop(mime, observer, maxBytes = bad)
    let entry = newEntry()
    defer: entry.destroy()
    expect ValueError: discard entry.enableBinaryDrag(mime, [])
    let source = pad.enableBinaryDrag(mime, [])
    expect ValueError: discard pad.enableTextDrag("text")
    expect ValueError: discard pad.enableUriDrag(["urn:example:data"])
    expect ValueError: discard pad.enableBinaryDrag(mime, [])
    let site = pad.onBinaryDrop(mime, observer)
    expect ValueError: discard pad.onTextDrop(proc (value: TextDrop) = discard)
    expect ValueError: discard pad.onUriDrop(proc (value: UriDrop) = discard)
    source.disconnect()
    site.disconnect()
    let text = pad.enableTextDrag("text")
    expect ValueError: discard pad.enableBinaryDrag(mime, [])
    text.disconnect()
    let uri = pad.onUriDrop(proc (value: UriDrop) = discard)
    expect ValueError: discard pad.onBinaryDrop(mime, observer)
    uri.disconnect()
  test "tokens do not revoke sites; disconnect/destruction clear both capture roots":
    var freed, policyFreed = 0
    let pad = newEventBox()
    block: discard pad.watch(addr freed, addr policyFreed)
    check freed == 0 and policyFreed == 0
    pad.destroy()
    check freed == 1 and policyFreed == 1
    let other = newDrawingArea()
    defer: other.destroy()
    let site = other.watch(addr freed, addr policyFreed)
    site.disconnect()
    check freed == 2 and policyFreed == 2
    var final = 0
    block:
      let orphan = newDrawingArea()
      g.weak_ref(cast[g.PGObject](orphan.raw), finalized, addr final)
      discard orphan.enableBinaryDrag(mime, [0'u8])
      discard orphan.watch(addr freed, addr policyFreed)
    check final == 1 and freed == 3 and policyFreed == 3
  test "pure functions reject configuration, updates and teardown before native work":
    let pad = newEventBox()
    defer: pad.destroy()
    let source = pad.enableBinaryDrag(mime, [0'u8])
    let site = pad.onBinaryDrop(mime, proc (value: BinaryDrop) = discard)
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var calls, denied = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      try: discard pad.enableBinaryDrag(mime, [])
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard pad.onBinaryDrop(mime, proc (value: BinaryDrop) = discard)
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard source.data
      except ValueError as error:
        if error.msg == guard: inc denied
      try: source.data = newBinaryData(mime, [])
      except ValueError as error:
        if error.msg == guard: inc denied
      try: source.disconnect()
      except ValueError as error:
        if error.msg == guard: inc denied
      try: site.disconnect()
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 6
    check site.connected and source.connected
