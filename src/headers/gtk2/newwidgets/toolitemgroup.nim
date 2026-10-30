# Generated from gtktoolitemgroup.h; included by headers/gtk2.nim.
proc tool_item_group_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_get_type".}
proc tool_item_group_new*(`label`: cstring): ptr ToolItemGroup {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_new".}
proc tool_item_group_set_label*(`group`: ptr ToolItemGroup; `label`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_set_label".}
proc tool_item_group_set_label_widget*(`group`: ptr ToolItemGroup; `label_widget`: ptr TWidget) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_set_label_widget".}
proc tool_item_group_set_collapsed*(`group`: ptr ToolItemGroup; `collapsed`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_set_collapsed".}
proc tool_item_group_set_ellipsize*(`group`: ptr ToolItemGroup; `ellipsize`: EllipsizeMode) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_set_ellipsize".}
proc tool_item_group_set_header_relief*(`group`: ptr ToolItemGroup; `style`: TReliefStyle) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_set_header_relief".}
proc tool_item_group_get_label*(`group`: ptr ToolItemGroup): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_get_label".}
proc tool_item_group_get_label_widget*(`group`: ptr ToolItemGroup): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_get_label_widget".}
proc tool_item_group_get_collapsed*(`group`: ptr ToolItemGroup): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_get_collapsed".}
proc tool_item_group_get_ellipsize*(`group`: ptr ToolItemGroup): EllipsizeMode {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_get_ellipsize".}
proc tool_item_group_get_header_relief*(`group`: ptr ToolItemGroup): TReliefStyle {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_get_header_relief".}
proc tool_item_group_insert*(`group`: ptr ToolItemGroup; `item`: ptr ToolItem; `position`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_insert".}
proc tool_item_group_set_item_position*(`group`: ptr ToolItemGroup; `item`: ptr ToolItem; `position`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_set_item_position".}
proc tool_item_group_get_item_position*(`group`: ptr ToolItemGroup; `item`: ptr ToolItem): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_get_item_position".}
proc tool_item_group_get_n_items*(`group`: ptr ToolItemGroup): guint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_get_n_items".}
proc tool_item_group_get_nth_item*(`group`: ptr ToolItemGroup; `index`: guint): ptr ToolItem {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_get_nth_item".}
proc tool_item_group_get_drop_item*(`group`: ptr ToolItemGroup; `x`: gint; `y`: gint): ptr ToolItem {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_group_get_drop_item".}
