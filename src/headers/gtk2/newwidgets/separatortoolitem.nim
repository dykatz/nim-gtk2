# Generated from gtkseparatortoolitem.h; included by headers/gtk2.nim.
proc separator_tool_item_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_separator_tool_item_get_type".}
proc separator_tool_item_new*(): ptr SeparatorToolItem {.cdecl, gcsafe, dynlib: lib, importc: "gtk_separator_tool_item_new".}
proc separator_tool_item_get_draw*(`item`: ptr SeparatorToolItem): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_separator_tool_item_get_draw".}
proc separator_tool_item_set_draw*(`item`: ptr SeparatorToolItem; `draw`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_separator_tool_item_set_draw".}
