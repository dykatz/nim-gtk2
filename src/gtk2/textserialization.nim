# Included by gtk2.nim. Native GTK2 rich text for trusted application data only.
type
  TextFormat* = object
    registration: TextBuffer # Private registration owner; never a content buffer.
    atom: rawGdk.TAtom
    name: string
    createTags: bool
  SerializedText* = object
    atom: rawGdk.TAtom
    name: string
    bytes: string # Binary, copied on entry/exit. Not UTF-8 text.
  TextSerializationError* = object of CatchableError
proc checkTextFormat(format: TextFormat) =
  discard format.registration.raw
  if format.atom == 0: raise newException(ValueError, "uninitialized text format")
proc newTextFormat*(tagset = "", canCreateTags = false): TextFormat =
  ## Registers GTK's native tagset codec on a private owned buffer, not on any
  ## application buffer (and never on its clipboard formats). Policy is immutable.
  requireOutsideModelFunction()
  discard checkedUtf8Text(tagset)
  if tagset.len > 64: raise newException(ValueError, "text tagset name is too long")
  for c in tagset:
    if c notin {'a'..'z', 'A'..'Z', '0'..'9', '-', '_'}:
      raise newException(ValueError, "text tagset names use ASCII letters, digits, '-' and '_'")
  result.registration = newTextBuffer()
  let p = result.registration.raw
  let name: cstring = if tagset.len == 0: nil else: tagset.cstring
  result.atom = rawGtk.register_serialize_tagset(p, name)
  let incoming = rawGtk.register_deserialize_tagset(p, name)
  if result.atom == 0 or incoming != result.atom:
    raise newException(TextSerializationError, "GTK could not register its rich-text format")
  rawGtk.deserialize_set_can_create_tags(p, result.atom, g.gbool(canCreateTags))
  result.createTags = canCreateTags
  let mime = rawGdk.atom_name(result.atom)
  if mime == nil: raise newException(TextSerializationError, "GTK returned no rich-text MIME name")
  try: result.name = $mime
  finally: g.g_free(mime)
proc mimeType*(format: TextFormat): string =
  checkTextFormat(format)
  format.name
proc canCreateTags*(format: TextFormat): bool =
  checkTextFormat(format)
  format.createTags
proc mimeType*(text: SerializedText): string = text.name
proc byteCount*(text: SerializedText): int = text.bytes.len
proc binaryCopy(bytes: string): string =
  result = newString(bytes.len)
  if bytes.len != 0: copyMem(addr result[0], unsafeAddr bytes[0], bytes.len)
proc data*(text: SerializedText): string = binaryCopy(text.bytes)
proc validateTextEnvelope(bytes: string) =
  # Audited GTK2 framing only, NOT an XML/pixdata parser or security boundary.
  # GTK's gint read_headers arithmetic accepts negative/overflowing lengths and
  # its unknown-first-header path sets a GError with invalid domain zero.
  # Reject those paths without suppressing warnings or fixing GTK private state.
  if bytes.len == 0 or bytes.len > high(g.gint).int - 30:
    raise newException(TextSerializationError, "empty or oversized native rich-text data")
  var pos = 0
  while pos < bytes.len:
    if bytes.len - pos <= 30:
      raise newException(TextSerializationError, "truncated native rich-text section")
    let expected = if pos == 0: "GTKTEXTBUFFERCONTENTS-0001" else: "GTKTEXTBUFFERPIXBDATA-0001"
    for i in 0..<26:
      if bytes[pos + i] != expected[i]:
        raise newException(TextSerializationError, "unexpected native rich-text section")
    var length = 0'u32
    for i in 26..<30: length = (length shl 8) or uint32(uint8(bytes[pos + i]))
    if length == 0 or uint64(length) > uint64(bytes.len - pos - 30):
      raise newException(TextSerializationError, "invalid native rich-text section length")
    pos += 30 + int(length)
proc newSerializedText*(format: TextFormat, bytes: string): SerializedText =
  ## Copy trusted native binary data with an explicitly selected format. Framing
  ## validation is not a sandbox or an XML/pixdata security audit.
  checkTextFormat(format)
  validateTextEnvelope(bytes)
  SerializedText(atom: format.atom, name: format.name, bytes: binaryCopy(bytes))
