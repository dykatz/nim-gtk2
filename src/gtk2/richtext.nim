# Included by gtk2.nim. Native iterators never escape an operation.
type
  TextTag* = object of ObjectHandle
    table: ObjectHandle
  TextMark* = object of ObjectHandle
  TextMatch* = object
    found*: bool
    first*, last*: int

proc raw*(t: TextTag): rawGtk.PTextTag = cast[rawGtk.PTextTag](nativePointer(t))
proc raw*(m: TextMark): rawGtk.PTextMark = cast[rawGtk.PTextMark](nativePointer(m))

# Public GParamSpec metadata, not GTK private storage. Initializing the precise
# property type also works on GLib versions predating empty-GValue getters.
proc typedProperty(p: pointer, name: cstring): g.TGValue =
  let spec = g.class_find_property(g.G_OBJECT_GET_CLASS(p), name)
  if spec == nil: raise newException(ValueError, "missing native property: " & $name)
  discard g.init(addr result, spec.value_type)
proc integerProperty(w: ObjectHandle, name: cstring, isEnum = false): int =
  let p = nativePointer(w)
  var v = typedProperty(p, name)
  defer: g.unset(addr v)
  g.get_property(cast[g.PGObject](p), name, addr v)
  if isEnum: g.get_enum(addr v).int else: g.get_int(addr v).int
proc setIntegerProperty(w: ObjectHandle, name: cstring, n: int, isEnum = false) =
  let p = nativePointer(w)
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  var v = typedProperty(p, name)
  defer: g.unset(addr v)
  if isEnum: g.set_enum(addr v, g.gint(n))
  else: g.set_int(addr v, g.gint(n))
  g.set_property(cast[g.PGObject](p), name, addr v)
proc booleanProperty(w: ObjectHandle, name: cstring): bool =
  let p = nativePointer(w)
  var v = typedProperty(p, name)
  defer: g.unset(addr v)
  g.get_property(cast[g.PGObject](p), name, addr v)
  g.toBool(g.get_boolean(addr v))
proc setBooleanProperty(w: ObjectHandle, name: cstring, value: bool) =
  let p = nativePointer(w)
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  var v = typedProperty(p, name)
  defer: g.unset(addr v)
  g.set_boolean(addr v, g.gbool(value))
  g.set_property(cast[g.PGObject](p), name, addr v)

template withTagTable(t: TextTag, body: untyped) =
  let owner = nativePointer(t.table)
  discard g.g_object_ref(owner)
  defer: g.g_object_unref(owner)
  body
proc setIntegerProperty(t: TextTag, name: cstring, n: int, isEnum = false) =
  withTagTable(t): setIntegerProperty(ObjectHandle(t), name, n, isEnum)
proc setBooleanProperty(t: TextTag, name: cstring, value: bool) =
  withTagTable(t): setBooleanProperty(ObjectHandle(t), name, value)

proc createTag*(b: TextBuffer, name = ""): TextTag =
  let text = checkedUtf8Text(name)
  let table = rawGtk.get_tag_table(b.raw)
  if name.len > 0 and rawGtk.table_lookup(table, text) != nil:
    raise newException(ValueError, "text tag name already exists")
  result.table.state = adoptObject(table, borrowed = true, cache = true, hasDestroySignal = false)
  result.state = adoptObject(rawGtk.text_tag_new(if name.len == 0: nil else: text),
    cache = true, hasDestroySignal = false, sink = false)
  rawGtk.table_add(table, result.raw)
proc tag*(b: TextBuffer, name: string): TextTag =
  let value = checkedUtf8Text(name)
  let table = rawGtk.get_tag_table(b.raw)
  let p = rawGtk.table_lookup(table, value)
  if p == nil: raise newException(ValueError, "text tag was not found")
  result.state = adoptObject(p, borrowed = true, cache = true, hasDestroySignal = false)
  result.table.state = adoptObject(table, borrowed = true, cache = true, hasDestroySignal = false)
type TagMembership = object
  tag: rawGtk.PTextTag
  found: bool
proc visitTextTag(tag: rawGtk.PTextTag, data: pointer) {.cdecl.} =
  let check = cast[ptr TagMembership](data)
  if tag == check.tag: check.found = true
proc checkedTagTable(tag: TextTag): rawGtk.PTextTagTable =
  result = cast[rawGtk.PTextTagTable](nativePointer(tag.table))
  var member = TagMembership(tag: tag.raw)
  rawGtk.table_foreach(result, visitTextTag, addr member)
  if not member.found: raise newException(ValueError, "text tag was removed from its table")
proc checkTag(b: TextBuffer, tag: TextTag) =
  let table = rawGtk.get_tag_table(b.raw)
  if table != checkedTagTable(tag):
    raise newException(ValueError, "text tag belongs to another table")
proc priority*(tag: TextTag): int =
  discard checkedTagTable(tag)
  rawGtk.get_priority(tag.raw).int
