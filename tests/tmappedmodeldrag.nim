# Genuine GTK model DnD using XTEST on an isolated X11 display.
import std/[os, unittest]
import gtk2
import headers/gtk2 as n
import headers/gdk2 as gd
import headers/glib2 as g

if getEnv("GTK2_TEST_VIRTUAL_DISPLAY") != "1" or getEnv("DISPLAY").len == 0:
  quit("Model drag tests require isolated DISPLAY and GTK2_TEST_VIRTUAL_DISPLAY=1", 1)
when defined(posix) and not defined(macosx):
  import headers/xlib as x
  const xtest = "libXtst.so(.6|)"
  proc XTestQueryExtension(d: x.PDisplay, event, error, major, minor: ptr cint): cint {.cdecl, dynlib: xtest, importc.}
  proc XTestFakeMotionEvent(d: x.PDisplay, screen, x, y: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc XTestFakeButtonEvent(d: x.PDisplay, button: cuint, press: cint, delay: culong): cint {.cdecl, dynlib: xtest, importc.}
  proc settle() =
    for _ in 0..<15:
      for _ in 0..<256:
        if n.events_pending() == 0: break
        discard n.main_iteration_do(g.gbool(false))
      sleep(8)
  gtk2.init()
  let d = x.XOpenDisplay(nil)
  doAssert d != nil
  var event, error, major, minor: cint
  doAssert XTestQueryExtension(d, addr event, addr error, addr major, addr minor) != 0
  type Point = tuple[x, y: cint]
  proc moveTo(p: Point) =
    doAssert XTestFakeMotionEvent(d, -1, p.x, p.y, 0) != 0
    discard x.XSync(d, 0)
    settle()
  proc button(down: bool) =
    doAssert XTestFakeButtonEvent(d, 1, cint(down), 0) != 0
    discard x.XSync(d, 0)
    settle()
  proc drag(a, b: Point) =
    moveTo(a)
    button(true)
    defer:
      button(false)
      # X11 may animate a rejected drag back to its source before drag-end.
      for _ in 0..<5: settle()
    moveTo((a.x + 20, a.y))
    moveTo(b)
    moveTo((b.x + 1, b.y))
  proc origin(w: gd.PWindow): Point =
    discard gd.get_origin(w, addr result.x, addr result.y)
  proc matches(p: n.PTreePath, indices: openArray[int]): bool =
    if p == nil: return false
    defer: n.free(p)
    if n.get_depth(p).int != indices.len: return false
    let raw = cast[ptr UncheckedArray[g.gint]](n.get_indices(p))
    for i, v in indices:
      if raw[i].int != v: return false
    true
  proc point(v: TreeView, path: openArray[int], bottom = false): Point =
    let o = origin(n.get_bin_window(v.raw))
    var ys: seq[cint]
    for y in 0.cint..<170.cint:
      var p: n.PTreePath
      discard n.get_path_at_pos(v.raw, 85, y, addr p, nil, nil, nil)
      if matches(p, path): ys.add(y)
    doAssert ys.len > 3
    (o.x + 85, o.y + (if bottom: ys[^2] else: ys[ys.len div 2]))
  proc point(v: gtk2.IconView, index: int): Point =
    let o = origin(n.get_window(cast[n.PWidget](v.raw)))
    for y in countup(5, 120, 2):
      for x in countup(5, 290, 2):
        if matches(n.icon_view_get_path_at_pos(v.raw, x.cint, y.cint), [index]):
          return (o.x + x.cint, o.y + y.cint)
    raise newException(ValueError, "icon not found")
  proc countEnd(w: n.PWidget, context: gd.PDragContext, data: pointer) {.cdecl.} =
    inc cast[ptr int](data)[]
  template watchEnd(view, count: untyped) =
    let wp = cast[n.PWidget](view.raw)
    let handler = g.g_signal_connect_data(wp, "drag-end", cast[g.TGCallback](countEnd), addr count, nil, g.TGConnectFlags(0))
    defer: g.g_signal_handler_disconnect(wp, handler)
  suite "native GTK same-widget row MOVE":
    test "ListStore insert/delete and reference invalidation; sibling view rejects":
      let host = newWindow("Model drag lists", 520, 180)
      defer: host.destroy()
      let models = newHBox(spacing = 12)
      host.add(models)
      let m = newListStore([cellString, cellInt])
      for i, s in ["Alpha", "Beta", "Gamma"]: discard m.appendRow([cell(s), cell(i)])
      let a = newTreeView(m)
      let b = newTreeView(m)
      for v in [a, b]:
        discard v.appendTextColumn("Row", 0)
        v.enableRowDragReorder()
        models.packStart(v)
      var ended = 0
      watchEnd(a, ended)
      let source = newTreeRowReference(m, treePath(0))
      let untouched = newTreeRowReference(m, treePath(1))
      var inserted, deleted: seq[seq[int]]
      let ins = m.onPathInserted(proc (p: TreePath) = inserted.add(p.indices))
      let del = m.onPathDeleted(proc (p: TreePath) = deleted.add(p.indices))
      defer:
        ins.disconnect()
        del.disconnect()
      host.showAll()
      settle()
      expect ValueError: a.enableRowDragReorder()
      drag(a.point([0]), b.point([2], bottom = true))
      check ended == 1
      check inserted.len == 0 and deleted.len == 0 and source.valid
      drag(a.point([0]), a.point([2], bottom = true))
      check ended == 2
      check m.rowCount == 3
      check [m.value(0, 0).stringValue, m.value(1, 0).stringValue, m.value(2, 0).stringValue] == ["Beta", "Gamma", "Alpha"]
      check m.value(2, 1).intValue == 0
      check inserted == @[@[3]] and deleted == @[@[0]]
      check not source.valid and untouched.path.indices == @[0]
    test "TreeStore moves a subtree into another parent":
      let host = newWindow("Model drag tree", 300, 180)
      defer: host.destroy()
      let m = newTreeStore([cellString])
      let source = m.appendRow([cell("Source")])
      discard m.appendRow([cell("Child")], source)
      let dest = m.appendRow([cell("Parent")])
      discard m.appendRow([cell("Existing")], dest)
      let v = newTreeView(m)
      discard v.appendTextColumn("Tree", 0)
      v.enableRowDragReorder()
      host.add(v)
      host.showAll()
      v.expandAll()
      settle()
      drag(v.point([0]), v.point([0, 0]))
      require m.childCount == 2 and m.childCount(treePath(0)) == 1
      check m.value(treePath(0, 0), 0).stringValue == "Child"
      drag(v.point([0]), v.point([1]))
      require m.childCount == 1 and m.childCount(treePath(0)) == 2
      check m.value(treePath(0), 0).stringValue == "Parent"
      let moved = if m.value(treePath(0, 0), 0).stringValue == "Source": 0 else: 1
      check m.value(treePath(0, moved), 0).stringValue == "Source"
      check m.value(treePath(0, moved, 0), 0).stringValue == "Child"
    test "IconView moves one item with its image cell":
      let host = newWindow("Model drag icons", 300, 180)
      defer: host.destroy()
      let m = newListStore([cellString, cellPixbuf])
      let a = newPixbuf(24, 24, 0xff0000ff'u32)
      let b = newPixbuf(24, 24, 0x00ff00ff'u32)
      discard m.appendRow([cell("Alpha"), cell(a)])
      discard m.appendRow([cell("Beta"), cell(b)])
      let v = newIconView(m, 1, 0)
      v.columns = 2
      v.enableRowDragReorder()
      host.add(v)
      host.showAll()
      settle()
      let fromPoint = v.point(1)
      let toPoint = v.point(0)
      drag(fromPoint, toPoint)
      require m.rowCount == 2
      check m.value(0, 0).stringValue == "Beta"
      check m.value(0, 1).pixbufValue.raw == b.raw
  discard x.XCloseDisplay(d)
else:
  quit("Model drag tests require X11/XTEST", 1)
