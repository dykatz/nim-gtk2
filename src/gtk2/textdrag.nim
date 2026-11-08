# Included by gtk2.nim. COPY-only text pads, not overrides of native editor/model DnD.
type
  TextDrop* = object
    text*: string
    x*, y*: int
    time*: uint32
  DragFlight = object
    context: rawGdk.PDragContext
    text: string
    x, y: int
    time: uint32
  TextSiteState = ref object
    widget: rawGtk.PWidget # Weak; the native destroy hook disconnects before finalization.
    source, active: bool
    handlers: seq[g.gulong]
    text: string
    icon: Pixbuf # Private immutable copy; native contexts retain their own reference.
    flights: seq[DragFlight]
    queue: RecentBinding[TextDrop]
  TextDragSource* = object
    state: TextSiteState
  TextDropSite* = object
    state: TextSiteState

const
  textSourceKey = "nim-gtk2-text-drag-source"
  textDestKey = "nim-gtk2-text-drop-site"
proc releaseTextSite(data: pointer) {.cdecl.} = GC_unref(cast[TextSiteState](data))
proc disconnectTextSite(s: TextSiteState) =
  if s == nil or not s.active: return
  let p = s.widget
  s.active = false
  s.icon = Pixbuf()
  s.widget = nil
  discard g.g_object_ref(p)
  defer: g.g_object_unref(p)
  let handlers = s.handlers
  s.handlers = @[]
  for id in handlers:
    if g.g_signal_handler_is_connected(p, id): g.g_signal_handler_disconnect(p, id)
  if s.source: rawGtk.drag_source_unset(p)
  else: rawGtk.drag_dest_unset(p)
  let flights = s.flights
  s.flights = @[]
  for flight in flights:
    if not s.source: rawGtk.drag_finish(flight.context, g.gbool(false), g.gbool(false), g.guint32(flight.time))
    g.g_object_unref(flight.context)
  if s.queue != nil:
    releaseRecentBinding[TextDrop](cast[pointer](s.queue), nil)
    s.queue = nil
  s.text = ""
  g.set_data_full(cast[g.PGObject](p), if s.source: textSourceKey.cstring else: textDestKey.cstring, nil, nil)
proc disconnect*(source: TextDragSource) =
  requireOutsideModelFunction()
  disconnectTextSite(source.state)
proc disconnect*(site: TextDropSite) = disconnectTextSite(site.state)
proc connected*(source: TextDragSource): bool = source.state != nil and source.state.active
proc connected*(site: TextDropSite): bool = site.state != nil and site.state.active
proc text*(source: TextDragSource): string =
  if not source.connected: raise newException(ValueError, "text drag source is disconnected")
  source.state.text
proc `text=`*(source: TextDragSource, value: string) =
  discard checkedUtf8Text(value)
  if not source.connected: raise newException(ValueError, "text drag source is disconnected")
  source.state.text = value # Active drags retain their drag-begin snapshot.
