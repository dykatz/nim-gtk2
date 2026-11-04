# Included by gtk2.nim. A builder is an owned UI document, not just a parser.
type
  BuilderError* = object of CatchableError
    domain*: uint32
    code*: int32
  BuilderObjectInfo* = object
    id*, typeName*: string
  BuilderSignal* = object
    objectId*, signalName*, handlerName*, connectObjectId*: string
    after*, swapped*: bool
  BuilderHandler* = object
    name*: string
    fn*: proc () {.closure.}
  BuilderDeclaration = object
    info: BuilderSignal
    obj: g.PGObject # Borrowed until the owning native builder is released.
    hasConnectObject: bool
  BuilderBookObj = object
    owner: ObjectHandle
    closed, wired: bool
    handles: seq[ObjectHandle]
    declarations: seq[BuilderDeclaration]
    connections: seq[Connection]
  BuilderBook = ref BuilderBookObj
  Builder* = object
    book: BuilderBook
proc closeBuilder(book: var BuilderBookObj)
proc `=destroy`(book: var BuilderBookObj) =
  try: closeBuilder(book)
  except Exception as error: reportSignalError(error)
  `=destroy`(book.connections)
  `=destroy`(book.declarations)
  `=destroy`(book.handles)
  `=destroy`(book.owner)
proc closed*(ui: Builder): bool = ui.book == nil or ui.book.closed
proc raw*(ui: Builder): rawGtk.PBuilder =
  if ui.closed: raise newException(ValueError, "UI builder is closed or uninitialized")
  cast[rawGtk.PBuilder](nativePointer(ui.book.owner))
proc disconnectSignals*(ui: Builder) =
  discard ui.raw
  let connections = ui.book.connections
  ui.book.connections = @[]
  ui.book.wired = false
  for connection in connections: connection.disconnect()
proc closeBuilder(book: var BuilderBookObj) =
  if book.closed: return
  book.closed = true # Reentrant close/lookups from destruction observers are checked.
  for connection in book.connections: connection.disconnect()
  book.connections = @[]
  if book.owner.state != nil:
    let p = cast[rawGtk.PBuilder](book.owner.state.p)
    let list = rawGtk.builder_get_objects(p) # Transfer-container; objects are borrowed.
    var objects: seq[pointer]
    var node = list
    while node != nil:
      objects.add(g.g_object_ref(node.data))
      node = node.next
    g.free(list)
    try:
      # Let normal container destruction visit descendants where possible. A
      # second pass also covers detached menus or XML children reparented outside.
      for obj in objects:
        if rawGtk.IS_WIDGET(obj) and rawGtk.get_parent(cast[rawGtk.PWidget](obj)) == nil:
          rawGtk.destroy(cast[rawGtk.PWidget](obj))
      for obj in objects:
        if rawGtk.IS_WIDGET(obj): rawGtk.destroy(cast[rawGtk.PWidget](obj))
      # Widgets run ordinary destroy observers and markDestroyed cleanup. Plain
      # GObjects can remain independently retained, but must lose UI callbacks.
      for handle in book.handles:
        if not handle.isDestroyed and not rawGtk.IS_WIDGET(handle.state.p):
          disconnectObjectSignals(handle)
    except Exception as error: reportSignalError(error)
    finally:
      for obj in objects: g.g_object_unref(obj)
  book.handles = @[]
  book.declarations = @[]
  book.owner = ObjectHandle() # Release the native object table now, not at last alias release.
proc close*(ui: Builder) =
  if ui.book != nil: closeBuilder(ui.book[])
proc builderId(value: string): cstring =
  result = checkedUtf8Text(value)
  if value.len == 0: raise newException(ValueError, "builder ID cannot be empty")
proc builderName(obj: g.PGObject): string =
  if g.G_TYPE_CHECK_INSTANCE_TYPE(obj, rawGtk.buildable_get_type()):
    result = $rawGtk.buildable_get_name(cast[rawGtk.PBuildable](obj))
