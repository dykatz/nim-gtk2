# Hidden configuration only: no realized widgets, drags, selection claims or requests.
import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2pixbuf as p
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
gtk2.init()
suite "copied drag-source Pixbuf icon configuration":
  test "all sources copy without retaining caller images or realizing pads":
    let textPad = newDrawingArea()
    let uriPad = newEventBox()
    let binaryPad = newDrawingArea()
    defer:
      textPad.destroy()
      uriPad.destroy()
      binaryPad.destroy()
    let text = textPad.enableTextDrag("sample")
    let uri = uriPad.enableUriDrag(["urn:example:sample"])
    let binary = binaryPad.enableBinaryDrag("application/vnd.example.sample", [0'u8, 255])
    var freed = 0
    block:
      let original = newPixbuf(13, 11, 0x12345680'u32)
      g.weak_ref(cast[g.PGObject](original.raw), finalized, addr freed)
      text.setIcon(original)
      uri.setIcon(original)
      binary.setIcon(original)
      p.fill(original.raw, 0xff000000'u32)
    check freed == 1
    for pad in [gtk2.Widget(textPad), gtk2.Widget(uriPad), gtk2.Widget(binaryPad)]:
      check not g.toBool(n.get_realized(pad.raw))
    expect ValueError: text.setIcon(default(Pixbuf))
    expect ValueError: uri.setIcon(default(Pixbuf))
    expect ValueError: binary.setIcon(default(Pixbuf))
    text.clearIcon()
    uri.clearIcon()
    binary.clearIcon()
    text.clearIcon()
    check text.connected and uri.connected and binary.connected
    check text.text == "sample" and uri.uris == @["urn:example:sample"]
    check binary.data.bytes == @[0'u8, 255]
    text.disconnect()
    uri.disconnect()
    binary.disconnect()
    expect ValueError: text.clearIcon()
    expect ValueError: uri.clearIcon()
    expect ValueError: binary.clearIcon()
    expect ValueError: text.setIcon(newPixbuf(1, 1))
    expect ValueError: uri.setIcon(newPixbuf(1, 1))
    expect ValueError: binary.setIcon(newPixbuf(1, 1))
  test "tokens/images never retain unparented pads; old tokens cannot affect new sources":
    var pads, images = 0
    block:
      let pad = newEventBox()
      g.weak_ref(cast[g.PGObject](pad.raw), finalized, addr pads)
      let source = pad.enableTextDrag("first")
      let image = newPixbuf(2, 2, 0xabcdef00'u32)
      g.weak_ref(cast[g.PGObject](image.raw), finalized, addr images)
      source.setIcon(image)
      source.disconnect()
      let replacement = pad.enableUriDrag(["urn:replacement"])
      replacement.setIcon(image)
      expect ValueError: source.clearIcon()
      expect ValueError: source.setIcon(image)
      check replacement.connected
    check pads == 1 and images == 1
    block:
      let pad = newDrawingArea()
      g.weak_ref(cast[g.PGObject](pad.raw), finalized, addr pads)
      pad.enableBinaryDrag("application/octet-stream", []).setIcon(newPixbuf(2, 3))
    check pads == 2
  test "all set/clear operations reject pure-function access before copying or teardown":
    let pad = newEventBox()
    let upad = newEventBox()
    let bpad = newEventBox()
    let entry = newEntry("a")
    defer:
      pad.destroy()
      upad.destroy()
      bpad.destroy()
      entry.destroy()
    let text = pad.enableTextDrag("text")
    let uri = upad.enableUriDrag(["urn:test"])
    let binary = bpad.enableBinaryDrag("application/octet-stream", [])
    let image = newPixbuf(2, 3)
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
      deny: text.setIcon(image)
      deny: uri.setIcon(image)
      deny: binary.setIcon(image)
      deny: text.clearIcon()
      deny: uri.clearIcon()
      deny: binary.clearIcon()
      deny: text.disconnect() # Source teardown must not bypass the icon purity guard.
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 7
    text.setIcon(image) # Guard restored.
    uri.setIcon(image)
    binary.setIcon(image)
