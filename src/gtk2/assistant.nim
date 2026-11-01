# Included by gtk2.nim. GTK2's nonblocking wizard window; page roots are public.
type
  Assistant* = object of Window
  AssistantPageKind* = enum
    assistantContent, assistantIntro, assistantConfirm, assistantSummary, assistantProgress

proc raw*(w: Assistant): ptr rawGtk.Assistant = cast[ptr rawGtk.Assistant](raw(Widget(w)))
proc `title=`*(w: Assistant, value: string) =
  rawGtk.set_title(cast[rawGtk.PWindow](w.raw), checkedUtf8Text(value))
proc newAssistant*(title = "Assistant", width = 640, height = 480, modal = false): Assistant =
  let caption = checkedUtf8Text(title)
  let a = checkedInt(width)
  let b = checkedInt(height)
  result.state = adoptWidget(rawGtk.assistant_new())
  rawGtk.set_title(cast[rawGtk.PWindow](result.raw), caption)
  rawGtk.set_default_size(cast[rawGtk.PWindow](result.raw), a, b)
  result.modal = modal
proc newAssistant*(parent: Window, title = "Assistant", width = 640, height = 480,
                   modal = false, destroyWithParent = true): Assistant =
  discard parent.raw
  result = newAssistant(title, width, height, modal)
  try:
    result.transientFor = parent
    result.destroyWithParent = destroyWithParent
  except:
    result.destroy()
    raise
proc pageCount*(w: Assistant): int = rawGtk.assistant_get_n_pages(w.raw).int
proc currentPage*(w: Assistant): int = rawGtk.assistant_get_current_page(w.raw).int
proc checkedAssistantPage(w: Assistant, index: int): g.gint =
  if index < 0 or index >= w.pageCount:
    raise newException(ValueError, "assistant page index out of bounds")
  checkedInt(index)
proc pageAt*(w: Assistant, index: int): Widget =
  result.state = adoptObject(rawGtk.assistant_get_nth_page(w.raw, checkedAssistantPage(w, index)),
    borrowed = true, cache = true)
proc pageIndex*(w: Assistant, child: Widget): int =
  let p = w.raw
  let page = child.raw
  for i in 0..<w.pageCount:
    if rawGtk.assistant_get_nth_page(p, g.gint(i)) == page: return i
  -1
proc requireAssistantPage(w: Assistant, child: Widget): rawGtk.PWidget =
  if w.pageIndex(child) < 0:
    raise newException(ValueError, "widget is not a page in this assistant")
  child.raw
proc pageType*(w: Assistant, child: Widget): AssistantPageKind =
  AssistantPageKind(cint(rawGtk.assistant_get_page_type(w.raw, requireAssistantPage(w, child))))
proc setPageType*(w: Assistant, child: Widget, kind: AssistantPageKind) =
  rawGtk.assistant_set_page_type(w.raw, requireAssistantPage(w, child), rawGtk.AssistantPageType(ord(kind)))
proc pageTitle*(w: Assistant, child: Widget): string =
  $rawGtk.assistant_get_page_title(w.raw, requireAssistantPage(w, child))
proc setPageTitle*(w: Assistant, child: Widget, value: string) =
  let caption = checkedUtf8Text(value)
  rawGtk.assistant_set_page_title(w.raw, requireAssistantPage(w, child), caption)
proc pageComplete*(w: Assistant, child: Widget): bool =
  g.toBool(rawGtk.assistant_get_page_complete(w.raw, requireAssistantPage(w, child)))
proc setPageComplete*(w: Assistant, child: Widget, value = true) =
  rawGtk.assistant_set_page_complete(w.raw, requireAssistantPage(w, child), g.gbool(value))
proc pageVisible*(w: Assistant, child: Widget): bool =
  g.toBool(rawGtk.get_visible(requireAssistantPage(w, child)))
