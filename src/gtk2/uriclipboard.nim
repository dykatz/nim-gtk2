# Included by gtk2.nim. Copied text/uri-list only; no launch, file I/O or text fallback.
type
  UriList* = object
    items: seq[string]
  UriClipboardKind* = enum urisUnavailable, urisAvailable, urisRejected
  ClipboardUris* = object
    kind*: UriClipboardKind
    uris*: seq[string]
    error*: string
  UriOfferState = ref object
    clipboard: Clipboard
    value: UriList
    active, pinned: bool
  UriClipboardOffer* = object
    state: UriOfferState
  UriRequestState = ref object
    clipboard: Clipboard
    active, nativePending: bool
    idle: g.guint
    owner: Connection
    fn: proc (value: ClipboardUris) {.closure.}
    value: ClipboardUris
  UriRequest* = object
    state: UriRequestState

proc checkUriToken(uri: string) =
  # Deliberately not a scheme-specific/authority parser or an authorization check.
  const letters = {'a'..'z', 'A'..'Z'}
  const hex = {'0'..'9', 'a'..'f', 'A'..'F'}
  if uri.len == 0 or uri[0] notin letters:
    raise newException(ValueError, "URI must have an absolute scheme")
  var i = 1
  while i < uri.len and uri[i] in letters + {'0'..'9', '+', '-', '.'}: inc i
  if i >= uri.len or uri[i] != ':':
    raise newException(ValueError, "URI must have an absolute scheme")
  inc i
  while i < uri.len:
    if uri[i] == '%':
      if i + 2 >= uri.len or uri[i+1] notin hex or uri[i+2] notin hex:
        raise newException(ValueError, "URI has an invalid percent escape")
      inc i, 3
    elif uri[i] in letters + {'0'..'9', '-', '.', '_', '~', ':', '/', '?', '#', '[', ']', '@', '!', '$', '&', '\'', '(', ')', '*', '+', ',', ';', '='}:
      inc i
    else:
      raise newException(ValueError, "URI must use ASCII URI characters; percent-encode other bytes")
proc newUriList*(uris: openArray[string]): UriList =
  ## Copy and check absolute ASCII URI tokens, preserving order/duplicates/escapes.
  ## Not scheme/host authorization, canonicalization or filesystem validation.
  var size = 0
  for uri in uris:
    checkUriToken(uri)
    if uri.len > high(g.gint).int - size - 2:
      raise newException(ValueError, "URI list is too large")
    size += uri.len + 2 # Native setter appends CRLF, and takes a gint byte length.
    result.items.add(uri)
proc uris*(value: UriList): seq[string] =
  for uri in value.items: result.add(uri) # Never expose the offer's sequence storage.
proc len*(value: UriList): int = value.items.len
proc active*(offer: UriClipboardOffer): bool = offer.state != nil and offer.state.active
proc releaseUriOffer(s: UriOfferState) =
  s.active = false
  s.value = UriList()
  s.clipboard = Clipboard()
  if s.pinned:
    s.pinned = false
    GC_unref(s)
