# GTK's native same-widget row MOVE mode, configured before realization.
const rowDragKey = "nim-gtk2-native-row-drag"

proc rowDragReorderEnabled*(w: TreeView): bool =
  ## Reports the native mode, not whether a particular drop would be accepted.
  g.toBool(rawGtk.get_reorderable(w.raw))

proc rowDragReorderEnabled*(w: IconView): bool =
  ## Reports the native mode, not whether a particular drop would be accepted.
  g.toBool(rawGtk.icon_view_get_reorderable(w.raw))

proc prepareRowDrag(w: rawGtk.PWidget, m: rawGtk.PTreeModel,
                    icon, enabled: bool): bool =
  if g.toBool(rawGtk.get_realized(w)):
    raise newException(ValueError, "configure row drag before view realization")
  let kind = g.G_OBJECT_TYPE(w)
  if kind != (if icon: rawGtk.icon_view_get_type() else: rawGtk.tree_view_get_type()):
    raise newException(ValueError, "row drag requires an ordinary TreeView or IconView")
  if m == nil or (g.G_OBJECT_TYPE(m) != rawGtk.list_store_get_type() and
      (icon or g.G_OBJECT_TYPE(m) != rawGtk.tree_store_get_type())):
    raise newException(ValueError, "row drag requires a direct native ListStore or TreeStore (ListStore only for IconView)")
  const unsortedColumn = -2.gint # GTK_TREE_SORTABLE_UNSORTED_SORT_COLUMN_ID
  var column: g.gint
  discard rawGtk.get_sort_column_id(cast[rawGtk.PTreeSortable](m), addr column, nil)
  if column != unsortedColumn:
    raise newException(ValueError, "row drag requires an unsorted model")
  let obj = cast[g.PGObject](w)
  if enabled and g.get_data(obj, rowDragKey) != nil: return false
  if enabled or rawGtk.drag_source_get_target_list(w) != nil or
      rawGtk.drag_dest_get_target_list(w) != nil:
    raise newException(ValueError, "view already has a native drag/drop site")
  # Set before the native setter can emit notify::reorderable. Only a marker;
  # GTK itself owns the sites, model row references, and active protocol state.
  g.set_data(obj, rowDragKey, w)
  true

proc enableRowDragReorder*(w: TreeView) =
  ## Enable same-view native MOVE for an unsorted direct ListStore or TreeStore.
  let p = w.raw
  let widget = cast[rawGtk.PWidget](p)
  if prepareRowDrag(widget, rawGtk.get_model(p), false, w.rowDragReorderEnabled):
    discard g.g_object_ref(widget)
    defer: g.g_object_unref(widget)
    rawGtk.set_reorderable(p, g.gbool(true))

proc enableRowDragReorder*(w: IconView) =
  ## Enable same-view native MOVE for an unsorted direct ListStore.
  let p = w.raw
  let widget = cast[rawGtk.PWidget](p)
  if prepareRowDrag(widget, rawGtk.icon_view_get_model(p), true, w.rowDragReorderEnabled):
    discard g.g_object_ref(widget)
    defer: g.g_object_unref(widget)
    rawGtk.icon_view_set_reorderable(p, g.gbool(true))

# Local COPY uses GTK's native drag and source-widget identity, not the native
# GTK_TREE_MODEL_ROW pointer payload or any application selection data.
type
  ModelRowDrop* = object
    row*: ModelRow        ## Source path and cell values at drag begin.
    hit*: TreePath       ## Row under the pointer, or the virtual root over empty space.
    x*, y*: int          ## Destination widget coordinates.
    time*: uint32        ## Native drop timestamp.
  ModelRowDropHandler* = proc (value: ModelRowDrop): bool {.closure.}
    ## Runs synchronously at drop. Return true only after commit; false does not roll back edits.
  ModelRowSite = ref object
    icon, live, available: bool
    flight: rawGdk.PDragContext # Borrowed until drag-end; never dereferenced later.
    sourceWindow: rawGdk.PWindow # Borrowed from that context; used only for identity.
    target: rawGdk.TAtom
    pressed: TreeRowReference
    snapshot: ModelRow
    receive: ModelRowDropHandler

const
  modelRowSiteKey = "nim-gtk2-local-model-drag"
  modelRowTarget = "application/x-nim-gtk2-local-model-row"
var modelDropBusy {.threadvar.}: bool

proc rowSite(w: rawGtk.PWidget): ModelRowSite =
  cast[ModelRowSite](g.get_data(cast[g.PGObject](w), modelRowSiteKey))

proc rowSiteModel(w: rawGtk.PWidget, icon: bool): rawGtk.PTreeModel =
  if icon: rawGtk.icon_view_get_model(cast[ptr rawGtk.IconView](w))
  else: rawGtk.get_model(cast[rawGtk.PTreeView](w))

