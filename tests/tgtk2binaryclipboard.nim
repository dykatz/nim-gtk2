# No desktop ownership changes, requests, realization or synthetic input.
import std/[unittest, strutils]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
static:
  doAssert not compiles(default(BinaryClipboardOffer).destroy())
gtk2.init()
suite "copied opaque binary values without desktop transfers":
  test "byte and MIME getters cannot mutate copied storage; empty is distinct from invalid target":
    var input = @[0'u8, 255, 128, 0, 13, 10]
    let value = newBinaryData("application/vnd.example.bytes+bin", input)
    input[0] = 42
    var copy = value.bytes
    copy[1] = 42
    copy.add(9)
    var mime = value.mime
    mime[0] = 'X'
    check value.bytes == @[0'u8, 255, 128, 0, 13, 10] and value.len == 6
    check value.mime == "application/vnd.example.bytes+bin"
    check newBinaryData("application/octet-stream", []).len == 0
    check default(BinaryData).bytes.len == 0
    check newBinaryData("application/" & repeat('a', 127), []).len == 0
  test "conservative application MIME subset excludes protocol targets, parameters and ambiguous spellings":
    for bad in ["", "application/", "text/plain", "image/png", "TARGETS", "TIMESTAMP", "MULTIPLE", "DELETE", "SAVE_TARGETS", "UTF8_STRING", "application/X-custom", "Application/octet-stream", "application/a b", "application/a;b=c", "application/a/b", "application/a\0b", "application/λ", "application/.name", "application/x-gtk-text-buffer-rich-text", "application/x-gdk-test", "application/x-color", "application/x-rootwindow-drop", "application/" & repeat('a', 128)]:
      expect ValueError: discard newBinaryData(bad, [0'u8])
    for good in ["application/octet-stream", "application/json", "application/vnd.example+bin", "application/x-example.data-v1"]:
      check newBinaryData(good, [255'u8]).bytes == @[255'u8]
  test "invalid handles/default values and repeated empty-token clear never publish":
    check not BinaryClipboardOffer().active
    BinaryClipboardOffer().clear()
    BinaryClipboardOffer().clear()
    expect ValueError: discard default(Clipboard).offerBinary(newBinaryData("application/octet-stream", []))
    expect ValueError: discard getClipboard().offerBinary(default(BinaryData))
  test "pure functions permit value construction but deny both offer overloads and clear":
    let entry = newEntry("a")
    defer: entry.destroy()
    let completion = newEntryCompletion(["alpha"])
    defer: completion.close()
    entry.completion = completion
    var calls, denied = 0
    const guard = "GTK handle access is forbidden inside a synchronous model function; use copied row values"
    completion.setMatch(proc (input: CompletionMatchInput): bool =
      inc calls
      let value = newBinaryData("application/octet-stream", [0'u8, 255])
      check value.bytes == @[0'u8, 255]
      try: discard default(Clipboard).offerBinary(value)
      except ValueError as error:
        if error.msg == guard: inc denied
      try: discard default(Clipboard).offerBinary("application/octet-stream", [0'u8])
      except ValueError as error:
        if error.msg == guard: inc denied
      try: BinaryClipboardOffer().clear()
      except ValueError as error:
        if error.msg == guard: inc denied
      true)
    completion.refilter()
    check calls > 0 and denied == calls * 3
    check not g.toBool(n.get_realized(cast[n.PWidget](entry.raw)))
