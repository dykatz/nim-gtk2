# Included by gtk2.nim. Explicit trusted-native negotiation, never automatic paste.
type
  RichOfferState = ref object
    clipboard: Clipboard
    variants: seq[SerializedText]
    plain: string
    targets: seq[string]
    active, pinned: bool
  RichClipboardOffer* = object
    state: RichOfferState
  RichClipboardKind* = enum
    richUnavailable, richPlainText, richDocument, richRejected
  RichClipboardResult* = object
    kind*: RichClipboardKind
    mime*: string # Exact rich target on rich success or rejection; empty for plain text.
    document*: TextBuffer
    text*: string
    error*: string
  RichClipboardEnvelope* = object
    mime*: string
    byteCount*: int
  RichClipboardPreview* = object
    kind*: RichClipboardKind # richPlainText or richDocument
    mime*: string
    text*: string # Plain projection, not a description of all tags/embedded content.
  RichEnvelopePolicy* = proc (value: RichClipboardEnvelope): bool {.closure.}
  RichPreviewPolicy* = proc (value: RichClipboardPreview): bool {.closure.}
  RichRequestState = ref object
    active, nativePending, fallback, richAvailable: bool
    idle: g.guint
    clipboard: Clipboard
    formats: seq[TextFormat]
    index, maxBytes: int
    inspect: RichEnvelopePolicy
    accept: RichPreviewPolicy
    advance, ownerEdited: bool
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
  s.variants = @[]
  s.plain = ""
  s.targets = @[]
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
      if info < g.guint(s.variants.len):
        let text = s.variants[info.int]
        rawGtk.set(selection, text.atom, 8,
          cast[g.Pguchar](text.bytes.cstring), g.gint(text.bytes.len))
      else:
        discard rawGtk.set_text(selection, s.plain.cstring, g.gint(s.plain.len))
    except Exception as error: reportSignalError(error)
proc offerRichText*(clipboard: Clipboard, variants: openArray[SerializedText],
                    plainText: string): RichClipboardOffer =
  ## Offer copied native bytes and explicit plain fallback. Claiming ownership is
  ## deliberate. No source buffer/view or application callbacks are retained.
  requireOutsideModelFunction()
  if variants.len notin 1..16:
    raise newException(ValueError, "rich clipboard offers require 1..16 distinct formats")
  var names: seq[string]
  var copies: seq[SerializedText]
  for text in variants:
    if text.atom == 0: raise newException(ValueError, "uninitialized serialized text")
    if text.name in names: raise newException(ValueError, "duplicate rich clipboard format")
    validateTextEnvelope(text.bytes)
    names.add(text.name)
    copies.add(text)
  discard checkedUtf8Text(plainText)
  if plainText.len > high(g.gint).int: raise newException(ValueError, "clipboard text is too large")
  let p = clipboard.raw
  let s = RichOfferState(clipboard: clipboard, variants: move(copies), plain: plainText,
    active: true, pinned: true)
  result.state = s
  names.add(["UTF8_STRING", "COMPOUND_TEXT", "TEXT", "STRING",
    "text/plain;charset=utf-8", "text/plain"])
  s.targets = names
  var targets = newSeq[rawGtk.TTargetEntry](names.len)
  for i in 0..<targets.len:
    targets[i] = rawGtk.TTargetEntry(target: names[i].cstring, flags: 0,
      info: g.guint(i))
  GC_ref(s) # Native clipboard owns this pin until clear (even if token is dropped).
  let success = rawGtk.set_with_data(p, addr targets[0], g.guint(targets.len),
    richOfferGet, richOfferClear, cast[pointer](s))
  if not g.toBool(success):
    # GTK may already have called clear during a failed/reentrant replacement.
    releaseRichOffer(s)
    raise newException(ValueError, "GTK could not claim rich clipboard ownership")
proc offerRichText*(clipboard: Clipboard, text: SerializedText,
                    plainText: string): RichClipboardOffer =
  clipboard.offerRichText([text], plainText)

proc clear*(offer: RichClipboardOffer) =
  requireOutsideModelFunction()
  if offer.active: offer.state.clipboard.clear()

copiedOfferPersistence(RichClipboardOffer, s.targets)

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
  s.formats = @[]
  s.inspect = nil
  s.accept = nil
  let idle = s.idle
  s.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  if not s.nativePending: s.clipboard = Clipboard()
  GC_unref(s) # Request lifetime pin; native callback/source pins are independent.