proc modelHit(w: rawGtk.PWidget, icon: bool, x, y: g.gint, widgetCoords: bool): TreePath =
  var bx = x
  var by = y
  var p: rawGtk.PTreePath
  if icon:
    let v = cast[ptr rawGtk.IconView](w)
    if widgetCoords: rawGtk.icon_view_convert_widget_to_bin_window_coords(v, x, y, addr bx, addr by)
    p = rawGtk.icon_view_get_path_at_pos(v, bx, by)
  else:
    let v = cast[rawGtk.PTreeView](w)
    if widgetCoords: rawGtk.convert_widget_to_bin_window_coords(v, x, y, addr bx, addr by)
    discard rawGtk.get_path_at_pos(v, bx, by, addr p, nil, nil, nil)
  if p != nil:
    defer: rawGtk.free(p)
    result = copyTreePath(p)

proc resetRowFlight(s: ModelRowSite) =
  s.available = false
  s.flight = nil
  s.sourceWindow = nil
  s.snapshot = ModelRow()

proc rowSiteRelease(data: pointer) {.cdecl.} = GC_unref(cast[ModelRowSite](data))

proc rowSiteDestroyed(w: rawGtk.PWidget, data: pointer) {.cdecl.} =
  let s = cast[ModelRowSite](data)
  s.live = false
  s.receive = nil
  s.pressed = TreeRowReference()
  s.resetRowFlight()

proc rowPress(w: rawGtk.PWidget, e: rawGdk.PEventButton, data: pointer): g.gboolean {.cdecl.} =
  result = g.gbool(false) # Do not consume normal selection or editing input.
  let s = cast[ModelRowSite](data)
  if not s.live or e.button != 1 or e.`type` != rawGdk.BUTTON_PRESS: return
  s.pressed = TreeRowReference()
  if not (e.x >= 0 and e.x <= high(g.gint).float and e.y >= 0 and e.y <= high(g.gint).float): return
  if not s.icon and e.window != rawGtk.get_bin_window(cast[rawGtk.PTreeView](w)): return
  # IconView button events bubble up from the internal bin window, not its outer window.
  if s.icon and e.window == rawGtk.get_window(w): return
  try:
    let path = modelHit(w, s.icon, e.x.gint, e.y.gint, false)
    let m = rowSiteModel(w, s.icon)
    if not path.isRoot and m != nil:
      s.pressed = newTreeRowReference(ownedTreeModel(m), path)
  except CatchableError: discard

proc rowRelease(w: rawGtk.PWidget, e: rawGdk.PEventButton, data: pointer): g.gboolean {.cdecl.} =
  if e.button == 1: cast[ModelRowSite](data).pressed = TreeRowReference()
  g.gbool(false)

proc rowDragBegin(w: rawGtk.PWidget, context: rawGdk.PDragContext, data: pointer) {.cdecl.} =
  let s = cast[ModelRowSite](data)
  let pressed = move(s.pressed)
  s.resetRowFlight()
  try:
    if not s.live or not pressed.valid: return
    let m = pressed.model
    if m.raw != rowSiteModel(w, s.icon): return
    let path = pressed.path
    var iter = pathIter(m, path)
    let sourceWindow = rawGdk.drag_context_get_source_window(context)
    if sourceWindow == nil: return
    s.snapshot = copyModelRow(m.raw, addr iter)
    s.flight = context
    s.sourceWindow = sourceWindow
    s.available = true
  except CatchableError: s.resetRowFlight()

proc rowDragEnd(w: rawGtk.PWidget, context: rawGdk.PDragContext, data: pointer) {.cdecl.} =
  let s = cast[ModelRowSite](data)
  if s.flight == context: s.resetRowFlight()

proc matchingRowSource(w: rawGtk.PWidget, context: rawGdk.PDragContext,
                       s: ModelRowSite): ModelRowSite =
  if not s.live or s.receive == nil or modelDropBusy or modelFunctionDepth != 0: return
  if (rawGdk.drag_context_get_actions(context) and rawGdk.ACTION_COPY) == 0: return
  if rawGtk.drag_dest_find_target(w, context, nil) != s.target: return
  let source = rawGtk.drag_get_source_widget(context)
  if source == nil: return
  let origin = rowSite(source)
  if origin != nil and origin.live and origin.available and
      origin.sourceWindow == rawGdk.drag_context_get_source_window(context):
    result = origin

proc rowDragMotion(w: rawGtk.PWidget, context: rawGdk.PDragContext,
                   x, y: g.gint, time: g.guint, data: pointer): g.gboolean {.cdecl.} =
  let s = cast[ModelRowSite](data)
  if matchingRowSource(w, context, s) == nil: return g.gbool(false)
  rawGdk.status(context, rawGdk.ACTION_COPY, g.guint32(time))
  g.gbool(true)

