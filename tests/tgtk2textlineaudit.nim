# No views, PRIMARY, selection requests, private lines, segments or layout calls.
import std/[unittest, macros, strutils]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
macro rejectPrivateLines(): untyped =
  result = newStmtList()
  for name in ["line_segment_split", "char_segment_new", "char_segment_new_from_two_strings", "toggle_segment_new", "pixbuf_segment_new", "widget_segment_new", "toggle_segment_check_func", "change_node_toggle_count", "widget_segment_add", "widget_segment_remove", "widget_segment_ref", "widget_segment_unref", "anchored_child_get_layout"]:
    let symbol = newDotExpr(ident"n", ident(name))
    result.add quote do:
      static: doAssert not declared(`symbol`)
  # The 26 former line calls have their first opaque pointer type retained.
  const specs = ["get_number:PTextLine", "char_has_tag:PTextLine,PTextBTree,gint,PTextTag",
    "byte_has_tag:PTextLine,PTextBTree,gint,PTextTag", "is_last:PTextLine,PTextBTree",
    "contains_end_iter:PTextLine,PTextBTree", "next:PTextLine", "next_excluding_last:PTextLine",
    "previous:PTextLine", "add_data:PTextLine,PTextLineData", "remove_data:PTextLine,gpointer",
    "get_data:PTextLine,gpointer", "invalidate_wrap:PTextLine,PTextLineData", "char_count:PTextLine",
    "byte_count:PTextLine", "char_index:PTextLine", "byte_to_segment:PTextLine,gint,Pgint",
    "char_to_segment:PTextLine,gint,Pgint", "byte_to_char_offsets:PTextLine,gint,Pgint,Pgint",
    "char_to_byte_offsets:PTextLine,gint,Pgint,Pgint", "byte_to_any_segment:PTextLine,gint,Pgint",
    "char_to_any_segment:PTextLine,gint,Pgint", "byte_to_char:PTextLine,gint", "char_to_byte:PTextLine,gint",
    "next_could_contain_tag:PTextLine,PTextBTree,PTextTag", "previous_could_contain_tag:PTextLine,PTextBTree,PTextTag",
    "line_data_new:PTextLayout,PTextLine", "width:PTextLineData", "set_width:PTextLineData,guint",
    "valid:PTextLineData", "set_valid:PTextLineData,guint"]
  doAssert specs.len == 30
  for spec in specs:
    let parts = spec.split(':')
    var call = newCall(newDotExpr(ident"n", ident(parts[0])))
    for name in parts[1].split(','):
      let typ = newDotExpr(ident(if name in ["gpointer", "gint", "Pgint", "guint"]: "g" else: "n"), ident(name))
      call.add(newCall(ident"default", typ))
    result.add quote do:
      static: doAssert not compiles(`call`)
  for name in ["bm_TGtkTextLineData_width", "bp_TGtkTextLineData_width", "bm_TGtkTextLineData_valid", "bp_TGtkTextLineData_valid", "TTextTagInfo", "PTextTagInfo", "TTextToggleBody", "PTextToggleBody", "TTextChildBody", "PTextChildBody", "TTextLineSegment", "PTextLineSegment", "TTextLineSegmentClass", "PTextLineSegmentClass", "TTextSegSplitFunc", "PTextSegSplitFunc", "TTextSegDeleteFunc", "TTextSegCleanupFunc", "PTextSegCleanupFunc", "TTextSegLineChangeFunc", "TTextSegCheckFunc", "PTextBTreeNode", "TTextLine", "TTextLineData"]:
    let symbol = newDotExpr(ident"n", ident(name))
    result.add quote do:
      static: doAssert not declared(`symbol`)
rejectPrivateLines()
static:
  doAssert sizeof(n.PTextLine) == sizeof(pointer) and sizeof(n.PTextLineData) == sizeof(pointer)
  doAssert not compiles(default(n.PTextLine).segments)
  doAssert not compiles(default(n.PTextLine).parent)
  doAssert not compiles(default(n.PTextLineData).flag0)
  doAssert not compiles(default(n.PTextLineData).height)
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc includes(list: g.PGSList, p: pointer): bool =
  var item = list
  while item != nil:
    if item.data == p: return true
    item = item.next
