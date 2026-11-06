# Included by gtk2.nim. Explicit trusted-native negotiation, never automatic paste.
type
  RichOfferState = ref object
    clipboard: Clipboard
    text: SerializedText
    plain: string
    active, pinned: bool
  RichClipboardOffer* = object
    state: RichOfferState
  RichClipboardKind* = enum
    richUnavailable, richPlainText, richDocument, richRejected
  RichClipboardResult* = object
    kind*: RichClipboardKind
    document*: TextBuffer
    text*: string
    error*: string
  RichRequestState = ref object
    active, nativePending, fallback, richAvailable: bool
    idle: g.guint
    clipboard: Clipboard
    format: TextFormat
    schema: TextBuffer
    owner: TextView
    buffer: TextBuffer
    connections: seq[Connection]
    plain: TextRequest
    bytes: string
    value: RichClipboardResult
    fn: proc (value: RichClipboardResult) {.closure.}
  RichTextRequest* = object
    state: RichRequestState

proc active*(offer: RichClipboardOffer): bool = offer.state != nil and offer.state.active
proc releaseRichOffer(s: RichOfferState) =
  s.active = false
  s.text = SerializedText()
  s.plain = ""
  s.clipboard = Clipboard()
  if s.pinned:
    s.pinned = false
    GC_unref(s)