proc dispatchRowDrop(w: rawGtk.PWidget, context: rawGdk.PDragContext,
                     x, y: g.gint, time: g.guint, data: pointer): g.gboolean =
  let s = cast[ModelRowSite](data)
  let origin = matchingRowSource(w, context, s)
  if origin == nil or rawGdk.drag_context_get_selected_action(context) != rawGdk.ACTION_COPY:
    return g.gbool(false)
  # No selection request: the authenticated local source already owns the row.
  # Hold everything needed across the application commit, which can destroy either view.
  discard g.g_object_ref(context)
  defer: g.g_object_unref(context)
  discard g.g_object_ref(w)
  defer: g.g_object_unref(w)
  let snapshot = move(origin.snapshot)
  origin.available = false
  let receive = s.receive
  modelDropBusy = true
  var accepted = false
  try:
    let hit = modelHit(w, s.icon, x, y, true)
    accepted = receive(ModelRowDrop(row: snapshot, hit: hit, x: x.int, y: y.int, time: time.uint32))
  except CatchableError as e:
    try: stderr.writeLine("gtk2 model drop callback: ", e.msg)
    except IOError: discard
  finally:
    rawGtk.drag_finish(context, g.gbool(accepted), g.gbool(false), g.guint32(time))
    modelDropBusy = false
  g.gbool(true)

proc rowDragDrop(w: rawGtk.PWidget, context: rawGdk.PDragContext,
                 x, y: g.gint, time: g.guint, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    dispatchRowDrop(w, context, x, y, time, data)

proc configureRowSite(w: rawGtk.PWidget, icon, source: bool, receive: ModelRowDropHandler) =
  if not source and receive == nil:
    raise newException(ValueError, "a model row site needs a source or receiver")
  if g.toBool(rawGtk.get_realized(w)) or modelDropBusy:
    raise newException(ValueError, "configure model drag before view realization, outside drops")
  if g.G_OBJECT_TYPE(w) != (if icon: rawGtk.icon_view_get_type() else: rawGtk.tree_view_get_type()):
    raise newException(ValueError, "model row transfer requires an ordinary TreeView or IconView")
  let m = rowSiteModel(w, icon)
  if m == nil or (source and g.G_OBJECT_TYPE(m) != rawGtk.list_store_get_type() and
      (icon or g.G_OBJECT_TYPE(m) != rawGtk.tree_store_get_type())):
    raise newException(ValueError, "model row source requires a direct ListStore or TreeStore (ListStore only for IconView)")
  if rowSite(w) != nil or rawGtk.drag_source_get_target_list(w) != nil or
      rawGtk.drag_dest_get_target_list(w) != nil:
    raise newException(ValueError, "view already has a native drag/drop site")
  let s = ModelRowSite(icon: icon, live: true, receive: receive,
    target: rawGdk.atom_intern(modelRowTarget, g.gbool(false)))
  GC_ref(s)
  g.set_data_full(cast[g.PGObject](w), modelRowSiteKey, cast[pointer](s), rowSiteRelease)
  template attach(signal, handler: untyped) =
    discard g.g_signal_connect_data(w, signal, cast[g.TGCallback](handler), cast[pointer](s), nil, g.TGConnectFlags(0))
  attach("destroy", rowSiteDestroyed)
  var target = rawGtk.TTargetEntry(target: modelRowTarget, flags: rawGtk.TARGET_SAME_APP)
  if source:
    attach("button-press-event", rowPress)
    attach("button-release-event", rowRelease)
    attach("drag-begin", rowDragBegin)
    attach("drag-end", rowDragEnd)
    rawGtk.drag_source_set(w, rawGdk.TModifierType(rawGdk.BUTTON1_MASK), addr target, 1, rawGdk.ACTION_COPY)
  if receive != nil:
    attach("drag-motion", rowDragMotion)
    attach("drag-drop", rowDragDrop)
    rawGtk.drag_dest_set(w, rawGtk.TDestDefaults(0), addr target, 1, rawGdk.ACTION_COPY)

proc configureModelRowDrag*(view: TreeView, source = true, receive: ModelRowDropHandler = nil) =
  ## Install same-application row COPY for the view's lifetime, before realization.
  ## A receiver returns true only after it has committed its application-defined placement.
  if view.rowDragReorderEnabled: raise newException(ValueError, "view already uses native row MOVE")
  configureRowSite(cast[rawGtk.PWidget](view.raw), false, source, receive)

proc configureModelRowDrag*(view: IconView, source = true, receive: ModelRowDropHandler = nil) =
  ## Install same-application item COPY for the view's lifetime, before realization.
  if view.rowDragReorderEnabled: raise newException(ValueError, "view already uses native row MOVE")
  configureRowSite(cast[rawGtk.PWidget](view.raw), true, source, receive)
