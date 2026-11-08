# Included by gtk2.nim. URI-only COPY pads; completion is not file authorization.
type
  UriDrop* = object
    uris*: seq[string]
    x*, y*: int
    time*: uint32
  UriDropPredicate* = proc (value: UriDrop): bool {.closure.}
  UriSourceFlight = object
    context: rawGdk.PDragContext
    value: UriList
  UriWire = ref object
    context: rawGdk.PDragContext
    widget: rawGtk.PWidget
    receiver: Window # Independent unrealized receiver: destroying the pad clears its signals.
    receiverHandler: g.gulong
    x, y: int
    time: uint32
    finished: bool
  UriSiteState = ref object
    widget: rawGtk.PWidget # Weak except for independent wire/cleanup pins.
    source, active: bool
    receiving: int
    handlers: seq[g.gulong]
    value: UriList
    icon: Pixbuf # Immutable copied source configuration, not a native-state mirror.
    flights: seq[UriSourceFlight]
    wires: seq[UriWire]
    queue: RecentBinding[UriDrop]
    accept: UriDropPredicate
    cleanupIdle: g.guint
    cleanupWidget: rawGtk.PWidget
  UriDragSource* = object
    state: UriSiteState
  UriDropSite* = object
    state: UriSiteState
const
  uriSourceKey = "nim-gtk2-uri-drag-source"
  uriDestKey = "nim-gtk2-uri-drop-site"
proc releaseUriSite(data: pointer) {.cdecl.} = GC_unref(cast[UriSiteState](data))
proc cleanupUriSite(s: UriSiteState) =
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
  s.value = UriList()
  g.set_data_full(cast[g.PGObject](p), if s.source: uriSourceKey.cstring else: uriDestKey.cstring, nil, nil)
proc releaseUriCleanup(data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[UriSiteState](data)
    let p = s.cleanupWidget
    s.cleanupWidget = nil
    if p != nil: g.g_object_unref(p)
    GC_unref(s)
proc uriCleanupIdle(data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[UriSiteState](data)
    s.cleanupIdle = 0
    cleanupUriSite(s)
    g.gbool(false)
proc queueUriCleanup(s: UriSiteState) =
  if s.active or s.wires.len != 0 or s.cleanupIdle != 0 or s.widget == nil: return
  s.cleanupWidget = cast[rawGtk.PWidget](g.g_object_ref(s.widget))
  GC_ref(s)
  s.cleanupIdle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](uriCleanupIdle),
    cast[pointer](s), cast[pointer](releaseUriCleanup))
proc disconnectUriSite(s: UriSiteState) =
  requireOutsideModelFunction()
  if s == nil or not s.active: return
  s.active = false
  s.icon = Pixbuf()
  s.accept = nil # Wire pins must not retain application policy captures after cancel.
  if s.queue != nil:
    releaseRecentBinding[UriDrop](cast[pointer](s.queue), nil)
    s.queue = nil
  s.value = UriList()
  # Do not finish a pending selection early: that can retire the source before
  # it answers. The actual reply/timeout completes disconnected requests as failure.
  # Keep the destination's native URI target list and receiver until every actual
  # reply/timeout, reserving the pad against replacement even after disconnect.
  if s.wires.len == 0:
    if s.receiving != 0: queueUriCleanup(s)
    else: cleanupUriSite(s)
proc disconnect*(source: UriDragSource) = disconnectUriSite(source.state)
proc disconnect*(site: UriDropSite) = disconnectUriSite(site.state)
proc connected*(source: UriDragSource): bool = source.state != nil and source.state.active
proc connected*(site: UriDropSite): bool = site.state != nil and site.state.active
proc draining*(site: UriDropSite): bool =
  site.state != nil and not site.state.active and site.state.widget != nil
proc uris*(source: UriDragSource): seq[string] =
  requireOutsideModelFunction()
  if not source.connected: raise newException(ValueError, "URI drag source is disconnected")
  source.state.value.uris
proc `uris=`*(source: UriDragSource, value: UriList) =
  requireOutsideModelFunction()
  if not source.connected: raise newException(ValueError, "URI drag source is disconnected")
  source.state.value = value