proc objects*(ui: Builder): seq[BuilderObjectInfo] =
  let list = rawGtk.builder_get_objects(ui.raw)
  defer: g.free(list)
  var node = list
  while node != nil:
    let obj = cast[g.PGObject](node.data)
    result.add(BuilderObjectInfo(id: builderName(obj), typeName: $g.g_type_name(g.G_OBJECT_TYPE(obj))))
    node = node.next
proc hasObject*(ui: Builder, id: string): bool = rawGtk.builder_get_object(ui.raw, builderId(id)) != nil
proc translationDomain*(ui: Builder): string = $rawGtk.builder_get_translation_domain(ui.raw)
proc declarations*(ui: Builder): seq[BuilderSignal] =
  discard ui.raw
  for entry in ui.book.declarations: result.add(entry.info)
proc retainBuilderHandle(ui: Builder, state: ObjectState) =
  for handle in ui.book.handles:
    if handle.state == state: return
  ui.book.handles.add(ObjectHandle(state: state))

template builderWidgetType(T: typedesc): g.GType =
  when T is Widget and Widget is T: rawGtk.widget_get_type()
  elif T is Window and Window is T: rawGtk.window_get_type()
  elif T is Button and Button is T: rawGtk.button_get_type()
  elif T is Label and Label is T: rawGtk.label_get_type()
  elif T is Entry and Entry is T: rawGtk.entry_get_type()
  elif T is VBox and VBox is T: rawGtk.vbox_get_type()
  elif T is HBox and HBox is T: rawGtk.hbox_get_type()
  elif T is Box and Box is T: rawGtk.box_get_type()
  elif T is ToggleButton and ToggleButton is T: rawGtk.toggle_button_get_type()
  elif T is CheckButton and CheckButton is T: rawGtk.check_button_get_type()
  elif T is RadioButton and RadioButton is T: rawGtk.radio_button_get_type()
  elif T is DrawingArea and DrawingArea is T: rawGtk.drawing_area_get_type()
  elif T is ScrolledWindow and ScrolledWindow is T: rawGtk.scrolled_window_get_type()
  elif T is Viewport and Viewport is T: rawGtk.viewport_get_type()
  elif T is Notebook and Notebook is T: rawGtk.notebook_get_type()
  elif T is HPaned and HPaned is T: rawGtk.hpaned_get_type()
  elif T is VPaned and VPaned is T: rawGtk.vpaned_get_type()
  elif T is SpinButton and SpinButton is T: rawGtk.spin_button_get_type()
  elif T is ProgressBar and ProgressBar is T: rawGtk.progress_bar_get_type()
  elif T is TextView and TextView is T: rawGtk.text_view_get_type()
  elif T is Image and Image is T: rawGtk.image_get_type()
  elif T is Frame and Frame is T: rawGtk.frame_get_type()
  elif T is Alignment and Alignment is T: rawGtk.alignment_get_type()
  elif T is Table and Table is T: rawGtk.table_get_type()
  elif T is Fixed and Fixed is T: rawGtk.fixed_get_type()
  elif T is EventBox and EventBox is T: rawGtk.event_box_get_type()
  elif T is MenuBar and MenuBar is T: rawGtk.menu_bar_get_type()
  elif T is Menu and Menu is T: rawGtk.menu_get_type()
  elif T is MenuItem and MenuItem is T: rawGtk.menu_item_get_type()
  elif T is CheckMenuItem and CheckMenuItem is T: rawGtk.check_menu_item_get_type()
  elif T is Toolbar and Toolbar is T: rawGtk.toolbar_get_type()
  elif T is ToolButton and ToolButton is T: rawGtk.tool_button_get_type()
  elif T is ToggleToolButton and ToggleToolButton is T: rawGtk.toggle_tool_button_get_type()
  elif T is Dialog and Dialog is T: rawGtk.dialog_get_type()
  else: {.error: "This widget type has no audited GtkBuilder lookup; use Widget/raw GTK instead".}
