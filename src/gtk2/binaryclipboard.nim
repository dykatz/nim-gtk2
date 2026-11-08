# Included by gtk2.nim. Outgoing opaque format-8 bytes; no parsing or fallback.
from std/strutils import startsWith
type
  BinaryData* = object
    target: string
    payload: seq[byte]
  BinaryOfferState = ref object
    clipboard: Clipboard
    value: BinaryData
    atom: rawGdk.TAtom
    active, pinned: bool
  BinaryClipboardOffer* = object
    state: BinaryOfferState

proc checkBinaryMime(mime: string) =
  const prefix = "application/"
  if not mime.startsWith(prefix) or mime.len <= prefix.len or mime.len > prefix.len + 127:
    raise newException(ValueError, "binary MIME must be a lowercase application subtype of 1..127 ASCII characters")
  let subtype = mime[prefix.len..^1]
  if subtype[0] notin {'a'..'z', '0'..'9'}:
    raise newException(ValueError, "binary MIME subtype must start with a lowercase letter or digit")
  for c in subtype:
    if c notin {'a'..'z', '0'..'9', '!', '#', '$', '&', '-', '^', '_', '.', '+'}:
      raise newException(ValueError, "binary MIME has an unsupported character or parameter")
  if subtype.startsWith("x-gtk-") or subtype.startsWith("x-gdk-") or
      subtype in ["x-color", "x-rootwindow-drop"]:
    raise newException(ValueError, "binary MIME is reserved for a native transfer protocol")
proc newBinaryData*(mime: string, bytes: openArray[byte]): BinaryData =
  ## Conservative explicit application MIME; opaque bytes, including NUL/non-UTF-8.
  checkBinaryMime(mime)
  # gtk_selection_data_set allocates length+1 using gint arithmetic.
  if bytes.len > high(g.gint).int - 1:
    raise newException(ValueError, "binary clipboard payload exceeds gint length+1 capacity")
  result.target = mime
  result.payload = newSeq[byte](bytes.len)
  if bytes.len > 0: copyMem(addr result.payload[0], unsafeAddr bytes[0], bytes.len)
proc mime*(value: BinaryData): string = value.target
proc len*(value: BinaryData): int = value.payload.len
proc bytes*(value: BinaryData): seq[byte] =
  result = newSeq[byte](value.payload.len)
  if result.len > 0: copyMem(addr result[0], unsafeAddr value.payload[0], result.len)
proc active*(offer: BinaryClipboardOffer): bool = offer.state != nil and offer.state.active
proc releaseBinaryOffer(s: BinaryOfferState) =
  s.active = false
  s.value = BinaryData()
  s.clipboard = Clipboard()
  if s.pinned:
    s.pinned = false
    GC_unref(s)
proc binaryOfferClear(clipboard: rawGtk.PClipboard, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: releaseBinaryOffer(cast[BinaryOfferState](data))
proc binaryOfferGet(clipboard: rawGtk.PClipboard, selection: rawGtk.PSelectionData,
    info: g.guint, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[BinaryOfferState](data)
    try:
      if not s.active: return
      let value = s.value # Root the original storage through native copying/clear.
      let p = if value.payload.len == 0: nil else: cast[g.Pguchar](unsafeAddr value.payload[0])
      rawGtk.set(selection, s.atom, 8, p, g.gint(value.payload.len))
    except Exception as error: reportSignalError(error)
proc offerBinary*(clipboard: Clipboard, value: BinaryData): BinaryClipboardOffer =
  ## Explicit single-target claim. Dropped tokens do not revoke the native pin.
  requireOutsideModelFunction()
  checkBinaryMime(value.target) # Default BinaryData is not a valid target.
  let p = clipboard.raw
  let s = BinaryOfferState(clipboard: clipboard, value: value,
    atom: transferAtom(value.target.cstring), active: true, pinned: true)
  result.state = s
  var target = rawGtk.TTargetEntry(target: s.value.target.cstring, flags: 0, info: 0)
  GC_ref(s)
  if not g.toBool(rawGtk.set_with_data(p, addr target, 1, binaryOfferGet, binaryOfferClear, cast[pointer](s))):
    releaseBinaryOffer(s) # GTK may already have cleared a failed reentrant candidate.
    raise newException(ValueError, "GTK could not claim binary clipboard ownership")
proc offerBinary*(clipboard: Clipboard, mime: string, bytes: openArray[byte]): BinaryClipboardOffer =
  requireOutsideModelFunction()
  clipboard.offerBinary(newBinaryData(mime, bytes))
proc clear*(offer: BinaryClipboardOffer) =
  requireOutsideModelFunction()
  if offer.active: offer.state.clipboard.clear()