proc `uris=`*(source: UriDragSource, uris: openArray[string]) =
  requireOutsideModelFunction()
  source.uris = newUriList(uris)
proc uriSiteDestroyed(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: disconnectUriSite(cast[UriSiteState](data))
    except Exception as error: reportSignalError(error)
proc connectUriSite(s: UriSiteState, signal: cstring, thunk: g.TGCallback) =
  s.handlers.add(g.g_signal_connect_data(s.widget, signal, thunk, cast[pointer](s), nil, g.TGConnectFlags(0)))
proc uriSourceBegin(instance: pointer, context: rawGdk.PDragContext, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[UriSiteState](data)
    GC_ref(s) # Independent of the source's qdata pin during native icon setup.
    defer: GC_unref(s)
    try:
      if s.active:
        for flight in s.flights:
          if flight.context == context: return
        s.flights.add(UriSourceFlight(context: cast[rawGdk.PDragContext](g.g_object_ref(context)), value: s.value))
        applySourceIcon(context, s.icon)
    except Exception as error: reportSignalError(error)
proc uriSourceEnd(instance: pointer, context: rawGdk.PDragContext, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[UriSiteState](data)
    for i, flight in s.flights:
      if flight.context == context:
        s.flights.delete(i)
        g.g_object_unref(context)
        break
proc uriSourceData(instance: pointer, context: rawGdk.PDragContext, selection: rawGtk.PSelectionData,
    info: g.guint, time: g.guint32, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[UriSiteState](data)
    if not s.active: return
    try:
      for flight in s.flights:
        if flight.context == context:
          var vector = newSeq[cstring](flight.value.items.len + 1)
          for i in 0..<flight.value.items.len: vector[i] = flight.value.items[i].cstring
          discard rawGtk.set_uris(selection, cast[g.PPgchar](addr vector[0]))
          return
    except Exception as error: reportSignalError(error)
proc acceptUriDrop(s: UriSiteState, value: UriDrop): bool =
  let predicate = s.accept # Root the fixed attachment policy throughout evaluation.
  if predicate == nil: return true
  # Give the policy independent sequence storage, not the later observer's value.
  var input = UriDrop(x: value.x, y: value.y, time: value.time)
  for uri in value.uris: input.uris.add(uri)
  try:
    inc modelFunctionDepth
    try: result = predicate(input)
    finally: dec modelFunctionDepth
  except Exception as error:
    reportSignalError(error)
    result = false
proc uriDestData(instance: pointer, context: rawGdk.PDragContext, x, y: g.gint,
    selection: rawGtk.PSelectionData, info: g.guint, time: g.guint32, data: pointer) {.cdecl, gcsafe.}
proc uriDestDrop(instance: pointer, context: rawGdk.PDragContext, x, y: g.gint,
    time: g.guint32, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[UriSiteState](data)
    if not s.active: return g.gbool(false)
    try:
      for wire in s.wires:
        if wire.context == context: return g.gbool(true)
      if rawGdk.drag_context_get_selected_action(context) != rawGdk.ACTION_COPY: return g.gbool(false)
      let target = rawGtk.drag_dest_find_target(s.widget, context, nil)
      if target != transferAtom("text/uri-list"): return g.gbool(false)
      let receiver = newWindow("", 1, 1) # Never show/realize; GTK creates its own IPC widget.
      rawGtk.set_screen(receiver.raw, rawGtk.get_screen(s.widget))
      let wire = UriWire(context: cast[rawGdk.PDragContext](g.g_object_ref(context)),
        widget: cast[rawGtk.PWidget](g.g_object_ref(s.widget)), receiver: receiver,
        x: x.int, y: y.int, time: time.uint32)
      wire.receiverHandler = g.g_signal_connect_data(receiver.raw, "drag-data-received",
        cast[g.TGCallback](uriDestData), cast[pointer](s), nil, g.TGConnectFlags(0))
      s.wires.add(wire)
      GC_ref(s) # Independent wire pin, not the user token/qdata/observation.
      rawGtk.drag_get_data(cast[rawGtk.PWidget](receiver.raw), context, target, time)
      return g.gbool(true)
    except Exception as error: reportSignalError(error)
    g.gbool(false)
proc uriDestData(instance: pointer, context: rawGdk.PDragContext, x, y: g.gint,
    selection: rawGtk.PSelectionData, info: g.guint, time: g.guint32, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[UriSiteState](data)
    for i in 0..<s.wires.len:
      if s.wires[i].context != context: continue
      let wire = move(s.wires[i])
      s.wires.delete(i)
      inc s.receiving
      defer:
        dec s.receiving
        if not s.active: queueUriCleanup(s)
        g.g_signal_handler_disconnect(wire.receiver.raw, wire.receiverHandler)
        wire.receiver.destroy()
        g.g_object_unref(wire.context)
        g.g_object_unref(wire.widget)
        GC_unref(s)
      var valid = false
      var value: UriDrop
      try:
        if s.active and not wire.finished:
          let received = readSelectionUris(selection)
          valid = received.kind == urisAvailable and
            rawGdk.drag_context_get_selected_action(context) == rawGdk.ACTION_COPY
          if valid:
            value = UriDrop(uris: received.uris, x: wire.x, y: wire.y, time: wire.time)
            valid = acceptUriDrop(s, value)
      except ValueError: discard
      except Exception as error: reportSignalError(error)
      if not wire.finished:
        wire.finished = true
        rawGtk.drag_finish(context, g.gbool(valid), g.gbool(false), g.guint32(wire.time))
      if valid and s.active: queueRecent(cast[pointer](s.queue), value)
      return
proc installUriSite(w: Widget, source: bool): UriSiteState =
  let p = checkTransferPad(w)
  let key = if source: uriSourceKey.cstring else: uriDestKey.cstring
  if g.get_data(cast[g.PGObject](p), key) != nil:
    raise newException(ValueError, "widget already has an active or draining URI transfer site")
  let targets = if source: rawGtk.drag_source_get_target_list(p) else: rawGtk.drag_dest_get_target_list(p)
  if targets != nil: raise newException(ValueError, "widget already has a native drag/drop site")
  result = UriSiteState(widget: p, source: source, active: true)
  GC_ref(result)
  g.set_data_full(cast[g.PGObject](p), key, cast[pointer](result), releaseUriSite)
  result.connectUriSite("destroy", cast[g.TGCallback](uriSiteDestroyed))
proc enableUriDrag*(w: Widget, value: UriList): UriDragSource {.discardable.} =
  let s = installUriSite(w, true)
  s.value = value
  s.connectUriSite("drag-begin", cast[g.TGCallback](uriSourceBegin))
  s.connectUriSite("drag-end", cast[g.TGCallback](uriSourceEnd))
  s.connectUriSite("drag-data-get", cast[g.TGCallback](uriSourceData))
  var target = rawGtk.TTargetEntry(target: "text/uri-list", flags: 0, info: 0)
  rawGtk.drag_source_set(s.widget, rawGdk.TModifierType(rawGdk.BUTTON1_MASK), addr target, 1, rawGdk.ACTION_COPY)
  UriDragSource(state: s)
proc enableUriDrag*(w: Widget, uris: openArray[string]): UriDragSource {.discardable.} =
  requireOutsideModelFunction()
  w.enableUriDrag(newUriList(uris))
proc onUriDrop*(w: Widget, fn: proc (value: UriDrop) {.closure.},
    accept: UriDropPredicate = nil): UriDropSite {.discardable.} =
  ## Optional fixed synchronous policy sees copied values under pure-function guards.
  ## Only accepted valid COPY drops finish successfully and reach the idle observer.
  requireOutsideModelFunction()
  if fn == nil: raise newException(ValueError, "URI drop callback cannot be nil")
  let s = installUriSite(w, false)
  s.accept = accept
  s.queue = RecentBinding[UriDrop](active: true, fn: fn)
  GC_ref(s.queue)
  s.connectUriSite("drag-drop", cast[g.TGCallback](uriDestDrop))
  var target = rawGtk.TTargetEntry(target: "text/uri-list", flags: 0, info: 0)
  rawGtk.drag_dest_set(s.widget, rawGtk.TDestDefaults(rawGtk.DEST_DEFAULT_MOTION or rawGtk.DEST_DEFAULT_HIGHLIGHT),
    addr target, 1, rawGdk.ACTION_COPY)
  UriDropSite(state: s)
