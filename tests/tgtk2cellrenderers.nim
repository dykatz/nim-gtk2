import std/unittest
import gtk2
import headers/gtk2 as n
import headers/glib2 as g

type
  CaptureObj = object
    released: ptr int
  Capture = ref CaptureObj
proc `=destroy`(capture: var CaptureObj) = inc capture.released[]
proc capturedColumn(view: TreeView, released: ptr int): RendererColumn =
  let capture = Capture(released: released)
  view.appendDrawColumn("Lifetime", 4, 4, proc (c: DrawContext, row: ModelRow, info: CellDrawInfo) =
    discard capture.released)

gtk2.init()
suite "unrealized renderer columns":
  test "native property bindings validate before packing and preserve renderer identity":
    let m = newListStore([cellString, cellInt])
    discard m.appendRow([cell("Phase"), cell(42)])
    let v = newTreeView(m)
    let render = n.cell_renderer_progress_new()
    discard g.g_object_ref_sink(render)
    defer: g.g_object_unref(render)
    expect ValueError: discard v.appendRendererColumn("nil", nil)
    expect ValueError: discard v.appendRendererColumn("bad", render, [("missing", 0)])
    expect ValueError: discard v.appendRendererColumn("bad", render, [("value", 0)])
    expect ValueError: discard v.appendRendererColumn("bad", render, [("value", 2)])
    expect ValueError: discard v.appendRendererColumn("bad", render, [("value", 1), ("value", 1)])
    let column = v.appendRendererColumn("Progress", render, [("text", 0), ("value", 1)])
    check column.rendererRaw == render
    expect ValueError: discard v.appendRendererColumn("again", render)
    var it: n.TTreeIter
    require g.toBool(n.get_iter_first(m.raw, addr it))
    n.column_cell_set_cell_data(column.raw, m.raw, addr it, g.gbool(false), g.gbool(false))
    var value: g.TGValue
    discard g.init(addr value, g.G_TYPE_INT)
    defer: g.unset(addr value)
    g.get_property(cast[g.PGObject](render), "value", addr value)
    check g.get_int(addr value) == 42
    check not g.toBool(n.get_realized(cast[n.PWidget](v.raw)))
  test "custom type measures without realizing or calling the painter":
    let m = newListStore([cellString])
    let view = newTreeView(m)
    var calls = 0
    let draw: CellDrawFunction = proc (c: DrawContext, row: ModelRow, info: CellDrawInfo) = inc calls
    expect ValueError: discard view.appendDrawColumn("bad", 0, 12, draw)
    expect ValueError: discard view.appendDrawColumn("bad", 12, high(int), draw)
    expect ValueError: discard view.appendDrawColumn("bad", 12, 12, nil)
    let col = view.appendDrawColumn("Custom", 57, 18, draw)
    let other = view.appendDrawColumn("Other", 17, 12, draw)
    var x, y, w, h: g.gint
    n.get_size(col.rendererRaw, cast[n.PWidget](view.raw), nil, addr x, addr y, addr w, addr h)
    check (x, y, w, h) == (0.gint, 0.gint, 57.gint, 18.gint)
    n.get_size(other.rendererRaw, cast[n.PWidget](view.raw), nil, nil, nil, nil, addr h)
    check h == 12 and calls == 0
    let sorted = newTreeModelSort(m, 0)
    discard m.appendRow([cell("B")])
    discard m.appendRow([cell("A")])
    var rejected = 0
    discard sorted.setCompare(proc (a, b: ModelRow): int =
      try: discard view.appendDrawColumn("no", 10, 10, draw)
      except ValueError: inc rejected
      cmp(a.values[0].stringValue, b.values[0].stringValue))
    check rejected > 0 and calls == 0
    view.destroy()
    expect ValueError: discard view.appendDrawColumn("destroyed", 1, 1, draw)
  test "a retained column pins its renderer and releases callback captures on last release":
    var released = 0
    let view = newTreeView(newListStore([cellString]))
    var col = capturedColumn(view, addr released)
    view.destroy()
    check col.rendererRaw != nil and released == 0
    col = RendererColumn()
    check released == 1