proc get*[T](ui: Builder, id: string, kind: typedesc[T]): T =
  let obj = rawGtk.builder_get_object(ui.raw, builderId(id))
  if obj == nil: raise newException(ValueError, "unknown builder object: " & id)
  let expected =
    when T is Widget: builderWidgetType(T)
    elif T is Action and Action is T: rawGtk.action_get_type()
    elif T is ToggleAction and ToggleAction is T: rawGtk.toggle_action_get_type()
    elif T is Adjustment and Adjustment is T: rawGtk.adjustment_get_type()
    elif T is TextBuffer and TextBuffer is T: rawGtk.text_buffer_get_type()
    else: {.error: "This handle requires a specialized factory and has no GtkBuilder lookup".}
  if not g.G_TYPE_CHECK_INSTANCE_TYPE(obj, expected):
    raise newException(ValueError, "builder object " & id & " has incompatible native type " & $g.g_type_name(g.G_OBJECT_TYPE(obj)))
  let destroySignal = g.g_signal_lookup("destroy", g.G_OBJECT_TYPE(obj)) != 0
  result.state = adoptObject(obj, borrowed = true, cache = true, hasDestroySignal = destroySignal)
  ui.retainBuilderHandle(result.state)

proc registerBuilderTypes() =
  # Nim loads GTK dynamically. Register core types explicitly rather than relying
  # on GtkBuilder's lazy GModule lookup of global executable symbols.
  let types = [rawGtk.window_get_type(), rawGtk.button_get_type(), rawGtk.label_get_type(),
    rawGtk.entry_get_type(), rawGtk.vbox_get_type(), rawGtk.hbox_get_type(),
    rawGtk.toggle_button_get_type(), rawGtk.check_button_get_type(), rawGtk.radio_button_get_type(),
    rawGtk.drawing_area_get_type(), rawGtk.scrolled_window_get_type(), rawGtk.viewport_get_type(),
    rawGtk.notebook_get_type(), rawGtk.hpaned_get_type(), rawGtk.vpaned_get_type(),
    rawGtk.spin_button_get_type(), rawGtk.progress_bar_get_type(), rawGtk.text_view_get_type(),
    rawGtk.image_get_type(), rawGtk.frame_get_type(), rawGtk.alignment_get_type(),
    rawGtk.table_get_type(), rawGtk.fixed_get_type(), rawGtk.event_box_get_type(),
    rawGtk.menu_bar_get_type(), rawGtk.menu_get_type(), rawGtk.menu_item_get_type(),
    rawGtk.check_menu_item_get_type(), rawGtk.toolbar_get_type(), rawGtk.tool_button_get_type(),
    rawGtk.toggle_tool_button_get_type(), rawGtk.dialog_get_type(), rawGtk.action_get_type(),
    rawGtk.toggle_action_get_type(), rawGtk.adjustment_get_type(), rawGtk.text_buffer_get_type(),
    rawGtk.action_group_get_type(), rawGtk.list_store_get_type(), rawGtk.tree_store_get_type(),
    rawGtk.text_tag_get_type(), rawGtk.text_tag_table_get_type()]
  discard types

type SignalCollector = object
  book: BuilderBook
  error: string
proc collectBuilderSignal(builder: rawGtk.PBuilder, obj: g.PGObject,
    signalName, handlerName: cstring, connectObject: g.PGObject,
    flags: g.TGConnectFlags, data: pointer) {.cdecl.} =
  let collector = cast[ptr SignalCollector](data)
  try:
    collector.book.declarations.add(BuilderDeclaration(obj: obj,
      hasConnectObject: connectObject != nil,
      info: BuilderSignal(objectId: builderName(obj), signalName: $signalName,
        handlerName: $handlerName, connectObjectId: (if connectObject == nil: "" else: builderName(connectObject)),
        after: (flags and g.G_CONNECT_AFTER) != 0, swapped: (flags and g.G_CONNECT_SWAPPED) != 0)))
  except Exception as error: collector.error = error.msg
proc finishBuilder(ui: Builder, status: g.guint, error: ptr g.GError) =
  if error != nil:
    let failure = newException(BuilderError, $error.message)
    failure.domain = uint32(error.domain)
    failure.code = int32(error.code)
    g.g_error_free(error)
    ui.close()
    raise failure
  if status == 0:
    ui.close()
    raise newException(BuilderError, "GTK could not load the UI document")
  var collector = SignalCollector(book: ui.book)
  rawGtk.builder_connect_signals_full(ui.raw, collectBuilderSignal, addr collector)
  if collector.error.len != 0:
    ui.close()
    raise newException(BuilderError, collector.error)
