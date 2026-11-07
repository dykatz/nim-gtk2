# Raw tag/property audit. No realized widgets, selections on the wire or input.
import std/[unittest, macros]
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
macro rejectOldTagHelpers(): untyped =
  result = newStmtList()
  for field in ["bg_color_set", "bg_stipple_set", "fg_color_set", "scale_set", "fg_stipple_set", "justification_set", "left_margin_set", "indent_set", "rise_set", "strikethrough_set", "right_margin_set", "pixels_above_lines_set", "pixels_below_lines_set", "pixels_inside_wrap_set", "tabs_set", "underline_set", "wrap_mode_set", "bg_full_height_set", "invisible_set", "editable_set", "language_set", "pad1", "pad2", "pad3"]:
    let arg = newCall(newDotExpr(ident"n", ident"PTextTag"), newNilLit())
    let get = newCall(newDotExpr(ident"n", ident(field)), arg)
    let set = newCall(newDotExpr(ident"n", ident("set_" & field)), arg,
      newCall(newDotExpr(ident"g", ident"guint"), newLit(0)))
    result.add quote do:
      static:
        doAssert not compiles(`get`)
        doAssert not compiles(`set`)
    for prefix in ["bm_TGtkTextTag_", "bp_TGtkTextTag_"]:
      let symbol = newDotExpr(ident"n", ident(prefix & field))
      result.add quote do:
        static: doAssert not declared(`symbol`)
rejectOldTagHelpers()
proc boolProp(t: ui.TextTag, name: cstring): bool =
  var v: g.TGValue
  discard g.init(addr v, g.G_TYPE_BOOLEAN)
  defer: g.unset(addr v)
  g.get_property(cast[g.PGObject](t.raw), name, addr v)
  g.toBool(g.get_boolean(addr v))
proc effectiveEditable(b: ui.TextBuffer): bool =
  var it: n.TTextIter
  n.get_iter_at_offset(b.raw, addr it, 1)
  g.toBool(n.editable(addr it, g.gbool(true)))
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc tagChanged(table: n.PTextTagTable, tag: n.PTextTag, sizeChanged: g.gboolean, data: pointer) {.cdecl.} = inc cast[ptr int](data)[]
type Drop = object
  buffer: ptr ui.TextBuffer
  tag: ptr ui.TextTag
proc dropAliases(obj: g.PGObject, spec: g.PGParamSpec, data: pointer) {.cdecl.} =
  let d = cast[ptr Drop](data)
  d.tag[] = default(ui.TextTag)
  d.buffer[] = default(ui.TextBuffer)
proc dropAtRemoval(table: n.PTextTagTable, tag: n.PTextTag, data: pointer) {.cdecl.} =
  let d = cast[ptr Drop](data)
  d.tag[] = default(ui.TextTag)
  d.buffer[] = default(ui.TextBuffer)
proc dropAtRange(buffer: n.PTextBuffer, tag: n.PTextTag, first, last: n.PTextIter, data: pointer) {.cdecl.} =
  let d = cast[ptr Drop](data)
  d.tag[] = default(ui.TextTag)
  d.buffer[] = default(ui.TextBuffer)
