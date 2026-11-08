# Included by gtk2.nim. Explicit trusted decoding on ordinary COPY-only image pads.
type
  ImageDropInfo* = object
    width*, height*: int
    hasAlpha*: bool
    x*, y*: int
    time*: uint32
  ImageDrop* = object
    info*: ImageDropInfo
    image*: Pixbuf # Private decoded pixel copy; application aliases are ordinary handles.
  ImageDropPredicate* = proc (value: ImageDropInfo): bool {.closure.}
  ImageSourceFlight = object
    context: rawGdk.PDragContext
    image: Pixbuf
  ImageWire = ref object
    context: rawGdk.PDragContext
    widget: rawGtk.PWidget
    receiver: Window # Unrealized independent receiver survives original pad destruction.
    receiverHandler: g.gulong
    target: rawGdk.TAtom
    x, y: int
    time: uint32
    finished: bool
  ImageSiteState = ref object
    widget: rawGtk.PWidget # Weak outside actual wire/cleanup work.
    source, active: bool
    receiving: int
    handlers: seq[g.gulong]
    maxPixels: int
    value, icon: Pixbuf # Private immutable copies; no getters exposing mutable storage.
    flights: seq[ImageSourceFlight]
    wires: seq[ImageWire]
    queue: RecentBinding[ImageDrop]
    accept: ImageDropPredicate
    cleanupIdle: g.guint
    cleanupWidget: rawGtk.PWidget
  ImageDragSource* = object
    state: ImageSiteState
  ImageDropSite* = object
    state: ImageSiteState
const
  imageSourceKey = "nim-gtk2-image-drag-source"
  imageDestKey = "nim-gtk2-image-drop-site"
proc releaseImageSite(data: pointer) {.cdecl.} = GC_unref(cast[ImageSiteState](data))
proc cleanupImageSite(s: ImageSiteState) =
  if s.active or s.wires.len != 0 or s.widget == nil: return
  let p = s.widget
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  s.widget = nil
  let handlers = move(s.handlers)
  for id in handlers:
    if g.g_signal_handler_is_connected(p, id): g.g_signal_handler_disconnect(p, id)
  if s.source: rawGtk.drag_source_unset(p)
  else: rawGtk.drag_dest_unset(p)
  let flights = move(s.flights)
  for flight in flights: g.g_object_unref(flight.context)
  s.value = Pixbuf()
  g.set_data_full(cast[g.PGObject](p), if s.source: imageSourceKey.cstring else: imageDestKey.cstring, nil, nil)
proc releaseImageCleanup(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[ImageSiteState](data)
    let p = s.cleanupWidget
    s.cleanupWidget = nil
    if p != nil: g.g_object_unref(p)
    GC_unref(s)
proc imageCleanupIdle(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[ImageSiteState](data)
    s.cleanupIdle = 0
    cleanupImageSite(s)
    g.gbool(false)
proc queueImageCleanup(s: ImageSiteState) =
  if s.active or s.wires.len != 0 or s.cleanupIdle != 0 or s.widget == nil: return
  s.cleanupWidget = cast[rawGtk.PWidget](g.g_object_ref(s.widget))
  GC_ref(s)
  s.cleanupIdle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](imageCleanupIdle),
    cast[pointer](s), cast[pointer](releaseImageCleanup))
proc disconnectImageSite(s: ImageSiteState) =
  requireOutsideModelFunction()
  if s == nil or not s.active: return
  s.active = false
  s.icon = Pixbuf()
  s.value = Pixbuf()
  s.accept = nil
  if s.queue != nil:
    releaseRecentBinding[ImageDrop](cast[pointer](s.queue), nil)
    s.queue = nil
  # Native replies cannot be canceled. Inactive sites reserve until actual receipt/timeout.
  if s.wires.len == 0:
    if s.receiving != 0: queueImageCleanup(s)
    else: cleanupImageSite(s)
proc disconnect*(source: ImageDragSource) = disconnectImageSite(source.state)
proc disconnect*(site: ImageDropSite) = disconnectImageSite(site.state)
proc connected*(source: ImageDragSource): bool = source.state != nil and source.state.active
proc connected*(site: ImageDropSite): bool = site.state != nil and site.state.active
proc draining*(site: ImageDropSite): bool =
  site.state != nil and not site.state.active and site.state.widget != nil
proc setImage*(source: ImageDragSource, image: Pixbuf) =
  requireOutsideModelFunction()
  if not source.connected: raise newException(ValueError, "image drag source is disconnected")
  let snapshot = image.copy()
  if not source.connected: raise newException(ValueError, "image drag source is disconnected")
  source.state.value = snapshot # Actual begin snapshots retain the previous immutable copy.
