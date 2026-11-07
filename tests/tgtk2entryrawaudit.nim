# Raw migration checks; all widgets remain unrealized throughout.
import std/unittest
import gtk2 as ui
import headers/gtk2 as n
import headers/glib2 as g
static:
  doAssert not compiles(n.editable(n.PEntry(nil)))
  doAssert not compiles(n.set_editable(n.PEntry(nil), g.guint(0)))
  doAssert not compiles(n.visible(n.PEntry(nil)))
  doAssert not compiles(n.set_visible(n.PEntry(nil), g.guint(0)))
  doAssert not compiles(n.in_drag(n.PEntry(nil)))
  doAssert not compiles(n.set_in_drag(n.PEntry(nil), g.guint(0)))
  doAssert not compiles(n.cache_includes_preedit(n.PEntry(nil)))
  doAssert not compiles(n.set_cache_includes_preedit(n.PEntry(nil), g.guint(0)))
  doAssert not compiles(n.need_im_reset(n.PEntry(nil)))
  doAssert not compiles(n.set_need_im_reset(n.PEntry(nil), g.guint(0)))
  doAssert not compiles(n.cursor_visible(n.PEntry(nil)))
  doAssert not compiles(n.set_cursor_visible(n.PEntry(nil), g.guint(0)))
  doAssert not compiles(n.in_click(n.PEntry(nil)))
  doAssert not compiles(n.set_in_click(n.PEntry(nil), g.guint(0)))
  doAssert not compiles(n.is_cell_renderer(n.PEntry(nil)))
  doAssert not compiles(n.set_is_cell_renderer(n.PEntry(nil), g.guint(0)))
  doAssert not compiles(n.editing_canceled(n.PEntry(nil)))
  doAssert not compiles(n.set_editing_canceled(n.PEntry(nil), g.guint(0)))
  doAssert not compiles(n.mouse_cursor_obscured(n.PEntry(nil)))
  doAssert not compiles(n.set_mouse_cursor_obscured(n.PEntry(nil), g.guint(0)))
  doAssert not compiles(n.overwrite_mode(n.PEntry(nil)))
  doAssert not compiles(n.has_frame(n.PEntry(nil)))
  doAssert not compiles(n.activates_default(n.PEntry(nil)))
  # All historical Entry masks, including those from earlier removed helpers.
  doAssert not declared(n.bm_TGtkEntry_editable)
  doAssert not declared(n.bp_TGtkEntry_editable)
  doAssert not declared(n.bm_TGtkEntry_visible)
  doAssert not declared(n.bp_TGtkEntry_visible)
  doAssert not declared(n.bm_TGtkEntry_overwrite_mode)
  doAssert not declared(n.bp_TGtkEntry_overwrite_mode)
  doAssert not declared(n.bm_TGtkEntry_in_drag)
  doAssert not declared(n.bp_TGtkEntry_in_drag)
  doAssert not declared(n.bm_TGtkEntry_cache_includes_preedit)
  doAssert not declared(n.bp_TGtkEntry_cache_includes_preedit)
  doAssert not declared(n.bm_TGtkEntry_need_im_reset)
  doAssert not declared(n.bp_TGtkEntry_need_im_reset)
  doAssert not declared(n.bm_TGtkEntry_has_frame)
  doAssert not declared(n.bp_TGtkEntry_has_frame)
  doAssert not declared(n.bm_TGtkEntry_activates_default)
  doAssert not declared(n.bp_TGtkEntry_activates_default)
  doAssert not declared(n.bm_TGtkEntry_cursor_visible)
  doAssert not declared(n.bp_TGtkEntry_cursor_visible)
  doAssert not declared(n.bm_TGtkEntry_in_click)
  doAssert not declared(n.bp_TGtkEntry_in_click)
  doAssert not declared(n.bm_TGtkEntry_is_cell_renderer)
  doAssert not declared(n.bp_TGtkEntry_is_cell_renderer)
  doAssert not declared(n.bm_TGtkEntry_editing_canceled)
  doAssert not declared(n.bp_TGtkEntry_editing_canceled)
  doAssert not declared(n.bm_TGtkEntry_mouse_cursor_obscured)
  doAssert not declared(n.bp_TGtkEntry_mouse_cursor_obscured)
  doAssert compiles(n.get_editable(cast[n.PEditable](n.PEntry(nil))))
  doAssert compiles(n.set_editable(cast[n.PEditable](n.PEntry(nil)), g.gbool(false)))
  doAssert compiles(n.get_visibility(n.PEntry(nil)))
  doAssert compiles(n.set_visibility(n.PEntry(nil), g.gbool(false)))