proc setPageVisible*(w: Assistant, child: Widget, value = true) =
  let p = requireAssistantPage(w, child)
  if not value and w.pageIndex(child) == w.currentPage:
    raise newException(ValueError, "select another page before hiding the current page")
  rawGtk.set_no_show_all(p, g.gbool(not value))
  if value: rawGtk.show(p)
  else: rawGtk.hide(p)
proc pageHeaderImage*(w: Assistant, child: Widget): Pixbuf =
  ownedPixbuf(rawGtk.assistant_get_page_header_image(w.raw, requireAssistantPage(w, child)), borrowed = true)
proc setPageHeaderImage*(w: Assistant, child: Widget, image: Pixbuf) =
  rawGtk.assistant_set_page_header_image(w.raw, requireAssistantPage(w, child), pixbufPointer(image))
proc pageSideImage*(w: Assistant, child: Widget): Pixbuf =
  ownedPixbuf(rawGtk.assistant_get_page_side_image(w.raw, requireAssistantPage(w, child)), borrowed = true)
proc setPageSideImage*(w: Assistant, child: Widget, image: Pixbuf) =
  rawGtk.assistant_set_page_side_image(w.raw, requireAssistantPage(w, child), pixbufPointer(image))
proc insertPage*(w: Assistant, index: int, child: Widget, title = "",
                 kind = assistantContent, complete = false): int {.discardable.} =
  let caption = checkedUtf8Text(title)
  checkChild(w, child)
  if index < 0 or index > w.pageCount:
    raise newException(ValueError, "assistant insertion index out of bounds")
  let position = checkedInt(index)
  result = rawGtk.assistant_insert_page(w.raw, child.raw, position).int
  rawGtk.assistant_set_page_title(w.raw, child.raw, caption)
  w.setPageType(child, kind)
  w.setPageComplete(child, complete)
  # Show only the page root, not the assistant or a toplevel. Hidden descendants
  # retain normal showAll semantics, like Notebook pages.
  child.show()
proc appendPage*(w: Assistant, child: Widget, title = "", kind = assistantContent,
                 complete = false): int {.discardable.} =
  w.insertPage(w.pageCount, child, title, kind, complete)
proc prependPage*(w: Assistant, child: Widget, title = "", kind = assistantContent,
                  complete = false): int {.discardable.} =
  w.insertPage(0, child, title, kind, complete)
proc `currentPage=`*(w: Assistant, index: int) =
  let n = checkedAssistantPage(w, index)
  if not g.toBool(rawGtk.get_visible(rawGtk.assistant_get_nth_page(w.raw, n))):
    raise newException(ValueError, "show a hidden page before selecting it")
  rawGtk.assistant_set_current_page(w.raw, n)
proc removePage*(w: Assistant, index: int) =
  let child = rawGtk.assistant_get_nth_page(w.raw, checkedAssistantPage(w, index))
  rawGtk.remove(cast[rawGtk.PContainer](w.raw), child)

const assistantActionKey = "nim-gtk2-assistant-action-owner"
proc addActionWidget*(w: Assistant, button: Button) =
  checkChild(w, button)
  let p = button.raw
  rawGtk.assistant_add_action_widget(w.raw, cast[rawGtk.PWidget](p))
  g.set_data(cast[g.PGObject](p), assistantActionKey, w.raw)
proc removeActionWidget*(w: Assistant, button: Button) =
  let p = button.raw
  let owner = w.raw
  if g.get_data(cast[g.PGObject](p), assistantActionKey) != cast[pointer](owner) or
      rawGtk.get_parent(cast[rawGtk.PWidget](p)) == nil:
    raise newException(ValueError, "button is not an action widget of this assistant")
  g.set_data(cast[g.PGObject](p), assistantActionKey, nil)
  rawGtk.assistant_remove_action_widget(owner, cast[rawGtk.PWidget](p))
proc updateButtons*(w: Assistant) = rawGtk.assistant_update_buttons_state(w.raw)
proc commit*(w: Assistant) = rawGtk.assistant_commit(w.raw)

