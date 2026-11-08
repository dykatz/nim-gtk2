# Included by gtk2.nim. Explicit outgoing images only; native writable encoders.
type
  ImageOfferState = ref object
    clipboard: Clipboard
    snapshot: Pixbuf
    active, pinned: bool
  ImageClipboardOffer* = object
    state: ImageOfferState

proc active*(offer: ImageClipboardOffer): bool = offer.state != nil and offer.state.active
proc releaseImageOffer(s: ImageOfferState) =
  s.active = false
  s.snapshot = Pixbuf()
  s.clipboard = Clipboard()
  if s.pinned:
    s.pinned = false
    GC_unref(s)
proc imageOfferClear(clipboard: rawGtk.PClipboard, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: releaseImageOffer(cast[ImageOfferState](data))
proc imageOfferGet(clipboard: rawGtk.PClipboard, selection: rawGtk.PSelectionData,
    info: g.guint, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[ImageOfferState](data)
    try:
      if s.active:
        let snapshot = s.snapshot # Keep the original pixels alive through native encoding/clear.
        discard rawGtk.set_pixbuf(selection, snapshot.raw)
    except Exception as error: reportSignalError(error)
proc offerImage*(clipboard: Clipboard, image: Pixbuf): ImageClipboardOffer =
  ## Explicitly publish a private pixel copy using GTK's writable image targets.
  ## No persistence/decoding. Dropping the token does not revoke native ownership.
  requireOutsideModelFunction()
  let p = clipboard.raw
  let snapshot = image.copy() # Validate/copy before any native ownership change.
  let list = rawGtk.list_new(nil, 0)
  if list == nil: raise newException(ValueError, "GTK could not allocate image targets")
  defer: rawGtk.unref(list)
  rawGtk.add_image_targets(list, 0, g.gbool(true))
  var count: g.gint
  let targets = rawGtk.target_table_new_from_list(list, addr count)
  defer:
    if targets != nil: rawGtk.target_table_free(targets, count)
  if targets == nil or count <= 0:
    raise newException(ValueError, "GTK has no writable clipboard image targets")
  let s = ImageOfferState(clipboard: clipboard, snapshot: snapshot, active: true, pinned: true)
  result.state = s
  GC_ref(s)
  if not g.toBool(rawGtk.set_with_data(p, targets, g.guint(count), imageOfferGet,
      imageOfferClear, cast[pointer](s))):
    releaseImageOffer(s)
    raise newException(ValueError, "GTK could not claim image clipboard ownership")
proc clear*(offer: ImageClipboardOffer) =
  requireOutsideModelFunction()
  if offer.active: offer.state.clipboard.clear()
