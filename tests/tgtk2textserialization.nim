# Hidden trusted rich-text serialization tests; no windows/clipboard ownership.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
import headers/gdk2pixbuf as pb
import headers/gdk2 as gd
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
proc imageAt(buffer: ui.TextBuffer, offset: int): bool =
  var iter: n.TTextIter
  n.get_iter_at_offset(buffer.raw, addr iter, g.gint(offset))
  n.get_pixbuf(addr iter) != nil
proc archived(finalized: ptr int): SerializedText =
  let buffer = newTextBuffer("λ🙂\n")
  let tag = buffer.createTag("emphasis")
  tag.bold = true
  tag.italic = true
  buffer.applyTag(tag, 0, 2)
  g.weak_ref(cast[g.PGObject](buffer.raw), gone, finalized)
  buffer.serialize(newTextFormat(canCreateTags = true))
ui.init()
suite "native rich-text serialization (unmapped)":
  test "raw native registration, policy, transferred format arrays and unregister":
    let buffer = n.text_buffer_new(nil)
    defer: g.g_object_unref(buffer)
    var outgoingBefore, incomingBefore: g.gint
    g.g_free(n.get_serialize_formats(buffer, addr outgoingBefore))
    g.g_free(n.get_deserialize_formats(buffer, addr incomingBefore))
    let atom = n.register_serialize_tagset(buffer, "raw-schema")
    check n.register_deserialize_tagset(buffer, "raw-schema") == atom
    check not g.toBool(n.deserialize_get_can_create_tags(buffer, atom))
    n.deserialize_set_can_create_tags(buffer, atom, g.gbool(true))
    check g.toBool(n.deserialize_get_can_create_tags(buffer, atom))
    var count: g.gint
    let outgoing = n.get_serialize_formats(buffer, addr count)
    check count == outgoingBefore + 1
    var found = false
    for i in 0..<int(count):
      if cast[ptr UncheckedArray[gd.TAtom]](outgoing)[i] == atom: found = true
    check found
    g.g_free(outgoing)
    let incoming = n.get_deserialize_formats(buffer, addr count)
    check count == incomingBefore + 1
    found = false
    for i in 0..<int(count):
      if cast[ptr UncheckedArray[gd.TAtom]](incoming)[i] == atom: found = true
    check found
    g.g_free(incoming)
    n.unregister_serialize_format(buffer, atom)
    n.unregister_deserialize_format(buffer, atom)
    g.g_free(n.get_serialize_formats(buffer, addr count))
    check count == outgoingBefore
    g.g_free(n.get_deserialize_formats(buffer, addr count))
    check count == incomingBefore
  test "native MIME identity, immutable per-owner tag policy and binary copies":
    let format = newTextFormat("app-v1", canCreateTags = true)
    check format.mimeType == "application/x-gtk-text-buffer-rich-text;format=app-v1"
    check format.canCreateTags
    check not newTextFormat("app-v1").canCreateTags
    expect ValueError: discard newTextFormat("invalid;mime")
    expect ValueError: discard newTextFormat("bad\0name")
    let buffer = newTextBuffer("λ🙂")
    let text = buffer.serialize(format)
    check text.mimeType == format.mimeType and text.byteCount > 30
    check '\0' in text.data # Native length framing is binary, never strlen-based.
    let equivalent = newTextFormat("app-v1", canCreateTags = true)
    check equivalent.deserialize(text).text == buffer.text
    expect ValueError: discard newTextFormat("other-v1").deserialize(text)
    var copy = text.data
    copy[0] = 'X'
    check text.data[0] == 'G'
    var original = text.data
    let reconstructed = newSerializedText(format, original)
    original[0] = 'X'
    check reconstructed.data[0] == 'G'
    check format.deserialize(reconstructed).text == "λ🙂"
    check newSerializedText(format, reconstructed.data).byteCount == text.byteCount
  test "tagged Unicode and invisible text survive without retaining source or format":
    var finalized = 0
    let text = archived(addr finalized)
    check finalized == 1
    let restored = newTextFormat(canCreateTags = true).deserialize(text)
    check restored.text == "λ🙂\n" and restored.characterCount == 3
    let tag = restored.tag("emphasis")
    check tag.bold and tag.italic and restored.hasTag(tag, 1)
    let secret = restored.createTag("secret")
    secret.invisible = true
    restored.applyTag(secret, 0, 1)
    let again = newTextFormat(canCreateTags = true).deserialize(restored.serialize(newTextFormat()))
    check again.text == restored.text and again.tag("secret").invisible
    check again.hasTag(again.tag("secret"), 0)
  test "fixed schema shares existing tag identity/properties and never creates unknown tags":
    let source = newTextBuffer("AB")
    let bold = source.createTag("style")
    bold.bold = true
    source.applyTag(bold, 0, 1)
    let format = newTextFormat("schema-v1")
    let text = source.serialize(format)
    expect TextSerializationError: discard format.deserialize(text)
    let schema = newTextBuffer("untouched")
    let existing = schema.createTag("style")
    existing.italic = true
    schema.modified = false
    var changes = 0
    let observer = schema.onChanged(proc () = inc changes)
    defer: observer.disconnect()
    let restored = format.deserialize(text, tagsFrom = schema)
    check restored.tag("style").raw == existing.raw
    check restored.tag("style").italic and not restored.tag("style").bold
    check restored.hasTag(existing, 0)
    check schema.text == "untouched" and not schema.modified and changes == 0
    expect ValueError:
      discard newTextFormat("schema-v1", canCreateTags = true).deserialize(text, tagsFrom = schema)
    let anonymous = source.createTag()
    anonymous.underline = true
    source.applyTag(anonymous, 1, 2)
    expect TextSerializationError: discard format.deserialize(source.serialize(format), tagsFrom = schema)
    check newTextFormat("schema-v1", canCreateTags = true).deserialize(source.serialize(format)).text == "AB"
  test "exact bounded snapshots exclude trailing pixbufs/anchors and preserve in-range images":
    let source = newTextBuffer("ABCD")
    source.insertImage(2, newPixbuf(3, 2, 0x123456ff'u32))
    let anchor = source.createChildAnchor(5)
    let format = newTextFormat(canCreateTags = true)
    source.modified = false
    source.cursorOffset = 1
    var changes = 0
    let observer = source.onChanged(proc () = inc changes)
    let cursorObserver = source.onCursorMoved(proc () = inc changes)
    let modifiedObserver = source.onModifiedChanged(proc () = inc changes)
    defer:
      observer.disconnect()
      cursorObserver.disconnect()
      modifiedObserver.disconnect()
    check format.deserialize(source.serialize(format, 0, 1)).text == "A"
    let restored = format.deserialize(source.serialize(format, 1, 4))
    check restored.text == "BC" and restored.characterCount == 3 and imageAt(restored, 1)
    var iter: n.TTextIter
    n.get_iter_at_offset(restored.raw, addr iter, 1)
    let image = n.get_pixbuf(addr iter)
    check pb.get_width(image) == 3 and pb.get_height(image) == 2
    let pixels = cast[ptr UncheckedArray[uint8]](pb.get_pixels(image))
    check pixels[0] == 0x12 and pixels[1] == 0x34 and pixels[2] == 0x56 and pixels[3] == 0xff
    # Decoding owns a new native pixbuf, not a pointer borrowed from the source.
    n.get_iter_at_offset(source.raw, addr iter, 2)
    check n.get_pixbuf(addr iter) != image
    check source.cursorOffset == 1 and not source.modified and changes == 0
    check not anchor.deleted and anchor.offset == 5
    expect ValueError: discard source.serialize(format)
    expect ValueError: discard source.serialize(format, -1, 1)
    expect ValueError: discard source.serialize(format, 3, 2)
    let literal = newTextBuffer("a\uFFFCb")
    expect ValueError: discard literal.serialize(format)
    check format.deserialize(literal.serialize(format, 0, 1)).text == "a"
    check format.deserialize(source.serialize(format, 2, 2)).characterCount == 0
  test "empty documents, truncated framing, malformed native markup and default values":
    let format = newTextFormat(canCreateTags = true)
    let empty = newTextBuffer().serialize(format)
    check format.deserialize(empty).characterCount == 0
    for invalid in ["", "not rich text", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"]:
      expect TextSerializationError: discard newSerializedText(format, invalid)
    var bytes = newTextBuffer("hello").serialize(format).data
    expect TextSerializationError: discard newSerializedText(format, bytes[0..^2])
    var invalidLength = bytes
    for i in 26..29: invalidLength[i] = '\xff'
    expect TextSerializationError: discard newSerializedText(format, invalidLength)
    bytes[^1] = '<' # Same valid envelope, native GMarkup failure after tag parsing.
    let invalidMarkup = newSerializedText(format, bytes)
    expect TextSerializationError: discard format.deserialize(invalidMarkup)
    expect ValueError: discard format.deserialize(default(SerializedText))
    expect ValueError: discard newTextBuffer().serialize(default(TextFormat))
