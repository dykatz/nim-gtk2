# Private entry points are gone. Exercise only public, viewless buffer/iter APIs.
import std/[unittest, macros, strutils]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2pixbuf as pix
macro rejectPrivateTreeCalls(): untyped =
  result = newStmtList()
  # Exact former call signatures, including overloads whose public names survive.
  const specs = [
    "mark_segment_new:PTextBTree,gboolean,cstring",
    "reference:PTextBTree", "unref:PTextBTree", "get_buffer:PTextBTree",
    "get_chars_changed_stamp:PTextBTree", "get_segments_changed_stamp:PTextBTree",
    "segments_changed:PTextBTree", "is_end:PTextBTree,PTextLine,PTextLineSegment,int32,int32",
    "find_line_by_y:PTextBTree,gpointer,gint,Pgint", "find_line_top:PTextBTree,PTextLine,gpointer",
    "add_view:PTextBTree,PTextLayout", "remove_view:PTextBTree,gpointer",
    "invalidate_region:PTextBTree,PTextIter,PTextIter", "get_view_size:PTextBTree,gpointer,Pgint,Pgint",
    "is_valid:PTextBTree,gpointer", "validate:PTextBTree,gpointer,gint,Pgint,Pgint,Pgint",
    "validate_line:PTextBTree,PTextLine,gpointer", "get_line:PTextBTree,gint,Pgint",
    "get_line_no_last:PTextBTree,gint,Pgint", "get_end_iter_line:PTextBTree",
    "get_line_at_char:PTextBTree,gint,Pgint,Pgint", "line_count:PTextBTree", "char_count:PTextBTree",
    "get_iter_at_char:PTextBTree,PTextIter,gint", "get_iter_at_line_char:PTextBTree,PTextIter,gint,gint",
    "get_iter_at_line_byte:PTextBTree,PTextIter,gint,gint", "get_iter_from_string:PTextBTree,PTextIter,cstring",
    "get_iter_at_mark_name:PTextBTree,PTextIter,cstring", "get_iter_at_mark:PTextBTree,PTextIter,PTextMark",
    "get_end_iter:PTextBTree,PTextIter", "get_iter_at_line:PTextBTree,PTextIter,PTextLine,gint",
    "get_iter_at_first_toggle:PTextBTree,PTextIter,PTextTag", "get_iter_at_last_toggle:PTextBTree,PTextIter,PTextTag",
    "get_iter_at_child_anchor:PTextBTree,PTextIter,PTextChildAnchor",
    "set_mark:PTextBTree,PTextMark,cstring,gboolean,PTextIter,gboolean",
    "remove_mark_by_name:PTextBTree,cstring", "remove_mark:PTextBTree,PTextMark",
    "get_selection_bounds:PTextBTree,PTextIter,PTextIter", "place_cursor:PTextBTree,PTextIter",
    "mark_is_insert:PTextBTree,PTextMark", "mark_is_selection_bound:PTextBTree,PTextMark",
    "get_mark_by_name:PTextBTree,cstring", "first_could_contain_tag:PTextBTree,PTextTag",
    "last_could_contain_tag:PTextBTree,PTextTag", "check:PTextBTree", "spew:PTextBTree",
    "release_mark_segment:PTextBTree,PTextLineSegment", "notify_will_remove_tag:PTextBTree,PTextTag",
    "spew:PTextBuffer", "get_btree:PTextBuffer", "get_line_log_attrs:PTextBuffer,PTextIter,Pgint",
    "notify_will_remove_tag:PTextBuffer,PTextTag", "btree_unregister_child_anchor:PTextChildAnchor",
    "btree_delete:PTextIter,PTextIter", "btree_insert:PTextIter,cstring,gint",
    "btree_insert_pixbuf:PTextIter,gdk2pixbuf.PPixbuf", "btree_insert_child_anchor:PTextIter,PTextChildAnchor",
    "btree_tag:PTextIter,PTextIter,PTextTag,gboolean", "btree_get_tags:PTextIter,Pgint",
    "btree_get_text:PTextIter,PTextIter,gboolean,gboolean", "btree_char_is_invisible:PTextIter",
    "btree_new:PTextTagTable,PTextBuffer"]
  doAssert specs.len == 62
  for spec in specs:
    let parts = spec.split(':')
    var call = newCall(newDotExpr(ident"n", ident(parts[0])))
    for name in parts[1].split(','):
      let typ = if name in ["int32", "cstring"]: ident(name)
        elif name == "gdk2pixbuf.PPixbuf": newDotExpr(ident"pix", ident"PPixbuf")
        elif name in ["gboolean", "gpointer", "gint", "Pgint"]: newDotExpr(ident"g", ident(name))
        else: newDotExpr(ident"n", ident(name))
      call.add(newCall(ident"default", typ))
    result.add quote do:
      static: doAssert not compiles(`call`)
