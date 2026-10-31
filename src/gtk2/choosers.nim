# Included by gtk2.nim. Standalone GTK2 color/font panels and nonblocking dialogs.
type
  ColorSelection* = object of VBox
  ColorSelectionDialog* = object of Dialog
  FontSelection* = object of VBox
  FontSelectionDialog* = object of Dialog

proc raw*(w: ColorSelection): rawGtk.PColorSelection = cast[rawGtk.PColorSelection](raw(Widget(w)))
proc raw*(w: ColorSelectionDialog): rawGtk.PColorSelectionDialog = cast[rawGtk.PColorSelectionDialog](raw(Widget(w)))
proc raw*(w: FontSelection): rawGtk.PFontSelection = cast[rawGtk.PFontSelection](raw(Widget(w)))
proc raw*(w: FontSelectionDialog): rawGtk.PFontSelectionDialog = cast[rawGtk.PFontSelectionDialog](raw(Widget(w)))
proc `title=`*(w: ColorSelectionDialog, value: string) =
  rawGtk.set_title(cast[rawGtk.PWindow](w.raw), checkedUtf8Text(value))
proc `title=`*(w: FontSelectionDialog, value: string) =
  rawGtk.set_title(cast[rawGtk.PWindow](w.raw), checkedUtf8Text(value))
proc colorSelection(w: ColorSelection): rawGtk.PColorSelection = w.raw
proc colorSelection(w: ColorSelectionDialog): rawGtk.PColorSelection =
  cast[rawGtk.PColorSelection](rawGtk.get_color_selection(w.raw))
proc fontSelection(w: FontSelection): rawGtk.PFontSelection = w.raw
proc fontSelection(w: FontSelectionDialog): rawGtk.PFontSelection =
  cast[rawGtk.PFontSelection](rawGtk.get_font_selection(w.raw))
proc selectedColor(p: rawGtk.PColorSelection, previous = false): Color =
  var native: TColor
  if previous:
    rawGtk.get_previous_color(p, addr native)
    result.alpha = rawGtk.get_previous_alpha(p)
  else:
    rawGtk.get_current_color(p, addr native)
    result.alpha = rawGtk.get_current_alpha(p)
  result.red = native.red
  result.green = native.green
  result.blue = native.blue
proc setSelectedColor(p: rawGtk.PColorSelection, value: Color, previous = false) =
  var native = TColor(red: value.red, green: value.green, blue: value.blue)
  if previous:
    rawGtk.set_previous_color(p, addr native)
    rawGtk.set_previous_alpha(p, value.alpha)
  else:
    rawGtk.set_current_color(p, addr native)
    rawGtk.set_current_alpha(p, value.alpha)
template colorSelectionProperties(Kind: typedesc) =
  proc color*(w: Kind): Color = selectedColor(colorSelection(w))
  proc `color=`*(w: Kind, value: Color) = setSelectedColor(colorSelection(w), value)
  proc previousColor*(w: Kind): Color = selectedColor(colorSelection(w), previous = true)
  proc `previousColor=`*(w: Kind, value: Color) = setSelectedColor(colorSelection(w), value, previous = true)
  proc useAlpha*(w: Kind): bool = g.toBool(rawGtk.get_has_opacity_control(colorSelection(w)))
  proc `useAlpha=`*(w: Kind, value: bool) = rawGtk.set_has_opacity_control(colorSelection(w), g.gbool(value))
  proc hasPalette*(w: Kind): bool = g.toBool(rawGtk.get_has_palette(colorSelection(w)))
  proc `hasPalette=`*(w: Kind, value: bool) = rawGtk.set_has_palette(colorSelection(w), g.gbool(value))
  proc isAdjusting*(w: Kind): bool = g.toBool(rawGtk.is_adjusting(colorSelection(w)))
colorSelectionProperties(ColorSelection)
colorSelectionProperties(ColorSelectionDialog)
proc copiedSelectedFont(p: rawGtk.PFontSelection): string =
  let text = rawGtk.get_font_name(p) # Transfer-full, unlike FontButton's getter.
  if text != nil:
    try: result = $text
    finally: g.g_free(text)