proc richOfferClear(clipboard: rawGtk.PClipboard, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: releaseRichOffer(cast[RichOfferState](data))
proc richOfferGet(clipboard: rawGtk.PClipboard, selection: rawGtk.PSelectionData,
                  info: g.guint, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[RichOfferState](data)
    try:
      if not s.active: return
      if info == 0:
        rawGtk.set(selection, s.text.atom, 8,
          cast[g.Pguchar](s.text.bytes.cstring), g.gint(s.text.bytes.len))
      else:
        discard rawGtk.set_text(selection, s.plain.cstring, g.gint(s.plain.len))
    except Exception as error: reportSignalError(error)
proc offerRichText*(clipboard: Clipboard, text: SerializedText,
                    plainText: string): RichClipboardOffer =
  ## Offer copied native bytes and explicit plain fallback. Claiming ownership is
  ## deliberate. No source buffer/view or application callbacks are retained.
  requireOutsideModelFunction()
  if text.atom == 0: raise newException(ValueError, "uninitialized serialized text")
  validateTextEnvelope(text.bytes)
  discard checkedUtf8Text(plainText)
  if plainText.len > high(g.gint).int: raise newException(ValueError, "clipboard text is too large")
  let p = clipboard.raw
  let s = RichOfferState(clipboard: clipboard, text: text, plain: plainText,
    active: true, pinned: true)
  result.state = s
  let names = [text.name, "UTF8_STRING", "COMPOUND_TEXT", "TEXT", "STRING",
    "text/plain;charset=utf-8", "text/plain"]
  var targets: array[7, rawGtk.TTargetEntry]
  for i in 0..<targets.len:
    targets[i] = rawGtk.TTargetEntry(target: names[i].cstring, flags: 0,
      info: (if i == 0: 0'u32 else: 1'u32))
  GC_ref(s) # Native clipboard owns this pin until clear (even if token is dropped).
  let success = rawGtk.set_with_data(p, addr targets[0], g.guint(targets.len),
    richOfferGet, richOfferClear, cast[pointer](s))
  if not g.toBool(success):
    # GTK may already have called clear during a failed/reentrant replacement.
    releaseRichOffer(s)
    raise newException(ValueError, "GTK could not claim rich clipboard ownership")
proc clear*(offer: RichClipboardOffer) =
  requireOutsideModelFunction()
  if offer.active: offer.state.clipboard.clear()

proc pending*(request: RichTextRequest): bool = request.state != nil and request.state.active
proc releaseRichRequest(s: RichRequestState) =
  if not s.active: return
  s.active = false
  s.fn = nil
  s.bytes = ""
  s.value = RichClipboardResult()
  s.plain.cancel()
  s.plain = TextRequest()
  let connections = move(s.connections)
  for connection in connections: connection.disconnect()
  s.owner = TextView()
  s.buffer = TextBuffer()
  s.schema = TextBuffer()
  s.format = TextFormat()
  let idle = s.idle
  s.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  if not s.nativePending: s.clipboard = Clipboard()
  GC_unref(s) # Request lifetime pin; native callback/source pins are independent.
proc cancel*(request: RichTextRequest) =
  requireOutsideModelFunction()
  if request.state != nil: releaseRichRequest(request.state)
proc richOwnerCurrent(s: RichRequestState): bool =
  s.owner.state == nil or (not s.owner.isDestroyed and s.owner.buffer.raw == s.buffer.raw)
proc releaseRichIdle(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: GC_unref(cast[RichRequestState](data))
proc dispatchRichRequest(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[RichRequestState](data)
    s.idle = 0
    if not s.active: return g.gbool(false)
    if not richOwnerCurrent(s):
      releaseRichRequest(s)
      return g.gbool(false)
    if s.richAvailable:
      try:
        s.value = RichClipboardResult(kind: richDocument,
          document: s.format.deserialize(newSerializedText(s.format, s.bytes), tagsFrom = s.schema))
      except CatchableError as error:
        s.value = RichClipboardResult(kind: richRejected, error: error.msg)
    let fn = s.fn
    let value = s.value
    releaseRichRequest(s) # Release captures/owner hooks before calling application code.
    try: fn(value)
    except Exception as error: reportSignalError(error)
    g.gbool(false)
proc queueRichRequest(s: RichRequestState) =
  if not s.active or s.idle != 0: return
  GC_ref(s)
  s.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchRichRequest),
    cast[pointer](s), cast[pointer](releaseRichIdle))
proc requestRichPlain(s: RichRequestState) =
  if not s.fallback:
    queueRichRequest(s)
    return
  s.plain = s.clipboard.requestText(proc (value: ClipboardText) =
    if not s.active: return
    if value.available: s.value = RichClipboardResult(kind: richPlainText, text: value.text)
    queueRichRequest(s))
proc richContents(clipboard: rawGtk.PClipboard, selection: rawGtk.PSelectionData,
                  data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[RichRequestState](data)
    s.nativePending = false
    defer: GC_unref(s)
    if not s.active:
      s.clipboard = Clipboard()
      return
    try:
      if selection != nil and rawGtk.selection_data_get_length(selection) >= 0:
        # A successful reply with the wrong type/format is rejection, not a silent
        # text downgrade. Absent/refused targets have negative native length.
        s.richAvailable = true
        let length = rawGtk.selection_data_get_length(selection).int
        if rawGtk.selection_data_get_format(selection) != 8 or
            rawGtk.selection_data_get_data_type(selection) != s.format.atom or
            rawGtk.selection_data_get_target(selection) != s.format.atom:
          s.richAvailable = false
          s.value = RichClipboardResult(kind: richRejected, error: "unexpected rich clipboard type or format")
        else:
          let bytes = rawGtk.selection_data_get_data(selection)
          if length > 0 and bytes == nil:
            s.richAvailable = false
            s.value = RichClipboardResult(kind: richRejected, error: "missing rich clipboard data")
          else:
            s.bytes = newString(length)
            if length > 0: copyMem(addr s.bytes[0], bytes, length)
      if s.richAvailable or s.value.kind == richRejected: queueRichRequest(s)
      else: requestRichPlain(s)
    except Exception as error:
      s.richAvailable = false
      s.value = RichClipboardResult(kind: richRejected, error: error.msg)
      queueRichRequest(s)
proc startRichRequest(clipboard: Clipboard, owner: TextView, format: TextFormat,
    trusted: bool, fn: proc (value: RichClipboardResult) {.closure.},
    fallbackToText: bool, tagsFrom: TextBuffer): RichTextRequest =
  let p = clipboard.raw
  checkTextFormat(format)
  if fn == nil: raise newException(ValueError, "rich clipboard callback cannot be nil")
  if tagsFrom.state != nil:
    discard tagsFrom.raw
    if format.canCreateTags:
      raise newException(ValueError, "tag creation cannot be combined with a shared tag schema")
  if owner.state != nil: discard owner.raw
  let s = RichRequestState(active: true, clipboard: clipboard, format: format,
    schema: tagsFrom, owner: owner, fn: fn, fallback: fallbackToText)
  result.state = s
  GC_ref(s)
  if owner.state != nil:
    s.buffer = owner.buffer
    let request = result
    s.connections.add(owner.onDestroy(proc () = request.cancel()))
    s.connections.add(s.buffer.onChanged(proc () = request.cancel()))
  if trusted:
    s.nativePending = true
    GC_ref(s)
    rawGtk.request_contents(p, format.atom, richContents, cast[pointer](s))
  else: requestRichPlain(s) # No native rich bytes requested or decoded without opt-in.
proc requestRichText*(clipboard: Clipboard, format: TextFormat, trusted: bool,
    fn: proc (value: RichClipboardResult) {.closure.}, fallbackToText = true,
    tagsFrom = default(TextBuffer)): RichTextRequest =
  startRichRequest(clipboard, TextView(), format, trusted, fn, fallbackToText, tagsFrom)
proc requestRichText*(clipboard: Clipboard, owner: TextView, format: TextFormat, trusted: bool,
    fn: proc (value: RichClipboardResult) {.closure.}, fallbackToText = true,
    tagsFrom = default(TextBuffer)): RichTextRequest =
  discard owner.raw
  startRichRequest(clipboard, owner, format, trusted, fn, fallbackToText, tagsFrom)
