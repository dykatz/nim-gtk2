# Public geometry on an isolated realized view, never private validation/reset.
import std/[os, strutils, unittest]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2 as gd
if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1":
  quit("Text geometry requires an isolated display and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
proc drain() =
  for i in 0..<512:
    gd.window_process_all_updates()
    if n.events_pending() == 0: return
    discard n.main_iteration_do(g.gbool(false))
  raise newException(ValueError, "text geometry did not settle")
ui.init()
suite "public text geometry without BTree access":
  test "wrapped display geometry differs from logical lines, transforms round-trip, marks survive edits":
    let host = newOffscreenWindow()
    defer: host.destroy()
    let b = newTextBuffer("λ🙂 " & repeat("native public geometry ", 10) & "\nSecond logical line\n")
    let mark = b.createMark(0, "stable", leftGravity = false)
    let view = newTextView(b)
    view.wrapMode = wrapWordChar
    view.cursorVisible = false
    view.editable = false
    view.setSizeRequest(320, 220)
    host.add(view)
    host.showAll()
    drain()
    check b.lineCount == 3
    var it, hit: n.TTextIter
    n.get_iter_at_mark(b.raw, addr it, mark.raw)
    var rect, visible: gd.TRectangle
    n.get_iter_location(view.raw, addr it, addr rect)
    n.get_visible_rect(view.raw, addr visible)
    check rect.height > 0 and visible.width > 0 and visible.height > 0
    var y, height: g.gint
    n.get_line_yrange(view.raw, addr it, addr y, addr height)
    check height > rect.height # One logical paragraph wraps into multiple display lines.
    var top: g.gint
    n.get_line_at_y(view.raw, addr hit, rect.y + rect.height div 2, addr top)
    check n.get_line(addr hit) == 0 and top <= rect.y
    n.get_iter_at_location(view.raw, addr hit, rect.x, rect.y + rect.height div 2)
    check n.get_line(addr hit) == 0
    var wx, wy, bx, by: g.gint
    n.buffer_to_window_coords(view.raw, n.TEXT_WINDOW_TEXT, rect.x - 17, rect.y - 19, addr wx, addr wy)
    n.window_to_buffer_coords(view.raw, n.TEXT_WINDOW_TEXT, wx, wy, addr bx, addr by)
    check bx == rect.x - 17 and by == rect.y - 19
    b.insertText(0, "prefix ") # Actual document edit, not invalidation/stamp manipulation.
    drain()
    # Discard old iterators and reacquire from a stable native mark after mutation.
    n.get_iter_at_mark(b.raw, addr it, mark.raw)
    check n.get_offset(addr it) == 7 and mark.offset == 7
    n.get_iter_location(view.raw, addr it, addr rect)
    check rect.height > 0 and view.buffer.raw == b.raw and b.lineCount == 3
    view.scrollToMark(mark)
    drain()
    check g.toBool(n.get_realized(cast[n.PWidget](view.raw)))
