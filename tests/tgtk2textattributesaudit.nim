# Raw boxed ownership/style audit. No realization, PRIMARY, requests or input.
import std/[unittest, macros]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
import headers/pango as p
macro rejectOldAttributeHelpers(): untyped =
  result = newStmtList()
  for spec in [("PTextAppearance", "TextAppearance", @["underline", "strikethrough", "draw_bg", "inside_selection", "is_text", "pad1", "pad2", "pad3", "pad4"]),
               ("PTextAttributes", "TextAttributes", @["invisible", "bg_full_height", "editable", "realized", "pad1", "pad2", "pad3", "pad4"])]:
    for field in spec[2]:
      let target = newCall(newDotExpr(ident"n", ident(spec[0])), newNilLit())
      let getter = newCall(newDotExpr(ident"n", ident(field)), target)
      let setter = newCall(newDotExpr(ident"n", ident("set_" & field)), target,
        newCall(newDotExpr(ident"g", ident"guint"), newLit(0)))
      result.add quote do:
        static:
          doAssert not compiles(`getter`)
          doAssert not compiles(`setter`)
      for prefix in ["bm_TGtk", "bp_TGtk"]:
        let name = newDotExpr(ident"n", ident(prefix & spec[1] & "_" & field))
        result.add quote do:
          static: doAssert not declared(`name`)
rejectOldAttributeHelpers()
proc setInt(tag: ui.TextTag, name: cstring, value: int) =
  var v: g.TGValue
  discard g.init(addr v, g.G_TYPE_INT)
  defer: g.unset(addr v)
  g.set_int(addr v, g.gint(value))
  g.set_property(cast[g.PGObject](tag.raw), name, addr v)
ui.init()
suite "TextAttributes public ownership and style":
  test "native ref returns the same boxed pointer; boxed copy shares, explicit copy isolates":
    let values = n.text_attributes_new()
    require values != nil
    defer: n.unref(values)
    check values.font_scale == 1.0
    let alias = n.reference(values)
    check alias == values
    alias.left_margin = 17 # Public scalar on owned detached values, not a tag edit.
    n.unref(alias)
    check values.left_margin == 17
    let boxed = cast[n.PTextAttributes](g.g_boxed_copy(n.text_attributes_get_type(), values))
    check boxed == values
    g.g_boxed_free(n.text_attributes_get_type(), boxed)
    let copied = n.copy(values)
    defer: n.unref(copied)
    check copied != values and copied.left_margin == 17
    copied.left_margin = 99
    check values.left_margin == 17
  test "native deep copy retains owned font/tabs and copy_values preserves destination refs":
    let source = n.text_attributes_new()
    source.font = p.font_description_from_string("Sans 13")
    source.tabs = p.tab_array_new(1, g.gbool(true))
    p.set_tab(source.tabs, 0, p.TAB_LEFT, 42)
    source.appearance.rise = -7
    source.font_scale = 1.25
    let copied = n.copy(source)
    defer: n.unref(copied)
    check copied.font != source.font and g.toBool(p.equal(copied.font, source.font))
    check copied.tabs != source.tabs
    let dest = n.text_attributes_new()
    defer: n.unref(dest)
    dest.font = p.font_description_from_string("Serif 9")
    let extra = n.reference(dest)
    n.copy_values(source, dest) # Fresh tabs/paragraph-color destination: see native leak caveat.
    n.unref(extra)
    check dest.font != source.font and dest.tabs != source.tabs
    check dest.font_scale == 1.25 and dest.appearance.rise == -7
    n.copy_values(dest, dest) # Native self-copy is a no-op.
    n.unref(source)
    var align: p.TTabAlign
    var location: g.gint
    p.get_tab(dest.tabs, 0, addr align, addr location)
    check location == 42 and align == p.TAB_LEFT
    check g.toBool(p.equal(dest.font, copied.font))
  test "view-default snapshots own their storage; iterator attributes overlay tags only":
    let b = newTextBuffer("λ🙂abc")
    let view = newTextView(b)
    defer: view.destroy()
    let original = n.get_default_attributes(view.raw) # Transfer-full copy, not borrowed.
    defer: n.unref(original)
    let originalMargin = original.left_margin
    let values = n.copy(original)
    defer: n.unref(values)
    let style = b.createTag("style")
    style.bold = true
    setInt(style, "left-margin", 37)
    setInt(style, "rise", 5)
    b.applyTag(style, 1, 3)
    var it: n.TTextIter
    n.get_iter_at_offset(b.raw, addr it, 1)
    check g.toBool(n.get_attributes(addr it, values))
    check values.left_margin == 37 and values.appearance.rise == 5
    check original.left_margin == originalMargin
    check b.text == "λ🙂abc"
    values.left_margin = 111 # Snapshot changes do not affect view defaults or tag properties.
    let after = n.get_default_attributes(view.raw)
    defer: n.unref(after)
    check after.left_margin == originalMargin
    n.get_iter_at_offset(b.raw, addr it, 4)
    let untagged = n.copy(original)
    defer: n.unref(untagged)
    check not g.toBool(n.get_attributes(addr it, untagged))
    check untagged.left_margin == originalMargin
    check not g.toBool(n.get_realized(cast[n.PWidget](view.raw)))
  test "public tag clearing and effective editability do not need attribute bit writes":
    let b = newTextBuffer("abcdef")
    let tag = b.createTag("policy")
    tag.invisible = true
    tag.editable = false
    tag.underline = true
    b.applyTag(tag, 1, 4)
    var it: n.TTextIter
    n.get_iter_at_offset(b.raw, addr it, 2)
    check not g.toBool(n.editable(addr it, g.gbool(true)))
    check b.textRange(0, 6, includeHidden = false) == "aef"
    tag.invisible = false
    tag.editable = true
    tag.underline = false
    check g.toBool(n.editable(addr it, g.gbool(false)))
    check b.textRange(0, 6, includeHidden = false) == "abcdef"
