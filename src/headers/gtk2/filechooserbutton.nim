# Included by headers/gtk2.nim; do not import directly.
proc file_chooser_button_get_type*():GType {.cdecl,
    importc: "gtk_file_chooser_button_get_type", dynlib: lib.}
proc file_chooser_button_new*(): PWidget {.cdecl,
    importc: "gtk_file_chooser_button_new", dynlib: lib.}
proc file_chooser_button_new_with_dialog*(dialog: PWidget): PWidget {.cdecl,
    importc: "gtk_file_chooser_button_new_with_dialog", dynlib: lib.}
proc file_chooser_button_get_title*(button: PFileChooserButton): cstring {.cdecl,
    importc: "gtk_file_chooser_button_get_title", dynlib: lib.}
proc file_chooser_button_set_title*(button: PFileChooserButton, title: cstring) {.cdecl,
    importc: "gtk_file_chooser_button_set_title", dynlib: lib.}
proc file_chooser_button_get_width_chars*(button: PFileChooserButton):gint {.cdecl,
    importc: "gtk_file_chooser_button_get_width_chars", dynlib: lib.}
proc file_chooser_button_set_width_chars*(button: PFileChooserButton,n_chars: gint) {.cdecl,
    importc: "gtk_file_chooser_button_set_width_chars", dynlib: lib.}
proc file_chooser_button_get_focus_on_click*(button: PFileChooserButton): gboolean {.cdecl,
    importc: "gtk_file_chooser_button_get_focus_on_click", dynlib: lib.}
proc file_chooser_button_set_focus_on_click*(button: PFileChooserButton,focus_on_click: gboolean) {.cdecl,
    importc: "gtk_file_chooser_button", dynlib: lib.}

proc TYPE_FILE_CHOOSER_BUTTON*(): GType =
  result = file_chooser_button_get_type()
proc FILE_CHOOSER_TYPE*(wid: pointer): GType =
  result = OBJECT_TYPE(wid)
proc `FILE_CHOOSER_BUTTON`*(anObject: pointer): PFileChooserButton =
  result = cast[PFileChooserButton](CHECK_CAST(anObject, TYPE_FILE_CHOOSER_BUTTON()))
proc FILE_CHOOSER_BUTTON_CLASS*(klass: pointer): PFileChooserButtonClass =
  result = cast[PFileChooserButtonClass](CHECK_CLASS_CAST(klass, TYPE_FILE_CHOOSER_BUTTON()))
proc IS_FILE_CHOOSER_BUTTON*(anObject: pointer): bool =
  result = CHECK_TYPE(anObject, TYPE_FILE_CHOOSER_BUTTON())
proc IS_FILE_CHOOSER_BUTTON_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_FILE_CHOOSER_BUTTON())
proc FILE_CHOOSER_BUTTON_GET_CLASS*(anObject: pointer): PFileChooserButtonClass =
  result = cast[PFileChooserButtonClass](CHECK_GET_CLASS(anObject, TYPE_FILE_CHOOSER_BUTTON()))