proc `priority=`*(tag: TextTag, value: int) =
  let table = checkedTagTable(tag)
  if value < 0 or value >= rawGtk.table_get_size(table).int:
    raise newException(ValueError, "text tag priority must be in 0..<table size")
  let p = tag.raw
  discard g.g_object_ref(table)
  discard g.g_object_ref(p)
  defer:
    g.g_object_unref(p)
    g.g_object_unref(table)
  rawGtk.set_priority(p, g.gint(value))
proc applyTag*(b: TextBuffer, tag: TextTag, first, last: int) =
  checkTag(b, tag)
  var r = bufferRange(b, first, last)
  let owner = b.raw
  let p = tag.raw
  discard g.g_object_ref(owner)
  discard g.g_object_ref(p)
  defer:
    g.g_object_unref(p)
    g.g_object_unref(owner)
  withTagTable(tag): rawGtk.apply_tag(owner, p, addr r.first, addr r.last)
proc removeTag*(b: TextBuffer, tag: TextTag, first, last: int) =
  checkTag(b, tag)
  var r = bufferRange(b, first, last)
  let owner = b.raw
  let p = tag.raw
  discard g.g_object_ref(owner)
  discard g.g_object_ref(p)
  defer:
    g.g_object_unref(p)
    g.g_object_unref(owner)
  withTagTable(tag): rawGtk.remove_tag(owner, p, addr r.first, addr r.last)
proc removeAllTags*(b: TextBuffer, first, last: int) =
  var r = bufferRange(b, first, last)
  rawGtk.remove_all_tags(b.raw, addr r.first, addr r.last)
proc hasTag*(b: TextBuffer, tag: TextTag, offset: int): bool =
  checkTag(b, tag)
  var it = bufferIter(b, offset)
  g.toBool(rawGtk.has_tag(addr it, tag.raw))
proc deleteTag*(b: TextBuffer, tag: TextTag) =
  checkTag(b, tag)
  let owner = b.raw
  let table = rawGtk.get_tag_table(owner)
  let p = tag.raw
  discard g.g_object_ref(owner)
  discard g.g_object_ref(p)
  defer:
    g.g_object_unref(p)
    g.g_object_unref(owner)
  withTagTable(tag): rawGtk.table_remove(table, p)
proc bold*(t: TextTag): bool = integerProperty(t, "weight") >= 700
proc `bold=`*(t: TextTag, value: bool) = setIntegerProperty(t, "weight", if value: 700 else: 400)
proc italic*(t: TextTag): bool = integerProperty(t, "style", true) == 2
proc `italic=`*(t: TextTag, value: bool) = setIntegerProperty(t, "style", if value: 2 else: 0, true)
proc underline*(t: TextTag): bool = integerProperty(t, "underline", true) != 0
proc `underline=`*(t: TextTag, value: bool) = setIntegerProperty(t, "underline", if value: 1 else: 0, true)
proc invisible*(t: TextTag): bool = booleanProperty(t, "invisible")
proc `invisible=`*(t: TextTag, value: bool) = setBooleanProperty(t, "invisible", value)
proc editable*(t: TextTag): bool = booleanProperty(t, "editable")
proc `editable=`*(t: TextTag, value: bool) = setBooleanProperty(t, "editable", value)
proc setTagColor(t: TextTag, name: cstring, color: Color) =
  if color.alpha != 65535: raise newException(ValueError, "text tag colors do not support alpha")
  let p = t.raw
  let owner = nativePointer(t.table)
  discard g.g_object_ref(owner)
  discard g.g_object_ref(p)
  defer:
    g.g_object_unref(p)
    g.g_object_unref(owner)
  var v = typedProperty(p, name)
  defer: g.unset(addr v)
  var native = TColor(red: color.red, green: color.green, blue: color.blue)
  g.set_boxed(addr v, addr native)
  g.set_property(cast[g.PGObject](p), name, addr v)
proc setForeground*(t: TextTag, color: Color) = setTagColor(t, "foreground-gdk", color)
proc setBackground*(t: TextTag, color: Color) = setTagColor(t, "background-gdk", color)
proc clearForeground*(t: TextTag) = setBooleanProperty(t, "foreground-set", false)
proc clearBackground*(t: TextTag) = setBooleanProperty(t, "background-set", false)
proc clearBold*(t: TextTag) = setBooleanProperty(t, "weight-set", false)
proc clearItalic*(t: TextTag) = setBooleanProperty(t, "style-set", false)
proc clearUnderline*(t: TextTag) = setBooleanProperty(t, "underline-set", false)
proc clearInvisible*(t: TextTag) = setBooleanProperty(t, "invisible-set", false)
proc clearEditable*(t: TextTag) = setBooleanProperty(t, "editable-set", false)