ui.init()
suite "public iterators after private line/segment removal":
  test "logical lines count CRLF/code points/bytes, not private line nodes or graphemes":
    let b = newTextBuffer("e\u0301🙂\r\n界\n")
    check b.characterCount == 7 and b.lineCount == 3
    var it: n.TTextIter
    n.get_start_iter(b.raw, addr it)
    check n.get_chars_in_line(addr it) == 5 and n.get_bytes_in_line(addr it) == 9
    check g.toBool(n.forward_to_line_end(addr it)) and n.get_offset(addr it) == 3
    check g.toBool(n.ends_line(addr it))
    n.get_start_iter(b.raw, addr it)
    check g.toBool(n.forward_line(addr it)) and n.get_offset(addr it) == 5
    check n.get_chars_in_line(addr it) == 2 and n.get_bytes_in_line(addr it) == 4
    check b.text == "e\u0301🙂\r\n界\n"
  test "public iterator copy owns storage, not a detached document snapshot":
    let b = newTextBuffer("abcλ")
    var it: n.TTextIter
    n.get_iter_at_offset(b.raw, addr it, 2)
    let copy = n.copy(addr it)
    require copy != nil
    check copy != (addr it) and n.get_offset(copy) == 2
    discard n.forward_char(copy)
    check n.get_offset(copy) == 3 and n.get_offset(addr it) == 2
    n.free(copy) # Owned storage; copying never protects against later mutations.
    let boxed = cast[n.PTextIter](g.g_boxed_copy(n.text_iter_get_type(), addr it))
    require boxed != nil
    check boxed != (addr it) and n.get_offset(boxed) == 2
    g.g_boxed_free(n.text_iter_get_type(), boxed)
  test "heap iterator storage does not retain its native buffer":
    var b = newTextBuffer("abc")
    var it: n.TTextIter
    n.get_start_iter(b.raw, addr it)
    let copy = n.copy(addr it)
    var final = 0
    g.weak_ref(cast[g.PGObject](b.raw), gone, addr final)
    b = default(ui.TextBuffer)
    check final == 1
    n.free(copy) # Free storage only; never inspect the now-invalid copied iterator.
  test "public borrowed mark/toggle elements survive freeing owned list nodes":
    let b = newTextBuffer("abcde")
    let mark = b.createMark(2, "named")
    let tag = b.createTag("style")
    b.applyTag(tag, 1, 4)
    var it: n.TTextIter
    n.get_iter_at_mark(b.raw, addr it, mark.raw)
    let marks = n.get_marks(addr it)
    check marks.includes(cast[pointer](mark.raw))
    g.free(marks)
    n.get_iter_at_offset(b.raw, addr it, 1)
    let starts = n.get_toggled_tags(addr it, g.gbool(true))
    check starts.includes(cast[pointer](tag.raw))
    g.free(starts)
    n.get_iter_at_offset(b.raw, addr it, 4)
    let ends = n.get_toggled_tags(addr it, g.gbool(false))
    check ends.includes(cast[pointer](tag.raw))
    g.free(ends)
    check mark.offset == 2
    tag.bold = true
    b.insertText(0, "λ")
    n.get_iter_at_mark(b.raw, addr it, mark.raw) # Reacquire; never repair old iterator fields.
    check n.get_offset(addr it) == 3
  test "public anchor lifecycle never requires widget-segment references or an embedding view":
    let b = newTextBuffer("ab")
    let anchor = b.createChildAnchor(1)
    let widgets = n.anchor_get_widgets(anchor.raw)
    check widgets == nil
    g.free(widgets)
    check not anchor.deleted and b.slice(0, 3) == "a\uFFFCb"
    b.deleteAnchor(anchor)
    check anchor.deleted and b.text == "ab"
