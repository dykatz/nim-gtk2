# Generated from gtktoolitem.h; included by headers/gtk2.nim.
proc tool_item_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_type".}
proc tool_item_new*(): ptr ToolItem {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_new".}
proc tool_item_set_homogeneous*(`tool_item`: ptr ToolItem; `homogeneous`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_set_homogeneous".}
proc tool_item_get_homogeneous*(`tool_item`: ptr ToolItem): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_homogeneous".}
proc tool_item_set_expand*(`tool_item`: ptr ToolItem; `expand`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_set_expand".}
proc tool_item_get_expand*(`tool_item`: ptr ToolItem): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_expand".}
proc tool_item_set_tooltip_text*(`tool_item`: ptr ToolItem; `text`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_set_tooltip_text".}
proc tool_item_set_tooltip_markup*(`tool_item`: ptr ToolItem; `markup`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_set_tooltip_markup".}
proc tool_item_set_use_drag_window*(`tool_item`: ptr ToolItem; `use_drag_window`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_set_use_drag_window".}
proc tool_item_get_use_drag_window*(`tool_item`: ptr ToolItem): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_use_drag_window".}
proc tool_item_set_visible_horizontal*(`tool_item`: ptr ToolItem; `visible_horizontal`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_set_visible_horizontal".}
proc tool_item_get_visible_horizontal*(`tool_item`: ptr ToolItem): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_visible_horizontal".}
proc tool_item_set_visible_vertical*(`tool_item`: ptr ToolItem; `visible_vertical`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_set_visible_vertical".}
proc tool_item_get_visible_vertical*(`tool_item`: ptr ToolItem): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_visible_vertical".}
proc tool_item_get_is_important*(`tool_item`: ptr ToolItem): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_is_important".}
proc tool_item_set_is_important*(`tool_item`: ptr ToolItem; `is_important`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_set_is_important".}
proc tool_item_get_ellipsize_mode*(`tool_item`: ptr ToolItem): EllipsizeMode {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_ellipsize_mode".}
proc tool_item_get_icon_size*(`tool_item`: ptr ToolItem): TIconSize {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_icon_size".}
proc tool_item_get_orientation*(`tool_item`: ptr ToolItem): TOrientation {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_orientation".}
proc tool_item_get_toolbar_style*(`tool_item`: ptr ToolItem): TToolbarStyle {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_toolbar_style".}
proc tool_item_get_relief_style*(`tool_item`: ptr ToolItem): TReliefStyle {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_relief_style".}
proc tool_item_get_text_alignment*(`tool_item`: ptr ToolItem): gfloat {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_text_alignment".}
proc tool_item_get_text_orientation*(`tool_item`: ptr ToolItem): TOrientation {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_text_orientation".}
proc tool_item_get_text_size_group*(`tool_item`: ptr ToolItem): ptr TSizeGroup {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_text_size_group".}
proc tool_item_retrieve_proxy_menu_item*(`tool_item`: ptr ToolItem): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_retrieve_proxy_menu_item".}
proc tool_item_get_proxy_menu_item*(`tool_item`: ptr ToolItem; `menu_item_id`: cstring): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_get_proxy_menu_item".}
proc tool_item_set_proxy_menu_item*(`tool_item`: ptr ToolItem; `menu_item_id`: cstring; `menu_item`: ptr TWidget) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_set_proxy_menu_item".}
proc tool_item_rebuild_menu*(`tool_item`: ptr ToolItem) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_rebuild_menu".}
proc tool_item_toolbar_reconfigured*(`tool_item`: ptr ToolItem) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_item_toolbar_reconfigured".}