proc textSiteDestroyed(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: disconnectTextSite(cast[TextSiteState](data))
    except Exception as error: reportSignalError(error)
proc connectTextSite(s: TextSiteState, signal: cstring, thunk: g.TGCallback) =
  let id = g.g_signal_connect_data(s.widget, signal, thunk, cast[pointer](s), nil, g.TGConnectFlags(0))
  s.handlers.add(id)
proc checkTransferPad(w: Widget): rawGtk.PWidget =
  result = w.raw
  let kind = g.G_OBJECT_TYPE(result)
  if kind != rawGtk.drawing_area_get_type() and kind != rawGtk.event_box_get_type():
    raise newException(ValueError, "SDK DnD requires an ordinary DrawingArea or EventBox pad")
proc applySourceIcon(context: rawGdk.PDragContext, image: Pixbuf) =
  if image.isEmpty: return # Leave GTK's actual default/global icon selection alone.
  let p = image.raw
  discard g.g_object_ref(p) # Protect against native reentrancy before GTK retains it.
  defer: g.g_object_unref(p)
  rawGtk.drag_set_icon_pixbuf(context, p, -2, -2) # GTK source-site's native hotspot.
proc sourceBegin(instance: pointer, context: rawGdk.PDragContext, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[TextSiteState](data)
    GC_ref(s) # Native icon setup may reenter application teardown.
    defer: GC_unref(s)
    try:
      if s.active:
        for flight in s.flights:
          if flight.context == context: return
        s.flights.add(DragFlight(context: cast[rawGdk.PDragContext](g.g_object_ref(context)), text: s.text))
        applySourceIcon(context, s.icon)
    except Exception as error: reportSignalError(error)
proc sourceEnd(instance: pointer, context: rawGdk.PDragContext, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[TextSiteState](data)
    for i, flight in s.flights:
      if flight.context == context:
        s.flights.delete(i)
        g.g_object_unref(context)
        break
proc sourceData(instance: pointer, context: rawGdk.PDragContext, selection: rawGtk.PSelectionData,
                info: g.guint, time: g.guint32, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[TextSiteState](data)
    if not s.active: return
    try:
      for flight in s.flights:
        if flight.context == context:
          discard rawGtk.set_text(selection, flight.text.cstring, g.gint(flight.text.len))
          return
    except Exception as error: reportSignalError(error)
proc destDrop(instance: pointer, context: rawGdk.PDragContext, x, y: g.gint,
              time: g.guint32, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[TextSiteState](data)
    if not s.active: return g.gbool(false)
    try:
      for flight in s.flights:
        if flight.context == context: return g.gbool(true)
      if rawGdk.drag_context_get_selected_action(context) != rawGdk.ACTION_COPY: return g.gbool(false)
      let target = rawGtk.drag_dest_find_target(s.widget, context, nil)
      if target == rawGdk.TAtom(0): return g.gbool(false)
      s.flights.add(DragFlight(context: cast[rawGdk.PDragContext](g.g_object_ref(context)),
        x: x.int, y: y.int, time: time.uint32))
      rawGtk.drag_get_data(s.widget, context, target, time)
      return g.gbool(true)
    except Exception as error: reportSignalError(error)
    g.gbool(false)
proc destData(instance: pointer, context: rawGdk.PDragContext, x, y: g.gint,
              selection: rawGtk.PSelectionData, info: g.guint, time: g.guint32,
              data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let s = cast[TextSiteState](data)
    if not s.active: return
    for i, flight in s.flights:
      if flight.context != context: continue
      s.flights.delete(i)
      defer: g.g_object_unref(context)
      var valid = false
      var value: TextDrop
      try:
        let text = readSelectionText(selection)
        if text.available:
          value = TextDrop(text: text.text, x: flight.x, y: flight.y, time: flight.time)
          valid = rawGdk.drag_context_get_selected_action(context) == rawGdk.ACTION_COPY
      except ValueError: discard # Invalid external text is a failed drop, not a callback value.
      except Exception as error: reportSignalError(error)
      # No DEFAULT_DROP flag: exactly this handler finishes each tracked request.
      # Never request DELETE; an observer cannot implement MOVE safely after idle.
      rawGtk.drag_finish(context, g.gbool(valid), g.gbool(false), g.guint32(flight.time))
      if valid: queueRecent(cast[pointer](s.queue), value)
      return
proc installTextSite(w: Widget, source: bool): TextSiteState =
  let p = checkTransferPad(w)
  let key = if source: textSourceKey.cstring else: textDestKey.cstring
  if g.get_data(cast[g.PGObject](p), key) != nil:
    raise newException(ValueError, "widget already has this SDK text transfer site")
  let targets = if source: rawGtk.drag_source_get_target_list(p) else: rawGtk.drag_dest_get_target_list(p)
  if targets != nil: raise newException(ValueError, "widget already has a native drag/drop site")
  result = TextSiteState(widget: p, source: source, active: true)
  GC_ref(result)
  g.set_data_full(cast[g.PGObject](p), key, cast[pointer](result), releaseTextSite)
  result.connectTextSite("destroy", cast[g.TGCallback](textSiteDestroyed))
proc enableTextDrag*(w: Widget, text: string): TextDragSource {.discardable.} =
  discard checkedUtf8Text(text)
  let s = installTextSite(w, true)
  s.text = text
  s.connectTextSite("drag-begin", cast[g.TGCallback](sourceBegin))
  s.connectTextSite("drag-end", cast[g.TGCallback](sourceEnd))
  s.connectTextSite("drag-data-get", cast[g.TGCallback](sourceData))
  rawGtk.drag_source_set(s.widget, rawGdk.TModifierType(rawGdk.BUTTON1_MASK), nil, 0, rawGdk.ACTION_COPY)
  rawGtk.drag_source_add_text_targets(s.widget)
  TextDragSource(state: s)
proc onTextDrop*(w: Widget, fn: proc (value: TextDrop) {.closure.}): TextDropSite {.discardable.} =
  if fn == nil: raise newException(ValueError, "drop callback cannot be nil")
  let s = installTextSite(w, false)
  s.queue = RecentBinding[TextDrop](active: true, fn: fn)
  GC_ref(s.queue)
  s.connectTextSite("drag-drop", cast[g.TGCallback](destDrop))
  s.connectTextSite("drag-data-received", cast[g.TGCallback](destData))
  rawGtk.drag_dest_set(s.widget, rawGtk.TDestDefaults(rawGtk.DEST_DEFAULT_MOTION or rawGtk.DEST_DEFAULT_HIGHLIGHT),
    nil, 0, rawGdk.ACTION_COPY)
  rawGtk.drag_dest_add_text_targets(s.widget)
  TextDropSite(state: s)