rejectPrivateTreeCalls()
static:
  doAssert sizeof(pix.PPixbuf) == sizeof(pointer)
  doAssert sizeof(n.TTextWindowType) == sizeof(cint)
  doAssert not compiles(block:
    let refTree: proc (tree: n.PTextBTree) {.cdecl.} = n.reference
    refTree(default(n.PTextBTree)))
  doAssert not compiles(block:
    let unrefTree: proc (tree: n.PTextBTree) {.cdecl.} = n.unref
    unrefTree(default(n.PTextBTree)))
ui.init()
suite "public paths after private text BTree removal":
  test "typed opaque IconSet refs do not become a fallback tree ref overload":
    let icons = n.icon_set_new()
    check n.reference(icons) == icons
    n.unref(icons)
    n.unref(icons)
  test "Unicode logical-line indices are characters or bytes as the public API specifies":
    let b = newTextBuffer("Aλ🙂\n界Z\n")
    check b.characterCount == 7 and b.lineCount == 3
    var it: n.TTextIter
    n.get_iter_at_line_offset(b.raw, addr it, 0, 2)
    check n.get_offset(addr it) == 2 and n.get_line_index(addr it) == 3
    check n.get_char(addr it) == g.gunichar(0x1f642)
    n.get_iter_at_line_index(b.raw, addr it, 0, 3) # UTF-8 byte boundary, not arbitrary byte.
    check n.get_offset(addr it) == 2
    n.get_iter_at_line_offset(b.raw, addr it, 1, 1)
    check n.get_offset(addr it) == 5 and n.get_line(addr it) == 1
    check n.get_line_offset(addr it) == 1 and n.get_line_index(addr it) == 3
    let hidden = b.createTag()
    hidden.invisible = true
    b.applyTag(hidden, 1, 3)
    check b.textRange(0, 7, includeHidden = false) == "A\n界Z\n"
    check b.text == "Aλ🙂\n界Z\n"
  test "marks reacquire iterators after edits; public tag lists and boundaries remain native":
    let b = newTextBuffer("abcde")
    let mark = b.createMark(2, "stable", leftGravity = true)
    var it: n.TTextIter
    n.get_iter_at_mark(b.raw, addr it, mark.raw)
    check n.get_offset(addr it) == 2
    b.insertText(0, "λ")
    # Never read the old iterator after mutation; no private stamps/repair needed.
    n.get_iter_at_mark(b.raw, addr it, mark.raw)
    check n.get_offset(addr it) == 3 and mark.offset == 3
    let tag = b.createTag("range")
    b.applyTag(tag, 1, 4)
    n.get_start_iter(b.raw, addr it)
    check g.toBool(n.forward_to_tag_toggle(addr it, tag.raw)) and n.get_offset(addr it) == 1
    check g.toBool(n.forward_to_tag_toggle(addr it, tag.raw)) and n.get_offset(addr it) == 4
    n.get_iter_at_offset(b.raw, addr it, 2)
    let tags = n.get_tags(addr it) # Own list nodes, borrow the elements.
    require tags != nil
    check tags.data == cast[pointer](tag.raw) and tags.next == nil
    g.free(tags)
    tag.bold = true
    b.deleteTag(tag)
    check not b.hasSelection and b.text == "λabcde"
  test "public object insertion/deletion owns image/anchor state without segment hooks":
    let b = newTextBuffer("ab")
    let image = newPixbuf(4, 4, 0x4080ffff'u32)
    b.insertImage(1, image)
    let anchor = b.createChildAnchor(2)
    check b.characterCount == 4 and b.text == "ab" and b.slice(0, 4) == "a\uFFFC\uFFFCb"
    var it: n.TTextIter
    n.get_iter_at_offset(b.raw, addr it, 1)
    check n.get_pixbuf(addr it) == image.raw
    n.get_iter_at_child_anchor(b.raw, addr it, anchor.raw)
    check n.get_offset(addr it) == 2 and n.get_child_anchor(addr it) == anchor.raw
    b.deleteRange(1, 3)
    check anchor.deleted and b.text == "ab" and image.width == 4
