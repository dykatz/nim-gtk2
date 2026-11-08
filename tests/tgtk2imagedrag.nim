# Configuration only, no input, native decoding, realization or selection claims.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2pixbuf as p
type CaptureObj = object
  freed: ptr int
proc `=destroy`(c: var CaptureObj) = inc c.freed[]
type Capture = ref CaptureObj
proc watch(w: gtk2.Widget, freed, policyFreed: ptr int): ImageDropSite =
  let observerCapture = Capture(freed: freed)
  let policyCapture = Capture(freed: policyFreed)
  let observer = proc (value: ImageDrop) = discard observerCapture.freed
  let accept: ImageDropPredicate = proc (value: ImageDropInfo): bool =
    discard policyCapture.freed
    true
  w.onImageDrop(true, observer, accept = accept)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
static:
  doAssert not compiles(default(ImageDragSource).image)
  doAssert not compiles(default(ImageDropInfo).image)
gtk2.init()
suite "explicitly trusted image COPY pad configuration":
  test "private payload/icon copies, atomic invalid updates and independent directions":
    let pad = newDrawingArea()
    defer: pad.destroy()
    var freed = 0
    var source: ImageDragSource
    block:
      let image = newPixbuf(3, 2, 0x12345680'u32)
      g.weak_ref(cast[g.PGObject](image.raw), finalized, addr freed)
      source = pad.enableImageDrag(image)
      source.setIcon(image)
      p.fill(image.raw, 0xff000000'u32)
    check freed == 1 and source.connected
    expect ValueError: source.setImage(default(Pixbuf))
    source.setImage(newPixbuf(1, 1))
    source.clearIcon()
    let site = pad.onImageDrop(true, proc (value: ImageDrop) = discard, maxPixels = 0)
    check site.connected and not site.draining and not g.toBool(n.get_realized(pad.raw))
    site.disconnect()
    source.disconnect()
    source.disconnect()
    expect ValueError: source.setImage(newPixbuf(1, 1))
    expect ValueError: source.setIcon(newPixbuf(1, 1))
  test "trust, bounds, callback, exact pads and cross-family native site conflicts":
    let pad = newEventBox()
    defer: pad.destroy()
    let observer = proc (value: ImageDrop) = discard
    expect ValueError: discard pad.onImageDrop(false, observer)
    expect ValueError: discard pad.onImageDrop(true, nil)
    for invalid in [-1, high(g.gint).int div 4 + 1]:
      expect ValueError: discard pad.onImageDrop(true, observer, maxPixels = invalid)
    expect ValueError: discard pad.enableImageDrag(default(Pixbuf))
    let entry = newEntry()
    defer: entry.destroy()
    expect ValueError: discard entry.enableImageDrag(newPixbuf(1, 1))
    expect ValueError: discard entry.onImageDrop(true, observer)
    let source = pad.enableImageDrag(newPixbuf(1, 1))
    expect ValueError: discard pad.enableTextDrag("text")
    expect ValueError: discard pad.enableUriDrag(["urn:test"])
    expect ValueError: discard pad.enableBinaryDrag("application/octet-stream", [])
    expect ValueError: discard pad.enableImageDrag(newPixbuf(1, 1))
    let site = pad.onImageDrop(true, observer)
    expect ValueError: discard pad.onTextDrop(proc (value: TextDrop) = discard)
    expect ValueError: discard pad.onUriDrop(proc (value: UriDrop) = discard)
    expect ValueError: discard pad.onBinaryDrop("application/octet-stream", proc (value: BinaryDrop) = discard)
    source.disconnect()
    site.disconnect()
    let text = pad.enableTextDrag("text")
    expect ValueError: discard pad.enableImageDrag(newPixbuf(1, 1))
    text.disconnect()
    let uri = pad.onUriDrop(proc (value: UriDrop) = discard)
    expect ValueError: discard pad.onImageDrop(true, observer)
    uri.disconnect()
  test "dropped tokens do not revoke; weak pads and prompt observer/policy teardown":
    var freed, policies, pads = 0
    var retained: ImageDragSource
    block:
      let pad = newEventBox()
      g.weak_ref(cast[g.PGObject](pad.raw), finalized, addr pads)
      retained = pad.enableImageDrag(newPixbuf(1, 2))
      discard pad.watch(addr freed, addr policies)
    check pads == 1 and freed == 1 and policies == 1 and not retained.connected
    let other = newDrawingArea()
    defer: other.destroy()
    let site = other.watch(addr freed, addr policies)
    site.disconnect()
    check freed == 2 and policies == 2
  test "pure guards cover attachment, pixels, icons and teardown before work":
    let pad = newEventBox()
    let entry = newEntry("a")
    defer:
      pad.destroy()
      entry.destroy()
    let image = newPixbuf(2, 3)
    let source = pad.enableImageDrag(image)
    let site = pad.onImageDrop(true, proc (value: ImageDrop) = discard)
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var calls, denied = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    template deny(body: untyped) =
      try: body
      except ValueError as error:
        if error.msg == guard: inc denied
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      deny: discard pad.enableImageDrag(image)
      deny: discard pad.onImageDrop(false, nil)
      deny: source.setImage(image)
      deny: source.setIcon(image)
      deny: source.clearIcon()
      deny: source.disconnect()
      deny: site.disconnect()
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 7
    check source.connected and site.connected