# Native prepare/apply handlers continue using pages and assistant private data
# after signal emission. Deliver user observers at idle, outside those handlers.
type AssistantBinding[T] = ref object
  fn: proc (value: T) {.closure.}
  values: seq[T]
  active: bool
  idle: g.guint
proc releaseAssistantIdle[T](data: pointer) {.cdecl.} = GC_unref(cast[AssistantBinding[T]](data))
proc releaseAssistantBinding[T](data: pointer, closure: g.PGClosure) {.cdecl.} =
  let binding = cast[AssistantBinding[T]](data)
  binding.active = false
  binding.fn = nil
  binding.values = @[]
  let idle = binding.idle
  binding.idle = 0
  if idle != 0: discard g.g_source_remove(idle)
  GC_unref(binding)
proc dispatchAssistant[T](data: pointer): g.gboolean {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    let binding = cast[AssistantBinding[T]](data)
    if binding.active and binding.values.len > 0:
      let value = binding.values[0]
      binding.values.delete(0)
      let fn = binding.fn
      try:
        when T is Widget:
          if not value.isDestroyed: fn(value)
        else: fn(value)
      except Exception as error: reportSignalError(error)
    if not binding.active or binding.values.len == 0:
      binding.idle = 0
      return g.gbool(false)
    g.gbool(true)
proc queueAssistant[T](binding: AssistantBinding[T], value: T) =
  if not binding.active: return
  when T is Widget: binding.values.setLen(0) # Only the latest prepare snapshot.
  binding.values.add(value)
  if binding.idle == 0:
    GC_ref(binding)
    binding.idle = g.g_idle_add_full(g.G_PRIORITY_DEFAULT_IDLE, cast[pointer](dispatchAssistant[T]),
      cast[pointer](binding), cast[pointer](releaseAssistantIdle[T]))
proc assistantPrepareThunk(instance, page, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}:
    try:
      var snapshot: Widget
      snapshot.state = adoptObject(page, borrowed = true, cache = true)
      queueAssistant(cast[AssistantBinding[Widget]](data), snapshot)
    except Exception as error: reportSignalError(error)
proc assistantActionThunk(instance, data: pointer) {.cdecl, gcsafe.} =
  {.cast(gcsafe).}: queueAssistant(cast[AssistantBinding[bool]](data), true)
proc connectAssistant[T](w: Assistant, signal: cstring, fn: proc (value: T) {.closure.},
                         thunk: g.TGCallback): Connection =
  let p = w.raw
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  let binding = AssistantBinding[T](fn: fn, active: true)
  GC_ref(binding)
  let id = g.g_signal_connect_data(p, signal, thunk, cast[pointer](binding),
    releaseAssistantBinding[T], g.G_CONNECT_AFTER)
  w.state.handlers.add(id)
  Connection(state: w.state, id: id)
proc onPrepare*(w: Assistant, fn: proc (page: Widget) {.closure.}): Connection {.discardable.} =
  ## Deferred/coalesced page notification, NOT a synchronous pre-display hook.
  ## Initialize content before navigation; snapshots may no longer be current.
  connectAssistant(w, "prepare", fn, cast[g.TGCallback](assistantPrepareThunk))
proc assistantAction(w: Assistant, signal: cstring, fn: proc () {.closure.}): Connection =
  if fn == nil: raise newException(ValueError, "signal callback cannot be nil")
  connectAssistant(w, signal, proc (unused: bool) = fn(), cast[g.TGCallback](assistantActionThunk))
proc onApply*(w: Assistant, fn: proc () {.closure.}): Connection {.discardable.} = assistantAction(w, "apply", fn)
proc onCancel*(w: Assistant, fn: proc () {.closure.}): Connection {.discardable.} = assistantAction(w, "cancel", fn)
proc onClose*(w: Assistant, fn: proc () {.closure.}): Connection {.discardable.} = assistantAction(w, "close", fn)
