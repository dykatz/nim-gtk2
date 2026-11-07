# Explicit isolated display: real tag inheritance/removal painting, no fake input.
import std/[os, unittest]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/gdk2pixbuf as pix
import headers/pango as p
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Tag rendering requires an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "tag rendering did not settle")
proc image(host: ui.OffscreenWindow): string =
  drain()
  let pb = host.pixbuf
  let data = cast[ptr UncheckedArray[uint8]](pix.get_pixels(pb.raw))
  let stride = pix.get_rowstride(pb.raw).int
  let columns = pb.width * pix.get_n_channels(pb.raw).int
  result = newString(columns * pb.height)
  for y in 0..<pb.height: copyMem(addr result[y * columns], addr data[y * stride], columns)
proc weight(view: ui.TextView): int =
  let values = n.get_default_attributes(view.raw)
  defer: n.unref(values)
  var it: n.TTextIter
  n.get_iter_at_offset(view.buffer.raw, addr it, 1)
  doAssert g.toBool(n.get_attributes(addr it, values))
  p.get_weight(values.font).int
ui.init()
suite "native tag override, priority and membership":
  test "unset differs from false; priority follows native metadata, removal repaints":
    let host = newOffscreenWindow()
    defer: host.destroy()
    let b = newTextBuffer("Native tag inheritance λ🙂")
    let low = b.createTag("low")
    let top = b.createTag("top")
    low.bold = true
    low.underline = true
    top.bold = false
    top.underline = false
    b.applyTag(low, 0, b.characterCount)
    b.applyTag(top, 0, b.characterCount)
    let view = newTextView(b)
    view.cursorVisible = false
    view.editable = false
    view.setSizeRequest(420, 100)
    host.add(view)
    host.showAll()
    let plain = host.image()
    check view.weight() == 400
    top.clearBold()
    top.clearUnderline()
    let inherited = host.image()
    check inherited != plain and view.weight() == 700
    check b.hasTag(top, 1) # Unsetting a property does not remove its ranges.
    top.bold = false
    top.underline = false
    check host.image() == plain and view.weight() == 400
    low.priority = 1
    check low.priority == 1 and top.priority == 0 and view.weight() == 700
    # Native priority alone emits no style invalidation; do not promise repaint
    # or fake one via rebinding, detach/reapply or synthetic table signals.
    low.priority = 0
    check top.priority == 1 and view.weight() == 400
    b.deleteTag(top) # Actual application removal, not a priority-cache workaround.
    check host.image() == inherited and view.weight() == 700
    expect ValueError: discard top.priority
    expect ValueError: discard b.hasTag(top, 1)
    check b.text == "Native tag inheritance λ🙂"
  test "shared table styles/removal reach separate buffers; GTK unregisters closed peers":
    let host = newOffscreenWindow()
    defer: host.destroy()
    let b = newTextBuffer("Shared table λ🙂")
    let tag = b.createTag("shared")
    let table = n.get_tag_table(b.raw)
    var peer = n.text_buffer_new(table) # Actual initial construction, never rebinding.
    defer:
      if peer != nil: g.g_object_unref(peer)
    n.set_text(peer, "Shared table λ🙂", -1)
    var first, last: n.TTextIter
    n.get_bounds(peer, addr first, addr last)
    n.apply_tag(peer, tag.raw, addr first, addr last)
    b.applyTag(tag, 0, b.characterCount)
    let stack = newVBox()
    let view = newTextView(b)
    view.editable = false
    view.cursorVisible = false
    view.setSizeRequest(420, 100)
    stack.packStart(view)
    let rawPeerView = n.text_view_new(peer)
    n.set_editable(cast[n.PTextView](rawPeerView), g.gbool(false))
    n.set_cursor_visible(cast[n.PTextView](rawPeerView), g.gbool(false))
    n.set_size_request(rawPeerView, 420, 100)
    n.pack_start(stack.raw, rawPeerView, g.gbool(true), g.gbool(true), 0)
    host.add(stack)
    host.showAll()
    let plain = host.image()
    tag.bold = true
    let styled = host.image()
    let middle = plain.len div 2
    check styled.len == plain.len
    check styled[0..<middle] != plain[0..<middle]
    check styled[middle..^1] != plain[middle..^1]
    b.deleteTag(tag)
    check host.image() == plain
    n.get_iter_at_offset(peer, addr first, 1)
    check not g.toBool(n.has_tag(addr first, tag.raw))
    var peerFinal = 0
    proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
    g.weak_ref(cast[g.PGObject](peer), gone, addr peerFinal)
    n.destroy(rawPeerView) # Parent owns widget; GTK releases its buffer reference.
    g.g_object_unref(peer)
    peer = nil
    check peerFinal == 1
    let remaining = b.createTag("after-peer")
    remaining.bold = true
    b.applyTag(remaining, 0, b.characterCount)
    b.deleteTag(remaining) # Native registry must contain only live buffers.
    check host.image().len > 0 and b.text == "Shared table λ🙂"