proc freshBuilder(domain: string): Builder =
  discard checkedUtf8Text(domain)
  registerBuilderTypes()
  result.book = BuilderBook(owner: ObjectHandle(state: adoptObject(rawGtk.builder_new(),
    hasDestroySignal = false, sink = false)))
  if domain.len != 0: rawGtk.builder_set_translation_domain(result.raw, domain.cstring)
proc newBuilder*(xml: string, translationDomain = ""): Builder =
  let text = checkedUtf8Text(xml)
  result = freshBuilder(translationDomain)
  var error: ptr g.GError
  let status = rawGtk.builder_add_from_string(result.raw, text, g.gsize(xml.len), addr error)
  finishBuilder(result, status, error)
proc loadBuilder*(filename: string, translationDomain = ""): Builder =
  let path = checkedString(filename)
  if filename.len == 0: raise newException(ValueError, "builder filename cannot be empty")
  when defined(windows): discard checkedUtf8Text(filename)
  result = freshBuilder(translationDomain)
  var error: ptr g.GError
  let status = rawGtk.builder_add_from_file(result.raw, path, addr error)
  finishBuilder(result, status, error)

proc builderSignalThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try: queueRecent(data, true)
    except Exception as error: reportSignalError(error)
proc connectBuilderDeclaration(ui: Builder, declaration: BuilderDeclaration,
    fn: proc () {.closure.}): Connection =
  # One closure environment per declaration, never a captured loop variable.
  let state = adoptObject(declaration.obj, borrowed = true, cache = true,
    hasDestroySignal = g.g_signal_lookup("destroy", g.G_OBJECT_TYPE(declaration.obj)) != 0)
  ui.retainBuilderHandle(state)
  connectRecent(ObjectHandle(state: state), declaration.info.signalName.cstring,
    proc (unused: bool) = fn(), cast[g.TGCallback](builderSignalThunk), after = declaration.info.after)
proc connectSignals*(ui: Builder, handlers: openArray[BuilderHandler]) =
  discard ui.raw
  if ui.book.wired: raise newException(ValueError, "builder signals are already connected")
  for i, handler in handlers:
    discard builderId(handler.name)
    if handler.fn == nil: raise newException(ValueError, "builder handler cannot be nil")
    for j in 0..<i:
      if handlers[j].name == handler.name: raise newException(ValueError, "duplicate builder handler name")
    var found = false
    for declaration in ui.book.declarations:
      if declaration.info.handlerName == handler.name: found = true
    if not found: raise newException(ValueError, "unused builder handler: " & handler.name)
  var indexes: seq[int]
  for declaration in ui.book.declarations:
    let info = declaration.info
    if info.swapped or declaration.hasConnectObject:
      raise newException(ValueError, "swapped/object-connected builder signals require raw GTK")
    var signalId: g.guint
    var detail: g.TGQuark
    if not g.toBool(g.g_signal_parse_name(info.signalName.cstring, g.G_OBJECT_TYPE(declaration.obj),
        addr signalId, addr detail, g.gbool(true))):
      raise newException(ValueError, "unknown builder signal: " & info.signalName)
    var query: g.TGSignalQuery
    g.g_signal_query(signalId, addr query)
    if query.n_params != 0 or query.return_type != g.G_TYPE_NONE or $query.signal_name == "destroy":
      raise newException(ValueError, "builder closure signals must be void/no-argument and not destroy")
    var index = -1
    for i, handler in handlers:
      if handler.name == info.handlerName: index = i
    if index < 0: raise newException(ValueError, "missing builder handler: " & info.handlerName)
    indexes.add(index)
  var connected: seq[Connection]
  try:
    for i, declaration in ui.book.declarations:
      connected.add(connectBuilderDeclaration(ui, declaration, handlers[indexes[i]].fn))
  except Exception:
    for connection in connected: connection.disconnect()
    raise
  ui.book.connections = connected
  ui.book.wired = true
