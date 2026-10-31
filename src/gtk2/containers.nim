# Included by gtk2.nim. Additional GTK2 layout containers; native fields stay private.
type
  Alignment* = object of Bin
  ButtonBox* = object of Box
  HButtonBox* = object of ButtonBox
  VButtonBox* = object of ButtonBox
  Table* = object of Container
  Fixed* = object of Container
  EventBox* = object of Bin
  ButtonBoxStyle* = enum
    buttonsDefault, buttonsSpread, buttonsEdge, buttonsStart, buttonsEnd, buttonsCenter
  AttachOption* = enum
    attachExpand, attachShrink, attachFill
  AttachOptions* = set[AttachOption]
  AlignmentValues* = tuple[xalign, yalign, xscale, yscale: float64]
  AlignmentPadding* = tuple[top, bottom, left, right: int]
  TableBounds* = tuple[left, right, top, bottom: int]

proc raw*(w: Alignment): rawGtk.PAlignment = cast[rawGtk.PAlignment](raw(Widget(w)))
proc raw*(w: ButtonBox): rawGtk.PButtonBox = cast[rawGtk.PButtonBox](raw(Widget(w)))
proc raw*(w: HButtonBox): rawGtk.PHButtonBox = cast[rawGtk.PHButtonBox](raw(Widget(w)))
proc raw*(w: VButtonBox): rawGtk.PVButtonBox = cast[rawGtk.PVButtonBox](raw(Widget(w)))
proc raw*(w: Table): rawGtk.PTable = cast[rawGtk.PTable](raw(Widget(w)))
proc raw*(w: Fixed): rawGtk.PFixed = cast[rawGtk.PFixed](raw(Widget(w)))
proc raw*(w: EventBox): rawGtk.PEventBox = cast[rawGtk.PEventBox](raw(Widget(w)))

proc checkMember(parent: Container, child: Widget) =
  let p = cast[rawGtk.PContainer](parent.raw)
  if rawGtk.get_parent(child.raw) != cast[rawGtk.PWidget](p):
    raise newException(ValueError, "widget is not a direct child of this container")
proc remove*(parent: Container, child: Widget) =
  ## Unparent a retained child without destroying it. Container-managed internal
  ## children are not public handles; raw bypasses remain the caller's responsibility.
  checkMember(parent, child)
  rawGtk.remove(cast[rawGtk.PContainer](parent.raw), child.raw)

proc alignmentFloat(w: Alignment, name: cstring): float64 =
  let p = w.raw
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_FLOAT)
  defer: g.unset(addr value)
  g.get_property(cast[g.PGObject](p), name, addr value)
  g.get_float(addr value).float64
proc newAlignment*(xalign = 0.5, yalign = 0.5, xscale = 0.0, yscale = 0.0): Alignment =
  let x = unitInterval(xalign)
  let y = unitInterval(yalign)
  let xs = unitInterval(xscale)
  let ys = unitInterval(yscale)
  result.state = adoptWidget(rawGtk.alignment_new(g.gfloat(x), g.gfloat(y), g.gfloat(xs), g.gfloat(ys)))
proc alignment*(w: Alignment): AlignmentValues =
  (alignmentFloat(w, "xalign"), alignmentFloat(w, "yalign"),
   alignmentFloat(w, "xscale"), alignmentFloat(w, "yscale"))
proc setAlignment*(w: Alignment, xalign, yalign, xscale, yscale: float64) =
  let x = unitInterval(xalign)
  let y = unitInterval(yalign)
  let xs = unitInterval(xscale)
  let ys = unitInterval(yscale)
  rawGtk.set(w.raw, g.gfloat(x), g.gfloat(y), g.gfloat(xs), g.gfloat(ys))
proc padding*(w: Alignment): AlignmentPadding =
  var top, bottom, left, right: g.guint
  rawGtk.get_padding(w.raw, addr top, addr bottom, addr left, addr right)
  (top.int, bottom.int, left.int, right.int)
proc setPadding*(w: Alignment, top = 0, bottom = 0, left = 0, right = 0) =
  let t = checkedInt(top)
  let b = checkedInt(bottom)
  let l = checkedInt(left)
  let r = checkedInt(right)
  if top > high(g.gint).int - bottom or left > high(g.gint).int - right:
    raise newException(ValueError, "combined padding must fit a nonnegative gint")
  rawGtk.set_padding(w.raw, g.guint(t), g.guint(b), g.guint(l), g.guint(r))

