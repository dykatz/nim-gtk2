# Explicit native PNG encode/decode of trusted tiny fixtures in a private temp directory.
# No claims/input/simulated callbacks; opt-in isolates native codec/file regressions.
import std/[os, tempfiles, unittest, exitprocs]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2pixbuf as p
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("PNG file tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc rawError(image: Pixbuf, path: string): tuple[domain: g.TGQuark, code: int, message: string] =
  var error: ptr g.GError
  let ok = when defined(windows):
    p.savev_utf8(image.raw, path.cstring, "png", nil, nil, addr error)
  else:
    p.savev(image.raw, path.cstring, "png", nil, nil, addr error)
  doAssert not g.toBool(ok) and error != nil
  defer: g.g_error_free(error)
  (error.domain, error.code.int, $error.message)
const signature = "\x89PNG\r\n\x1a\n"
gtk2.init()
let directory = createTempDir("nim-gtk2-png-", "")
addExitProc(proc () = removeDir(directory))
suite "explicit native PNG file encoding":
  test "fixed PNG despite extension, exact straight RGBA, overwrite, caller release and retained snapshots":
    let path = directory / "copied-λ-🙂.not-png"
    let value = newRgbaPixels(3, 2, [1'u8, 2, 3, 0, 255, 128, 0, 127, 19, 57, 211, 255,
      0, 255, 128, 1, 250, 2, 179, 128, 3, 4, 5, 254])
    var freed = 0
    block:
      let image = newPixbuf(value)
      g.weak_ref(cast[g.PGObject](image.raw), finalized, addr freed)
      image.savePng(path)
      check image.rgbaPixels().bytes == value.bytes
    check freed == 1 # No native/module/file pin left on a successful call.
    check readFile(path)[0..<signature.len] == signature
    let loaded = loadPixbuf(path) # Only our own known tiny encoded fixture is decoded.
    check loaded.width == 3 and loaded.height == 2 and loaded.hasAlpha
    let before = loaded.rgbaPixels()
    check before.bytes == value.bytes
    let replacement = newPixbuf(1, 1, 0xabcdef80'u32)
    replacement.savePng(path) # Native replaces/truncates existing path, without a dialog or rollback.
    let after = loadPixbuf(path)
    check after.width == 1 and after.height == 1
    check after.rgbaPixels().bytes == @[0xab'u8, 0xcd, 0xef, 0x80]
    check loaded.rgbaPixels().bytes == before.bytes # Saving another image does not mutate old images/values.
    var allBytes: seq[byte]
    for i in 0..255: allBytes.add(byte(i))
    let allPath = directory / "all-bytes"
    newPixbuf(8, 8, allBytes).savePng(allPath)
    check loadPixbuf(allPath).rgbaPixels().bytes == allBytes
    when defined(posix):
      let nativeBytesPath = directory / "native-byte-\xff.png"
      replacement.savePng(nativeBytesPath) # POSIX filenames are native bytes, not forced UTF-8.
      check loadPixbuf(nativeBytesPath).rgbaPixels().bytes == replacement.rgbaPixels().bytes
  test "actual native RGB buffer encodes as RGB without inventing alpha or mutating source":
    let native = p.pixbuf_new(p.COLORSPACE_RGB, g.gbool(false), 8, 3, 2)
    require native != nil
    defer: g.g_object_unref(native)
    p.fill(native, 0x123456ff'u32)
    let holder = newImage()
    defer: holder.destroy()
    n.set_from_pixbuf(holder.raw, native)
    let image = holder.pixbuf
    let path = directory / "rgb.png"
    image.savePng(path)
    let loaded = loadPixbuf(path)
    check not image.hasAlpha and not loaded.hasAlpha
    check loaded.rgbaPixels().bytes == image.rgbaPixels().bytes
  test "real GError domain/code/message match native failures and remain copied after reuse":
    let image = newPixbuf(2, 3)
    let fileParent = directory / "ordinary-file"
    writeFile(fileParent, "parent sentinel")
    var messages: seq[string]
    for path in [directory / "missing" / "image.png", directory, fileParent / "child.png", ""]:
      let expected = rawError(image, path)
      try:
        image.savePng(path)
        check false
      except gtk2.PixbufError as error:
        check error.domain == expected.domain and error.code == expected.code
        check error.msg == expected.message and error.msg.len > 0
        messages.add(error.msg)
      check readFile(fileParent) == "parent sentinel"
    for message in messages: check message.len > 0
    let recovery = directory / "after-errors.png"
    image.savePng(recovery)
    check loadPixbuf(recovery).rgbaPixels().bytes == image.rgbaPixels().bytes
  test "pre-I/O rejection preserves existing file and unsuccessful calls release pins":
    let path = directory / "sentinel.png"
    writeFile(path, "must remain untouched")
    expect ValueError: default(Pixbuf).savePng(path)
    check readFile(path) == "must remain untouched"
    var freed = 0
    block:
      let image = newPixbuf(1, 1)
      g.weak_ref(cast[g.PGObject](image.raw), finalized, addr freed)
      expect ValueError: image.savePng(path & "\0ignored")
      check readFile(path) == "must remain untouched"
      try:
        image.savePng(directory / "absent" / "not-written.png")
        check false
      except gtk2.PixbufError: discard
    check freed == 1
    check readFile(path) == "must remain untouched"
