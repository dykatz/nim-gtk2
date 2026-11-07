# Isolated rendering/default-style snapshots; no selection requests or fake input.
import std/[os, unittest]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/gdk2pixbuf as pix
import headers/pango as p
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Attribute rendering requires an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "attribute rendering did not settle")
proc image(host: ui.OffscreenWindow): string =
  drain()
  let pb = host.pixbuf
  let data = cast[ptr UncheckedArray[uint8]](pix.get_pixels(pb.raw))
  let stride = pix.get_rowstride(pb.raw).int
  let columns = pb.width * pix.get_n_channels(pb.raw).int
  result = newString(columns * pb.height)
  for y in 0..<pb.height: copyMem(addr result[y * columns], addr data[y * stride], columns)
ui.init()
suite "native effective style and detached attribute ownership":
  test "tag changes repaint, detached snapshots do not mutate views and survive teardown":
    let host = newOffscreenWindow()
    defer: host.destroy()
    let b = newTextBuffer("Attributes λ🙂 style")
    let view = newTextView(b)
    view.cursorVisible = false
    view.editable = false
    view.setSizeRequest(400, 100)
    let tag = b.createTag("style")
    tag.bold = true
    tag.underline = true
    b.applyTag(tag, 0, b.characterCount)
    host.add(view)
    host.showAll()
    let styled = host.image()
    let snapshot = n.get_default_attributes(view.raw)
    defer: n.unref(snapshot)
    var it: n.TTextIter
    n.get_iter_at_offset(b.raw, addr it, 2)
    check g.toBool(n.get_attributes(addr it, snapshot))
    require snapshot.font != nil
    check p.get_weight(snapshot.font) == p.WEIGHT_BOLD
    let copy = n.copy(snapshot)
    defer: n.unref(copy)
    check copy != snapshot and copy.font != snapshot.font
    tag.bold = false
    tag.underline = false
    let plain = host.image()
    check plain != styled
    check p.get_weight(snapshot.font) == p.WEIGHT_BOLD
    snapshot.left_margin = 170 # A detached value is not a live tag/view style.
    check host.image() == plain
    let alias = n.reference(copy)
    check alias == copy
    n.unref(alias)
    host.destroy()
    check view.isDestroyed and p.get_weight(copy.font) == p.WEIGHT_BOLD
    check b.text == "Attributes λ🙂 style"
