# Generated from gtkfilechooserwidget.h; included by headers/gtk2.nim.
proc file_chooser_widget_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_file_chooser_widget_get_type".}
proc file_chooser_widget_new*(`action`: TFileChooserAction): ptr FileChooserWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_file_chooser_widget_new".}
