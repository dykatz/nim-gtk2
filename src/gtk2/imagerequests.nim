# Included by gtk2.nim. Explicit trust gates native codec decoding, not a sandbox.
type
  ImageClipboardKind* = enum imageUnavailable, imageAvailable, imageRejected
  ClipboardImage* = object
    kind*: ImageClipboardKind
    image*: Pixbuf # Owned private pixel copy; aliases within application values are ordinary handles.
    error*: string
  ImageRequestState = ref object
    clipboard: Clipboard
    maxPixels: int
    active, nativePending: bool
    idle: g.guint
    ownerWidget: g.PGObject # Weak: a public Connection would retain the owner.
    ownerHandler: g.gulong
    fn: proc (value: ClipboardImage) {.closure.}
    value: ClipboardImage
  ImageRequest* = object
    state: ImageRequestState

proc pending*(request: ImageRequest): bool = request.state != nil and request.state.active
proc detachImageOwner(s: ImageRequestState) =
  let p = s.ownerWidget
  let id = s.ownerHandler
  s.ownerWidget = nil
  s.ownerHandler = 0
  if p != nil and id != 0 and g.g_signal_handler_is_connected(p, id):
    g.g_signal_handler_disconnect(p, id)
proc cancelImageRequest(s: ImageRequestState) =
  if s == nil or not s.active: return
  s.active = false
  s.fn = nil
  s.value = ClipboardImage()
  detachImageOwner(s)
  let idle = s.idle
  s.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  if not s.nativePending: s.clipboard = Clipboard()
proc cancel*(request: ImageRequest) =
  requireOutsideModelFunction()
  cancelImageRequest(request.state)
proc releaseImageOwner(data: pointer, closure: g.PGClosure) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[ImageRequestState](data)
    defer: GC_unref(s)
    try:
      if s.ownerWidget != nil:
        s.ownerWidget = nil
        s.ownerHandler = 0
        cancelImageRequest(s) # Never reference/disconnect a finalizing owner.
    except Exception as error: reportSignalError(error)
proc destroyImageOwner(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: cancelImageRequest(cast[ImageRequestState](data))
    except Exception as error: reportSignalError(error)
proc releaseImageIdle(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: GC_unref(cast[ImageRequestState](data))
proc dispatchImageRequest(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[ImageRequestState](data)
    s.idle = 0
    if s.active:
      let fn = s.fn
      let value = s.value
      cancelImageRequest(s) # Clear captures/owner before locally rooted user work.
      try: fn(value)
      except Exception as error: reportSignalError(error)
    g.gbool(false)
proc copyClipboardImage(image: rawPixbuf.PPixbuf, maxPixels: int): ClipboardImage =
  if image == nil: return # GTK conflates absent/unsupported data and decoder failure.
  result.kind = imageRejected
  let width = rawPixbuf.get_width(image).int64
  let height = rawPixbuf.get_height(image).int64
  result.error = "invalid image clipboard dimensions"
  if width <= 0 or height <= 0: return
  result.error = "image clipboard reply exceeds maxPixels"
  if width * height > maxPixels.int64: return # Before our pixel allocation/copy, AFTER native decode.
  result.image = requiredPixbuf(rawPixbuf.copy(image))
  result.kind = imageAvailable
  result.error = ""
proc imageContents(clipboard: rawGtk.PClipboard, image: rawPixbuf.PPixbuf,
    data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[ImageRequestState](data)
    s.nativePending = false
    defer: GC_unref(s) # GTK owns the borrowed decoded image through this callback.
    if not s.active:
      s.clipboard = Clipboard()
      return # Cancel skips our copy, NOT native decoding/codec negotiation.
    try: s.value = copyClipboardImage(image, s.maxPixels)
    except Exception as error:
      s.value = ClipboardImage(kind: imageRejected, error: error.msg)
      reportSignalError(error)
    if not s.active:
      s.value = ClipboardImage()
      s.clipboard = Clipboard()
      return
    GC_ref(s)
    s.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchImageRequest),
      cast[pointer](s), cast[pointer](releaseImageIdle))
proc startImageRequest(clipboard: Clipboard, owner: Widget, trusted: bool,
    fn: proc (value: ClipboardImage) {.closure.}, maxPixels: int): ImageRequest =
  requireOutsideModelFunction()
  if not trusted: raise newException(ValueError, "image clipboard decoding requires explicit trust")
  if maxPixels < 0 or maxPixels > high(g.gint).int div 4:
    raise newException(ValueError, "image maxPixels must be in 0..536870911")
  if fn == nil: raise newException(ValueError, "image clipboard callback cannot be nil")
  let p = clipboard.raw
  if owner.state != nil: discard owner.raw
  let s = ImageRequestState(clipboard: clipboard, maxPixels: maxPixels,
    active: true, nativePending: true, fn: fn)
  result.state = s
  GC_ref(s) # Wire pin survives tokens/owner destruction and GTK's codec retries.
  if owner.state != nil:
    s.ownerWidget = cast[g.PGObject](owner.raw)
    GC_ref(s)
    s.ownerHandler = g.g_signal_connect_data(s.ownerWidget, "destroy",
      cast[g.TGCallback](destroyImageOwner), cast[pointer](s), releaseImageOwner, g.TGConnectFlags(0))
  rawGtk.request_image(p, imageContents, cast[pointer](s))
proc requestImage*(clipboard: Clipboard, trusted: bool,
    fn: proc (value: ClipboardImage) {.closure.}, maxPixels = 4 * 1024 * 1024): ImageRequest =
  ## Trust must be explicit before GTK decodes. Limit only our post-decode pixel copy.
  startImageRequest(clipboard, Widget(), trusted, fn, maxPixels)
proc requestImage*(clipboard: Clipboard, owner: Widget, trusted: bool,
    fn: proc (value: ClipboardImage) {.closure.}, maxPixels = 4 * 1024 * 1024): ImageRequest =
  ## Non-retaining owner cancels delivery, not decoding, native memory or wire retries.
  requireOutsideModelFunction()
  discard owner.raw
  startImageRequest(clipboard, owner, trusted, fn, maxPixels)
