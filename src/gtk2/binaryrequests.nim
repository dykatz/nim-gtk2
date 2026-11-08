# Included by gtk2.nim after binaryclipboard. Opaque copied replies, never a parser.
type
  BinaryClipboardKind* = enum bytesUnavailable, bytesAvailable, bytesRejected
  ClipboardBytes* = object
    kind*: BinaryClipboardKind
    mime*: string
    bytes*: seq[byte]
    error*: string
  BinaryRequestState = ref object
    clipboard: Clipboard
    mime: string
    atom: rawGdk.TAtom
    maxBytes: int
    active, nativePending: bool
    idle: g.guint
    ownerWidget: g.PGObject # Non-owning; native signal closure has its own state pin.
    ownerHandler: g.gulong
    fn: proc (value: ClipboardBytes) {.closure.}
    value: ClipboardBytes
  BinaryRequest* = object
    state: BinaryRequestState

proc pending*(request: BinaryRequest): bool = request.state != nil and request.state.active
proc detachBinaryOwner(s: BinaryRequestState) =
  let p = s.ownerWidget
  let id = s.ownerHandler
  s.ownerWidget = nil
  s.ownerHandler = 0
  if p != nil and id != 0 and g.g_signal_handler_is_connected(p, id):
    g.g_signal_handler_disconnect(p, id)
proc cancelBinaryRequest(s: BinaryRequestState) =
  if s == nil or not s.active: return
  s.active = false
  s.fn = nil
  s.value = ClipboardBytes()
  detachBinaryOwner(s)
  let idle = s.idle
  s.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  if not s.nativePending: s.clipboard = Clipboard()
proc cancel*(request: BinaryRequest) =
  requireOutsideModelFunction()
  cancelBinaryRequest(request.state)
proc releaseBinaryOwner(data: pointer, closure: g.PGClosure) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[BinaryRequestState](data)
    defer: GC_unref(s)
    try:
      if s.ownerWidget != nil:
        s.ownerWidget = nil # Never ref/disconnect a finalizing native owner.
        s.ownerHandler = 0
        cancelBinaryRequest(s)
    except Exception as error: reportSignalError(error)
proc destroyBinaryOwner(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: cancelBinaryRequest(cast[BinaryRequestState](data))
    except Exception as error: reportSignalError(error)
proc releaseBinaryIdle(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: GC_unref(cast[BinaryRequestState](data))
proc dispatchBinaryRequest(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[BinaryRequestState](data)
    s.idle = 0
    if s.active:
      let fn = s.fn
      let value = s.value
      BinaryRequest(state: s).cancel() # Detach before reentrant application work.
      try: fn(value)
      except Exception as error: reportSignalError(error)
    g.gbool(false)
proc readSelectionBytes(selection: rawGtk.PSelectionData, atom: rawGdk.TAtom,
    mime: string, maxBytes: int): ClipboardBytes =
  result.mime = mime
  if selection == nil or rawGtk.selection_data_get_length(selection) < 0: return
  result.kind = bytesRejected
  result.error = "unexpected binary clipboard target, type or format"
  if rawGtk.selection_data_get_target(selection) != atom or
      rawGtk.selection_data_get_data_type(selection) != atom or
      rawGtk.selection_data_get_format(selection) != 8: return
  let size = rawGtk.selection_data_get_length(selection).int
  result.error = "binary clipboard reply exceeds maxBytes"
  if size > maxBytes: return # Before any application payload allocation/copy.
  let data = rawGtk.selection_data_get_data(selection)
  result.error = "missing binary clipboard data"
  if size > 0 and data == nil: return
  result.bytes = newSeq[byte](size)
  if size > 0: copyMem(addr result.bytes[0], data, size)
  result.kind = bytesAvailable
  result.error = ""
proc binaryContents(clipboard: rawGtk.PClipboard, selection: rawGtk.PSelectionData,
    data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[BinaryRequestState](data)
    s.nativePending = false
    defer: GC_unref(s) # Wire pin lasts until real receipt, including after cancel.
    if not s.active:
      s.clipboard = Clipboard()
      return
    try: s.value = readSelectionBytes(selection, s.atom, s.mime, s.maxBytes)
    except Exception as error:
      s.value = ClipboardBytes(kind: bytesRejected, mime: s.mime, error: error.msg)
      reportSignalError(error)
    if not s.active:
      s.value = ClipboardBytes()
      s.clipboard = Clipboard()
      return
    GC_ref(s)
    s.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchBinaryRequest),
      cast[pointer](s), cast[pointer](releaseBinaryIdle))
proc startBinaryRequest(clipboard: Clipboard, owner: Widget, mime: string,
    fn: proc (value: ClipboardBytes) {.closure.}, maxBytes: int): BinaryRequest =
  requireOutsideModelFunction()
  checkBinaryMime(mime)
  if maxBytes < 0 or maxBytes > high(g.gint).int - 1:
    raise newException(ValueError, "binary maxBytes must be in 0..2147483646")
  if fn == nil: raise newException(ValueError, "binary clipboard callback cannot be nil")
  let p = clipboard.raw
  if owner.state != nil: discard owner.raw
  let s = BinaryRequestState(clipboard: clipboard, mime: mime, atom: transferAtom(mime.cstring),
    maxBytes: maxBytes, active: true, nativePending: true, fn: fn)
  result.state = s
  GC_ref(s) # Independent native request pin, even when owner/caller tokens disappear.
  if owner.state != nil:
    s.ownerWidget = cast[g.PGObject](owner.raw)
    GC_ref(s) # Native owner signal closure, not an owning Widget/Connection handle.
    s.ownerHandler = g.g_signal_connect_data(s.ownerWidget, "destroy",
      cast[g.TGCallback](destroyBinaryOwner), cast[pointer](s), releaseBinaryOwner, g.TGConnectFlags(0))
  rawGtk.request_contents(p, s.atom, binaryContents, cast[pointer](s))
proc requestBinary*(clipboard: Clipboard, mime: string,
    fn: proc (value: ClipboardBytes) {.closure.}, maxBytes = 16 * 1024 * 1024): BinaryRequest =
  ## Request one opaque application MIME; copied observations always run at idle.
  ## maxBytes bounds our copy, not native receipt/INCR allocation or owner work.
  startBinaryRequest(clipboard, Widget(), mime, fn, maxBytes)
proc requestBinary*(clipboard: Clipboard, owner: Widget, mime: string,
    fn: proc (value: ClipboardBytes) {.closure.}, maxBytes = 16 * 1024 * 1024): BinaryRequest =
  ## Non-retaining owner binding: destruction/disposal cancels user delivery only.
  discard owner.raw
  startBinaryRequest(clipboard, owner, mime, fn, maxBytes)