proc findText*(b: TextBuffer, needle: string, first = 0, last = -1,
               backwards = false, visibleOnly = false, textOnly = true): TextMatch =
  let text = checkedUtf8Text(needle)
  if needle.len == 0: raise newException(ValueError, "search text cannot be empty")
  var r = bufferRange(b, first, if last == -1: b.characterCount else: last)
  var a, z: rawGtk.TTextIter
  let flags = rawGtk.TTextSearchFlags((if visibleOnly: rawGtk.TEXT_SEARCH_VISIBLE_ONLY else: 0) or
    (if textOnly: rawGtk.TEXT_SEARCH_TEXT_ONLY else: 0))
  result = TextMatch(first: -1, last: -1)
  result.found = g.toBool(if backwards:
    rawGtk.backward_search(addr r.last, text, flags, addr a, addr z, addr r.first)
    else: rawGtk.forward_search(addr r.first, text, flags, addr a, addr z, addr r.last))
  if result.found:
    result.first = rawGtk.get_offset(addr a).int
    result.last = rawGtk.get_offset(addr z).int

proc createMark*(b: TextBuffer, offset: int, name = "", leftGravity = true): TextMark =
  let text = checkedUtf8Text(name)
  var it = bufferIter(b, offset)
  if name.len > 0 and rawGtk.get_mark(b.raw, text) != nil:
    raise newException(ValueError, "text mark name already exists")
  let owner = b.raw
  discard g.g_object_ref(owner)
  defer: g.g_object_unref(owner)
  # Own before mark-set: a native listener may delete the mark during insertion.
  # The borrowed convenience create_mark return can then already be dangling.
  result.state = adoptObject(rawGtk.text_mark_new(if name.len == 0: nil else: text,
    g.gbool(leftGravity)), cache = true, hasDestroySignal = false, sink = false)
  rawGtk.add_mark(owner, result.raw, addr it)
proc mark*(b: TextBuffer, name: string): TextMark =
  let p = rawGtk.get_mark(b.raw, checkedUtf8Text(name))
  if p == nil: raise newException(ValueError, "text mark was not found")
  result.state = adoptObject(p, borrowed = true, cache = true, hasDestroySignal = false)
proc deleted*(m: TextMark): bool = g.toBool(rawGtk.get_deleted(m.raw))
proc name*(m: TextMark): string = $rawGtk.get_name(m.raw)
proc leftGravity*(m: TextMark): bool = g.toBool(rawGtk.get_left_gravity(m.raw))
proc visible*(m: TextMark): bool = g.toBool(rawGtk.get_visible(m.raw))
proc `visible=`*(m: TextMark, value: bool) =
  let p = m.raw
  let owner = rawGtk.get_buffer(p)
  discard g.g_object_ref(p)
  if owner != nil: discard g.g_object_ref(owner)
  defer:
    if owner != nil: g.g_object_unref(owner)
    g.g_object_unref(p)
  rawGtk.set_visible(p, g.gbool(value))
proc buffer*(m: TextMark): TextBuffer =
  let p = rawGtk.get_buffer(m.raw)
  if p == nil: raise newException(ValueError, "text mark is deleted")
  ownedTextBuffer(p)
proc checkMark(b: TextBuffer, m: TextMark) =
  if rawGtk.get_buffer(m.raw) != b.raw:
    raise newException(ValueError, "text mark is deleted or belongs to another buffer")
proc offset*(m: TextMark): int =
  let p = rawGtk.get_buffer(m.raw)
  if p == nil: raise newException(ValueError, "text mark is deleted")
  var it: rawGtk.TTextIter
  rawGtk.get_iter_at_mark(p, addr it, m.raw)
  rawGtk.get_offset(addr it).int
proc moveMark*(b: TextBuffer, m: TextMark, offset: int) =
  checkMark(b, m)
  var it = bufferIter(b, offset)
  let owner = b.raw
  let p = m.raw
  discard g.g_object_ref(owner)
  discard g.g_object_ref(p)
  defer:
    g.g_object_unref(p)
    g.g_object_unref(owner)
  rawGtk.move_mark(owner, p, addr it)
proc deleteMark*(b: TextBuffer, m: TextMark) =
  checkMark(b, m)
  if m.raw == rawGtk.get_insert(b.raw) or m.raw == rawGtk.get_selection_bound(b.raw):
    raise newException(ValueError, "GTK's cursor and selection marks cannot be deleted")
  let owner = b.raw
  let p = m.raw
  discard g.g_object_ref(owner)
  discard g.g_object_ref(p)
  defer:
    g.g_object_unref(p)
    g.g_object_unref(owner)
  rawGtk.delete_mark(owner, p)
proc scrollToMark*(w: TextView, m: TextMark) =
  checkMark(w.buffer, m)
  rawGtk.scroll_to_mark(w.raw, m.raw, 0, g.gbool(false), 0, 0)
proc insertImage*(b: TextBuffer, offset: int, image: Pixbuf) =
  let p = image.raw
  var it = bufferIter(b, offset)
  rawGtk.insert_pixbuf(b.raw, addr it, p)
proc slice*(b: TextBuffer, first, last: int, includeHidden = true): string =
  ## Like textRange, but embedded images/anchors appear as U+FFFC.
  var r = bufferRange(b, first, last)
  let p = rawGtk.get_slice(b.raw, addr r.first, addr r.last, g.gbool(includeHidden))
  try: result = $p
  finally: g.g_free(p)
