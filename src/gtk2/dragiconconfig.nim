# Shared source icon configuration; no native source-site mutation.
type
  DragContextInfo* = object
    actions*, suggestedAction*, selectedAction*: uint32 ## Native GdkDragAction bits, zero if unset.
    protocol*: int ## Native GdkDragProtocol value.
    hasDestination*: bool ## Native destination window present, not drop acceptance.
  DragIconFactory* = proc (info: DragContextInfo): Widget {.closure.}
  DragIconConfig = object
    image: Pixbuf
    factory: DragIconFactory
    x, y: g.gint

const dragIconPopupKey = "nim-gtk2-active-drag-icon-popup"

proc snapshotDragContext(context: rawGdk.PDragContext): DragContextInfo =
  DragContextInfo(actions: cast[uint32](rawGdk.drag_context_get_actions(context)),
    suggestedAction: cast[uint32](rawGdk.drag_context_get_suggested_action(context)),
    selectedAction: cast[uint32](rawGdk.drag_context_get_selected_action(context)),
    protocol: ord(rawGdk.drag_context_get_protocol(context)),
    hasDestination: rawGdk.drag_context_get_dest_window(context) != nil)

proc destroyDragIconPopup(data: pointer) {.cdecl.} =
  let p = cast[rawGtk.PWidget](data)
  rawGtk.destroy(p)
  g.g_object_unref(p)

proc applySourceIcon(context: rawGdk.PDragContext, widget: rawGtk.PWidget, config: DragIconConfig) =
  if config.factory == nil:
    if config.image.isEmpty: return # Leave actual GTK defaults alone.
    let p = config.image.raw
    discard g.g_object_ref(p)
    defer: g.g_object_unref(p)
    rawGtk.drag_set_icon_pixbuf(context, p, config.x, config.y)
    return
  # This packet is fixed before invoking application code. Keep the initiating
  # objects alive through realization and native icon installation.
  let factory = config.factory
  let x = config.x
  let y = config.y
  discard g.g_object_ref(context)
  defer: g.g_object_unref(context)
  discard g.g_object_ref(widget)
  defer: g.g_object_unref(widget)
  try:
    let child = factory(snapshotDragContext(context))
    let p = child.raw
    if p == widget or rawGtk.get_parent(p) != nil or g.toBool(rawGtk.get_realized(p)) or
        g.toBool(rawGtk.is_toplevel(p)):
      raise newException(ValueError, "drag icon factory must produce fresh unrealized non-window content")
    if g.get_data(cast[g.PGObject](widget), objectStateKey) == cast[pointer](1): return
    let screen = rawGtk.get_screen(widget)
    let popup = rawGtk.window_new(rawGtk.WINDOW_POPUP)
    if popup == nil: raise newException(ValueError, "could not create drag icon popup")
    discard g.g_object_ref_sink(popup)
    var installed = false
    defer:
      if not installed: destroyDragIconPopup(popup)
    rawGtk.set_screen(cast[rawGtk.PWindow](popup), screen)
    rawGtk.set_type_hint(cast[rawGtk.PWindow](popup), rawGdk.WINDOW_TYPE_HINT_DND)
    rawGtk.add(cast[rawGtk.PContainer](popup), p)
    rawGtk.show_all(p) # Show only fresh content; GTK decides when to map the popup.
    if child.isDestroyed or g.get_data(cast[g.PGObject](widget), objectStateKey) == cast[pointer](1): return
    g.set_data_full(cast[g.PGObject](context), dragIconPopupKey, popup, destroyDragIconPopup)
    installed = true
    rawGtk.drag_set_icon_widget(context, popup, x, y)
  except Exception as e: reportSignalError(e)
