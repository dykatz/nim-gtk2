# Included by gtk2ui.nim: display widgets, status stacks and response signals.
type
  Image* = object of Widget
  Statusbar* = object of Box
  InfoBar* = object of Container # Pack content, not GTK's private outer HBox.
  IconSize* = enum
    iconMenu = 1, iconSmallToolbar, iconLargeToolbar, iconButton, iconDrag, iconDialog
  ImageStorage* = enum
    imageEmpty, imagePixmap, imageImage, imagePixbuf, imageStock, imageIconSet,
    imageAnimation, imageIconName, imageGIcon
  MessageKind* = enum
    messageInfo, messageWarning, messageQuestion, messageError, messageOther
  ResponseId* = distinct cint
  StatusContext* = object
    state: ObjectState
    id: g.guint
  StatusMessage* = object
    context: StatusContext
    id: g.guint
  ResponseCallback = ref object
    fn: proc (id: ResponseId) {.closure.}
  StatusTextCallback = ref object
    fn: proc (text: string) {.closure.}

const
  responseNone* = ResponseId(-1)
  responseReject* = ResponseId(-2)
  responseAccept* = ResponseId(-3)
  responseDeleteEvent* = ResponseId(-4)
  responseOk* = ResponseId(-5)
  responseCancel* = ResponseId(-6)
  responseClose* = ResponseId(-7)
  responseYes* = ResponseId(-8)
  responseNo* = ResponseId(-9)
  responseApply* = ResponseId(-10)
  responseHelp* = ResponseId(-11)

proc `==`*(a, b: ResponseId): bool {.borrow.}
proc `$`*(id: ResponseId): string = $cint(id)
proc customResponse*(value: int): ResponseId =
  if value < 0 or value > high(cint).int:
    raise newException(ValueError, "custom response must fit a nonnegative gint")
  ResponseId(cint(value))

proc raw*(w: Image): rawGtk.PImage = cast[rawGtk.PImage](raw(Widget(w)))
proc raw*(w: Statusbar): rawGtk.PStatusbar = cast[rawGtk.PStatusbar](raw(Widget(w)))
proc raw*(w: InfoBar): rawGtk.PInfoBar = cast[rawGtk.PInfoBar](raw(Widget(w)))

proc sensitive*(w: Widget): bool = g.toBool(rawGtk.get_sensitive(w.raw))
proc `sensitive=`*(w: Widget, value: bool) = rawGtk.set_sensitive(w.raw, g.gbool(value))

proc newImage*(): Image = result.state = adoptWidget(rawGtk.image_new())
proc newImageFromFile*(filename: string): Image =
  ## Native GTK behavior: unreadable images display the missing-image stock icon.
  result.state = adoptWidget(rawGtk.image_new_from_file(checkedString(filename)))
proc newImageFromIcon*(name: string, size = iconButton): Image =
  result.state = adoptWidget(rawGtk.image_new_from_icon_name(checkedString(name), rawGtk.TIconSize(size)))
proc newImageFromStock*(id: string, size = iconButton): Image =
  result.state = adoptWidget(rawGtk.image_new_from_stock(checkedString(id), rawGtk.TIconSize(size)))
proc setFromFile*(w: Image, filename: string) = rawGtk.set_from_file(w.raw, checkedString(filename))
proc setFromIcon*(w: Image, name: string, size = iconButton) =
  rawGtk.set_from_icon_name(w.raw, checkedString(name), rawGtk.TIconSize(size))
proc setFromStock*(w: Image, id: string, size = iconButton) =
  rawGtk.set_from_stock(w.raw, checkedString(id), rawGtk.TIconSize(size))
proc clear*(w: Image) = rawGtk.clear(w.raw)
proc storageKind*(w: Image): ImageStorage = ImageStorage(ord(rawGtk.get_storage_type(w.raw)))
proc pixelSize*(w: Image): int = rawGtk.get_pixel_size(w.raw).int
proc `pixelSize=`*(w: Image, size: int) = rawGtk.set_pixel_size(w.raw, sizeRequestValue(size))
proc iconName*(w: Image): string =
  if w.storageKind != imageIconName:
    raise newException(ValueError, "image does not contain a named icon")
  var name: cstring
  var size: rawGtk.TIconSize
  rawGtk.get_icon_name(w.raw, addr name, addr size)
  $name # Borrowed native string: copy, never free.
proc stockId*(w: Image): string =
  if w.storageKind != imageStock:
    raise newException(ValueError, "image does not contain a stock icon")
  var id: cstring
  var size: rawGtk.TIconSize
  rawGtk.get_stock(w.raw, addr id, addr size)
  $id

proc newStatusbar*(resizeGrip = true): Statusbar =
  result.state = adoptWidget(rawGtk.statusbar_new())
  rawGtk.set_has_resize_grip(result.raw, g.gbool(resizeGrip))
proc resizeGrip*(w: Statusbar): bool = g.toBool(rawGtk.get_has_resize_grip(w.raw))
proc `resizeGrip=`*(w: Statusbar, enabled: bool) = rawGtk.set_has_resize_grip(w.raw, g.gbool(enabled))
proc context*(w: Statusbar, description: string): StatusContext =
  let id = rawGtk.get_context_id(w.raw, checkedString(description))
  StatusContext(state: w.state, id: id)
