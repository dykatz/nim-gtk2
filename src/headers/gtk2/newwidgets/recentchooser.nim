# Generated from gtkrecentchooser.h; included by headers/gtk2.nim.
proc recent_chooser_error_quark*(): TGQuark {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_error_quark".}
proc recent_chooser_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_type".}
proc recent_chooser_set_show_private*(`chooser`: ptr RecentChooser; `show_private`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_set_show_private".}
proc recent_chooser_get_show_private*(`chooser`: ptr RecentChooser): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_show_private".}
proc recent_chooser_set_show_not_found*(`chooser`: ptr RecentChooser; `show_not_found`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_set_show_not_found".}
proc recent_chooser_get_show_not_found*(`chooser`: ptr RecentChooser): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_show_not_found".}
proc recent_chooser_set_select_multiple*(`chooser`: ptr RecentChooser; `select_multiple`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_set_select_multiple".}
proc recent_chooser_get_select_multiple*(`chooser`: ptr RecentChooser): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_select_multiple".}
proc recent_chooser_set_limit*(`chooser`: ptr RecentChooser; `limit`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_set_limit".}
proc recent_chooser_get_limit*(`chooser`: ptr RecentChooser): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_limit".}
proc recent_chooser_set_local_only*(`chooser`: ptr RecentChooser; `local_only`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_set_local_only".}
proc recent_chooser_get_local_only*(`chooser`: ptr RecentChooser): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_local_only".}
proc recent_chooser_set_show_tips*(`chooser`: ptr RecentChooser; `show_tips`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_set_show_tips".}
proc recent_chooser_get_show_tips*(`chooser`: ptr RecentChooser): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_show_tips".}
proc recent_chooser_set_show_icons*(`chooser`: ptr RecentChooser; `show_icons`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_set_show_icons".}
proc recent_chooser_get_show_icons*(`chooser`: ptr RecentChooser): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_show_icons".}
proc recent_chooser_set_sort_type*(`chooser`: ptr RecentChooser; `sort_type`: RecentSortType) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_set_sort_type".}
proc recent_chooser_get_sort_type*(`chooser`: ptr RecentChooser): RecentSortType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_sort_type".}
proc recent_chooser_set_sort_func*(`chooser`: ptr RecentChooser; `sort_func`: RecentSortFunc; `sort_data`: pointer; `data_destroy`: TGDestroyNotify) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_set_sort_func".}
proc recent_chooser_set_current_uri*(`chooser`: ptr RecentChooser; `uri`: cstring; `error`: ptr ptr GError): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_set_current_uri".}
proc recent_chooser_get_current_uri*(`chooser`: ptr RecentChooser): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_current_uri".}
proc recent_chooser_get_current_item*(`chooser`: ptr RecentChooser): ptr RecentInfo {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_current_item".}
proc recent_chooser_select_uri*(`chooser`: ptr RecentChooser; `uri`: cstring; `error`: ptr ptr GError): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_select_uri".}
proc recent_chooser_unselect_uri*(`chooser`: ptr RecentChooser; `uri`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_unselect_uri".}
proc recent_chooser_select_all*(`chooser`: ptr RecentChooser) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_select_all".}
proc recent_chooser_unselect_all*(`chooser`: ptr RecentChooser) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_unselect_all".}
proc recent_chooser_get_items*(`chooser`: ptr RecentChooser): ptr TGList {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_items".}
proc recent_chooser_get_uris*(`chooser`: ptr RecentChooser; `length`: ptr gsize): ptr cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_uris".}
proc recent_chooser_add_filter*(`chooser`: ptr RecentChooser; `filter`: ptr RecentFilter) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_add_filter".}
proc recent_chooser_remove_filter*(`chooser`: ptr RecentChooser; `filter`: ptr RecentFilter) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_remove_filter".}
proc recent_chooser_list_filters*(`chooser`: ptr RecentChooser): ptr TGSList {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_list_filters".}
proc recent_chooser_set_filter*(`chooser`: ptr RecentChooser; `filter`: ptr RecentFilter) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_set_filter".}
proc recent_chooser_get_filter*(`chooser`: ptr RecentChooser): ptr RecentFilter {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_chooser_get_filter".}