proc checkSerializableRange(bounds: tuple[first, last: rawGtk.TTextIter]) =
  # GTK2's serializer fails to advance over a non-pixbuf U+FFFC (including a
  # child anchor). Reject these rather than hang or silently omit widgets.
  var iter = bounds.first
  var last = bounds.last
  while rawGtk.compare(addr iter, addr last) < 0:
    if rawGtk.get_char(addr iter) == 0xfffc'u32 and rawGtk.get_pixbuf(addr iter) == nil:
      raise newException(ValueError, "native rich-text serialization does not support child anchors or literal U+FFFC in the selected range")
    discard rawGtk.forward_char(addr iter)
proc serialize*(b: TextBuffer, format: TextFormat, first = 0, last = -1): SerializedText =
  ## Copy an exact Unicode range as native GTK2 data. Anchors and literal U+FFFC
  ## are unsupported; no marks, view state or application callbacks are saved.
  checkTextFormat(format)
  var bounds = bufferRange(b, first, if last == -1: b.characterCount else: last)
  checkSerializableRange(bounds)
  let source = b.raw
  discard g.g_object_ref(source)
  defer: g.g_object_unref(source)
  # The native serializer scans past end before clamping and may include pixbufs
  # outside the selected range. Copy the exact range through public insert_range
  # into an unobserved buffer sharing the tag table, then serialize its full span.
  var snapshot: TextBuffer
  snapshot.state = adoptObject(rawGtk.text_buffer_new(rawGtk.get_tag_table(source)),
    cache = true, hasDestroySignal = false, sink = false)
  var where: rawGtk.TTextIter
  rawGtk.get_start_iter(snapshot.raw, addr where)
  rawGtk.insert_range(snapshot.raw, addr where, addr bounds.first, addr bounds.last)
  var copied = bufferRange(snapshot, 0, snapshot.characterCount)
  let registration = format.registration.raw
  discard g.g_object_ref(registration)
  defer: g.g_object_unref(registration)
  var length: g.gsize
  let bytes = rawGtk.text_buffer_serialize(registration, snapshot.raw, format.atom,
    addr copied.first, addr copied.last, addr length)
  defer: g.g_free(bytes)
  if bytes == nil or length > g.gsize(high(g.gint).int - 30):
    raise newException(TextSerializationError, "GTK could not serialize this range")
  result = SerializedText(atom: format.atom, name: format.name, bytes: newString(int(length)))
  if length != 0: copyMem(addr result.bytes[0], bytes, int(length))
  validateTextEnvelope(result.bytes)
proc deserialize*(format: TextFormat, text: SerializedText,
                  tagsFrom = default(TextBuffer)): TextBuffer =
  ## Decode into a new detached buffer. Never insert into an observed/live buffer:
  ## GTK continues using iterators/tags between its synchronous changed emissions.
  checkTextFormat(format)
  if text.atom == 0 or text.atom != format.atom:
    raise newException(ValueError, "serialized text belongs to a different native format")
  validateTextEnvelope(text.bytes)
  let hasSchema = not tagsFrom.isDestroyed
  if hasSchema and format.createTags:
    raise newException(ValueError, "tag creation cannot be combined with a shared tag schema")
  if not hasSchema and tagsFrom.state != nil:
    raise newException(ValueError, "tag schema buffer is destroyed")
  let table = if hasSchema: rawGtk.get_tag_table(tagsFrom.raw) else: nil
  var decoded: TextBuffer
  decoded.state = adoptObject(rawGtk.text_buffer_new(table), cache = true,
    hasDestroySignal = false, sink = false)
  let p = decoded.raw
  let registration = format.registration.raw
  discard g.g_object_ref(registration)
  defer: g.g_object_unref(registration)
  var iter: rawGtk.TTextIter
  rawGtk.get_start_iter(p, addr iter)
  var error: ptr g.GError
  let success = rawGtk.text_buffer_deserialize(registration, p, format.atom,
    addr iter, cast[ptr g.guint8](unsafeAddr text.bytes[0]), g.gsize(text.bytes.len), addr error)
  var message = "GTK could not deserialize native rich text"
  if error != nil:
    if error.message != nil: message = $error.message
    g.g_error_free(error)
  if not g.toBool(success): raise newException(TextSerializationError, message)
  result = decoded
