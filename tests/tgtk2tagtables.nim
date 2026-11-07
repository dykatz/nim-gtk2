# Public table ownership/traversal only. No realized widgets or desktop requests.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
static:
  doAssert not declared(n.table_add_buffer)
  doAssert not declared(n.table_remove_buffer)
  doAssert not compiles(n.table_add_buffer(n.PTextTagTable(nil), nil))
  doAssert not compiles(n.table_remove_buffer(n.PTextTagTable(nil), nil))
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc removed(table: n.PTextTagTable, tag: n.PTextTag, data: pointer) {.cdecl.} = inc cast[ptr int](data)[]
type Collection = object
  count: int
  tags: array[3, n.PTextTag]
proc collect(tag: n.PTextTag, data: pointer) {.cdecl.} =
  # Synchronous borrowed argument: acquire ownership, no table mutation/event pump.
  let c = cast[ptr Collection](data)
  doAssert c.count < c.tags.len
  discard g.g_object_ref(tag)
  c.tags[c.count] = tag
  inc c.count
proc hasTag(b: n.PTextBuffer, tag: n.PTextTag): bool =
  var it: n.TTextIter
  n.get_iter_at_offset(b, addr it, 1)
  g.toBool(n.has_tag(addr it, tag))
proc apply(b: n.PTextBuffer, tag: n.PTextTag) =
  var first, last: n.TTextIter
  n.get_bounds(b, addr first, addr last)
  n.apply_tag(b, tag, addr first, addr last)
ui.init()
suite "public GtkTextTagTable traversal and ownership":
  test "constructor/borrowed lookup/table finalization differ from explicit removal":
    let table = n.text_tag_table_new()
    let tag = n.text_tag_new("owned")
    var tableFinal, tagFinal, removals = 0
    g.weak_ref(cast[g.PGObject](table), gone, addr tableFinal)
    g.weak_ref(cast[g.PGObject](tag), gone, addr tagFinal)
    discard g.g_signal_connect_data(table, "tag-removed", cast[g.TGCallback](removed), addr removals, nil, g.TGConnectFlags(0))
    n.table_add(table, tag)
    g.g_object_unref(tag) # Table now owns the tag.
    let b = n.text_buffer_new(table) # Native constructor refs and registers table.
    check n.get_tag_table(b) == table
    let spec = g.class_find_property(g.G_OBJECT_GET_CLASS(b), "tag-table")
    require spec != nil
    check spec.value_type == n.text_tag_table_get_type()
    check (spec.flags and g.G_PARAM_CONSTRUCT_ONLY) != 0
    g.g_object_unref(table) # Buffer is now table's only owner.
    check tableFinal == 0 and tagFinal == 0
    let borrowed = n.table_lookup(n.get_tag_table(b), "owned")
    require borrowed == tag
    discard g.g_object_ref(borrowed) # Lookup was borrowed; retain before buffer dies.
    g.g_object_unref(b)
    check tableFinal == 1 and tagFinal == 0 and removals == 0
    var value: g.TGValue
    discard g.init(addr value, g.G_TYPE_STRING)
    g.get_property(cast[g.PGObject](borrowed), "name", addr value)
    check $g.get_string(addr value) == "owned" # Retained detached tag is alive.
    g.unset(addr value)
    g.g_object_unref(borrowed)
    check tagFinal == 1
  test "unordered synchronous foreach borrows; owned collection can remove afterward":
    let table = n.text_tag_table_new()
    defer: g.g_object_unref(table)
    let named = n.text_tag_new("named")
    let emptyName = n.text_tag_new("")
    let anonymous = n.text_tag_new(nil)
    var tagsFinal = 0
    for tag in [named, emptyName, anonymous]:
      g.weak_ref(cast[g.PGObject](tag), gone, addr tagsFinal)
      n.table_add(table, tag)
      g.g_object_unref(tag)
    check n.table_get_size(table) == 3
    check n.table_lookup(table, "named") == named and n.table_lookup(table, "") == emptyName
    check n.table_lookup(table, "absent") == nil
    var c: Collection
    n.table_foreach(table, collect, addr c)
    check c.count == 3
    for tag in [named, emptyName, anonymous]: check tag in c.tags
    # Never mutate in foreach. Retaining arguments does not make that legal.
    for tag in c.tags: n.table_remove(table, tag)
    check n.table_get_size(table) == 0 and tagsFinal == 0
    for tag in c.tags: g.g_object_unref(tag)
    check tagsFinal == 3
  test "shared table is not shared text; native buffer finalization unregisters itself":
    let b = newTextBuffer("primary λ🙂")
    let tag = b.createTag("shared")
    let table = n.get_tag_table(b.raw)
    var peer = n.text_buffer_new(table)
    n.set_text(peer, "peer text", -1)
    b.applyTag(tag, 0, b.characterCount)
    peer.apply(tag.raw)
    check hasTag(peer, tag.raw) and b.hasTag(tag, 1)
    check n.get_char_count(peer) == 9 and b.text == "primary λ🙂"
    var peerFinal = 0
    g.weak_ref(cast[g.PGObject](peer), gone, addr peerFinal)
    g.g_object_unref(peer) # No SDK/private unregister call, only public final release.
    peer = nil
    check peerFinal == 1 and b.hasTag(tag, 1)
    peer = n.text_buffer_new(table)
    n.set_text(peer, "new peer", -1)
    defer: g.g_object_unref(peer)
    peer.apply(tag.raw)
    b.deleteTag(tag) # Native table-wide range removal covers every registered buffer.
    check not hasTag(peer, tag.raw) and not hasTag(b.raw, tag.raw)
    check n.table_get_size(table) == 0
    expect ValueError: discard tag.priority
    expect ValueError: b.applyTag(tag, 0, 1)
    let replacement = b.createTag("shared")
    check replacement.raw != tag.raw and replacement.priority == 0
    check not hasTag(peer, replacement.raw) # Add/name reuse does not apply ranges.
    b.deleteTag(replacement)
  test "SDK table retention is deliberate, buffer ownership is not inferred from tags":
    var b = newTextBuffer("abc")
    var tag = b.createTag("retained")
    var bufferFinal, tableFinal = 0
    g.weak_ref(cast[g.PGObject](b.raw), gone, addr bufferFinal)
    g.weak_ref(cast[g.PGObject](n.get_tag_table(b.raw)), gone, addr tableFinal)
    b = default(ui.TextBuffer)
    check bufferFinal == 1 and tableFinal == 0
    check tag.priority == 0 # SDK tag owns its table; unlike the raw tag above.
    tag = default(ui.TextTag)
    check tableFinal == 1
