# Included by gtk2.nim. Ordinary COPY pads; opaque bytes, never a parser.
type
  BinaryDrop* = object
    mime*: string
    bytes*: seq[byte]
    x*, y*: int
    time*: uint32
  BinaryDropPredicate* = proc (value: BinaryDrop): bool {.closure.}
  BinarySourceFlight = object
    context: rawGdk.PDragContext
    value: BinaryData
  BinaryWire = ref object
    context: rawGdk.PDragContext
    widget: rawGtk.PWidget
    receiver: Window # Independent and unrealized; destroyed pads lose native signals.
    receiverHandler: g.gulong
    x, y: int
    time: uint32
    finished: bool
  BinarySiteState = ref object
    widget: rawGtk.PWidget # Weak except for wire/cleanup pins.
    source, active: bool
    receiving: int
    handlers: seq[g.gulong]
    mime: string
    atom: rawGdk.TAtom
    maxBytes: int
    value: BinaryData
    flights: seq[BinarySourceFlight]
    wires: seq[BinaryWire]
    queue: RecentBinding[BinaryDrop]
    accept: BinaryDropPredicate
    cleanupIdle: g.guint
    cleanupWidget: rawGtk.PWidget
  BinaryDragSource* = object
    state: BinarySiteState
  BinaryDropSite* = object
    state: BinarySiteState
const
  binarySourceKey = "nim-gtk2-binary-drag-source"
  binaryDestKey = "nim-gtk2-binary-drop-site"
proc releaseBinarySite(data: pointer) {.cdecl.} = GC_unref(cast[BinarySiteState](data))
proc cleanupBinarySite(s: BinarySiteState) =
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
  s.value = BinaryData()
  g.set_data_full(cast[g.PGObject](p), if s.source: binarySourceKey.cstring else: binaryDestKey.cstring, nil, nil)
proc releaseBinaryCleanup(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[BinarySiteState](data)
    let p = s.cleanupWidget
    s.cleanupWidget = nil
    if p != nil: g.g_object_unref(p)
    GC_unref(s)
proc binaryCleanupIdle(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[BinarySiteState](data)
    s.cleanupIdle = 0
    cleanupBinarySite(s)
    g.gbool(false)
proc queueBinaryCleanup(s: BinarySiteState) =
  if s.active or s.wires.len != 0 or s.cleanupIdle != 0 or s.widget == nil: return
  s.cleanupWidget = cast[rawGtk.PWidget](g.g_object_ref(s.widget))
  GC_ref(s)
  s.cleanupIdle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](binaryCleanupIdle),
    cast[pointer](s), cast[pointer](releaseBinaryCleanup))
proc disconnectBinarySite(s: BinarySiteState) =
  requireOutsideModelFunction()
  if s == nil or not s.active: return
  s.active = false
  s.accept = nil
  if s.queue != nil:
    releaseRecentBinding[BinaryDrop](cast[pointer](s.queue), nil)
    s.queue = nil
  s.value = BinaryData()
  # Never finish before actual reply/timeout. Keep the native site reserved while draining.
  if s.wires.len == 0:
    if s.receiving != 0: queueBinaryCleanup(s)
    else: cleanupBinarySite(s)
proc disconnect*(source: BinaryDragSource) = disconnectBinarySite(source.state)
proc disconnect*(site: BinaryDropSite) = disconnectBinarySite(site.state)
proc connected*(source: BinaryDragSource): bool = source.state != nil and source.state.active
proc connected*(site: BinaryDropSite): bool = site.state != nil and site.state.active
proc draining*(site: BinaryDropSite): bool =
  site.state != nil and not site.state.active and site.state.widget != nil
proc data*(source: BinaryDragSource): BinaryData =
  requireOutsideModelFunction()
  if not source.connected: raise newException(ValueError, "binary drag source is disconnected")
  source.state.value
proc `data=`*(source: BinaryDragSource, value: BinaryData) =
  requireOutsideModelFunction()
  if not source.connected: raise newException(ValueError, "binary drag source is disconnected")
  checkBinaryMime(value.target)
  if value.target != source.state.mime:
    raise newException(ValueError, "binary drag MIME is fixed per attachment")
  source.state.value = value # In-flight contexts retain their begin snapshot.
