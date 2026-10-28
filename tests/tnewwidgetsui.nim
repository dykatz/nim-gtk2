# Creates hidden native widgets only. No show(), dialog_run(), or main loop.
import std/[os, tempfiles, unittest]
import gtk2 as gtk
import glib2 as g
import gdk2

proc runTests() =
  let home = createTempDir("nim_gtk2_widgets_", "")
  defer: removeDir(home)
  var environment: seq[tuple[key, value: string, present: bool]]
  for key in ["XDG_DATA_HOME", "XDG_CONFIG_HOME", "XDG_CACHE_HOME"]:
    environment.add((key, getEnv(key), existsEnv(key)))
    let directory = home / key
    createDir(directory)
    putEnv(key, directory)
  defer:
    for item in environment:
      if item.present: putEnv(item.key, item.value)
      else: delEnv(item.key)
  doAssert g.toBool(gtk.init_check(nil, nil)), "A display is required"

  var widgets: seq[gtk.PWidget]
  var objects: seq[pointer]
  proc keep[T](p: ptr T): ptr T =
    doAssert p != nil
    discard g.g_object_ref_sink(p)
    widgets.add(cast[gtk.PWidget](p))
    p
  defer:
    # Recent choosers load through idle sources even when hidden. Finish ready
    # work before disposal (GTK2's unfinished-load teardown double-removes a
    # source with modern GLib). This is bounded, nonblocking context pumping,
    # not a visible application main loop.
    for i in 0 ..< 1000:
      if gtk.events_pending() == 0: break
      discard gtk.main_iteration_do(g.gbool(false))
    for i in countdown(widgets.high, 0):
      gtk.destroy(widgets[i])
      g.g_object_unref(widgets[i])
    for i in countdown(objects.high, 0):
      g.g_object_unref(objects[i])

  suite "new raw widgets (hidden-window integration)":
    test "AboutDialog, Assistant and Expander":
      let about = keep(gtk.about_dialog_new())
      gtk.about_dialog_set_program_name(about, "Nim SDK")
      gtk.about_dialog_set_version(about, "1.0")
      check $gtk.about_dialog_get_program_name(about) == "Nim SDK"
      check $gtk.about_dialog_get_version(about) == "1.0"
      var authors = [cstring("Nim developers"), cstring(nil)]
      gtk.about_dialog_set_authors(about, addr authors[0])
      check $gtk.about_dialog_get_authors(about)[] == "Nim developers"
      let wizard = keep(gtk.assistant_new())
      let page = cast[gtk.PWidget](gtk.label_new("Welcome"))
      check gtk.assistant_append_page(wizard, page) == 0
      gtk.assistant_set_page_type(wizard, page, gtk.ASSISTANT_PAGE_INTRO)
      gtk.assistant_set_page_title(wizard, page, "Introduction")
      gtk.assistant_set_page_complete(wizard, page, g.gbool(true))
      check gtk.assistant_get_n_pages(wizard) == 1
      check gtk.assistant_get_page_type(wizard, page) == gtk.ASSISTANT_PAGE_INTRO
      check g.toBool(gtk.assistant_get_page_complete(wizard, page))
      var released = false
      proc forward(current: g.gint, data: pointer): g.gint {.cdecl, gcsafe.} = -1
      proc release(data: pointer) {.cdecl, gcsafe.} = cast[ptr bool](data)[] = true
      gtk.assistant_set_forward_page_func(wizard, forward, addr released, release)
      gtk.assistant_set_forward_page_func(wizard, nil, nil, nil)
      check released
      let expander = keep(gtk.expander_new("Details"))
      gtk.expander_set_expanded(expander, g.gbool(true))
      gtk.expander_set_spacing(expander, 7)
      check g.toBool(gtk.expander_get_expanded(expander))
      check gtk.expander_get_spacing(expander) == 7

    test "color/font buttons, chooser widget and icon model":
      var color = gdk2.TColor(red: 1234, green: 2345, blue: 3456)
      let picker = keep(gtk.color_button_new_with_color(addr color))
      gtk.color_button_set_use_alpha(picker, g.gbool(true))
      gtk.color_button_set_alpha(picker, 40000)
      var returned: gdk2.TColor
      gtk.color_button_get_color(picker, addr returned)
      check returned.red == color.red
      check returned.blue == color.blue
      check gtk.color_button_get_alpha(picker) == 40000
      let font = keep(gtk.font_button_new_with_font("Sans 12"))
      gtk.font_button_set_show_size(font, g.gbool(false))
      check not g.toBool(gtk.font_button_get_show_size(font))
      check ($gtk.font_button_get_font_name(font)).len > 0
      let chooser = keep(gtk.file_chooser_widget_new(gtk.FILE_CHOOSER_ACTION_OPEN))
      check gtk.get_action(cast[gtk.PFileChooser](chooser)) == gtk.FILE_CHOOSER_ACTION_OPEN
      var column = g.G_TYPE_STRING
      let model = gtk.list_store_newv(1, addr column)
      defer: g.g_object_unref(model)
      var iter: gtk.TTreeIter
      gtk.append(model, addr iter)
      gtk.set(model, addr iter, 0.cint, cstring("First item"), -1.cint)
      let icons = keep(gtk.icon_view_new_with_model(cast[gtk.PTreeModel](model)))
      gtk.icon_view_set_text_column(icons, 0)
      gtk.icon_view_set_columns(icons, 3)
      gtk.icon_view_set_selection_mode(icons, gtk.SELECTION_MULTIPLE)
      let path = gtk.tree_path_new_from_string("0")
      defer: gtk.free(path)
      gtk.icon_view_select_path(icons, path)
      check g.toBool(gtk.icon_view_path_is_selected(icons, path))
      check gtk.icon_view_get_columns(icons) == 3
      check gtk.icon_view_get_model(icons) == cast[gtk.PTreeModel](model)

    test "recent chooser variants use an isolated manager and filter":
      let filename = home / "recently-used.xbel"
      let manager = cast[ptr gtk.RecentManager](g.g_object_new(
        gtk.recent_manager_get_type(), "filename", filename.cstring, nil))
      require manager != nil
      objects.add(manager) # Outlive every chooser using this manager.
      # GTK2's empty-recent-list idle cleanup double-removes its source with
      # modern GLib. Use a real, isolated fixture rather than hiding warnings.
      let document = home / "fixture.txt"
      writeFile(document, "test document")
      let documentUri = g.g_filename_to_uri(document.cstring, nil, nil)
      require documentUri != nil
      defer: g.g_free(documentUri)
      var data = gtk.RecentData(display_name: "fixture.txt", mime_type: "text/plain",
        app_name: "Nim SDK tests", app_exec: "nim-sdk-test %u", is_private: g.gbool(false))
      check g.toBool(gtk.recent_manager_add_full(manager, documentUri, addr data))
      let chooser = keep(gtk.recent_chooser_widget_new_for_manager(manager))
      let menu = keep(gtk.recent_chooser_menu_new_for_manager(manager))
      discard keep(gtk.recent_chooser_dialog_new_for_manager(
        "Recent", nil, manager, nil)) # nil is the terminating button sentinel.
      let chooserApi = cast[ptr gtk.RecentChooser](chooser)
      gtk.recent_chooser_set_limit(chooserApi, 7)
      gtk.recent_chooser_set_sort_type(chooserApi, gtk.RECENT_SORT_MRU)
      check gtk.recent_chooser_get_limit(chooserApi) == 7
      check gtk.recent_chooser_get_sort_type(chooserApi) == gtk.RECENT_SORT_MRU
      gtk.recent_chooser_menu_set_show_numbers(menu, g.gbool(true))
      check g.toBool(gtk.recent_chooser_menu_get_show_numbers(menu))
      let filter = gtk.recent_filter_new()
      gtk.recent_filter_set_name(filter, "Text files")
      gtk.recent_filter_add_pattern(filter, "*.txt")
      gtk.recent_chooser_add_filter(chooserApi, filter) # chooser owns the filter
      check $gtk.recent_filter_get_name(filter) == "Text files"
      let infos = gtk.recent_chooser_get_items(chooserApi)
      var node = infos
      var count = 0
      while node != nil:
        inc count
        gtk.recent_info_unref(cast[ptr gtk.RecentInfo](node.data))
        node = node.next
      g.free(infos)
      check count == 1

    test "toolbar items, palettes and tool groups":
      let toolbar = keep(gtk.toolbar_new())
      let item = keep(gtk.tool_item_new())
      gtk.tool_item_set_expand(item, g.gbool(true))
      gtk.toolbar_insert(toolbar, item, -1)
      check g.toBool(gtk.tool_item_get_expand(item))
      let button = keep(gtk.tool_button_new(nil, "Open"))
      gtk.tool_button_set_label(button, "Save")
      gtk.toolbar_insert(toolbar, cast[ptr gtk.ToolItem](button), -1)
      check $gtk.tool_button_get_label(button) == "Save"
      let toggle = keep(gtk.toggle_tool_button_new())
      gtk.toggle_tool_button_set_active(toggle, g.gbool(true))
      check g.toBool(gtk.toggle_tool_button_get_active(toggle))
      let radio = keep(gtk.radio_tool_button_new(nil))
      let other = keep(gtk.radio_tool_button_new_from_widget(radio))
      gtk.toggle_tool_button_set_active(cast[ptr gtk.ToggleToolButton](other), g.gbool(true))
      check not g.toBool(gtk.toggle_tool_button_get_active(cast[ptr gtk.ToggleToolButton](radio)))
      let menuButton = keep(gtk.menu_tool_button_new(nil, "More"))
      let menu = gtk.menu_new()
      gtk.menu_tool_button_set_menu(menuButton, cast[gtk.PWidget](menu))
      check gtk.menu_tool_button_get_menu(menuButton) == cast[gtk.PWidget](menu)
      let separator = keep(gtk.separator_tool_item_new())
      gtk.separator_tool_item_set_draw(separator, g.gbool(false))
      gtk.toolbar_insert(toolbar, cast[ptr gtk.ToolItem](separator), -1)
      check not g.toBool(gtk.separator_tool_item_get_draw(separator))
      check gtk.toolbar_get_n_items(toolbar) == 3
      let palette = keep(gtk.tool_palette_new())
      let group = keep(gtk.tool_item_group_new("Tools"))
      gtk.add(cast[gtk.PContainer](palette), cast[gtk.PWidget](group))
      let groupItem = keep(gtk.tool_button_new(nil, "Draw"))
      gtk.tool_item_group_insert(group, cast[ptr gtk.ToolItem](groupItem), -1)
      check gtk.tool_item_group_get_n_items(group) == 1
      gtk.tool_item_group_set_collapsed(group, g.gbool(true))
      check g.toBool(gtk.tool_item_group_get_collapsed(group))
      gtk.tool_palette_set_exclusive(palette, group, g.gbool(true))
      check g.toBool(gtk.tool_palette_get_exclusive(palette, group))

    test "Spinner, ScaleButton and VolumeButton":
      let spinner = keep(gtk.spinner_new())
      gtk.spinner_start(spinner)
      gtk.spinner_stop(spinner)
      let scale = keep(gtk.scale_button_new(gtk.ICON_SIZE_SMALL_TOOLBAR, 0, 10, 0.5, nil))
      gtk.scale_button_set_value(scale, 4.5)
      check gtk.scale_button_get_value(scale) == 4.5
      let volume = keep(gtk.volume_button_new())
      gtk.scale_button_set_value(cast[ptr gtk.ScaleButton](volume), 0.75)
      check gtk.scale_button_get_value(cast[ptr gtk.ScaleButton](volume)) == 0.75

    when defined(posix) and not defined(macosx):
      test "Unix print and page-setup dialogs (no printing or dialog run)":
        let printDialog = keep(gtk.print_unix_dialog_new("Print", nil))
        gtk.print_unix_dialog_set_current_page(printDialog, 2)
        check gtk.print_unix_dialog_get_current_page(printDialog) == 2
        let settings = gtk.print_settings_new()
        objects.add(settings)
        gtk.print_unix_dialog_set_settings(printDialog, settings)
        let pageDialog = keep(gtk.page_setup_unix_dialog_new("Page Setup", nil))
        let setup = gtk.page_setup_new()
        objects.add(setup)
        gtk.page_setup_set_orientation(setup, gtk.PAGE_ORIENTATION_LANDSCAPE)
        gtk.page_setup_unix_dialog_set_page_setup(pageDialog, setup)
        check gtk.page_setup_get_orientation(
          gtk.page_setup_unix_dialog_get_page_setup(pageDialog)) == gtk.PAGE_ORIENTATION_LANDSCAPE

runTests()
