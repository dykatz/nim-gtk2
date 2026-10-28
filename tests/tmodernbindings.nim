# No display required. Compile with --warningAsError:Deprecated, not suppression.
import std/unittest
import glib2 as g
import gtk2 as rawGtk
import gdk2
import cairo
import cairoft
import pangoutils

static:
  doAssert sizeof(g.gsize) == sizeof(pointer)
  doAssert sizeof(g.gssize) == sizeof(pointer)
  doAssert sizeof(g.GType) == sizeof(pointer)
  doAssert g.gsize is uint
  doAssert g.gssize is int
  doAssert sizeof(g.gboolean) == sizeof(cint) # Not Nim's one-byte bool.
  doAssert compiles(pangoutils.read_line(nil, nil))
  doAssert not declared(rawGtk.nimrod_init)
  doAssert not declared(cairo.PContext)
  # Entire deprecated widget families are absent, not just their constructors.
  doAssert not declared(rawGtk.PCList)
  doAssert not declared(rawGtk.PCTree)
  doAssert not declared(rawGtk.CTREE_NODE)
  doAssert not declared(rawGtk.PCombo)
  doAssert not declared(rawGtk.PCurve)
  doAssert not declared(rawGtk.PGammaCurve)
  doAssert not declared(rawGtk.PFileSelection)
  doAssert not declared(rawGtk.PInputDialog)
  doAssert not declared(rawGtk.PList)
  doAssert not declared(rawGtk.PListItem)
  doAssert not declared(rawGtk.POldEditable)
  doAssert not declared(rawGtk.POptionMenu)
  doAssert not declared(rawGtk.PPixmap)
  doAssert not declared(rawGtk.PPreview)
  doAssert not declared(rawGtk.PRuler)
  doAssert not declared(rawGtk.PHRuler)
  doAssert not declared(rawGtk.PVRuler)
  doAssert not declared(rawGtk.PText)
  doAssert not declared(rawGtk.PTree)
  doAssert not declared(rawGtk.PTreeItem)
  doAssert not declared(rawGtk.PTipsQuery)
  doAssert not declared(rawGtk.PProgress)
  doAssert not declared(rawGtk.PTooltips)
  doAssert not declared(rawGtk.clist_new)
  doAssert not declared(rawGtk.ctree_new)
  doAssert not declared(rawGtk.combo_new)
  doAssert not declared(rawGtk.file_selection_new)
  doAssert not declared(rawGtk.text_new)
  doAssert not declared(rawGtk.tree_new)
  doAssert not declared(rawGtk.tooltips_new)
  # Preserve modern widgets and unrelated overloads despite similar names.
  doAssert compiles(block:
    rawGtk.remove(cast[rawGtk.PContainer](nil), nil)
    let text: rawGtk.PTextView = rawGtk.text_view_new()
    let tree: rawGtk.PTreeView = rawGtk.tree_view_new()
    let model: rawGtk.PListStore = rawGtk.list_store_new(1)
    let combo: rawGtk.PComboBox = rawGtk.comboBoxNew()
    let image: rawGtk.PImage = rawGtk.image_new()
    let progress: rawGtk.PProgressBar = rawGtk.progress_bar_new()
    let toolbar: rawGtk.PToolbar = rawGtk.toolbar_new()
    let targets: rawGtk.PTargetList = rawGtk.list_new(nil, 0)
    let handle: rawGtk.PHandleBox = rawGtk.handle_box_new()
    let tearoff: rawGtk.PTearoffMenuItem = rawGtk.tearoff_menu_item_new()
    discard text
    discard tree
    discard model
    discard combo
    discard image
    discard progress
    discard toolbar
    discard targets
    discard handle
    discard tearoff
    var iconClass: rawGtk.TStatusIconClass
    # GtkTooltip is modern; it must not be confused with removed GtkTooltips.
    discard iconClass.query_tooltip(nil, 0, 0, g.gbool(false),
      rawGtk.PTooltip(nil)))
  doAssert compiles(block:
    let context: ptr cairo.Context = gdk2.cairo_create(nil)
    let face: ptr cairo.FontFace = cairoft.ftFontFaceCreateForFtFace(nil, 0)
    discard context
    discard face)

suite "modern raw binding representations":
  test "GLib integer/pointer conversions preserve the full address width":
    let bits = high(uint) - 123'u
    check g.GPOINTER_TO_SIZE(g.GSIZE_TO_POINTER(bits)) == bits
    check cast[uint](g.GUINT_TO_POINTER(high(g.guint))) == uint(high(g.guint))

  test "GLib string layout matches native pointer-sized lengths":
    let str = g.g_string_new_len("hello", -1)
    defer: discard g.free(str, g.gbool(true))
    check str.len == 5'u
    check str.allocated_len >= str.len + 1
    check $str.str == "hello"
    discard g.append(str, " world")
    check str.len == 11'u
    check $str.str == "hello world"

  test "native size out parameters use full-width Nim storage":
    var read, written: g.gsize
    let converted = g.g_convert("λ", -1, "UTF-8", "UTF-8",
      addr read, addr written, nil)
    check converted != nil
    defer: g.g_free(converted)
    check read == 2'u
    check written == 2'u
    check $converted == "λ"

  test "Cairo failures are catchable and retain the native status":
    cairo.checkStatus(cairo.StatusSuccess)
    for status in [cairo.StatusNoMemory, cairo.StatusReadError,
                   cairo.StatusInvalidMatrix]:
      var caught = false
      try:
        cairo.checkStatus(status)
      except cairo.CairoError as error:
        caught = true
        check error.status == status
        check error.msg.len > 0
      check caught
