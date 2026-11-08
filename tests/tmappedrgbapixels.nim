# Native offscreen rendering on an isolated opted-in display; no codecs or input.
import std/[os, unittest]
import gtk2
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("RGBA pixel rendering requires isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "RGBA rendering did not settle")
proc finalized(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc rendered(host: gtk2.OffscreenWindow): RgbaPixels =
  drain()
  host.pixbuf.rgbaPixels()
gtk2.init()
suite "copied RGBA8 actual native image rendering":
  test "exact opaque channel order, independent historical snapshots and native-owned image lifetime":
    let host = newOffscreenWindow(4, 3)
    defer: host.destroy()
    let view = newImage()
    host.add(view)
    var bytes: seq[byte]
    for row in 0..<3:
      for column in 0..<4:
        bytes.add([byte(17 + column * 53), byte(23 + row * 71), byte(129 - column * 31), 255'u8])
    let value = newRgbaPixels(4, 3, bytes)
    var freed = 0
    block:
      let image = newPixbuf(value)
      g.weak_ref(cast[g.PGObject](image.raw), finalized, addr freed)
      view.pixbuf = image
    check freed == 0 # Native GtkImage, not caller or pure value, owns remaining source ref.
    bytes[0] = 99
    host.showAll()
    let before = host.rendered()
    check before.width == 4 and before.height == 3 and before.bytes == value.bytes
    var edited = before.bytes
    for i in countup(0, edited.high, 4):
      edited[i] = 231
      edited[i+1] = 35
      edited[i+2] = 97
    view.pixbuf = newPixbuf(4, 3, edited)
    check freed == 1
    let after = host.rendered()
    check after.bytes == edited and after.bytes != before.bytes
    check before.bytes == value.bytes
    var local = after.bytes
    local[0] = 0
    check host.rendered().bytes == edited # Returned sequences never alias native display storage.
    let retained = after
    host.destroy()
    check retained.bytes == edited and before.bytes == value.bytes
