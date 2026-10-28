# No display required. Verify every added dynamic symbol, typed handles,
# supporting printing objects, callback types, and explicit GError ownership.
import std/[dynlib, os, strutils, unittest]
import gtk2 as gtk
import glib2 as g

static:
  doAssert not compiles(block:
    const size = sizeof(gtk.AboutDialog)
    discard size)
  doAssert not compiles(block:
    const size = sizeof(gtk.IconView)
    discard size)
  doAssert sizeof(gtk.AssistantPageType) == sizeof(cint)
  doAssert sizeof(gtk.RecentFilterFlags) == sizeof(cint)
  doAssert sizeof(gtk.PrintSettingsFunc) == sizeof(pointer)
  doAssert not compiles(gtk.PAGE_ORIENTATION_PORTRAIT or gtk.PAGE_ORIENTATION_LANDSCAPE)
  doAssert compiles(gtk.RECENT_FILTER_URI or gtk.RECENT_FILTER_MIME_TYPE)
  doAssert not declared(gtk.about_dialog_set_url_hook)
  doAssert not declared(gtk.tool_item_set_tooltip)
  doAssert not declared(gtk.file_chooser_widget_new_with_backend)
  doAssert not declared(gtk.icon_view_set_orientation)
  when defined(windows) or defined(macosx):
    doAssert not declared(gtk.print_unix_dialog_new)

when defined(windows):
  const library = "libgtk-win32-2.0-0.dll"
elif defined(macosx):
  const library = "(libgtk-quartz-2.0.0.dylib|libgtk-x11-2.0.dylib)"
else:
  const library = "libgtk-x11-2.0.so(|.0)"

const nativeSymbols = staticRead("new_widget_symbols.txt")

suite "additional GTK2 raw API (no display)":
  test "all generated functions exist in the native GTK library":
    let handle = loadLibPattern(library)
    require handle != nil
    defer: unloadLib(handle)
    for line in nativeSymbols.splitLines:
      if line.len == 0: continue
      let parts = line.splitWhitespace
      when defined(windows) or defined(macosx):
        if parts[0] == "unix": continue
      checkpoint parts[1]
      check symAddr(handle, parts[1].cstring) != nil

  test "print settings, page ranges and page setup use the native ABI":
    let settings = gtk.print_settings_new()
    defer: g.g_object_unref(settings)
    gtk.print_settings_set_n_copies(settings, 3)
    gtk.print_settings_set_duplex(settings, gtk.PRINT_DUPLEX_HORIZONTAL)
    check gtk.print_settings_get_n_copies(settings) == 3
    check gtk.print_settings_get_duplex(settings) == gtk.PRINT_DUPLEX_HORIZONTAL
    var pages = [gtk.PageRange(start: 1, `end`: 3), gtk.PageRange(start: 5, `end`: 8)]
    gtk.print_settings_set_page_ranges(settings, addr pages[0], 2)
    var count: g.gint
    let returned = gtk.print_settings_get_page_ranges(settings, addr count)
    defer: g.g_free(returned)
    check count == 2
    let ranges = cast[ptr UncheckedArray[gtk.PageRange]](returned)
    check ranges[0].start == 1
    check ranges[1].`end` == 8
    let paper = gtk.paper_size_new("iso_a4")
    defer: gtk.paper_size_free(paper)
    check abs(gtk.paper_size_get_width(paper, gtk.UNIT_MM) - 210.0) < 0.01
    let setup = gtk.page_setup_new()
    defer: g.g_object_unref(setup)
    gtk.page_setup_set_paper_size(setup, paper)
    gtk.page_setup_set_orientation(setup, gtk.PAGE_ORIENTATION_LANDSCAPE)
    check gtk.page_setup_get_orientation(setup) == gtk.PAGE_ORIENTATION_LANDSCAPE

  test "typed errors are returned and explicitly freed":
    var error: ptr g.GError
    let filename = getTempDir() / ("nim_gtk2_missing_print_settings_" & $getCurrentProcessId())
    require not fileExists(filename)
    let settings = gtk.print_settings_new_from_file(filename.cstring, addr error)
    check settings == nil
    require error != nil
    defer: g.g_error_free(error)
    check error.domain != 0
    check ($error.message).len > 0

  test "custom filters receive their complete C data structure":
    let filter = gtk.recent_filter_new()
    # RecentFilter is initially floating, like GtkFileFilter.
    discard g.g_object_ref_sink(filter)
    defer: g.g_object_unref(filter)
    var calls = 0
    proc match(info: ptr gtk.RecentFilterInfo, data: pointer): g.gboolean {.cdecl, gcsafe.} =
      inc cast[ptr int](data)[]
      g.gbool($info.uri == "file:///test.txt")
    gtk.recent_filter_add_custom(filter, gtk.RECENT_FILTER_URI, match, addr calls, nil)
    var info = gtk.RecentFilterInfo(contains: gtk.RECENT_FILTER_URI, uri: "file:///test.txt")
    check g.toBool(gtk.recent_filter_filter(filter, addr info))
    check calls == 1
