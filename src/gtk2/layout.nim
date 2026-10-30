# Included by gtk2.nim; all handles share its ownership/signal machinery.
type
  ScrolledWindow* = object of Bin
  Viewport* = object of Bin
  Notebook* = object of Container
  Paned* = object of Container
  HPaned* = object of Paned
  VPaned* = object of Paned
  ScrollPolicy* = enum
    scrollAlways, scrollAutomatic, scrollNever
  ShadowStyle* = enum
    shadowNone, shadowIn, shadowOut, shadowEtchedIn, shadowEtchedOut
  TabPosition* = enum
    tabLeft, tabRight, tabTop, tabBottom
  PageCallback = ref object
    fn: proc (index: int) {.closure.}

proc raw*(w: ScrolledWindow): rawGtk.PScrolledWindow =
  cast[rawGtk.PScrolledWindow](raw(Widget(w)))
proc raw*(w: Viewport): rawGtk.PViewport = cast[rawGtk.PViewport](raw(Widget(w)))
proc raw*(w: Notebook): rawGtk.PNotebook = cast[rawGtk.PNotebook](raw(Widget(w)))
proc raw*(w: Paned): rawGtk.PPaned = cast[rawGtk.PPaned](raw(Widget(w)))
proc raw*(w: HPaned): rawGtk.PHPaned = cast[rawGtk.PHPaned](raw(Widget(w)))
proc raw*(w: VPaned): rawGtk.PVPaned = cast[rawGtk.PVPaned](raw(Widget(w)))

proc visible*(w: Widget): bool = g.toBool(rawGtk.get_visible(w.raw))

proc newScrolledWindow*(horizontal = scrollAutomatic,
                        vertical = scrollAutomatic): ScrolledWindow =
  result.state = adoptWidget(rawGtk.scrolled_window_new(nil, nil))
  rawGtk.set_policy(result.raw, rawGtk.TPolicyType(horizontal), rawGtk.TPolicyType(vertical))

proc policies*(w: ScrolledWindow): tuple[horizontal, vertical: ScrollPolicy] =
  var x, y: rawGtk.TPolicyType
  rawGtk.get_policy(w.raw, addr x, addr y)
  (ScrollPolicy(x), ScrollPolicy(y))

proc setPolicies*(w: ScrolledWindow, horizontal, vertical: ScrollPolicy) =
  rawGtk.set_policy(w.raw, rawGtk.TPolicyType(horizontal), rawGtk.TPolicyType(vertical))
proc shadow*(w: ScrolledWindow): ShadowStyle = ShadowStyle(rawGtk.get_shadow_type(w.raw))
proc `shadow=`*(w: ScrolledWindow, value: ShadowStyle) =
  rawGtk.set_shadow_type(w.raw, rawGtk.TShadowType(value))

proc newViewport*(): Viewport =
  result.state = adoptWidget(rawGtk.viewport_new(nil, nil))
proc shadow*(w: Viewport): ShadowStyle = ShadowStyle(rawGtk.get_shadow_type(w.raw))
proc `shadow=`*(w: Viewport, value: ShadowStyle) =
  rawGtk.set_shadow_type(w.raw, rawGtk.TShadowType(value))

proc newHPaned*(): HPaned =
  result.state = adoptWidget(rawGtk.hpaned_new())
proc newVPaned*(): VPaned =
  result.state = adoptWidget(rawGtk.vpaned_new())
proc hasFirstChild*(w: Paned): bool = rawGtk.get_child1(w.raw) != nil
proc hasSecondChild*(w: Paned): bool = rawGtk.get_child2(w.raw) != nil

proc packFirst*(w: Paned, child: Widget, resize = false, shrink = true) =
  ## Left in HPaned, top in VPaned. A slot must be empty.
  checkChild(w, child)
  if w.hasFirstChild: raise newException(ValueError, "first pane already has a child")
  rawGtk.pack1(w.raw, child.raw, g.gbool(resize), g.gbool(shrink))
proc packSecond*(w: Paned, child: Widget, resize = true, shrink = true) =
  ## Right in HPaned, bottom in VPaned.
  checkChild(w, child)
  if w.hasSecondChild: raise newException(ValueError, "second pane already has a child")
  rawGtk.pack2(w.raw, child.raw, g.gbool(resize), g.gbool(shrink))

proc removeFirst*(w: Paned) =
  ## Unparents, rather than destroys, a child retained by a Nim handle.
  let p = rawGtk.get_child1(w.raw)
  if p == nil: raise newException(ValueError, "first pane is empty")
  rawGtk.remove(cast[rawGtk.PContainer](w.raw), p)
proc removeSecond*(w: Paned) =
  let p = rawGtk.get_child2(w.raw)
  if p == nil: raise newException(ValueError, "second pane is empty")
  rawGtk.remove(cast[rawGtk.PContainer](w.raw), p)

proc position*(w: Paned): int = rawGtk.get_position(w.raw).int
proc `position=`*(w: Paned, value: int) =
  ## -1 restores GTK's automatic divider positioning.
  let p = if value == -1: g.gint(-1) else: checkedInt(value)
  rawGtk.set_position(w.raw, p)