proc binarySiteDestroyed(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: disconnectBinarySite(cast[BinarySiteState](data))
    except Exception as error: reportSignalError(error)
proc connectBinarySite(s: BinarySiteState, signal: cstring, thunk: g.TGCallback) =
  s.handlers.add(g.g_signal_connect_data(s.widget, signal, thunk, cast[pointer](s), nil, g.TGConnectFlags(0)))
proc binarySourceBegin(instance: pointer, context: rawGdk.PDragContext, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[BinarySiteState](data)
    try:
      if s.active:
        for flight in s.flights:
          if flight.context == context: return
        s.flights.add(BinarySourceFlight(context: cast[rawGdk.PDragContext](g.g_object_ref(context)), value: s.value))
    except Exception as error: reportSignalError(error)
proc binarySourceEnd(instance: pointer, context: rawGdk.PDragContext, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[BinarySiteState](data)
    for i, flight in s.flights:
      if flight.context == context:
        s.flights.delete(i)
        g.g_object_unref(context)
        break
proc binarySourceData(instance: pointer, context: rawGdk.PDragContext, selection: rawGtk.PSelectionData,
    info: g.guint, time: g.guint32, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[BinarySiteState](data)
    if not s.active: return
    try:
      for flight in s.flights:
        if flight.context == context:
          let value = flight.value
          let p = if value.payload.len == 0: nil else: cast[g.Pguchar](unsafeAddr value.payload[0])
          rawGtk.set(selection, s.atom, 8, p, g.gint(value.payload.len))
          return
    except Exception as error: reportSignalError(error)
proc acceptBinaryDrop(s: BinarySiteState, value: BinaryDrop): bool =
  let predicate = s.accept
  if predicate == nil: return true
  try:
    var input = BinaryDrop(mime: value.mime, x: value.x, y: value.y, time: value.time,
      bytes: newSeq[byte](value.bytes.len))
    if input.bytes.len > 0: copyMem(addr input.bytes[0], unsafeAddr value.bytes[0], input.bytes.len)
    if not s.active: return false
    inc modelFunctionDepth
    try: result = predicate(input)
    finally: dec modelFunctionDepth
  except Exception as error:
    reportSignalError(error)
    result = false
proc binaryDestData(instance: pointer, context: rawGdk.PDragContext, x, y: g.gint,
    selection: rawGtk.PSelectionData, info: g.guint, time: g.guint32, data: pointer) {.cdecl, gcsafe.}
proc binaryDestDrop(instance: pointer, context: rawGdk.PDragContext, x, y: g.gint,
    time: g.guint32, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[BinarySiteState](data)
    if not s.active: return g.gbool(false)
    try:
      for wire in s.wires:
        if wire.context == context: return g.gbool(true)
      if rawGdk.drag_context_get_selected_action(context) != rawGdk.ACTION_COPY: return g.gbool(false)
      let target = rawGtk.drag_dest_find_target(s.widget, context, nil)
      if target != s.atom: return g.gbool(false)
      let receiver = newWindow("", 1, 1) # Never shown/realized; GTK owns its IPC resource.
      rawGtk.set_screen(receiver.raw, rawGtk.get_screen(s.widget))
      let wire = BinaryWire(context: cast[rawGdk.PDragContext](g.g_object_ref(context)),
        widget: cast[rawGtk.PWidget](g.g_object_ref(s.widget)), receiver: receiver,
        x: x.int, y: y.int, time: time.uint32)
      wire.receiverHandler = g.g_signal_connect_data(receiver.raw, "drag-data-received",
        cast[g.TGCallback](binaryDestData), cast[pointer](s), nil, g.TGConnectFlags(0))
      s.wires.add(wire)
      GC_ref(s)
      rawGtk.drag_get_data(cast[rawGtk.PWidget](receiver.raw), context, target, time)
      return g.gbool(true)
    except Exception as error: reportSignalError(error)
    g.gbool(false)
proc binaryDestData(instance: pointer, context: rawGdk.PDragContext, x, y: g.gint,
    selection: rawGtk.PSelectionData, info: g.guint, time: g.guint32, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[BinarySiteState](data)
    for i in 0..<s.wires.len:
      if s.wires[i].context != context: continue
      let wire = move(s.wires[i])
      s.wires.delete(i)
      inc s.receiving
      defer:
        dec s.receiving
        if not s.active: queueBinaryCleanup(s)
        g.g_signal_handler_disconnect(wire.receiver.raw, wire.receiverHandler)
        wire.receiver.destroy()
        g.g_object_unref(wire.context)
        g.g_object_unref(wire.widget)
        GC_unref(s)
      var valid = false
      var value: BinaryDrop
      try:
        if s.active and not wire.finished and
            rawGdk.drag_context_get_selected_action(context) == rawGdk.ACTION_COPY:
          let received = readSelectionBytes(selection, s.atom, s.mime, s.maxBytes)
          valid = s.active and received.kind == bytesAvailable and
            rawGdk.drag_context_get_selected_action(context) == rawGdk.ACTION_COPY
          if valid:
            value = BinaryDrop(mime: received.mime, bytes: received.bytes, x: wire.x, y: wire.y, time: wire.time)
            valid = acceptBinaryDrop(s, value) and s.active
      except Exception as error:
        valid = false
        reportSignalError(error)
      if not wire.finished:
        wire.finished = true
        rawGtk.drag_finish(context, g.gbool(valid), g.gbool(false), g.guint32(wire.time))
      if valid and s.active: queueRecent(cast[pointer](s.queue), value)
      return
proc installBinarySite(w: Widget, source: bool, mime: string): BinarySiteState =
  let p = checkTransferPad(w)
  let key = if source: binarySourceKey.cstring else: binaryDestKey.cstring
  if g.get_data(cast[g.PGObject](p), key) != nil:
    raise newException(ValueError, "widget already has an active or draining binary transfer site")
  let targets = if source: rawGtk.drag_source_get_target_list(p) else: rawGtk.drag_dest_get_target_list(p)
  if targets != nil: raise newException(ValueError, "widget already has a native drag/drop site")
  result = BinarySiteState(widget: p, source: source, active: true, mime: mime, atom: transferAtom(mime.cstring))
  GC_ref(result)
  g.set_data_full(cast[g.PGObject](p), key, cast[pointer](result), releaseBinarySite)
  result.connectBinarySite("destroy", cast[g.TGCallback](binarySiteDestroyed))
proc enableBinaryDrag*(w: Widget, value: BinaryData): BinaryDragSource {.discardable.} =
  requireOutsideModelFunction()
  checkBinaryMime(value.target)
  let s = installBinarySite(w, true, value.target)
  s.value = value
  s.connectBinarySite("drag-begin", cast[g.TGCallback](binarySourceBegin))
  s.connectBinarySite("drag-end", cast[g.TGCallback](binarySourceEnd))
  s.connectBinarySite("drag-data-get", cast[g.TGCallback](binarySourceData))
  var target = rawGtk.TTargetEntry(target: s.mime.cstring, flags: 0, info: 0)
  rawGtk.drag_source_set(s.widget, rawGdk.TModifierType(rawGdk.BUTTON1_MASK), addr target, 1, rawGdk.ACTION_COPY)
  BinaryDragSource(state: s)
proc enableBinaryDrag*(w: Widget, mime: string, bytes: openArray[byte]): BinaryDragSource {.discardable.} =
  requireOutsideModelFunction()
  w.enableBinaryDrag(newBinaryData(mime, bytes))
proc onBinaryDrop*(w: Widget, mime: string, fn: proc (value: BinaryDrop) {.closure.},
    maxBytes = 16 * 1024 * 1024, accept: BinaryDropPredicate = nil): BinaryDropSite {.discardable.} =
  ## Bound our copy, not native receipt; optional copied pure decision precedes finish.
  requireOutsideModelFunction()
  checkBinaryMime(mime)
  if maxBytes < 0 or maxBytes > high(g.gint).int - 1:
    raise newException(ValueError, "binary maxBytes must be in 0..2147483646")
  if fn == nil: raise newException(ValueError, "binary drop callback cannot be nil")
  let s = installBinarySite(w, false, mime)
  s.maxBytes = maxBytes
  s.accept = accept
  s.queue = RecentBinding[BinaryDrop](active: true, fn: fn)
  GC_ref(s.queue)
  s.connectBinarySite("drag-drop", cast[g.TGCallback](binaryDestDrop))
  var target = rawGtk.TTargetEntry(target: s.mime.cstring, flags: 0, info: 0)
  rawGtk.drag_dest_set(s.widget, rawGtk.TDestDefaults(rawGtk.DEST_DEFAULT_MOTION or rawGtk.DEST_DEFAULT_HIGHLIGHT),
    addr target, 1, rawGdk.ACTION_COPY)
  BinaryDropSite(state: s)
