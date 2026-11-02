# Included by desktop.nim on X11 GTK2 platforms (Unix, not Quartz).
type
  EmbedId* = distinct uint32 # GdkNativeWindow, not Xlib's unsigned-long Window.
  Socket* = object of Container
  Plug* = object of Window
proc `==`*(a, b: EmbedId): bool {.borrow.}
proc `$`*(id: EmbedId): string = $uint32(id)
proc isEmpty*(id: EmbedId): bool = uint32(id) == 0
proc embedId*[T: SomeInteger](value: T): EmbedId =
  when T is SomeSignedInt:
    if value < 0: raise newException(ValueError, "embedding ID cannot be negative")
  if uint64(value) > high(uint32).uint64: raise newException(ValueError, "embedding ID must fit guint32")
  EmbedId(uint32(value))
proc raw*(w: Socket): rawGtk.PSocket = cast[rawGtk.PSocket](raw(Widget(w)))
proc raw*(w: Plug): rawGtk.PPlug = cast[rawGtk.PPlug](raw(Widget(w)))
proc keepSocket(instance, data: pointer): g.gboolean {.cdecl.} = g.gbool(true)
proc newSocket*(): Socket =
  result.state = adoptWidget(rawGtk.socket_new())
  # Native default destroys the socket on plug removal. Keep SDK sockets reusable;
  # user removal observers run at idle and can explicitly destroy the owner.
  let id = g.g_signal_connect_data(result.raw, "plug-removed", cast[g.TGCallback](keepSocket), nil, nil, g.G_CONNECT_AFTER)
  result.state.handlers.add(id)
proc hasPlug*(w: Socket): bool =
  if rawGtk.get_plug_window(w.raw) != nil: return true
  # A same-process Plug may be parented before it has a GdkWindow.
  let children = rawGtk.get_children(cast[rawGtk.PContainer](w.raw))
  result = children != nil
  g.free(children)
proc anchoredSocket(w: Socket) =
  let top = rawGtk.get_toplevel(cast[rawGtk.PWidget](w.raw))
  if not rawGtk.IS_WINDOW(top) or g.G_TYPE_CHECK_INSTANCE_TYPE(top, rawGtk.offscreen_window_get_type()):
    raise newException(ValueError, "socket must belong to an onscreen Window tree before embedding or requesting its ID")
proc id*(w: Socket): EmbedId =
  anchoredSocket(w)
  EmbedId(rawGtk.get_id(w.raw)) # Realizes the anchored socket, but does not show it.
proc addId*(w: Socket, id: EmbedId) =
  anchoredSocket(w)
  if id.isEmpty: raise newException(ValueError, "cannot attach an empty embedding ID")
  if w.hasPlug: raise newException(ValueError, "socket already has a plug")
  if id == w.id: raise newException(ValueError, "socket cannot embed itself")
  rawGtk.add_id(w.raw, uint32(id))
proc newPlug*(socketId = EmbedId(0)): Plug =
  result.state = adoptWidget(rawGtk.plug_new(uint32(socketId)))
proc newPlug*(socket: Socket): Plug =
  if socket.hasPlug: raise newException(ValueError, "socket already has a plug")
  newPlug(socket.id)
proc id*(w: Plug): EmbedId = EmbedId(rawGtk.get_id(w.raw))
proc isEmbedded*(w: Plug): bool = g.toBool(rawGtk.get_embedded(w.raw))
proc plugAdded(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueRecent(data, true)
proc plugRemoved(instance, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueRecent(data, false)
  g.gbool(false) # The constructor's AFTER handler supplies the retention policy.
proc onPlugAdded*(w: Socket, fn: proc () {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectRecent(w, "plug-added", proc (unused: bool) = fn(), cast[g.TGCallback](plugAdded))
proc onPlugRemoved*(w: Socket, fn: proc () {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  # Run before the native boolean accumulator is stopped by the keeper.
  connectRecent(w, "plug-removed", proc (unused: bool) = fn(), cast[g.TGCallback](plugRemoved), after = false)
proc onEmbedded*(w: Plug, fn: proc () {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectRecent(w, "embedded", proc (unused: bool) = fn(), cast[g.TGCallback](plugAdded))
