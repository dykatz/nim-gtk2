# Generated from gtkrecentmanager.h; included by headers/gtk2.nim.
proc recent_manager_error_quark*(): TGQuark {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_error_quark".}
proc recent_manager_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_get_type".}
proc recent_manager_new*(): ptr RecentManager {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_new".}
proc recent_manager_get_default*(): ptr RecentManager {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_get_default".}
proc recent_manager_add_item*(`manager`: ptr RecentManager; `uri`: cstring): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_add_item".}
proc recent_manager_add_full*(`manager`: ptr RecentManager; `uri`: cstring; `recent_data`: ptr RecentData): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_add_full".}
proc recent_manager_remove_item*(`manager`: ptr RecentManager; `uri`: cstring; `error`: ptr ptr GError): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_remove_item".}
proc recent_manager_lookup_item*(`manager`: ptr RecentManager; `uri`: cstring; `error`: ptr ptr GError): ptr RecentInfo {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_lookup_item".}
proc recent_manager_has_item*(`manager`: ptr RecentManager; `uri`: cstring): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_has_item".}
proc recent_manager_move_item*(`manager`: ptr RecentManager; `uri`: cstring; `new_uri`: cstring; `error`: ptr ptr GError): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_move_item".}
proc recent_manager_set_limit*(`manager`: ptr RecentManager; `limit`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_set_limit".}
proc recent_manager_get_limit*(`manager`: ptr RecentManager): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_get_limit".}
proc recent_manager_get_items*(`manager`: ptr RecentManager): ptr TGList {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_get_items".}
proc recent_manager_purge_items*(`manager`: ptr RecentManager; `error`: ptr ptr GError): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_manager_purge_items".}
proc recent_info_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_get_type".}
proc recent_info_ref*(`info`: ptr RecentInfo): ptr RecentInfo {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_ref".}
proc recent_info_unref*(`info`: ptr RecentInfo) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_unref".}
proc recent_info_get_uri*(`info`: ptr RecentInfo): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_get_uri".}
proc recent_info_get_display_name*(`info`: ptr RecentInfo): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_get_display_name".}
proc recent_info_get_description*(`info`: ptr RecentInfo): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_get_description".}
proc recent_info_get_mime_type*(`info`: ptr RecentInfo): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_get_mime_type".}
proc recent_info_get_private_hint*(`info`: ptr RecentInfo): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_get_private_hint".}
proc recent_info_get_applications*(`info`: ptr RecentInfo; `length`: ptr gsize): ptr cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_get_applications".}
proc recent_info_last_application*(`info`: ptr RecentInfo): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_last_application".}
proc recent_info_has_application*(`info`: ptr RecentInfo; `app_name`: cstring): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_has_application".}
proc recent_info_get_groups*(`info`: ptr RecentInfo; `length`: ptr gsize): ptr cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_get_groups".}
proc recent_info_has_group*(`info`: ptr RecentInfo; `group_name`: cstring): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_has_group".}
proc recent_info_get_icon*(`info`: ptr RecentInfo; `size`: gint): gdk2pixbuf.PPixbuf {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_get_icon".}
proc recent_info_get_short_name*(`info`: ptr RecentInfo): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_get_short_name".}
proc recent_info_get_uri_display*(`info`: ptr RecentInfo): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_get_uri_display".}
proc recent_info_get_age*(`info`: ptr RecentInfo): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_get_age".}
proc recent_info_is_local*(`info`: ptr RecentInfo): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_is_local".}
proc recent_info_exists*(`info`: ptr RecentInfo): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_exists".}
proc recent_info_match*(`info_a`: ptr RecentInfo; `info_b`: ptr RecentInfo): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_info_match".}