proc layoutStyle*(w: ButtonBox): ButtonBoxStyle = ButtonBoxStyle(rawGtk.get_layout(w.raw))
proc `layoutStyle=`*(w: ButtonBox, value: ButtonBoxStyle) = rawGtk.set_layout(w.raw, rawGtk.TButtonBoxStyle(ord(value)))
proc spacing*(w: ButtonBox): int = rawGtk.get_spacing(cast[rawGtk.PBox](w.raw)).int
proc `spacing=`*(w: ButtonBox, value: int) = rawGtk.set_spacing(cast[rawGtk.PBox](w.raw), checkedBoxSpacing(value))
proc newHButtonBox*(spacing = 6, style = buttonsEnd): HButtonBox =
  let s = checkedBoxSpacing(spacing)
  result.state = adoptWidget(rawGtk.hbutton_box_new())
  rawGtk.set_spacing(cast[rawGtk.PBox](result.raw), s)
  result.layoutStyle = style
proc newVButtonBox*(spacing = 6, style = buttonsEnd): VButtonBox =
  let s = checkedBoxSpacing(spacing)
  result.state = adoptWidget(rawGtk.vbutton_box_new())
  rawGtk.set_spacing(cast[rawGtk.PBox](result.raw), s)
  result.layoutStyle = style
proc secondary*(w: ButtonBox, child: Widget): bool =
  checkMember(w, child)
  g.toBool(rawGtk.get_child_secondary(w.raw, child.raw))
proc setSecondary*(w: ButtonBox, child: Widget, value = true) =
  checkMember(w, child)
  rawGtk.set_child_secondary(w.raw, child.raw, g.gbool(value))

proc tableSizeValue(value: int): g.guint =
  if value < 1 or value > 65535:
    raise newException(ValueError, "table dimensions must be 1..65535")
  g.guint(value)
proc tableU16(value: int): g.guint =
  if value < 0 or value > 65535:
    raise newException(ValueError, "table spacing/padding must be 0..65535")
  g.guint(value)
proc newTable*(rows, columns: int, homogeneous = false): Table =
  let r = tableSizeValue(rows)
  let c = tableSizeValue(columns)
  result.state = adoptWidget(rawGtk.table_new(r, c, g.gbool(homogeneous)))
proc dimensions*(w: Table): tuple[rows, columns: int] =
  var rows, columns: g.guint
  rawGtk.get_size(w.raw, addr rows, addr columns)
  (rows.int, columns.int)
proc rowCount*(w: Table): int = w.dimensions.rows
proc columnCount*(w: Table): int = w.dimensions.columns
proc homogeneous*(w: Table): bool = g.toBool(rawGtk.get_homogeneous(w.raw))
proc `homogeneous=`*(w: Table, value: bool) = rawGtk.set_homogeneous(w.raw, g.gbool(value))
proc childUInt(parent: Container, child: rawGtk.PWidget, name: cstring): int =
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_UINT)
  defer: g.unset(addr value)
  rawGtk.child_get_property(cast[rawGtk.PContainer](parent.raw), child, name, addr value)
  g.get_uint(addr value).int
proc tableBounds(w: Table, child: rawGtk.PWidget): TableBounds =
  (childUInt(w, child, "left-attach"), childUInt(w, child, "right-attach"),
   childUInt(w, child, "top-attach"), childUInt(w, child, "bottom-attach"))
proc cellBounds*(w: Table, child: Widget): TableBounds =
  checkMember(w, child)
  tableBounds(w, child.raw)
proc attachFlags(options: AttachOptions): rawGtk.TAttachOptions =
  for option in options: result = result or rawGtk.TAttachOptions(1 shl ord(option))
proc attach*(w: Table, child: Widget, left, right, top, bottom: int,
             xoptions: AttachOptions = {attachExpand, attachFill},
             yoptions: AttachOptions = {attachExpand, attachFill}, xpadding = 0, ypadding = 0) =
  checkChild(w, child)
  let size = w.dimensions
  if left < 0 or left >= right or right > size.columns or
      top < 0 or top >= bottom or bottom > size.rows:
    raise newException(ValueError, "table attachment must be a nonempty half-open rectangle within its dimensions")
  let x = tableU16(xpadding)
  let y = tableU16(ypadding)
  rawGtk.attach(w.raw, child.raw, g.guint(left), g.guint(right), g.guint(top), g.guint(bottom),
    attachFlags(xoptions), attachFlags(yoptions), x, y)
