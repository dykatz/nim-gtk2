# Isolated native mark rendering; no selection requests or synthetic input.
import std/[os, unittest]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/gdk2pixbuf as pix
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Mark rendering requires an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "mark rendering did not settle")
proc image(host: ui.OffscreenWindow): string =
  drain()
  let p = host.pixbuf
  let data = cast[ptr UncheckedArray[uint8]](pix.get_pixels(p.raw))
  let stride = pix.get_rowstride(p.raw).int
  let columns = p.width * pix.get_n_channels(p.raw).int
  result = newString(columns * p.height)
  for y in 0..<p.height: copyMem(addr result[y * columns], addr data[y * stride], columns)
ui.init()
suite "native mark rendering and lifetime":
  test "public mark visibility/movement/deletion redraw in a native text view":
    let host = newOffscreenWindow()
    defer: host.destroy()
    let b = newTextBuffer("Native λ🙂 mark cursor")
    let view = newTextView(b)
    view.cursorVisible = false
    view.editable = false
    view.setSizeRequest(380, 90)
    let mark = b.createMark(5, "visible mark")
    host.add(view)
    host.showAll()
    let baseline = host.image()
    mark.visible = true
    check host.image() != baseline
    check mark.offset == 5 and mark.buffer.raw == b.raw
    b.moveMark(mark, 9)
    let moved = host.image()
    check moved != baseline
    mark.visible = false
    check host.image() == baseline
    mark.visible = true
    b.deleteMark(mark)
    check mark.deleted and host.image() == baseline
    check b.text == "Native λ🙂 mark cursor" and not b.modified
    expect ValueError: view.scrollToMark(mark)
  test "gravity survives edits with two native views and explicit owner getter":
    let host = newOffscreenWindow()
    defer: host.destroy()
    let b = newTextBuffer("λ🙂abc")
    let box = newHBox()
    let first = newTextView(b)
    let second = newTextView(b)
    first.cursorVisible = false
    second.cursorVisible = false
    box.packStart(first)
    box.packStart(second)
    host.add(box)
    let left = b.createMark(1, leftGravity = true)
    let right = b.createMark(1, leftGravity = false)
    host.showAll()
    discard host.image()
    left.visible = true
    right.visible = true
    b.insertText(1, "界🙂")
    discard host.image()
    check left.offset == 1 and right.offset == 3
    check left.buffer.raw == b.raw and right.buffer.raw == b.raw
    b.deleteMark(left)
    b.deleteMark(right)
    discard host.image()
    check left.deleted and right.deleted and b.text == "λ界🙂🙂abc"