proc imageSiteDestroyed(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: disconnectImageSite(cast[ImageSiteState](data))
    except Exception as error: reportSignalError(error)
proc connectImageSite(s: ImageSiteState, signal: cstring, thunk: g.TGCallback) =
  s.handlers.add(g.g_signal_connect_data(s.widget, signal, thunk, cast[pointer](s), nil, g.TGConnectFlags(0)))
proc imageSourceBegin(instance: pointer, context: rawGdk.PDragContext, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[ImageSiteState](data)
    GC_ref(s)
    defer: GC_unref(s)
    try:
      if s.active:
        for flight in s.flights:
          if flight.context == context: return
        s.flights.add(ImageSourceFlight(context: cast[rawGdk.PDragContext](g.g_object_ref(context)), image: s.value))
        applySourceIcon(context, s.icon)
    except Exception as error: reportSignalError(error)
proc imageSourceEnd(instance: pointer, context: rawGdk.PDragContext, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[ImageSiteState](data)
    GC_ref(s)
    defer: GC_unref(s)
    for i, flight in s.flights:
      if flight.context == context:
        s.flights.delete(i)
        g.g_object_unref(context)
        break
proc imageSourceData(instance: pointer, context: rawGdk.PDragContext, selection: rawGtk.PSelectionData,
    info: g.guint, time: g.guint32, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[ImageSiteState](data)
    GC_ref(s)
    defer: GC_unref(s)
    if not s.active: return
    try:
      for flight in s.flights:
        if flight.context == context:
          # GTK may invoke encoders/reenter before it finishes reading pixels.
          let p = flight.image.raw
          discard g.g_object_ref(p)
          defer: g.g_object_unref(p)
          discard rawGtk.set_pixbuf(selection, p)
          return
    except Exception as error: reportSignalError(error)
proc acceptImageDrop(s: ImageSiteState, value: ImageDropInfo): bool =
  let predicate = s.accept
  if predicate == nil: return true
  try:
    if not s.active: return false
    inc modelFunctionDepth
    try: result = predicate(value)
    finally: dec modelFunctionDepth
  except Exception as error:
    reportSignalError(error)
    result = false
proc imageDestData(instance: pointer, context: rawGdk.PDragContext, x, y: g.gint,
    selection: rawGtk.PSelectionData, info: g.guint, time: g.guint32, data: pointer) {.cdecl, gcsafe.}
proc imageDestDrop(instance: pointer, context: rawGdk.PDragContext, x, y: g.gint,
    time: g.guint32, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[ImageSiteState](data)
    GC_ref(s)
    defer: GC_unref(s)
    if not s.active: return g.gbool(false)
    try:
      for wire in s.wires:
        if wire.context == context: return g.gbool(true)
      if rawGdk.drag_context_get_selected_action(context) != rawGdk.ACTION_COPY: return g.gbool(false)
      let target = rawGtk.drag_dest_find_target(s.widget, context, nil)
      if target == rawGdk.TAtom(0): return g.gbool(false)
      let receiver = newWindow("", 1, 1)
      if not s.active:
        receiver.destroy()
        return g.gbool(false)
      rawGtk.set_screen(receiver.raw, rawGtk.get_screen(s.widget))
      if not s.active:
        receiver.destroy()
        return g.gbool(false)
      let wire = ImageWire(context: cast[rawGdk.PDragContext](g.g_object_ref(context)),
        widget: cast[rawGtk.PWidget](g.g_object_ref(s.widget)), receiver: receiver, target: target,
        x: x.int, y: y.int, time: time.uint32)
      wire.receiverHandler = g.g_signal_connect_data(receiver.raw, "drag-data-received",
        cast[g.TGCallback](imageDestData), cast[pointer](s), nil, g.TGConnectFlags(0))
      s.wires.add(wire)
      GC_ref(s)
      rawGtk.drag_get_data(cast[rawGtk.PWidget](receiver.raw), context, target, time)
      return g.gbool(true)
    except Exception as error: reportSignalError(error)
    g.gbool(false)
proc imageDestData(instance: pointer, context: rawGdk.PDragContext, x, y: g.gint,
    selection: rawGtk.PSelectionData, info: g.guint, time: g.guint32, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[ImageSiteState](data)
    for i in 0..<s.wires.len:
      if s.wires[i].context != context: continue
      let wire = move(s.wires[i])
      s.wires.delete(i)
      inc s.receiving
      defer:
        dec s.receiving
        if not s.active: queueImageCleanup(s)
        g.g_signal_handler_disconnect(wire.receiver.raw, wire.receiverHandler)
        wire.receiver.destroy()
        g.g_object_unref(wire.context)
        g.g_object_unref(wire.widget)
        GC_unref(s)
      var valid = false
      var value: ImageDrop
      try:
        if s.active and not wire.finished and
            rawGdk.drag_context_get_selected_action(context) == rawGdk.ACTION_COPY and
            selection != nil and rawGtk.selection_data_get_target(selection) == wire.target and
            rawGtk.selection_data_get_data_type(selection) == wire.target and
            rawGtk.selection_data_get_format(selection) == 8 and
            rawGtk.selection_data_get_length(selection) > 0 and rawGtk.selection_data_get_data(selection) != nil:
          # Trust was required at attachment; canceled/non-COPY/wrong-envelope replies skip decoding.
          let decoded = rawGtk.get_pixbuf(selection) # Transfer full, native autodetecting loader.
          defer:
            if decoded != nil: g.g_object_unref(decoded)
          if decoded != nil and s.active:
            let received = copyClipboardImage(decoded, s.maxPixels) # Post-decode copy bound, not a sandbox.
            valid = s.active and received.kind == imageAvailable and
              rawGdk.drag_context_get_selected_action(context) == rawGdk.ACTION_COPY
            if valid:
              value = ImageDrop(image: received.image, info: ImageDropInfo(width: received.image.width,
                height: received.image.height, hasAlpha: received.image.hasAlpha,
                x: wire.x, y: wire.y, time: wire.time))
              valid = acceptImageDrop(s, value.info) and s.active
      except Exception as error:
        valid = false
        reportSignalError(error)
      if not wire.finished:
        wire.finished = true
        rawGtk.drag_finish(context, g.gbool(valid), g.gbool(false), g.guint32(wire.time))
      if valid and s.active: queueRecent(cast[pointer](s.queue), value)
      return
proc imageTargetTable(writable: bool): tuple[table: rawGtk.PTargetEntry, count: g.gint] =
  let list = rawGtk.list_new(nil, 0)
  if list == nil: raise newException(ValueError, "could not allocate image drag targets")
  defer: rawGtk.unref(list)
  rawGtk.add_image_targets(list, 0, g.gbool(writable))
  result.table = rawGtk.target_table_new_from_list(list, addr result.count)
  if result.table == nil or result.count <= 0:
    if result.table != nil: rawGtk.target_table_free(result.table, result.count)
    raise newException(ValueError, "no native image drag targets available")
proc installImageSite(w: Widget, source: bool): ImageSiteState =
  let p = checkTransferPad(w)
  let key = if source: imageSourceKey.cstring else: imageDestKey.cstring
  if g.get_data(cast[g.PGObject](p), key) != nil:
    raise newException(ValueError, "widget already has an active or draining image transfer site")
  let targets = if source: rawGtk.drag_source_get_target_list(p) else: rawGtk.drag_dest_get_target_list(p)
  if targets != nil: raise newException(ValueError, "widget already has a native drag/drop site")
  result = ImageSiteState(widget: p, source: source, active: true)
  GC_ref(result)
  g.set_data_full(cast[g.PGObject](p), key, cast[pointer](result), releaseImageSite)
  result.connectImageSite("destroy", cast[g.TGCallback](imageSiteDestroyed))
proc enableImageDrag*(w: Widget, image: Pixbuf): ImageDragSource {.discardable.} =
  requireOutsideModelFunction()
  let snapshot = image.copy() # Prepare everything before touching native registration.
  let targets = imageTargetTable(true)
  defer: rawGtk.target_table_free(targets.table, targets.count)
  let s = installImageSite(w, true)
  s.value = snapshot
  s.connectImageSite("drag-begin", cast[g.TGCallback](imageSourceBegin))
  s.connectImageSite("drag-end", cast[g.TGCallback](imageSourceEnd))
  s.connectImageSite("drag-data-get", cast[g.TGCallback](imageSourceData))
  rawGtk.drag_source_set(s.widget, rawGdk.TModifierType(rawGdk.BUTTON1_MASK), targets.table, targets.count, rawGdk.ACTION_COPY)
  ImageDragSource(state: s)
proc onImageDrop*(w: Widget, trusted: bool, fn: proc (value: ImageDrop) {.closure.},
    maxPixels = 4 * 1024 * 1024, accept: ImageDropPredicate = nil): ImageDropSite {.discardable.} =
  requireOutsideModelFunction()
  if not trusted: raise newException(ValueError, "image drop decoding requires explicit trust")
  if maxPixels < 0 or maxPixels > high(g.gint).int div 4:
    raise newException(ValueError, "image maxPixels must be in 0..536870911")
  if fn == nil: raise newException(ValueError, "image drop callback cannot be nil")
  let targets = imageTargetTable(false)
  defer: rawGtk.target_table_free(targets.table, targets.count)
  let s = installImageSite(w, false)
  s.maxPixels = maxPixels
  s.accept = accept
  s.queue = RecentBinding[ImageDrop](active: true, fn: fn)
  GC_ref(s.queue)
  s.connectImageSite("drag-drop", cast[g.TGCallback](imageDestDrop))
  rawGtk.drag_dest_set(s.widget, rawGtk.TDestDefaults(rawGtk.DEST_DEFAULT_MOTION or rawGtk.DEST_DEFAULT_HIGHLIGHT),
    targets.table, targets.count, rawGdk.ACTION_COPY)
  ImageDropSite(state: s)