proc removeAtBirth(table: n.PTextTagTable, tag: n.PTextTag, data: pointer) {.cdecl.} = n.table_remove(table, tag)
ui.init()
suite "TextTag public properties, priority and lifetime":
  test "public override properties exist with actual boolean types; no padding property":
    let b = newTextBuffer("abc")
    let tag = b.createTag("sample")
    for name in ["background-set", "background-stipple-set", "foreground-set", "scale-set", "foreground-stipple-set", "justification-set", "left-margin-set", "indent-set", "rise-set", "strikethrough-set", "right-margin-set", "pixels-above-lines-set", "pixels-below-lines-set", "pixels-inside-wrap-set", "tabs-set", "underline-set", "wrap-mode-set", "background-full-height-set", "invisible-set", "editable-set", "language-set", "paragraph-background-set", "accumulative-margin"]:
      let spec = g.class_find_property(g.G_OBJECT_GET_CLASS(tag.raw), name.cstring)
      require spec != nil
      check spec.value_type == g.G_TYPE_BOOLEAN
    check g.class_find_property(g.G_OBJECT_GET_CLASS(tag.raw), "pad1") == nil
  test "false overrides versus unset, and checked native priorities reorder membership":
    let b = newTextBuffer("abc")
    let low = b.createTag("low")
    let high = b.createTag("high")
    low.editable = false
    high.editable = true
    b.applyTag(low, 0, 3)
    b.applyTag(high, 0, 3)
    check low.priority == 0 and high.priority == 1 and effectiveEditable(b)
    high.editable = false
    check boolProp(high, "editable-set") and not effectiveEditable(b)
    high.clearEditable()
    check not boolProp(high, "editable-set") and not effectiveEditable(b)
    low.editable = true
    check effectiveEditable(b)
    high.editable = false
    check not effectiveEditable(b)
    var changes = 0
    let changedHook = g.g_signal_connect_data(n.get_tag_table(b.raw), "tag-changed", cast[g.TGCallback](tagChanged), addr changes, nil, g.TGConnectFlags(0))
    low.priority = 1
    check low.priority == 1 and high.priority == 0 and effectiveEditable(b)
    check changes == 0 # Native priority alone does not invalidate cached view styles.
    g.g_signal_handler_disconnect(n.get_tag_table(b.raw), changedHook)
    for bad in [-1, 2, int.high]:
      expect ValueError: low.priority = bad
      check low.priority == 1 and high.priority == 0
    high.underline = false
    check boolProp(high, "underline-set")
    high.clearUnderline()
    check not boolProp(high, "underline-set") and b.hasTag(high, 1)
    high.bold = false
    high.italic = false
    high.invisible = false
    high.clearBold()
    high.clearItalic()
    high.clearInvisible()
    check not boolProp(high, "weight-set") and not boolProp(high, "style-set") and not boolProp(high, "invisible-set")
    let other = newTextBuffer("abc")
    expect ValueError: other.applyTag(high, 0, 1)
    b.deleteTag(low)
    expect ValueError: discard low.priority
    expect ValueError: low.priority = 0
    expect ValueError: b.applyTag(low, 0, 1)
    low.bold = true # Detached tag properties remain native; not reattachment.
    check high.priority == 0 and b.tag("high").raw == high.raw
    check b.text == "abc"
  test "properties pin tag and table through native notify dropping final aliases":
    for property in ["weight", "style", "underline", "invisible", "editable", "foreground-gdk", "background-gdk", "underline-set"]:
      var b = newTextBuffer("abc")
      var tag = b.createTag("tag")
      if property == "underline-set": tag.underline = true
      var tagFinal, tableFinal = 0
      g.weak_ref(cast[g.PGObject](tag.raw), gone, addr tagFinal)
      g.weak_ref(cast[g.PGObject](n.get_tag_table(b.raw)), gone, addr tableFinal)
      var drop = Drop(buffer: addr b, tag: addr tag)
      let signal = "notify::" & property
      discard g.g_signal_connect_data(tag.raw, signal.cstring, cast[g.TGCallback](dropAliases), addr drop, nil, g.TGConnectFlags(0))
      case property
      of "weight": tag.bold = true
      of "style": tag.italic = true
      of "underline": tag.underline = true
      of "invisible": tag.invisible = true
      of "editable": tag.editable = false
      of "foreground-gdk": tag.setForeground(rgba16(500, 1000, 2000))
      of "background-gdk": tag.setBackground(rgba16(1000, 2000, 3000))
      else: tag.clearUnderline()
      check tagFinal == 1 and tableFinal == 1 and tag.isDestroyed
  test "range and table-removal signals can drop public tag/buffer aliases":
    for kind in ["apply-tag", "remove-tag", "tag-removed"]:
      var b = newTextBuffer("abc")
      var tag = b.createTag("tag")
      if kind != "apply-tag": b.applyTag(tag, 0, 3)
      var bufferFinal, tagFinal = 0
      g.weak_ref(cast[g.PGObject](b.raw), gone, addr bufferFinal)
      g.weak_ref(cast[g.PGObject](tag.raw), gone, addr tagFinal)
      var drop = Drop(buffer: addr b, tag: addr tag)
      if kind == "tag-removed":
        discard g.g_signal_connect_data(n.get_tag_table(b.raw), kind.cstring, cast[g.TGCallback](dropAtRemoval), addr drop, nil, g.TGConnectFlags(0))
        b.deleteTag(tag)
      else:
        discard g.g_signal_connect_data(b.raw, kind.cstring, cast[g.TGCallback](dropAtRange), addr drop, nil, g.TGConnectFlags(0))
        if kind == "apply-tag": b.applyTag(tag, 0, 3)
        else: b.removeTag(tag, 0, 3)
      check bufferFinal == 1 and tagFinal == 1
  test "native tag-added removal returns a valid detached tag, not guessed membership":
    let b = newTextBuffer("abc")
    discard g.g_signal_connect_data(n.get_tag_table(b.raw), "tag-added", cast[g.TGCallback](removeAtBirth), nil, nil, g.TGConnectFlags(0))
    let tag = b.createTag("removed")
    tag.underline = true
    check tag.underline
    expect ValueError: discard tag.priority
    expect ValueError: b.applyTag(tag, 0, 1)
  test "pure matcher rejects priority and override mutations":
    let b = newTextBuffer("abc")
    let tag = b.createTag()
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"])
    defer: c.close()
    entry.completion = c
    var denied = 0
    c.setMatch(proc (input: CompletionMatchInput): bool =
      try: tag.priority = 0
      except ValueError: inc denied
      try: tag.clearUnderline()
      except ValueError: inc denied
      try: tag.bold = true
      except ValueError: inc denied
      true)
    c.refilter()
    check denied >= 3 and denied mod 3 == 0
