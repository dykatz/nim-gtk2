# Included by gtk2.nim after drawing and copied model rows.
type
  RendererColumn* = object of ObjectHandle
    renderer: ObjectState
  CellAttribute* = tuple[property: string, column: int]
  CellDrawInfo* = object
    width*, height*: int
    flags*: uint32 ## Native GtkCellRendererState bits.
  CellDrawFunction* = proc (context: DrawContext, row: ModelRow, info: CellDrawInfo) {.closure.}
  CellDrawing = ref object
    width, height: g.gint
    ready: bool
    row: ModelRow
    draw: CellDrawFunction

const
  packedRendererKey = "nim-gtk2-packed-cell-renderer"
  cellDrawingKey = "nim-gtk2-cell-drawing"
var drawingCellType: g.GType

proc selected*(info: CellDrawInfo): bool = (info.flags and rawGtk.CELL_RENDERER_SELECTED.uint32) != 0
proc prelit*(info: CellDrawInfo): bool = (info.flags and rawGtk.CELL_RENDERER_PRELIT.uint32) != 0
proc insensitive*(info: CellDrawInfo): bool = (info.flags and rawGtk.CELL_RENDERER_INSENSITIVE.uint32) != 0

proc raw*(column: RendererColumn): rawGtk.PTreeViewColumn =
  cast[rawGtk.PTreeViewColumn](nativePointer(column))
proc rendererRaw*(column: RendererColumn): rawGtk.PCellRenderer =
  ## Borrowed pointer; do not change SDK draw renderer configuration or cell data callbacks.
  discard column.raw
  cast[rawGtk.PCellRenderer](nativePointer(ObjectHandle(state: column.renderer)))

proc packRenderer(title: string, p: rawGtk.PCellRenderer): RendererColumn =
  result.state = adoptObject(rawGtk.tree_view_column_new(), hasDestroySignal = false)
  result.renderer = adoptObject(p, borrowed = true)
  let column = result.raw
  rawGtk.column_set_title(column, checkedUtf8Text(title))
  rawGtk.column_pack_start(column, p, g.gbool(true))
  g.set_data(cast[g.PGObject](p), packedRendererKey, p)

proc appendRendererColumn*(view: TreeView, title: string, renderer: rawGtk.PCellRenderer,
                           attributes: openArray[CellAttribute] = []): RendererColumn {.discardable.} =
  ## Pack a live, otherwise unpacked native renderer. GTK sinks any floating reference.
  let v = view.raw
  discard checkedUtf8Text(title)
  if renderer == nil or not g.toBool(g.g_type_is_a(g.G_OBJECT_TYPE(renderer), rawGtk.cell_renderer_get_type())):
    raise newException(ValueError, "expected a live native cell renderer")
  if g.get_data(cast[g.PGObject](renderer), packedRendererKey) != nil:
    raise newException(ValueError, "renderer has already been packed by the SDK")
  let m = rawGtk.get_model(v)
  if m == nil: raise newException(ValueError, "renderer column requires a model")
  var specs: seq[g.PGParamSpec]
  for a in attributes:
    let name = checkedUtf8Text(a.property)
    if a.column < 0 or a.column >= rawGtk.get_n_columns(m).int:
      raise newException(ValueError, "renderer binding column is out of range")
    let spec = g.class_find_property(g.G_OBJECT_GET_CLASS(renderer), name)
    if spec == nil or (spec.flags and g.G_PARAM_WRITABLE) == 0 or
        (spec.flags and g.G_PARAM_CONSTRUCT_ONLY) != 0 or spec in specs:
      raise newException(ValueError, "renderer binding requires a distinct writable property")
    if spec.value_type != rawGtk.get_column_type(m, g.gint(a.column)):
      raise newException(ValueError, "renderer property and model column must have identical native types")
    specs.add(spec)
  result = packRenderer(title, renderer)
  let p = result.raw
  for i, a in attributes:
    rawGtk.column_add_attribute(p, renderer, specs[i].name, g.gint(a.column))
  discard g.g_object_ref(v)
  defer: g.g_object_unref(v)
  discard rawGtk.append_column(v, p)

proc cellDrawing(p: rawGtk.PCellRenderer): CellDrawing =
  cast[CellDrawing](g.get_data(cast[g.PGObject](p), cellDrawingKey))
proc releaseCellDrawing(data: pointer) {.cdecl.} = GC_unref(cast[CellDrawing](data))

proc measureCell(cell: rawGtk.PCellRenderer, widget: rawGtk.PWidget, area: rawGdk.PRectangle,
                 x, y, width, height: ptr g.gint) {.cdecl.} =
  let state = cellDrawing(cell)
  if x != nil: x[] = 0
  if y != nil: y[] = 0
  if width != nil: width[] = (if state == nil: 0.gint else: state.width)
  if height != nil: height[] = (if state == nil: 0.gint else: state.height)