template fontSelectionProperties(Kind: typedesc) =
  proc fontName*(w: Kind): string = copiedSelectedFont(fontSelection(w))
  proc setFontName*(w: Kind, value: string): bool {.discardable.} =
    let name = checkedFontName(value)
    g.toBool(rawGtk.set_font_name(fontSelection(w), name))
  proc `fontName=`*(w: Kind, value: string) =
    if not w.setFontName(value):
      raise newException(ValueError, "GTK could not apply font; parent the selector into a window first")
  proc previewText*(w: Kind): string = $rawGtk.get_preview_text(fontSelection(w))
  proc `previewText=`*(w: Kind, value: string) = rawGtk.set_preview_text(fontSelection(w), checkedUtf8Text(value))
fontSelectionProperties(FontSelection)
fontSelectionProperties(FontSelectionDialog)

proc newColorSelection*(color = rgba16(0, 0, 0), useAlpha = false, hasPalette = false): ColorSelection =
  result.state = adoptWidget(rawGtk.color_selection_new())
  result.useAlpha = useAlpha
  result.hasPalette = hasPalette
  result.color = color
  result.previousColor = color
proc newFontSelection*(): FontSelection = result.state = adoptWidget(rawGtk.font_selection_new())
proc chooserResponseWidget(w: Dialog, response: ResponseId): rawGtk.PWidget =
  result = rawGtk.get_widget_for_response(w.raw, g.gint(response))
  if result == nil: raise newException(ValueError, "chooser response button is unavailable")
proc chooserResponseVisible(w: Dialog, response: ResponseId, visible: bool) =
  let p = chooserResponseWidget(w, response)
  rawGtk.set_no_show_all(p, g.gbool(not visible))
  if visible: rawGtk.show(p)
  else: rawGtk.hide(p)
proc showHelp*(w: ColorSelectionDialog): bool = g.toBool(rawGtk.get_visible(chooserResponseWidget(w, responseHelp)))
proc `showHelp=`*(w: ColorSelectionDialog, value: bool) = chooserResponseVisible(w, responseHelp, value)
proc showApply*(w: FontSelectionDialog): bool = g.toBool(rawGtk.get_visible(chooserResponseWidget(w, responseApply)))
proc `showApply=`*(w: FontSelectionDialog, value: bool) = chooserResponseVisible(w, responseApply, value)
proc newColorSelectionDialog*(title = "Pick a Color", color = rgba16(0, 0, 0),
                              useAlpha = false, hasPalette = false, modal = false): ColorSelectionDialog =
  let caption = checkedUtf8Text(title)
  result.state = adoptWidget(rawGtk.color_selection_dialog_new(caption))
  result.modal = modal
  result.useAlpha = useAlpha
  result.hasPalette = hasPalette
  result.color = color
  result.previousColor = color
  result.showHelp = false # Keep GTK's initially hidden button hidden by showAll.
proc newColorSelectionDialog*(parent: Window, title = "Pick a Color", color = rgba16(0, 0, 0),
                              useAlpha = false, hasPalette = false, modal = false,
                              destroyWithParent = true): ColorSelectionDialog =
  discard parent.raw
  result = newColorSelectionDialog(title, color, useAlpha, hasPalette, modal)
  attachDialogParent(result, parent, destroyWithParent)
proc newFontSelectionDialog*(title = "Pick a Font", modal = false): FontSelectionDialog =
  result.state = adoptWidget(rawGtk.font_selection_dialog_new(checkedUtf8Text(title)))
  result.modal = modal
  result.showApply = false
proc newFontSelectionDialog*(parent: Window, title = "Pick a Font", modal = false,
                             destroyWithParent = true): FontSelectionDialog =
  discard parent.raw
  result = newFontSelectionDialog(title, modal)
  attachDialogParent(result, parent, destroyWithParent)

# GTK updates several private controls after its native change signals. Read a
# copied final selection at idle so observers may safely destroy the owner.
type ChooserWatch = tuple[p: pointer, id: g.gulong, retained: bool]
type ChooserBinding[T] = ref object
  fn: proc (value: T) {.closure.}
  selector: pointer # Borrowed for standalone panels; retained for private panels.
  watches: seq[ChooserWatch]
  last: T
  active, pending: bool
  idle: g.guint
proc stopChooser[T](binding: ChooserBinding[T]) =
  binding.active = false
  binding.pending = false
  binding.fn = nil
  let idle = binding.idle
  binding.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  let watches = binding.watches
  binding.watches = @[]
  for watch in watches:
    if g.g_signal_handler_is_connected(watch.p, watch.id):
      g.g_signal_handler_disconnect(watch.p, watch.id)
  for watch in watches:
    if watch.retained: g.g_object_unref(watch.p)
  binding.selector = nil
