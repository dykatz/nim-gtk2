# Included by gtk2.nim. Fixed cell layouts, normalized HSV, offscreen snapshots.
import std/math

type
  CellView* = object of Widget
  HSV* = object of Widget
  OffscreenWindow* = object of Window
  HSVColor* = object
    hue*, saturation*, value*: float64
  HSVState* = object
    color*: HSVColor
    adjusting*: bool
  HSVMetrics* = object
    diameter*, ringWidth*: int

proc raw*(w: CellView): ptr rawGtk.CellView = cast[ptr rawGtk.CellView](raw(Widget(w)))
proc raw*(w: HSV): ptr rawGtk.HSV = cast[ptr rawGtk.HSV](raw(Widget(w)))
proc raw*(w: OffscreenWindow): ptr rawGtk.OffscreenWindow = cast[ptr rawGtk.OffscreenWindow](raw(Widget(w)))
proc unitComponent(value: float64): float64 =
  result = finite(value)
  if result < 0 or result > 1: raise newException(ValueError, "color components must be in 0..1")
proc hsvColor*(hue, saturation, value: float64): HSVColor =
  HSVColor(hue: unitComponent(hue), saturation: unitComponent(saturation), value: unitComponent(value))
proc checkedHSV(value: HSVColor): HSVColor = hsvColor(value.hue, value.saturation, value.value)
proc toColor*(value: HSVColor, alpha = 65535'u16): Color =
  let color = checkedHSV(value)
  var r, gr, b: g.gdouble
  rawGtk.hsv_to_rgb(color.hue, color.saturation, color.value, addr r, addr gr, addr b)
  rgba16(int(round(r * 65535)), int(round(gr * 65535)), int(round(b * 65535)), alpha.int)
proc toHSV*(value: Color): HSVColor =
  rawGtk.rgb_to_hsv(value.red.float64 / 65535, value.green.float64 / 65535,
    value.blue.float64 / 65535, addr result.hue, addr result.saturation, addr result.value)
proc hsvValue(p: pointer): HSVState =
  let hsv = cast[ptr rawGtk.HSV](p)
  rawGtk.hsv_get_color(hsv, addr result.color.hue, addr result.color.saturation, addr result.color.value)
  result.adjusting = g.toBool(rawGtk.hsv_is_adjusting(hsv))
proc color*(w: HSV): HSVColor = hsvValue(w.raw).color
proc `color=`*(w: HSV, value: HSVColor) =
  let checked = checkedHSV(value)
  rawGtk.hsv_set_color(w.raw, checked.hue, checked.saturation, checked.value)
proc isAdjusting*(w: HSV): bool = g.toBool(rawGtk.hsv_is_adjusting(w.raw))
proc metrics*(w: HSV): HSVMetrics =
  var size, width: g.gint
  rawGtk.hsv_get_metrics(w.raw, addr size, addr width)
  HSVMetrics(diameter: size.int, ringWidth: width.int)
proc checkedHSVMetrics(value: HSVMetrics): tuple[size, width: g.gint] =
  result = (checkedInt(value.diameter), checkedInt(value.ringWidth))
  if result.width == 0 or 2'i64 * result.width.int64 + 1 > result.size.int64:
    raise newException(ValueError, "HSV metrics require ringWidth > 0 and 2 * ringWidth + 1 <= diameter")
proc `metrics=`*(w: HSV, value: HSVMetrics) =
  let checked = checkedHSVMetrics(value)
  rawGtk.hsv_set_metrics(w.raw, checked.size, checked.width)
proc newHSV*(color = hsvColor(0, 0, 0), diameter = 174, ringWidth = 15): HSV =
  let checked = checkedHSV(color)
  let geometry = HSVMetrics(diameter: diameter, ringWidth: ringWidth)
  discard checkedHSVMetrics(geometry)
  result.state = adoptWidget(rawGtk.hsv_new())
  result.metrics = geometry
  result.color = checked
proc onChanged*(w: HSV, fn: proc (value: HSVState) {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let p = w.raw
  let binding = ChooserBinding[HSVState](fn: fn, selector: p, active: true,
    last: hsvValue(p), readValue: hsvValue, deduplicate: true)
  watchChooser(binding, p, "changed", cast[g.TGCallback](chooserSignal[HSVState]))
  anchorChooser(w, binding)

proc newOffscreenWindow*(width = 320, height = 200): OffscreenWindow =
  let x = pixbufDimension(width)
  let y = pixbufDimension(height)
  result.state = adoptWidget(rawGtk.offscreen_window_new())
  rawGtk.set_default_size(cast[rawGtk.PWindow](result.raw), x, y)
proc offscreenImage(p: pointer): Pixbuf =
  # Native GTK passes NULL to GDK (and warns) before first realization.
  if g.toBool(rawGtk.get_realized(cast[rawGtk.PWidget](p))):
    result = ownedPixbuf(rawGtk.offscreen_window_get_pixbuf(cast[ptr rawGtk.OffscreenWindow](p)))
proc pixbuf*(w: OffscreenWindow): Pixbuf = offscreenImage(w.raw)
proc offscreenDamage(instance, event, data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueChooser(cast[ChooserBinding[Pixbuf]](data))
  g.gbool(false) # Observe damage, do not consume the native event.
proc onSnapshot*(w: OffscreenWindow, fn: proc (image: Pixbuf) {.closure.}): Connection {.discardable.} =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let p = w.raw
  let binding = ChooserBinding[Pixbuf](fn: fn, selector: p, active: true,
    readValue: offscreenImage, deduplicate: false)
  watchChooser(binding, p, "damage-event", cast[g.TGCallback](offscreenDamage))
  anchorChooser(w, binding)

const
  cellModelWatchKey = "nim-gtk2-cell-view-model-watch"
  cellStaticRendererKey = "nim-gtk2-cell-view-static-renderer"
proc refresh*(w: CellView) =
  rawGtk.queue_resize(cast[rawGtk.PWidget](w.raw))
  rawGtk.queue_draw(cast[rawGtk.PWidget](w.raw))
proc stopCellModelWatch(w: CellView) =
  let p = cast[g.PGObject](w.raw)
  let id = cast[g.gulong](g.get_data(p, cellModelWatchKey))
  g.set_data(p, cellModelWatchKey, nil)
  if id != 0 and g.g_signal_handler_is_connected(p, id): g.g_signal_handler_disconnect(p, id)
proc cellModelChanged(instance, path, iter, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueChooser(cast[ChooserBinding[bool]](data))
proc cellModelDeleted(instance, path, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueChooser(cast[ChooserBinding[bool]](data))
proc cellModelReordered(instance, path, iter, order, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueChooser(cast[ChooserBinding[bool]](data))
proc cellModelValue(p: pointer): bool = true
proc watchCellModel(w: CellView, model: TreeModel) =
  let p = w.raw
  let binding = ChooserBinding[bool](selector: p, active: true, readValue: cellModelValue,
    fn: proc (unused: bool) =
      rawGtk.queue_resize(cast[rawGtk.PWidget](p))
      rawGtk.queue_draw(cast[rawGtk.PWidget](p)))
  watchChooser(binding, model.raw, "row-changed", cast[g.TGCallback](cellModelChanged), retained = true)
  watchChooser(binding, model.raw, "row-inserted", cast[g.TGCallback](cellModelChanged))
  watchChooser(binding, model.raw, "row-deleted", cast[g.TGCallback](cellModelDeleted))
  watchChooser(binding, model.raw, "rows-reordered", cast[g.TGCallback](cellModelReordered))
  let connection = anchorChooser(w, binding)
  g.set_data(cast[g.PGObject](p), cellModelWatchKey, cast[pointer](connection.id))
proc resetCellView(w: CellView) =
  stopCellModelWatch(w)
  rawGtk.cell_view_set_model(w.raw, nil)
  rawGtk.cell_layout_clear(cast[rawGtk.PCellLayout](w.raw))
  g.set_data(cast[g.PGObject](w.raw), cellStaticRendererKey, nil)
proc retainStaticCell(w: CellView, renderer: rawGtk.PCellRenderer) =
  # GTK2 get_cells calls set_cell_data unconditionally, which warns on static
  # (model-less) views. Retain our own renderer via SDK-owned native data instead.
  g.set_data_full(cast[g.PGObject](w.raw), cellStaticRendererKey,
    g.g_object_ref(renderer), cast[g.TGDestroyNotify](g.g_object_unref))
proc singleCell(w: CellView, rendererType: g.GType): rawGtk.PCellRenderer =
  if rawGtk.cell_view_get_model(w.raw) != nil:
    raise newException(ValueError, "cell view displays a model, not static content")
  let renderer = g.get_data(cast[g.PGObject](w.raw), cellStaticRendererKey)
  if renderer == nil or not g.G_TYPE_CHECK_INSTANCE_TYPE(renderer, rendererType):
    raise newException(ValueError, "cell view has a different renderer kind")
  cast[rawGtk.PCellRenderer](renderer)
proc `text=`*(w: CellView, value: string) =
  let text = checkedUtf8Text(value)
  discard w.raw
  var native: g.TGValue
  discard g.init(addr native, g.G_TYPE_STRING)
  defer: g.unset(addr native)
  g.set_string(addr native, text)
  let renderer = rawGtk.cell_renderer_text_new()
  g.set_property(cast[g.PGObject](renderer), "text", addr native)
  resetCellView(w)
  rawGtk.cell_layout_pack_start(cast[rawGtk.PCellLayout](w.raw), renderer, g.gbool(true))
  retainStaticCell(w, renderer)
  w.refresh()
proc text*(w: CellView): string =
  let renderer = singleCell(w, rawGtk.cell_renderer_text_get_type())
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_STRING)
  defer: g.unset(addr value)
  g.get_property(cast[g.PGObject](renderer), "text", addr value)
  $g.get_string(addr value)
proc `pixbuf=`*(w: CellView, value: Pixbuf) =
  let image = value.pixbufPointer
  discard w.raw
  var native: g.TGValue
  discard g.init(addr native, rawPixbuf.pixbuf_get_type())
  defer: g.unset(addr native)
  g.set_object(addr native, image)
  let renderer = rawGtk.cell_renderer_pixbuf_new()
  g.set_property(cast[g.PGObject](renderer), "pixbuf", addr native)
  resetCellView(w)
  rawGtk.cell_layout_pack_start(cast[rawGtk.PCellLayout](w.raw), renderer, g.gbool(false))
  retainStaticCell(w, renderer)
  w.refresh()
proc pixbuf*(w: CellView): Pixbuf =
  let renderer = singleCell(w, rawGtk.cell_renderer_pixbuf_get_type())
  var value: g.TGValue
  discard g.init(addr value, rawPixbuf.pixbuf_get_type())
  defer: g.unset(addr value)
  g.get_property(cast[g.PGObject](renderer), "pixbuf", addr value)
  ownedPixbuf(cast[rawPixbuf.PPixbuf](g.get_object(addr value)), borrowed = true)
proc model*(w: CellView): TreeModel = ownedTreeModel(rawGtk.cell_view_get_model(w.raw))
proc setModel*(w: CellView, model: TreeModel, textColumn: int, pixbufColumn = -1) =
  if model.columnKind(textColumn) != cellString:
    raise newException(ValueError, "cell view text column must contain strings")
  if pixbufColumn != -1 and model.columnKind(pixbufColumn) != cellPixbuf:
    raise newException(ValueError, "cell view image column must contain pixbufs")
  discard w.raw
  resetCellView(w)
  let layout = cast[rawGtk.PCellLayout](w.raw)
  if pixbufColumn != -1:
    let image = rawGtk.cell_renderer_pixbuf_new()
    rawGtk.cell_layout_pack_start(layout, image, g.gbool(false))
    rawGtk.cell_layout_add_attribute(layout, image, "pixbuf", g.gint(pixbufColumn))
  let text = rawGtk.cell_renderer_text_new()
  rawGtk.cell_layout_pack_start(layout, text, g.gbool(true))
  rawGtk.cell_layout_add_attribute(layout, text, "text", g.gint(textColumn))
  rawGtk.cell_view_set_model(w.raw, model.raw)
  watchCellModel(w, model)
proc displayedPath*(w: CellView): TreePath =
  let path = rawGtk.cell_view_get_displayed_row(w.raw) # Transfer full.
  if path != nil:
    defer: rawGtk.free(path)
    result = copyTreePath(path)
proc `displayedPath=`*(w: CellView, value: TreePath) =
  let model = w.model
  if not value.isRoot: discard pathIter(model, value)
  let path = if value.isRoot: nil else: nativeTreePath(value)
  defer:
    if path != nil: rawGtk.free(path)
  rawGtk.cell_view_set_displayed_row(w.raw, path)
proc displayedRow*(w: CellView): int =
  checkFlatModel(w.model.raw)
  let path = w.displayedPath
  if path.isRoot: -1 else: path.indices[0]
proc `displayedRow=`*(w: CellView, value: int) =
  checkFlatModel(w.model.raw)
  if value == -1: w.displayedPath = treePath()
  else: w.displayedPath = treePath(value)
proc rowSize*(w: CellView, path: TreePath): tuple[width, height: int] =
  discard pathIter(w.model, path)
  let native = nativeTreePath(path)
  defer: rawGtk.free(native)
  var size: rawGtk.TRequisition
  if not g.toBool(rawGtk.cell_view_get_size_of_row(w.raw, native, addr size)):
    raise newException(ValueError, "GTK could not measure the cell row")
  (size.width.int, size.height.int)
proc `backgroundColor=`*(w: CellView, value: Color) =
  var color = TColor(red: value.red, green: value.green, blue: value.blue)
  rawGtk.cell_view_set_background_color(w.raw, addr color)
proc clearBackground*(w: CellView) = rawGtk.cell_view_set_background_color(w.raw, nil)
proc newCellView*(text = ""): CellView =
  discard checkedUtf8Text(text)
  result.state = adoptWidget(rawGtk.cell_view_new())
  result.text = text
proc newCellView*(image: Pixbuf): CellView =
  discard image.pixbufPointer
  result.state = adoptWidget(rawGtk.cell_view_new())
  result.pixbuf = image
proc newCellView*(model: TreeModel, textColumn: int, pixbufColumn = -1): CellView =
  # Validate schema before allocating a native widget.
  if model.columnKind(textColumn) != cellString or
      (pixbufColumn != -1 and model.columnKind(pixbufColumn) != cellPixbuf):
    raise newException(ValueError, "cell view requires string and optional pixbuf columns")
  result.state = adoptWidget(rawGtk.cell_view_new())
  result.setModel(model, textColumn, pixbufColumn)