proc unrealized(entry: ui.Entry) = doAssert not g.toBool(n.get_realized(cast[n.PWidget](entry.raw)))
proc dropEntry(obj: g.PGObject, spec: g.PGParamSpec, data: pointer) {.cdecl.} = cast[ptr ui.Entry](data)[] = default(ui.Entry)
proc gone(data: pointer, obj: g.PGObject) {.cdecl.} = inc cast[ptr int](data)[]
ui.init()
suite "raw GtkEntry public replacements":
  test "native editable/visibility bool APIs can clear flags without touching text":
    let entry = newEntry("λ🙂abc")
    defer: entry.destroy()
    unrealized(entry)
    entry.selectRange(4, 1)
    let before = entry.selectionBounds
    let editable = cast[n.PEditable](entry.raw)
    for value in [false, true, false]:
      n.set_editable(editable, g.gbool(value))
      n.set_visibility(entry.raw, g.gbool(value))
      check g.toBool(n.get_editable(editable)) == value and entry.editable == value
      check g.toBool(n.get_visibility(entry.raw)) == value and entry.textVisible == value
      check entry.text == "λ🙂abc" and entry.selectionBounds == before
      unrealized(entry)
    expect ValueError: discard entry.selectedText
  test "editing-canceled is a typed public GtkCellEditable property, not a field alias":
    let entry = newEntry("application sample")
    defer: entry.destroy()
    unrealized(entry)
    let obj = cast[g.PGObject](entry.raw)
    let spec = g.class_find_property(g.G_OBJECT_GET_CLASS(obj), "editing-canceled")
    require spec != nil
    check spec.value_type == g.G_TYPE_BOOLEAN
    var value: g.TGValue
    discard g.init(addr value, spec.value_type)
    defer: g.unset(addr value)
    g.get_property(obj, "editing-canceled", addr value)
    check not g.toBool(g.get_boolean(addr value))
    for flag in [true, false]:
      g.set_boolean(addr value, g.gbool(flag))
      g.set_property(obj, "editing-canceled", addr value)
      g.get_property(obj, "editing-canceled", addr value)
      check g.toBool(g.get_boolean(addr value)) == flag
      check entry.text == "application sample"
      unrealized(entry)
  test "ergonomic editable setter pins raw notify dropping last alias":
    var entry = newEntry("abc")
    var finalized = 0
    g.weak_ref(cast[g.PGObject](entry.raw), gone, addr finalized)
    discard g.g_signal_connect_data(entry.raw, "notify::editable", cast[g.TGCallback](dropEntry), addr entry, nil, g.TGConnectFlags(0))
    entry.editable = false
    check entry.isDestroyed and finalized == 1
  test "protected combo/inherited spin retain supported policy and ownership":
    let combo = newComboBoxText(["λ🙂 sample"], editable = true)
    defer: combo.destroy()
    combo.activeIndex = 0
    combo.entry.editable = false
    combo.entry.textVisible = false
    check combo.activeIndex == 0 and combo.entry.text == "λ🙂 sample"
    unrealized(combo.entry)
    let spin = newSpinButton(newAdjustment(12.5, 0, 100, 0.1), digits = 1)
    defer: spin.destroy()
    spin.editable = false
    check not spin.editable and spin.value == 12.5
    unrealized(spin)