proc prepareDrawCell(column: rawGtk.PTreeViewColumn, cell: rawGtk.PCellRenderer,
                     model: rawGtk.PTreeModel, iter: rawGtk.PTreeIter, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let state = cellDrawing(cell)
    if state == nil: return
    state.ready = false
    state.row = ModelRow()
    if modelFunctionDepth != 0: return
    try:
      state.row = copyModelRow(model, iter)
      state.ready = true
    except Exception as error: reportSignalError(error)

proc paintCell(cell: rawGtk.PCellRenderer, window: rawGdk.PDrawable, widget: rawGtk.PWidget,
               background, area, expose: rawGdk.PRectangle, flags: rawGtk.TCellRendererState) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let state = cellDrawing(cell)
    if state == nil or not state.ready or modelFunctionDepth != 0 or window == nil or
        area == nil or area.width <= 0 or area.height <= 0: return
    let scope = DrawScope()
    try:
      scope.p = rawGdk.cairo_create(window)
      if scope.p == nil: raise newException(IOError, "could not create a cell Cairo context")
      rawCairo.checkStatus(rawCairo.status(scope.p))
      if expose != nil:
        rawCairo.rectangle(scope.p, expose.x.float64, expose.y.float64, expose.width.float64, expose.height.float64)
        rawCairo.clip(scope.p)
      rawCairo.translate(scope.p, area.x.float64, area.y.float64)
      rawCairo.rectangle(scope.p, 0, 0, area.width.float64, area.height.float64)
      rawCairo.clip(scope.p)
      inc modelFunctionDepth
      try:
        state.draw(DrawContext(scope: scope), state.row,
          CellDrawInfo(width: area.width.int, height: area.height.int, flags: cast[uint32](flags)))
      finally: dec modelFunctionDepth
      rawCairo.checkStatus(rawCairo.status(scope.p))
    except Exception as error: reportSignalError(error)
    finally:
      let p = scope.p
      scope.p = nil
      if p != nil: rawCairo.destroy(p)

proc drawingClassInit(klass, data: pointer) {.cdecl.} =
  let p = cast[rawGtk.PCellRendererClass](klass)
  p.get_size = measureCell
  p.render = paintCell

proc ensureDrawingCellType(): g.GType =
  if drawingCellType == 0:
    let parent = rawGtk.cell_renderer_get_type()
    var query: g.TGTypeQuery
    g.g_type_query(parent, addr query)
    if query.class_size.int != sizeof(rawGtk.TCellRendererClass) or query.instance_size == 0 or
        query.instance_size > g.guint(high(uint16)):
      raise newException(ValueError, "unsupported GtkCellRenderer class ABI")
    var info = g.TGTypeInfo(class_size: uint16(query.class_size), instance_size: uint16(query.instance_size),
                           class_init: drawingClassInit)
    drawingCellType = g.g_type_register_static(parent, "NimGtk2DrawingCellRenderer", addr info, g.TGTypeFlags(0))
    if drawingCellType == 0: raise newException(ValueError, "could not register custom cell renderer")
  drawingCellType

proc appendDrawColumn*(view: TreeView, title: string, width, height: int,
                      draw: CellDrawFunction): RendererColumn {.discardable.} =
  ## Append a display-only renderer with a fixed requested size and synchronous drawing.
  let v = view.raw
  discard checkedUtf8Text(title)
  if width notin 1..32767 or height notin 1..32767:
    raise newException(ValueError, "drawing cell dimensions must be in 1..32767")
  if draw == nil: raise newException(ValueError, "drawing cell callback cannot be nil")
  if rawGtk.get_model(v) == nil: raise newException(ValueError, "drawing cell requires a model")
  let native = g.g_object_new(ensureDrawingCellType(), nil)
  if native == nil: raise newException(ValueError, "could not allocate drawing cell renderer")
  discard g.g_object_ref_sink(native)
  defer: g.g_object_unref(native)
  let p = cast[rawGtk.PCellRenderer](native)
  let state = CellDrawing(width: g.gint(width), height: g.gint(height), draw: draw)
  GC_ref(state)
  g.set_data_full(native, cellDrawingKey, cast[pointer](state), releaseCellDrawing)
  result = packRenderer(title, p)
  let column = result.raw
  rawGtk.column_set_cell_data_func(column, p, prepareDrawCell, nil, nil)
  discard g.g_object_ref(v)
  defer: g.g_object_unref(v)
  discard rawGtk.append_column(v, column)
