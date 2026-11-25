import std/unittest
import gtk2
import headers/gtk2 as n
import headers/gdk2 as gd
import headers/glib2 as g

gtk2.init()
suite "unrealized native model drag configuration":
  test "direct models opt in without realizing, changing rows or modifying sibling views":
    let m = newListStore([cellString, cellPixbuf])
    discard m.appendRow([cell("row"), cell(newPixbuf(12, 12))])
    let v = newTreeView(m)
    let sibling = newTreeView(m)
    let icons = newIconView(m, 1, 0)
    check not v.rowDragReorderEnabled and not icons.rowDragReorderEnabled
    v.enableRowDragReorder()
    v.enableRowDragReorder()
    icons.enableRowDragReorder()
    check v.rowDragReorderEnabled and icons.rowDragReorderEnabled
    check not sibling.rowDragReorderEnabled
    for w in [gtk2.Widget(v), gtk2.Widget(icons)]:
      check not g.toBool(n.get_realized(w.raw))
      check n.drag_source_get_target_list(w.raw) != nil
      check n.drag_dest_get_target_list(w.raw) != nil
    check m.rowCount == 1 and m.value(0, 0).stringValue == "row"
    let tree = newTreeStore([cellString])
    let hierarchy = newTreeView(tree)
    hierarchy.enableRowDragReorder()
    check hierarchy.rowDragReorderEnabled
    v.destroy()
    expect ValueError: discard v.rowDragReorderEnabled()
    expect ValueError: v.enableRowDragReorder()
  test "proxies, sorted models, pure functions and foreign sites reject":
    let m = newListStore([cellString, cellBool])
    discard m.appendRow([cell("first"), cell(true)])
    discard m.appendRow([cell("second"), cell(true)])
    let view = newTreeView(m)
    let sorted = newTreeModelSort(m, 0)
    let filtered = newTreeModelFilter(m, 1)
    expect ValueError: newTreeView(sorted).enableRowDragReorder()
    expect ValueError: newTreeView(filtered).enableRowDragReorder()
    var guarded = 0
    let compare: ModelCompare = proc (a, b: ModelRow): int =
      try: view.enableRowDragReorder()
      except ValueError: inc guarded
      try: discard view.rowDragReorderEnabled
      except ValueError: inc guarded
      cmp(a.values[0].stringValue, b.values[0].stringValue)
    discard sorted.setCompare(compare)
    check guarded >= 2
    let sortable = cast[n.PTreeSortable](m.raw)
    n.set_sort_column_id(sortable, 0, n.SORT_ASCENDING)
    expect ValueError: view.enableRowDragReorder()
    n.set_sort_column_id(sortable, -2, n.SORT_ASCENDING)
    var target = n.TTargetEntry(target: "application/x-test-row")
    let p = cast[n.PWidget](view.raw)
    n.drag_dest_set(p, n.TDestDefaults(0), addr target, 1, gd.ACTION_COPY)
    let before = n.drag_dest_get_target_list(p)
    expect ValueError: view.enableRowDragReorder()
    check n.drag_dest_get_target_list(p) == before
    check not view.rowDragReorderEnabled
    let foreign = newTreeView(m)
    n.set_reorderable(foreign.raw, g.gbool(true))
    expect ValueError: foreign.enableRowDragReorder()
    check foreign.rowDragReorderEnabled
  test "local COPY roles are explicit, exclusive and unrealized":
    let m = newListStore([cellString, cellBool])
    let view = newTreeView(m)
    expect ValueError: view.configureModelRowDrag(source = false)
    let projected = newTreeModelFilter(m, 1)
    let destination = newTreeView(projected)
    expect ValueError: destination.configureModelRowDrag()
    var calls = 0
    destination.configureModelRowDrag(source = false, receive = proc (v: ModelRowDrop): bool =
      inc calls
      false)
    view.configureModelRowDrag()
    let src = cast[n.PWidget](view.raw)
    let dst = cast[n.PWidget](destination.raw)
    check n.drag_source_get_target_list(src) != nil and n.drag_dest_get_target_list(src) == nil
    check n.drag_source_get_target_list(dst) == nil and n.drag_dest_get_target_list(dst) != nil
    check not g.toBool(n.get_realized(src)) and not g.toBool(n.get_realized(dst))
    check not view.rowDragReorderEnabled
    expect ValueError: view.configureModelRowDrag()
    expect ValueError: view.enableRowDragReorder()
    let native = newTreeView(m)
    native.enableRowDragReorder()
    expect ValueError: native.configureModelRowDrag()
    destination.destroy()
    check calls == 0