proc releaseChooser[T](data: pointer, closure: g.PGClosure) {.cdecl.} =
  let binding = cast[ChooserBinding[T]](data)
  stopChooser(binding)
  GC_unref(binding)
proc destroyChooserOwner[T](instance, data: pointer) {.cdecl.} = stopChooser(cast[ChooserBinding[T]](data))
proc releaseChooserIdle[T](data: pointer) {.cdecl.} = GC_unref(cast[ChooserBinding[T]](data))
proc chooserValue[T](p: pointer): T =
  when T is Color: selectedColor(cast[rawGtk.PColorSelection](p))
  else: copiedSelectedFont(cast[rawGtk.PFontSelection](p))
proc dispatchChooser[T](data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let binding = cast[ChooserBinding[T]](data)
    if binding.active and binding.pending:
      binding.pending = false
      try:
        let value = chooserValue[T](binding.selector)
        if value != binding.last:
          binding.last = value
          let fn = binding.fn
          fn(value)
      except Exception as error: reportSignalError(error)
    if not binding.active or not binding.pending:
      binding.idle = 0
      return g.gbool(false)
    g.gbool(true)
proc queueChooser[T](binding: ChooserBinding[T]) =
  if not binding.active: return
  binding.pending = true
  if binding.idle == 0:
    GC_ref(binding)
    binding.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchChooser[T]),
      cast[pointer](binding), cast[pointer](releaseChooserIdle[T]))
proc chooserSignal[T](instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueChooser(cast[ChooserBinding[T]](data))
proc chooserNotify[T](instance, detail, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueChooser(cast[ChooserBinding[T]](data))
proc watchChooser[T](binding: ChooserBinding[T], p: pointer, signal: cstring,
                     callback: g.TGCallback, retained = false) =
  if retained: discard g.g_object_ref(p)
  let id = g.g_signal_connect_data(p, signal, callback, cast[pointer](binding), nil, g.G_CONNECT_AFTER)
  binding.watches.add((p, id, retained))
proc connectChooser[T](owner: Widget, selector: pointer, fn: proc (value: T) {.closure.}): Connection =
  let p = owner.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let binding = ChooserBinding[T](fn: fn, selector: selector, active: true, last: chooserValue[T](selector))
  when T is Color:
    watchChooser(binding, selector, "color-changed", cast[g.TGCallback](chooserSignal[T]), selector != p)
    watchChooser(binding, selector, "notify::has-opacity-control", cast[g.TGCallback](chooserNotify[T]))
  else:
    watchChooser(binding, selector, "notify::font-name", cast[g.TGCallback](chooserNotify[T]), selector != p)
    let font = cast[rawGtk.PFontSelection](selector)
    # GTK2 does not notify font-name for all user list changes. Watch selection
    # changes and preview styling too; none of these private controls are exposed.
    for list in [rawGtk.get_family_list(font), rawGtk.get_face_list(font), rawGtk.get_size_list(font)]:
      let selection = rawGtk.get_selection(cast[rawGtk.PTreeView](list))
      watchChooser(binding, selection, "changed", cast[g.TGCallback](chooserSignal[T]), retained = true)
    watchChooser(binding, rawGtk.get_preview_entry(font), "style-set", cast[g.TGCallback](chooserNotify[T]), retained = true)
  GC_ref(binding)
  # An owner-local anchor gives Connection its normal cancellation semantics.
  # The destroy thunk also cleans up if the owner's temporary Nim state is gone.
  let id = g.g_signal_connect_data(p, "destroy", cast[g.TGCallback](destroyChooserOwner[T]),
    cast[pointer](binding), releaseChooser[T], g.G_CONNECT_AFTER)
  owner.state.handlers.add(id)
  Connection(state: owner.state, id: id)
proc onColorChanged*(w: ColorSelection, fn: proc (value: Color) {.closure.}): Connection {.discardable.} =
  connectChooser(w, colorSelection(w), fn)
proc onColorChanged*(w: ColorSelectionDialog, fn: proc (value: Color) {.closure.}): Connection {.discardable.} =
  connectChooser(w, colorSelection(w), fn)
proc onFontChanged*(w: FontSelection, fn: proc (value: string) {.closure.}): Connection {.discardable.} =
  connectChooser(w, fontSelection(w), fn)
proc onFontChanged*(w: FontSelectionDialog, fn: proc (value: string) {.closure.}): Connection {.discardable.} =
  connectChooser(w, fontSelection(w), fn)
