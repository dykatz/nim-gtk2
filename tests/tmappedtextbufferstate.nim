# Explicit isolated display: realized views may claim PRIMARY even while unmapped.
import std/[os, unittest]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
import headers/gdk2pixbuf as pix
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("TextBuffer state rendering requires an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "buffer rendering did not settle")
proc image(host: ui.OffscreenWindow): string =
  drain()
  let pb = host.pixbuf
  let data = cast[ptr UncheckedArray[uint8]](pix.get_pixels(pb.raw))
  let stride = pix.get_rowstride(pb.raw).int
  let columns = pb.width * pix.get_n_channels(pb.raw).int
  result = newString(columns * pb.height)
  for y in 0..<pb.height: copyMem(addr result[y * columns], addr data[y * stride], columns)
ui.init()
suite "native buffer state in shared realized views":
  test "dirty flags do not edit/redraw content; Unicode selection and edits stay native":
    let host = newOffscreenWindow()
    defer: host.destroy()
    let b = newTextBuffer("Aλ🙂界Z\nLine two")
    let stack = newVBox()
    let first = newTextView(b)
    let second = newTextView(b)
    for view in [first, second]:
      view.cursorVisible = false
      view.editable = false
      view.setSizeRequest(420, 100)
      stack.packStart(view)
    host.add(stack)
    host.showAll()
    let plain = host.image()
    var dirty, changed = 0
    b.onModifiedChanged(proc () = inc dirty)
    b.onChanged(proc () =
      doAssert b.modified
      inc changed)
    defer: b.disconnectSignals()
    b.modified = true
    b.modified = false
    check host.image() == plain and changed == 0 and dirty == 2
    b.selectRange(4, 1)
    check b.cursorOffset == 1 and b.selectionBounds == (true, 1, 4)
    check not b.modified and host.image() != plain
    b.cursorOffset = 2
    check not b.hasSelection and host.image() == plain
    b.withUserAction:
      b.deleteRange(1, 2)
      b.appendText("!")
    let edited = host.image()
    let middle = plain.len div 2
    check edited.len == plain.len
    check edited[0..<middle] != plain[0..<middle]
    check edited[middle..^1] != plain[middle..^1]
    check first.buffer.raw == b.raw and second.buffer.raw == b.raw
    check first.text == "A🙂界Z\nLine two!" and second.text == first.text
    check changed == 2 and dirty == 3
    b.modified = false
    let locked = b.createTag()
    locked.editable = false
    b.applyTag(locked, 0, b.characterCount)
    b.selectRange(0, 2)
    let before = b.text
    check b.deleteSelection(interactive = true) # Selection existed; no permitted deletion.
    check b.text == before and not b.modified and changed == 2