proc uriOfferClear(clipboard: rawGtk.PClipboard, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: releaseUriOffer(cast[UriOfferState](data))
proc uriOfferGet(clipboard: rawGtk.PClipboard, selection: rawGtk.PSelectionData,
    info: g.guint, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[UriOfferState](data)
    try:
      if not s.active: return
      var vector = newSeq[cstring](s.value.items.len + 1)
      for i in 0..<s.value.items.len: vector[i] = s.value.items[i].cstring
      discard rawGtk.set_uris(selection, cast[g.PPgchar](addr vector[0]))
    except Exception as error: reportSignalError(error)
proc offerUris*(clipboard: Clipboard, value: UriList): UriClipboardOffer =
  ## Explicitly replace clipboard ownership. GTK pins copied data until clear;
  ## dropping the returned token does not revoke the offer.
  requireOutsideModelFunction()
  let p = clipboard.raw
  let s = UriOfferState(clipboard: clipboard, value: value, active: true, pinned: true)
  result.state = s
  var target = rawGtk.TTargetEntry(target: "text/uri-list", flags: 0, info: 0)
  GC_ref(s)
  if not g.toBool(rawGtk.set_with_data(p, addr target, 1, uriOfferGet, uriOfferClear, cast[pointer](s))):
    releaseUriOffer(s)
    raise newException(ValueError, "GTK could not claim URI clipboard ownership")
proc offerUris*(clipboard: Clipboard, uris: openArray[string]): UriClipboardOffer =
  requireOutsideModelFunction()
  clipboard.offerUris(newUriList(uris))
proc clear*(offer: UriClipboardOffer) =
  requireOutsideModelFunction()
  if offer.active: offer.state.clipboard.clear()
proc pending*(request: UriRequest): bool = request.state != nil and request.state.active
proc detachUriOwner(s: UriRequestState) =
  s.owner.disconnect()
  s.owner = Connection()
proc cancel*(request: UriRequest) =
  requireOutsideModelFunction()
  let s = request.state
  if s == nil or not s.active: return
  s.active = false
  s.fn = nil
  s.value = ClipboardUris()
  detachUriOwner(s)
  let idle = s.idle
  s.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  # The independent native pin/clipboard ref survives a canceled wire request.
  if not s.nativePending: s.clipboard = Clipboard()
proc releaseUriIdle(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: GC_unref(cast[UriRequestState](data))
proc dispatchUriRequest(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[UriRequestState](data)
    s.idle = 0
    if s.active:
      let fn = s.fn
      let value = s.value
      UriRequest(state: s).cancel() # Clear captures/connections before application code.
      try: fn(value)
      except Exception as error: reportSignalError(error)
    g.gbool(false)
proc readSelectionUris(selection: rawGtk.PSelectionData): ClipboardUris =
  if selection == nil or rawGtk.selection_data_get_length(selection) < 0: return
  result.kind = urisRejected
  result.error = "unexpected URI clipboard type or format"
  let atom = transferAtom("text/uri-list")
  if rawGtk.selection_data_get_target(selection) != atom or
      rawGtk.selection_data_get_data_type(selection) != atom or
      rawGtk.selection_data_get_format(selection) != 8: return
  let size = rawGtk.selection_data_get_length(selection).int
  let data = rawGtk.selection_data_get_data(selection)
  if size > 0 and data == nil:
    result.error = "missing URI clipboard data"
    return
  var bytes = newString(size)
  if size > 0: copyMem(addr bytes[0], data, size)
  discard checkedUtf8Text(bytes) # Reject embedded NUL/malformed UTF-8 before native conversion.
  if size == 0: return ClipboardUris(kind: urisAvailable)
  let vector = rawGtk.get_uris(selection) # Native comment/whitespace parsing, transfer full.
  if vector == nil:
    result.error = "GTK could not decode URI clipboard data"
    return
  defer: g.g_strfreev(vector)
  let array = cast[ptr UncheckedArray[cstring]](vector)
  var items: seq[string]
  var i = 0
  while array[i] != nil:
    let uri = $array[i]
    checkUriToken(uri)
    items.add(uri)
    inc i
  ClipboardUris(kind: urisAvailable, uris: items)
proc uriContents(clipboard: rawGtk.PClipboard, selection: rawGtk.PSelectionData,
    data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[UriRequestState](data)
    s.nativePending = false
    defer: GC_unref(s)
    if not s.active:
      s.clipboard = Clipboard()
      return
    try: s.value = readSelectionUris(selection)
    except ValueError as error: s.value = ClipboardUris(kind: urisRejected, error: error.msg)
    except Exception as error:
      s.value = ClipboardUris(kind: urisRejected, error: error.msg)
      reportSignalError(error)
    GC_ref(s)
    s.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchUriRequest),
      cast[pointer](s), cast[pointer](releaseUriIdle))
proc startUriRequest(clipboard: Clipboard, owner: Widget,
    fn: proc (value: ClipboardUris) {.closure.}): UriRequest =
  requireOutsideModelFunction()
  let p = clipboard.raw
  if fn == nil: raise newException(ValueError, "URI clipboard callback cannot be nil")
  if owner.state != nil: discard owner.raw
  let s = UriRequestState(clipboard: clipboard, active: true, nativePending: true, fn: fn)
  result.state = s
  if owner.state != nil:
    let request = result
    s.owner = owner.onDestroy(proc () = request.cancel())
  GC_ref(s)
  rawGtk.request_contents(p, transferAtom("text/uri-list"), uriContents, cast[pointer](s))
proc requestUris*(clipboard: Clipboard, fn: proc (value: ClipboardUris) {.closure.}): UriRequest =
  startUriRequest(clipboard, Widget(), fn)
proc requestUris*(clipboard: Clipboard, owner: Widget,
    fn: proc (value: ClipboardUris) {.closure.}): UriRequest =
  discard owner.raw
  startUriRequest(clipboard, owner, fn)
