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
  proc drag(a, b: Point, afterBegin: proc () = nil) =
    moveTo(a)
    button(true)
    defer:
      button(false)
      # X11 may animate a rejected drag back to its source before drag-end.
      for _ in 0..<5: settle()
    moveTo((a.x + 20, a.y))
    if afterBegin != nil: afterBegin()
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
  proc countAccepted(w: n.PWidget, context: gd.PDragContext, data: pointer) {.cdecl.} =
    if g.toBool(gd.drag_drop_succeeded(context)): inc cast[ptr int](data)[]
  proc countDataRequest(w: n.PWidget, context: gd.PDragContext, selection: n.PSelectionData,
                        info, time: g.guint, data: pointer) {.cdecl.} =
    inc cast[ptr int](data)[]
  suite "native GTK model drag-and-drop":
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
    test "local TreeView/IconView COPY commits application-defined placement exactly once":
      let host = newWindow("Cross-view model drag", 600, 180)
      defer: host.destroy()
      let box = newHBox(spacing = 12)
      host.add(box)
      let tree = newTreeStore([cellString, cellInt])
      let root = tree.appendRow([cell("Product"), cell(42)])
      let list = newListStore([cellString, cellPixbuf])
      let image = newPixbuf(24, 24, 0x842012ff'u32)
      discard list.appendRow([cell("Existing"), cell(image)])
      let a = newTreeView(tree)
      discard a.appendTextColumn("Tree", 0)
      let b = newIconView(list, 1, 0)
      box.packStart(a)
      box.packStart(b)
      var calls, inserted, accepted, dataRequests, deletions = 0
      let sourceWidget = cast[n.PWidget](a.raw)
      let acceptedId = g.g_signal_connect_data(sourceWidget, "drag-end", cast[g.TGCallback](countAccepted), addr accepted, nil, g.TGConnectFlags(0))
      let requestId = g.g_signal_connect_data(sourceWidget, "drag-data-get", cast[g.TGCallback](countDataRequest), addr dataRequests, nil, g.TGConnectFlags(0))
      let deleteId = g.g_signal_connect_data(sourceWidget, "drag-data-delete", cast[g.TGCallback](countEnd), addr deletions, nil, g.TGConnectFlags(0))
      defer:
        for id in [acceptedId, requestId, deleteId]: g.g_signal_handler_disconnect(sourceWidget, id)
      var observed: ModelRowDrop
      a.configureModelRowDrag(receive = proc (value: ModelRowDrop): bool =
        if value.hit.isRoot: return false
        discard tree.insertRow(0, [cell(value.row.values[0].stringValue), cell(7)], value.hit)
        true)
      b.configureModelRowDrag(receive = proc (value: ModelRowDrop): bool =
        inc calls
        observed = value
        case calls
        of 1: return false
        of 2: raise newException(ValueError, "expected test rejection")
        else:
          list.insertRow(value.hit.indices[0], [cell(value.row.values[0].stringValue), cell(image)])
          inc inserted
          true)
      host.showAll()
      settle()
      expect ValueError: a.configureModelRowDrag()
      let start = a.point([0])
      let dest = b.point(0)
      drag((start.x, start.y + 80), dest)
      check calls == 0
      let acceptedBeforeMatched = accepted # Ignore a native outcome for an unmatched drag.
      drag(start, dest)
      check calls == 1 and list.rowCount == 1 and tree.hasRow(root)
      drag(start, dest)
      check calls == 2 and list.rowCount == 1 and tree.hasRow(root)
      drag(start, dest, proc () = tree.setValue(root, 1, cell(43)))
      check calls == 3
      check inserted == 1
      check observed.row.values[0].stringValue == "Product"
      check accepted - acceptedBeforeMatched == 1
      check dataRequests == 0
      check deletions == 0
      check observed.row.path == root and observed.row.values[1].intValue == 42
      check observed.hit.indices == @[0]
      check list.rowCount == 2 and list.value(0, 0).stringValue == "Product"
      check tree.childCount == 1 and tree.value(root, 1).intValue == 43
      drag(b.point(0), a.point([0]))
      require tree.childCount(root) == 1
      check tree.value(treePath(0, 0), 0).stringValue == "Product"
      check list.rowCount == 2
    test "committing receiver may destroy its own view without a second completion":
      let host = newWindow("Destroy local receiver", 600, 180)
      defer: host.destroy()
      let box = newHBox(spacing = 12)
      host.add(box)
      let src = newListStore([cellString])
      discard src.appendRow([cell("Source")])
      let dst = newListStore([cellString])
      discard dst.appendRow([cell("Destination")])
      let a = newTreeView(src)
      let b = newTreeView(dst)
      for view in [a, b]:
        discard view.appendTextColumn("Row", 0)
        box.packStart(view)
      a.configureModelRowDrag()
      var calls = 0
      b.configureModelRowDrag(source = false, receive = proc (value: ModelRowDrop): bool =
        inc calls
        discard dst.appendRow(value.row.values)
        b.destroy()
        true)
      host.showAll()
      settle()
      drag(a.point([0]), b.point([0]))
      check b.isDestroyed and calls == 1 and dst.rowCount == 2 and src.rowCount == 1
    test "MOVE deletes only the stable unchanged leaf after a committed drop":
      let host = newWindow("Local row MOVE", 650, 190)
      defer: host.destroy()
      let box = newHBox(spacing = 12)
      host.add(box)
      let m = newTreeStore([cellString])
      discard m.appendRow([cell("Original")])
      discard m.appendRow([cell("Parent")])
      discard m.appendRow([cell("Child")], treePath(1))
      let dst = newListStore([cellString])
      discard dst.appendRow([cell("Target")])
      let a = newTreeView(m)
      let b = newTreeView(dst)
      let shared = newTreeView(m)
      for view in [a, b, shared]:
        discard view.appendTextColumn("Row", 0)
        box.packStart(view)
      var calls, wrong, deletes: int
      var mode = 0
      var order: seq[string]
      var original = newTreeRowReference(m, treePath(0))
      a.configureModelRowDrag(action = rowDragMove)
      shared.configureModelRowDrag(source = false, action = rowDragMove,
        receive = proc (value: ModelRowDrop): bool = (inc wrong; false))
      b.configureModelRowDrag(source = false, action = rowDragMove,
        receive = proc (value: ModelRowDrop): bool =
          inc calls
          check value.action == rowDragMove and value.row.values[0].stringValue == "Original"
          check original.valid
          if mode == 0: return false
          if mode == 1: raise newException(ValueError, "expected MOVE rejection")
          discard dst.appendRow(value.row.values)
          order.add("commit")
          if mode == 2: m.setValue(original.path, 0, cell("Edited"))
          if mode == 4: a.destroy()
          true)
      let conn = m.onPathDeleted(proc (path: TreePath) = order.add("delete " & $path))
      defer: conn.disconnect()
      let source = cast[n.PWidget](a.raw)
      let handler = g.g_signal_connect_data(source, "drag-data-delete", cast[g.TGCallback](countEnd), addr deletes, nil, g.TGConnectFlags(0))
      defer:
        if g.g_signal_handler_is_connected(source, handler): g.g_signal_handler_disconnect(source, handler)
      host.showAll()
      settle()
      let target = b.point([0])
      drag(a.point([0]), shared.point([0]))
      drag(a.point([1]), target) # Nonleaf is not transferable.
      drag(a.point([0]), target, proc () = m.setValue(original.path, 0, cell("Changed during drag")))
      check wrong == 0 and calls == 0 and deletes == 0
      m.setValue(original.path, 0, cell("Original"))
      for phase in 0..3:
        mode = phase
        if phase == 3: m.setValue(original.path, 0, cell("Original"))
        drag(a.point(original.path.indices), target, proc () =
          if phase == 3: discard m.insertRow(0, [cell("Neighbor")]))
        check calls == phase+1
        if phase < 3: check original.valid and deletes == 0
      check deletes == 1 and not original.valid
      check order == @["commit", "commit", "delete 1"]
      check m.childCount == 2 and m.value(treePath(0), 0).stringValue == "Neighbor"
      check m.value(treePath(1, 0), 0).stringValue == "Child"
      check dst.rowCount == 3
      mode = 4
      discard m.insertRow(0, [cell("Original")])
      original = newTreeRowReference(m, treePath(0))
      settle()
      drag(a.point([0]), target)
      check a.isDestroyed and original.valid and dst.rowCount == 4 and deletes == 1
  discard x.XCloseDisplay(d)
else:
  quit("Model drag tests require X11/XTEST", 1)
