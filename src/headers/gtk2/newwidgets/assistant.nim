# Generated from gtkassistant.h; included by headers/gtk2.nim.
proc assistant_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_get_type".}
proc assistant_new*(): ptr Assistant {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_new".}
proc assistant_get_current_page*(`assistant`: ptr Assistant): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_get_current_page".}
proc assistant_set_current_page*(`assistant`: ptr Assistant; `page_num`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_set_current_page".}
proc assistant_get_n_pages*(`assistant`: ptr Assistant): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_get_n_pages".}
proc assistant_get_nth_page*(`assistant`: ptr Assistant; `page_num`: gint): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_get_nth_page".}
proc assistant_prepend_page*(`assistant`: ptr Assistant; `page`: ptr TWidget): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_prepend_page".}
proc assistant_append_page*(`assistant`: ptr Assistant; `page`: ptr TWidget): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_append_page".}
proc assistant_insert_page*(`assistant`: ptr Assistant; `page`: ptr TWidget; `position`: gint): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_insert_page".}
proc assistant_set_forward_page_func*(`assistant`: ptr Assistant; `page_func`: AssistantPageFunc; `data`: pointer; `destroy`: TGDestroyNotify) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_set_forward_page_func".}
proc assistant_set_page_type*(`assistant`: ptr Assistant; `page`: ptr TWidget; `type`: AssistantPageType) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_set_page_type".}
proc assistant_get_page_type*(`assistant`: ptr Assistant; `page`: ptr TWidget): AssistantPageType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_get_page_type".}
proc assistant_set_page_title*(`assistant`: ptr Assistant; `page`: ptr TWidget; `title`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_set_page_title".}
proc assistant_get_page_title*(`assistant`: ptr Assistant; `page`: ptr TWidget): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_get_page_title".}
proc assistant_set_page_header_image*(`assistant`: ptr Assistant; `page`: ptr TWidget; `pixbuf`: gdk2pixbuf.PPixbuf) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_set_page_header_image".}
proc assistant_get_page_header_image*(`assistant`: ptr Assistant; `page`: ptr TWidget): gdk2pixbuf.PPixbuf {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_get_page_header_image".}
proc assistant_set_page_side_image*(`assistant`: ptr Assistant; `page`: ptr TWidget; `pixbuf`: gdk2pixbuf.PPixbuf) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_set_page_side_image".}
proc assistant_get_page_side_image*(`assistant`: ptr Assistant; `page`: ptr TWidget): gdk2pixbuf.PPixbuf {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_get_page_side_image".}
proc assistant_set_page_complete*(`assistant`: ptr Assistant; `page`: ptr TWidget; `complete`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_set_page_complete".}
proc assistant_get_page_complete*(`assistant`: ptr Assistant; `page`: ptr TWidget): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_get_page_complete".}
proc assistant_add_action_widget*(`assistant`: ptr Assistant; `child`: ptr TWidget) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_add_action_widget".}
proc assistant_remove_action_widget*(`assistant`: ptr Assistant; `child`: ptr TWidget) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_remove_action_widget".}
proc assistant_update_buttons_state*(`assistant`: ptr Assistant) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_update_buttons_state".}
proc assistant_commit*(`assistant`: ptr Assistant) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_assistant_commit".}
