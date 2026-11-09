# No native encoding/decoding, file work, realized widgets, selections or input.
import std/unittest
import gtk2
import headers/gdk2pixbuf as p
import headers/glib2 as g
static:
  var buffer: cstring
  var size: g.gsize
  var error: ptr g.GError
  doAssert sizeof(g.gsize) == sizeof(int)
  doAssert typeof(p.save_to_bufferv(default(p.PPixbuf), addr buffer, addr size,
    "png", nil, nil, addr error)) is g.gboolean
suite "pure owning PNG byte values before GTK initialization":
  test "default empty, copied byte access, no native lifetime":
    let value = default(PngBytes)
    let alias = value
    var bytes = value.bytes
    bytes.add(255)
    check value.isEmpty and value.len == 0 and value.bytes.len == 0
    check alias.bytes.len == 0 and bytes == @[255'u8]
gtk2.init()
suite "PNG byte encoding pre-native validation":
  test "negative bounds and empty handles reject without calling encoder":
    expect ValueError: discard default(Pixbuf).encodePng()
    let image = newPixbuf(2, 3)
    expect ValueError: discard image.encodePng(-1)
    expect ValueError: discard image.encodePng(low(int))
    check image.width == 2 and image.height == 3
  test "pure functions can use values but reject encoding before bounds/handles/native work":
    let image = newPixbuf(2, 3)
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var calls, denied, pure = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      let value = default(PngBytes)
      if value.isEmpty and value.len == 0 and value.bytes.len == 0: inc pure
      try: discard image.encodePng()
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard default(Pixbuf).encodePng(-1)
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 2 and pure == calls
