# Generated from gtkrecentchoosermenu.h; included by headers/gtk2.nim.
proc recent_chooser_menu_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_menu_get_type".}
proc recent_chooser_menu_new*(): ptr RecentChooserMenu {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_menu_new".}
proc recent_chooser_menu_new_for_manager*(`manager`: ptr RecentManager): ptr RecentChooserMenu {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_menu_new_for_manager".}
proc recent_chooser_menu_get_show_numbers*(`menu`: ptr RecentChooserMenu): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_menu_get_show_numbers".}
proc recent_chooser_menu_set_show_numbers*(`menu`: ptr RecentChooserMenu; `show_numbers`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_menu_set_show_numbers".}
