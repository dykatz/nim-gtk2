# No realizing/mapping, PRIMARY ownership, selection requests or fake input.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
static:
  doAssert not compiles(n.editable(n.PTextView(nil)))
  doAssert not compiles(n.set_editable(n.PTextView(nil), g.guint(0)))
  doAssert not compiles(n.overwrite_mode(n.PTextView(nil)))
  doAssert not compiles(n.set_overwrite_mode(n.PTextView(nil), g.guint(0)))
  doAssert not compiles(n.cursor_visible(n.PTextView(nil)))
  doAssert not compiles(n.set_cursor_visible(n.PTextView(nil), g.guint(0)))
  doAssert not compiles(n.need_im_reset(n.PTextView(nil)))
  doAssert not compiles(n.set_need_im_reset(n.PTextView(nil), g.guint(0)))
  doAssert not compiles(n.just_selected_element(n.PTextView(nil)))
  doAssert not compiles(n.set_just_selected_element(n.PTextView(nil), g.guint(0)))
  doAssert not compiles(n.disable_scroll_on_focus(n.PTextView(nil)))
  doAssert not compiles(n.set_disable_scroll_on_focus(n.PTextView(nil), g.guint(0)))
  doAssert not compiles(n.onscreen_validated(n.PTextView(nil)))
  doAssert not compiles(n.set_onscreen_validated(n.PTextView(nil), g.guint(0)))
  doAssert not compiles(n.mouse_cursor_obscured(n.PTextView(nil)))
  doAssert not compiles(n.set_mouse_cursor_obscured(n.PTextView(nil), g.guint(0)))
  doAssert not declared(n.bm_TGtkTextView_editable)
  doAssert not declared(n.bp_TGtkTextView_editable)
  doAssert not declared(n.bm_TGtkTextView_overwrite_mode)
  doAssert not declared(n.bp_TGtkTextView_overwrite_mode)
  doAssert not declared(n.bm_TGtkTextView_cursor_visible)
  doAssert not declared(n.bp_TGtkTextView_cursor_visible)
  doAssert not declared(n.bm_TGtkTextView_need_im_reset)
  doAssert not declared(n.bp_TGtkTextView_need_im_reset)
  doAssert not declared(n.bm_TGtkTextView_just_selected_element)
  doAssert not declared(n.bp_TGtkTextView_just_selected_element)
  doAssert not declared(n.bm_TGtkTextView_disable_scroll_on_focus)
  doAssert not declared(n.bp_TGtkTextView_disable_scroll_on_focus)
  doAssert not declared(n.bm_TGtkTextView_onscreen_validated)
  doAssert not declared(n.bp_TGtkTextView_onscreen_validated)
  doAssert not declared(n.bm_TGtkTextView_mouse_cursor_obscured)
  doAssert not declared(n.bp_TGtkTextView_mouse_cursor_obscured)
proc unrealized(view: ui.TextView) = doAssert not g.toBool(n.get_realized(cast[n.PWidget](view.raw)))
proc drain() =
  while n.events_pending() != 0: discard n.main_iteration_do(g.gbool(false))
proc dropView(obj: g.PGObject, spec: g.PGParamSpec, data: pointer) {.cdecl.} = cast[ptr ui.TextView](data)[] = default(ui.TextView)
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
ui.init()
suite "raw TextView public policy audit (unrealized)":
  test "native booleans clear policies; view policies do not change a shared buffer":
    let buffer = newTextBuffer("λ🙂abc")
    let view = newTextView(buffer)
    let mirror = newTextView(buffer)
    defer: view.destroy()
    defer: mirror.destroy()
    buffer.selectRange(4, 1)
    let selection = buffer.selectionBounds
    let cursor = buffer.cursorOffset
    var changed = 0
    buffer.onChanged(proc () = inc changed)
    check view.editable and view.cursorVisible and view.acceptsTab and not view.overwriteMode
    view.overwriteMode = false # Unchanged native policy is safe before realization.
    expect ValueError: view.overwriteMode = true
    check not view.overwriteMode
    for flag in [false, true, true, false]:
      view.editable = flag
      view.cursorVisible = flag
      view.acceptsTab = flag
      check view.editable == flag and view.cursorVisible == flag
      check view.acceptsTab == flag and not view.overwriteMode
      check g.toBool(n.get_editable(view.raw)) == flag
      check g.toBool(n.get_cursor_visible(view.raw)) == flag
      check g.toBool(n.get_accepts_tab(view.raw)) == flag
      check not g.toBool(n.get_overwrite(view.raw))
      unrealized(view)
      unrealized(mirror)
    drain()
    check buffer.text == "λ🙂abc" and not buffer.modified and changed == 0
    check buffer.selectionBounds == selection and buffer.cursorOffset == cursor
    check mirror.editable and mirror.cursorVisible and mirror.acceptsTab and not mirror.overwriteMode
    buffer.insertText(1, "X") # Explicit buffer edits remain allowed with readonly views.
    check buffer.text == "λX🙂abc"
    check view.buffer.raw == buffer.raw and mirror.buffer.raw == buffer.raw
    unrealized(view)
    unrealized(mirror)
  test "raw native getters/setters use gboolean not private uint flags":
    let view = newTextView("sample")
    defer: view.destroy()
    for flag in [false, true, false]:
      n.set_editable(view.raw, g.gbool(flag))
      n.set_cursor_visible(view.raw, g.gbool(flag))
      n.set_accepts_tab(view.raw, g.gbool(flag))
      check view.editable == flag and view.cursorVisible == flag
      check view.acceptsTab == flag and not view.overwriteMode
    unrealized(view)
  test "three unrealized-safe native setters pin notify emitters dropping last alias":
    for property in ["editable", "cursor-visible", "accepts-tab"]:
      var view = newTextView("sample")
      var finalized = 0
      unrealized(view)
      g.weak_ref(cast[g.PGObject](view.raw), gone, addr finalized)
      let signal = "notify::" & property
      discard g.g_signal_connect_data(view.raw, signal.cstring, cast[g.TGCallback](dropView), addr view, nil, g.TGConnectFlags(0))
      case property
      of "editable": view.editable = false
      of "cursor-visible": view.cursorVisible = false
      else: view.acceptsTab = false
      check view.isDestroyed and finalized == 1
  test "synchronous matcher guard and destroyed-handle rejection":
    let view = newTextView("sample")
    let entry = newEntry("a")
    defer: entry.destroy()
    let c = newEntryCompletion(["alpha"])
    defer: c.close()
    entry.completion = c
    var denied = 0
    c.setMatch(proc (input: CompletionMatchInput): bool =
      try: view.overwriteMode = true
      except ValueError: inc denied
      try: discard view.cursorVisible
      except ValueError: inc denied
      try: view.acceptsTab = false
      except ValueError: inc denied
      true)
    c.refilter()
    check denied >= 3 and denied mod 3 == 0
    unrealized(view)
    view.destroy()
    expect ValueError: discard view.overwriteMode
    expect ValueError: view.cursorVisible = true
