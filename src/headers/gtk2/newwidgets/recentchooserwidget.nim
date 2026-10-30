# Generated from gtkrecentchooserwidget.h; included by headers/gtk2.nim.
proc recent_chooser_widget_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_widget_get_type".}
proc recent_chooser_widget_new*(): ptr RecentChooserWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_widget_new".}
proc recent_chooser_widget_new_for_manager*(`manager`: ptr RecentManager): ptr RecentChooserWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_widget_new_for_manager".}
