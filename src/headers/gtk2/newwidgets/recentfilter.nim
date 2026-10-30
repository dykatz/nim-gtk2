# Generated from gtkrecentfilter.h; included by headers/gtk2.nim.
proc recent_filter_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_get_type".}
proc recent_filter_new*(): ptr RecentFilter {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_new".}
proc recent_filter_set_name*(`filter`: ptr RecentFilter; `name`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_set_name".}
proc recent_filter_get_name*(`filter`: ptr RecentFilter): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_get_name".}
proc recent_filter_add_mime_type*(`filter`: ptr RecentFilter; `mime_type`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_add_mime_type".}
proc recent_filter_add_pattern*(`filter`: ptr RecentFilter; `pattern`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_add_pattern".}
proc recent_filter_add_pixbuf_formats*(`filter`: ptr RecentFilter) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_add_pixbuf_formats".}
proc recent_filter_add_application*(`filter`: ptr RecentFilter; `application`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_add_application".}
proc recent_filter_add_group*(`filter`: ptr RecentFilter; `group`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_add_group".}
proc recent_filter_add_age*(`filter`: ptr RecentFilter; `days`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_add_age".}
proc recent_filter_add_custom*(`filter`: ptr RecentFilter; `needed`: RecentFilterFlags; `func`: RecentFilterFunc; `data`: pointer; `data_destroy`: TGDestroyNotify) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_add_custom".}
proc recent_filter_get_needed*(`filter`: ptr RecentFilter): RecentFilterFlags {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_get_needed".}
proc recent_filter_filter*(`filter`: ptr RecentFilter; `filter_info`: ptr RecentFilterInfo): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_recent_filter_filter".}