proc contextPointer(c: StatusContext): rawGtk.PStatusbar =
  if c.id == 0: raise newException(ValueError, "status context is uninitialized")
  cast[rawGtk.PStatusbar](nativePointer(ObjectHandle(state: c.state)))
proc push*(c: StatusContext, text: string): StatusMessage {.discardable.} =
  let id = rawGtk.push(contextPointer(c), c.id, checkedString(text))
  StatusMessage(context: c, id: id)
proc pop*(c: StatusContext) = rawGtk.pop(contextPointer(c), c.id)
proc remove*(message: StatusMessage) =
  if message.id == 0: raise newException(ValueError, "status message is uninitialized")
  rawGtk.remove(contextPointer(message.context), message.context.id, message.id)

proc releaseStatusCallback(data: pointer, closure: g.PGClosure) {.cdecl.} =
  GC_unref(cast[StatusTextCallback](data))
proc statusTextThunk(instance: rawGtk.PStatusbar, context: g.guint,
                     text: cstring, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let fn = cast[StatusTextCallback](data).fn
    try:
      fn($text) # Copy the borrowed text before invoking a reentrant user callback.
    except Exception as error:
      reportSignalError(error)
proc connectStatusText(w: Statusbar, signal: cstring,
                       fn: proc (text: string) {.closure.}): Connection =
  let p = w.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let callback = StatusTextCallback(fn: fn)
  GC_ref(callback)
  let id = g.g_signal_connect_data(p, signal, cast[g.TGCallback](statusTextThunk),
    cast[pointer](callback), releaseStatusCallback, g.G_CONNECT_AFTER)
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)
proc onTextPushed*(w: Statusbar, fn: proc (text: string) {.closure.}): Connection {.discardable.} =
  connectStatusText(w, "text-pushed", fn)
proc onTextPopped*(w: Statusbar, fn: proc (text: string) {.closure.}): Connection {.discardable.} =
  connectStatusText(w, "text-popped", fn)

proc newInfoBar*(kind = messageInfo): InfoBar =
  result.state = adoptWidget(rawGtk.info_bar_new())
  rawGtk.set_message_type(result.raw, rawGtk.TMessageType(ord(kind)))
proc messageKind*(w: InfoBar): MessageKind = MessageKind(ord(rawGtk.get_message_type(w.raw)))
proc `messageKind=`*(w: InfoBar, kind: MessageKind) = rawGtk.set_message_type(w.raw, rawGtk.TMessageType(ord(kind)))
proc packStart*(w: InfoBar, child: Widget, options = packExpandWidget, padding = 0) =
  checkChild(w, child)
  let pad = g.guint(checkedInt(padding))
  let area = cast[rawGtk.PBox](rawGtk.get_content_area(w.raw))
  rawGtk.pack_start(area, child.raw, g.gbool(options != packShrink),
    g.gbool(options == packExpandWidget), pad)
proc packEnd*(w: InfoBar, child: Widget, options = packExpandWidget, padding = 0) =
  checkChild(w, child)
  let pad = g.guint(checkedInt(padding))
  let area = cast[rawGtk.PBox](rawGtk.get_content_area(w.raw))
  rawGtk.pack_end(area, child.raw, g.gbool(options != packShrink),
    g.gbool(options == packExpandWidget), pad)
proc addButton*(w: InfoBar, text: string, response: ResponseId): Button =
  let p = rawGtk.add_button(w.raw, checkedString(text), g.gint(response))
  # Native add_button creates and parents it. Retain that borrowed result.
  result.state = adoptObject(p, borrowed = true)
proc addActionWidget*(w: InfoBar, button: Button, response: ResponseId) =
  checkChild(w, button)
  rawGtk.set_can_default(cast[rawGtk.PWidget](button.raw), g.gbool(true))
  rawGtk.add_action_widget(w.raw, cast[rawGtk.PWidget](button.raw), g.gint(response))
proc setResponseSensitive*(w: InfoBar, response: ResponseId, enabled: bool) =
  rawGtk.set_response_sensitive(w.raw, g.gint(response), g.gbool(enabled))
proc `defaultResponse=`*(w: InfoBar, response: ResponseId) =
  if not rawGtk.IS_WINDOW(rawGtk.get_toplevel(cast[rawGtk.PWidget](w.raw))):
    raise newException(ValueError, "attach InfoBar to a window before setting its default response")
  rawGtk.set_default_response(w.raw, g.gint(response))
proc respond*(w: InfoBar, response: ResponseId) = rawGtk.response(w.raw, g.gint(response))

proc releaseResponseCallback(data: pointer, closure: g.PGClosure) {.cdecl.} =
  GC_unref(cast[ResponseCallback](data))
proc responseThunk(instance: pointer, response: g.gint, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let fn = cast[ResponseCallback](data).fn
    try:
      fn(ResponseId(response))
    except Exception as error:
      reportSignalError(error)
proc connectResponse(w: Widget, fn: proc (id: ResponseId) {.closure.}): Connection =
  let p = w.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let callback = ResponseCallback(fn: fn)
  GC_ref(callback)
  let id = g.g_signal_connect_data(p, "response", cast[g.TGCallback](responseThunk),
    cast[pointer](callback), releaseResponseCallback, g.TGConnectFlags(0))
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)

proc onResponse*(w: InfoBar, fn: proc (id: ResponseId) {.closure.}): Connection {.discardable.} =
  connectResponse(w, fn)
