# Included by headers/gtk2.nim; do not import directly.
proc file_chooser_get_type*(): GType{.cdecl, dynlib: lib,
                                      importc: "gtk_file_chooser_get_type".}
proc file_chooser_error_quark*(): TGQuark{.cdecl, dynlib: lib,
    importc: "gtk_file_chooser_error_quark".}
proc TYPE_FILE_CHOOSER*(): GType =
  result = file_chooser_get_type()

proc FILE_CHOOSER*(obj: pointer): PFileChooser =
  result = cast[PFileChooser](G_TYPE_CHECK_INSTANCE_CAST(obj,
      TYPE_FILE_CHOOSER()))

proc IS_FILE_CHOOSER*(obj: pointer): gboolean =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_FILE_CHOOSER())

proc set_action*(chooser: PFileChooser, action: TFileChooserAction){.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_set_action".}
proc get_action*(chooser: PFileChooser): TFileChooserAction{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_get_action".}
proc set_local_only*(chooser: PFileChooser, local_only: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_set_local_only".}
proc get_local_only*(chooser: PFileChooser): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_get_local_only".}
proc set_select_multiple*(chooser: PFileChooser,
                                       select_multiple: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_set_select_multiple".}
proc get_select_multiple*(chooser: PFileChooser): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_get_select_multiple".}
proc set_current_name*(chooser: PFileChooser, name: cstring){.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_set_current_name".}
proc get_filename*(chooser: PFileChooser): cstring{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_get_filename".}
proc set_filename*(chooser: PFileChooser, filename: cstring): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_set_filename".}
proc select_filename*(chooser: PFileChooser, filename: cstring): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_select_filename".}
proc unselect_filename*(chooser: PFileChooser, filename: cstring){.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_unselect_filename".}
proc select_all*(chooser: PFileChooser){.cdecl, dynlib: lib,
    importc: "gtk_file_chooser_select_all".}
proc unselect_all*(chooser: PFileChooser){.cdecl, dynlib: lib,
    importc: "gtk_file_chooser_unselect_all".}
proc get_filenames*(chooser: PFileChooser): PGSList{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_get_filenames".}
proc set_current_folder*(chooser: PFileChooser, filename: cstring): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_set_current_folder".}
proc get_current_folder*(chooser: PFileChooser): cstring{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_get_current_folder".}
proc get_uri*(chooser: PFileChooser): cstring{.cdecl, dynlib: lib,
    importc: "gtk_file_chooser_get_uri".}
proc set_uri*(chooser: PFileChooser, uri: cstring): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_set_uri".}
proc select_uri*(chooser: PFileChooser, uri: cstring): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_select_uri".}
proc unselect_uri*(chooser: PFileChooser, uri: cstring){.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_unselect_uri".}
proc get_uris*(chooser: PFileChooser): PGSList{.cdecl, dynlib: lib,
    importc: "gtk_file_chooser_get_uris".}
proc set_current_folder_uri*(chooser: PFileChooser, uri: cstring): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_set_current_folder_uri".}
proc get_current_folder_uri*(chooser: PFileChooser): cstring{.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_get_current_folder_uri".}
proc set_preview_widget*(chooser: PFileChooser,
                                      preview_widget: PWidget){.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_set_preview_widget".}
proc get_preview_widget*(chooser: PFileChooser): PWidget{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_get_preview_widget".}
proc set_preview_widget_active*(chooser: PFileChooser,
    active: gboolean){.cdecl, dynlib: lib,
                       importc: "gtk_file_chooser_set_preview_widget_active".}
proc get_preview_widget_active*(chooser: PFileChooser): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_get_preview_widget_active".}
proc set_use_preview_label*(chooser: PFileChooser,
    use_label: gboolean){.cdecl, dynlib: lib,
                          importc: "gtk_file_chooser_set_use_preview_label".}
proc get_use_preview_label*(chooser: PFileChooser): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_get_use_preview_label".}
proc get_preview_filename*(chooser: PFileChooser): cstring{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_get_preview_filename".}
proc get_preview_uri*(chooser: PFileChooser): cstring{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_get_preview_uri".}
proc set_extra_widget*(chooser: PFileChooser, extra_widget: PWidget){.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_set_extra_widget".}
proc get_extra_widget*(chooser: PFileChooser): PWidget{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_get_extra_widget".}
proc add_filter*(chooser: PFileChooser, filter: PFileFilter){.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_add_filter".}
proc remove_filter*(chooser: PFileChooser, filter: PFileFilter){.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_remove_filter".}
proc list_filters*(chooser: PFileChooser): PGSList{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_list_filters".}
proc set_filter*(chooser: PFileChooser, filter: PFileFilter){.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_set_filter".}
proc get_filter*(chooser: PFileChooser): PFileFilter{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_get_filter".}
proc add_shortcut_folder*(chooser: PFileChooser, folder: cstring,
                                       error: pointer): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_add_shortcut_folder".}
proc remove_shortcut_folder*(chooser: PFileChooser,
    folder: cstring, error: pointer): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_file_chooser_remove_shortcut_folder".}
proc list_shortcut_folders*(chooser: PFileChooser): PGSList{.cdecl,
    dynlib: lib, importc: "gtk_file_chooser_list_shortcut_folders".}
proc add_shortcut_folder_uri*(chooser: PFileChooser, uri: cstring,
    error: pointer): gboolean{.cdecl, dynlib: lib, importc: "gtk_file_chooser_add_shortcut_folder_uri".}
proc remove_shortcut_folder_uri*(chooser: PFileChooser,
    uri: cstring, error: pointer): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_file_chooser_remove_shortcut_folder_uri".}
proc list_shortcut_folder_uris*(chooser: PFileChooser): PGSList{.
    cdecl, dynlib: lib, importc: "gtk_file_chooser_list_shortcut_folder_uris".}
proc set_do_overwrite_confirmation*(chooser: PFileChooser,
    do_overwrite_confirmation: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_file_chooser_set_do_overwrite_confirmation".}