proc cancel*(request: RichTextRequest) =
  requireOutsideModelFunction()
  if request.state != nil: releaseRichRequest(request.state)
proc richOwnerCurrent(s: RichRequestState): bool =
  not s.ownerEdited and (s.owner.state == nil or
    (not s.owner.isDestroyed and s.owner.buffer.raw == s.buffer.raw))
proc releaseRichIdle(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: GC_unref(cast[RichRequestState](data))
proc requestRichPlain(s: RichRequestState)
proc requestNextRich(s: RichRequestState)

proc passesRichPolicy[T](policy: proc (value: T): bool {.closure.}, input: T): bool =
  if policy == nil: return true
  inc modelFunctionDepth
  try: result = policy(input)
  finally: dec modelFunctionDepth

proc dispatchRichRequest(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[RichRequestState](data)
    if modelFunctionDepth != 0: return g.gbool(true)
    s.idle = 0
    if not s.active: return g.gbool(false)
    if not richOwnerCurrent(s):
      releaseRichRequest(s)
      return g.gbool(false)
    let mime = s.value.mime
    try:
      if s.advance:
        s.advance = false
        inc s.index
        requestNextRich(s)
        return g.gbool(false)
      if s.richAvailable:
        let format = s.formats[s.index]
        if s.inspect != nil:
          validateTextEnvelope(s.bytes)
          if not passesRichPolicy(s.inspect, RichClipboardEnvelope(mime: mime, byteCount: s.bytes.len)):
            raise newException(ValueError, "rich clipboard envelope rejected by application")
        if not s.active or not richOwnerCurrent(s):
          releaseRichRequest(s)
          return g.gbool(false)
        let payload = SerializedText(atom: format.atom, name: format.name, bytes: move(s.bytes))
        s.value = RichClipboardResult(kind: richDocument, mime: mime,
          document: format.deserialize(payload, tagsFrom = s.schema))
      if s.accept != nil and s.value.kind in {richPlainText, richDocument}:
        let preview = if s.value.kind == richPlainText: binaryCopy(s.value.text) else: s.value.document.text
        if not passesRichPolicy(s.accept, RichClipboardPreview(kind: s.value.kind, mime: mime, text: preview)):
          raise newException(ValueError, "rich clipboard preview rejected by application")
    except Exception as error:
      s.value = RichClipboardResult(kind: richRejected, mime: mime, error: error.msg)
    if not s.active or not richOwnerCurrent(s):
      releaseRichRequest(s)
      return g.gbool(false)
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
    if value.available:
      if value.text.len <= s.maxBytes:
        s.value = RichClipboardResult(kind: richPlainText, text: value.text)
      else:
        s.value = RichClipboardResult(kind: richRejected, error: "plain clipboard text exceeds maxBytes")
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
    let format = s.formats[s.index]
    try:
      if selection != nil and rawGtk.selection_data_get_length(selection) >= 0:
        s.value.mime = format.name
        # A successful reply with the wrong type/format is rejection, not a silent
        # text downgrade. Absent/refused targets have negative native length.
        s.richAvailable = true
        let length = rawGtk.selection_data_get_length(selection).int
        if rawGtk.selection_data_get_format(selection) != 8 or
            rawGtk.selection_data_get_data_type(selection) != format.atom or
            rawGtk.selection_data_get_target(selection) != format.atom:
          s.richAvailable = false
          s.value = RichClipboardResult(kind: richRejected, mime: format.name, error: "unexpected rich clipboard type or format")
        elif length > s.maxBytes:
          s.richAvailable = false
          s.value = RichClipboardResult(kind: richRejected, mime: format.name, error: "rich clipboard data exceeds maxBytes")
        else:
          let bytes = rawGtk.selection_data_get_data(selection)
          if length > 0 and bytes == nil:
            s.richAvailable = false
            s.value = RichClipboardResult(kind: richRejected, mime: format.name, error: "missing rich clipboard data")
          else:
            s.bytes = newString(length)
            if length > 0: copyMem(addr s.bytes[0], bytes, length)
      s.advance = not s.richAvailable and s.value.kind != richRejected
      queueRichRequest(s)
    except Exception as error:
      s.richAvailable = false
      s.value = RichClipboardResult(kind: richRejected, mime: format.name, error: error.msg)
      queueRichRequest(s)

proc requestNextRich(s: RichRequestState) =
  if s.index >= s.formats.len:
    requestRichPlain(s)
    return
  s.nativePending = true
  GC_ref(s)
  rawGtk.request_contents(s.clipboard.raw, s.formats[s.index].atom, richContents, cast[pointer](s))

proc startRichRequest(clipboard: Clipboard, owner: TextView, formats: openArray[TextFormat],
    trusted: bool, fn: proc (value: RichClipboardResult) {.closure.},
    fallbackToText: bool, tagsFrom: TextBuffer, maxBytes: int,
    inspect: RichEnvelopePolicy, accept: RichPreviewPolicy): RichTextRequest =
  discard clipboard.raw
  if fn == nil: raise newException(ValueError, "rich clipboard callback cannot be nil")
  if formats.len notin 1..16:
    raise newException(ValueError, "rich clipboard requests require 1..16 distinct formats")
  if maxBytes < 0 or maxBytes > high(g.gint).int:
    raise newException(ValueError, "rich clipboard maxBytes must be in 0..2147483647")
  if tagsFrom.state != nil: discard tagsFrom.raw
  var checked: seq[TextFormat]
  for format in formats:
    checkTextFormat(format)
    for prior in checked:
      if prior.atom == format.atom: raise newException(ValueError, "duplicate rich clipboard format")
    if tagsFrom.state != nil and format.canCreateTags:
      raise newException(ValueError, "tag creation cannot be combined with a shared tag schema")
    checked.add(format)
  if owner.state != nil: discard owner.raw
  let s = RichRequestState(active: true, clipboard: clipboard, formats: move(checked),
    schema: tagsFrom, owner: owner, fn: fn, fallback: fallbackToText,
    maxBytes: maxBytes, inspect: inspect, accept: accept)
  result.state = s
  GC_ref(s)
  if owner.state != nil:
    s.buffer = owner.buffer
    let request = result
    s.connections.add(owner.onDestroy(proc () = request.cancel()))
    # Internal invalidation is synchronous even during rich insertion. Do not
    # run application code or release owner/schema pins on the native stack.
    s.connections.add(connect(s.buffer, "changed", proc () =
      if richCommitActive:
        s.ownerEdited = true
        queueRichRequest(s)
      else: request.cancel(), after = true))
  if trusted: requestNextRich(s)
  else: requestRichPlain(s) # No native rich bytes requested or decoded without opt-in.
proc requestRichText*(clipboard: Clipboard, format: TextFormat, trusted: bool,
    fn: proc (value: RichClipboardResult) {.closure.}, fallbackToText = true,
    tagsFrom = default(TextBuffer), maxBytes = high(g.gint).int,
    inspect: RichEnvelopePolicy = nil, accept: RichPreviewPolicy = nil): RichTextRequest =
  startRichRequest(clipboard, TextView(), [format], trusted, fn, fallbackToText, tagsFrom, maxBytes, inspect, accept)
proc requestRichText*(clipboard: Clipboard, owner: TextView, format: TextFormat, trusted: bool,
    fn: proc (value: RichClipboardResult) {.closure.}, fallbackToText = true,
    tagsFrom = default(TextBuffer), maxBytes = high(g.gint).int,
    inspect: RichEnvelopePolicy = nil, accept: RichPreviewPolicy = nil): RichTextRequest =
  discard owner.raw
  startRichRequest(clipboard, owner, [format], trusted, fn, fallbackToText, tagsFrom, maxBytes, inspect, accept)

proc requestRichText*(clipboard: Clipboard, formats: openArray[TextFormat], trusted: bool,
    fn: proc (value: RichClipboardResult) {.closure.}, fallbackToText = true,
    tagsFrom = default(TextBuffer), maxBytes = 16 * 1024 * 1024,
    inspect: RichEnvelopePolicy = nil, accept: RichPreviewPolicy = nil): RichTextRequest =
  ## Try exact targets in caller order; only native refusal advances negotiation.
  ## Policies use copied metadata/text under synchronous pure-function guards.
  startRichRequest(clipboard, TextView(), formats, trusted, fn, fallbackToText, tagsFrom, maxBytes, inspect, accept)

proc requestRichText*(clipboard: Clipboard, owner: TextView, formats: openArray[TextFormat], trusted: bool,
    fn: proc (value: RichClipboardResult) {.closure.}, fallbackToText = true,
    tagsFrom = default(TextBuffer), maxBytes = 16 * 1024 * 1024,
    inspect: RichEnvelopePolicy = nil, accept: RichPreviewPolicy = nil): RichTextRequest =
  discard owner.raw
  startRichRequest(clipboard, owner, formats, trusted, fn, fallbackToText, tagsFrom, maxBytes, inspect, accept)