proc newNotebook*(): Notebook =
  result.state = adoptWidget(rawGtk.notebook_new())
proc pageCount*(w: Notebook): int = rawGtk.get_n_pages(w.raw).int
proc currentPage*(w: Notebook): int = rawGtk.get_current_page(w.raw).int

proc checkedPage(w: Notebook, index: int): g.gint =
  if index < 0 or index >= w.pageCount:
    raise newException(ValueError, "notebook page index is out of range")
  checkedInt(index)

proc pageIndex*(w: Notebook, child: Widget): int =
  ## -1 if the live widget is not a content page in this notebook.
  rawGtk.page_num(w.raw, child.raw).int

proc requirePage(w: Notebook, child: Widget): rawGtk.PWidget =
  if w.pageIndex(child) < 0:
    raise newException(ValueError, "widget is not a page in this notebook")
  child.raw

proc `currentPage=`*(w: Notebook, index: int) =
  let n = checkedPage(w, index)
  if not g.toBool(rawGtk.get_visible(rawGtk.get_nth_page(w.raw, n))):
    raise newException(ValueError, "show a hidden page before selecting it")
  rawGtk.set_current_page(w.raw, n)

proc insertPage*(w: Notebook, index: int, child: Widget,
                 tabText: string): int {.discardable.} =
  checkChild(w, child)
  if index < 0 or index > w.pageCount:
    raise newException(ValueError, "notebook insertion index is out of range")
  let n = checkedInt(index)
  let label = newLabel(tabText) # Validate strings and own the temporary label.
  # GTK2 refuses to select hidden pages. Show only the content root, not its
  # descendants or the notebook/toplevel, so selection works before run().
  child.show()
  rawGtk.insert_page(w.raw, child.raw, label.raw, n).int

proc appendPage*(w: Notebook, child: Widget, tabText: string): int {.discardable.} =
  w.insertPage(w.pageCount, child, tabText)

proc removePage*(w: Notebook, index: int) =
  ## Retained content handles remain live and may be reparented.
  rawGtk.remove_page(w.raw, checkedPage(w, index))
proc reorderPage*(w: Notebook, child: Widget, index: int) =
  let p = requirePage(w, child)
  let n = checkedPage(w, index)
  rawGtk.reorder_child(w.raw, p, n)
proc tabText*(w: Notebook, child: Widget): string =
  $rawGtk.get_tab_label_text(w.raw, requirePage(w, child))
proc setTabText*(w: Notebook, child: Widget, text: string) =
  let p = requirePage(w, child)
  rawGtk.set_tab_label_text(w.raw, p, checkedString(text))
proc tabReorderable*(w: Notebook, child: Widget): bool =
  g.toBool(rawGtk.get_tab_reorderable(w.raw, requirePage(w, child)))
proc setTabReorderable*(w: Notebook, child: Widget, enabled: bool) =
  let p = requirePage(w, child)
  rawGtk.set_tab_reorderable(w.raw, p, g.gbool(enabled))

proc showTabs*(w: Notebook): bool = g.toBool(rawGtk.get_show_tabs(w.raw))
proc `showTabs=`*(w: Notebook, value: bool) = rawGtk.set_show_tabs(w.raw, g.gbool(value))
proc showBorder*(w: Notebook): bool = g.toBool(rawGtk.get_show_border(w.raw))
proc `showBorder=`*(w: Notebook, value: bool) = rawGtk.set_show_border(w.raw, g.gbool(value))
proc scrollable*(w: Notebook): bool = g.toBool(rawGtk.get_scrollable(w.raw))
proc `scrollable=`*(w: Notebook, value: bool) = rawGtk.set_scrollable(w.raw, g.gbool(value))
proc tabPosition*(w: Notebook): TabPosition = TabPosition(rawGtk.get_tab_pos(w.raw))
proc `tabPosition=`*(w: Notebook, value: TabPosition) =
  rawGtk.set_tab_pos(w.raw, rawGtk.TPositionType(value))

proc releasePageCallback(data: pointer, closure: g.PGClosure) {.cdecl.} =
  GC_unref(cast[PageCallback](data))

proc switchPageThunk(instance: rawGtk.PNotebook, page: rawGtk.PNotebookPage,
                     index: g.guint, data: pointer) {.cdecl, gcsafe.} =
  # GTK2 passes an opaque GtkNotebookPage*, NOT a GtkWidget*. Do not wrap it.
  {.cast(gcsafe).}:
    let fn = cast[PageCallback](data).fn
    try:
      fn(index.int) # Copy the closure first: it may disconnect itself.
    except Exception as error:
      reportSignalError(error)

proc onSwitchPage*(w: Notebook,
                   fn: proc (index: int) {.closure.}): Connection {.discardable.} =
  ## After GTK's default switch handler; the argument is a zero-based index.
  let p = w.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let callback = PageCallback(fn: fn)
  GC_ref(callback)
  let id = g.g_signal_connect_data(p, "switch-page", cast[g.TGCallback](switchPageThunk),
    cast[pointer](callback), releasePageCallback, g.G_CONNECT_AFTER)
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)