proc resize*(w: Table, rows, columns: int) =
  let r = tableSizeValue(rows)
  let c = tableSizeValue(columns)
  let children = rawGtk.get_children(cast[rawGtk.PContainer](w.raw))
  defer: g.free(children)
  var node = children
  while node != nil:
    let bounds = tableBounds(w, cast[rawGtk.PWidget](node.data))
    if bounds.right > columns or bounds.bottom > rows:
      raise newException(ValueError, "cannot shrink a table across existing child attachments")
    node = node.next
  rawGtk.resize(w.raw, r, c)
proc rowSpacing*(w: Table): int = rawGtk.get_default_row_spacing(w.raw).int
proc `rowSpacing=`*(w: Table, value: int) = rawGtk.set_row_spacings(w.raw, tableU16(value))
proc columnSpacing*(w: Table): int = rawGtk.get_default_col_spacing(w.raw).int
proc `columnSpacing=`*(w: Table, value: int) = rawGtk.set_col_spacings(w.raw, tableU16(value))
proc checkedTableIndex(index, count: int): g.guint =
  if index < 0 or index >= count: raise newException(ValueError, "table spacing index out of bounds")
  g.guint(index)
proc rowSpacing*(w: Table, row: int): int = rawGtk.get_row_spacing(w.raw, checkedTableIndex(row, w.rowCount)).int
proc columnSpacing*(w: Table, column: int): int = rawGtk.get_col_spacing(w.raw, checkedTableIndex(column, w.columnCount)).int
proc setRowSpacing*(w: Table, row, spacing: int) =
  let index = checkedTableIndex(row, w.rowCount)
  let value = tableU16(spacing)
  rawGtk.set_row_spacing(w.raw, index, value)
proc setColumnSpacing*(w: Table, column, spacing: int) =
  let index = checkedTableIndex(column, w.columnCount)
  let value = tableU16(spacing)
  rawGtk.set_col_spacing(w.raw, index, value)

proc signedCoordinate(value: int): g.gint =
  if value < low(g.gint).int or value > high(g.gint).int:
    raise newException(ValueError, "fixed coordinate must fit a signed gint")
  g.gint(value)
proc newFixed*(): Fixed = result.state = adoptWidget(rawGtk.fixed_new())
proc put*(w: Fixed, child: Widget, x, y: int) =
  checkChild(w, child)
  let a = signedCoordinate(x)
  let b = signedCoordinate(y)
  rawGtk.put(w.raw, child.raw, a, b)
proc move*(w: Fixed, child: Widget, x, y: int) =
  checkMember(w, child)
  let a = signedCoordinate(x)
  let b = signedCoordinate(y)
  rawGtk.move(w.raw, child.raw, a, b)
proc childInt(parent: Container, child: Widget, name: cstring): int =
  var value: g.TGValue
  discard g.init(addr value, g.G_TYPE_INT)
  defer: g.unset(addr value)
  rawGtk.child_get_property(cast[rawGtk.PContainer](parent.raw), child.raw, name, addr value)
  g.get_int(addr value).int
proc position*(w: Fixed, child: Widget): tuple[x, y: int] =
  checkMember(w, child)
  (childInt(w, child, "x"), childInt(w, child, "y"))

proc visibleWindow*(w: EventBox): bool = g.toBool(rawGtk.get_visible_window(w.raw))
proc `visibleWindow=`*(w: EventBox, value: bool) = rawGtk.set_visible_window(w.raw, g.gbool(value))
proc aboveChild*(w: EventBox): bool = g.toBool(rawGtk.get_above_child(w.raw))
proc `aboveChild=`*(w: EventBox, value: bool) = rawGtk.set_above_child(w.raw, g.gbool(value))
proc newEventBox*(visibleWindow = true, aboveChild = false): EventBox =
  result.state = adoptWidget(rawGtk.event_box_new())
  result.visibleWindow = visibleWindow
  result.aboveChild = aboveChild
