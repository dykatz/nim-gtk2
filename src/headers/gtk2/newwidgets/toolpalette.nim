# Generated from gtktoolpalette.h; included by headers/gtk2.nim.
proc tool_palette_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_type".}
proc tool_palette_new*(): ptr ToolPalette {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_new".}
proc tool_palette_set_group_position*(`palette`: ptr ToolPalette; `group`: ptr ToolItemGroup; `position`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_set_group_position".}
proc tool_palette_set_exclusive*(`palette`: ptr ToolPalette; `group`: ptr ToolItemGroup; `exclusive`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_set_exclusive".}
proc tool_palette_set_expand*(`palette`: ptr ToolPalette; `group`: ptr ToolItemGroup; `expand`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_set_expand".}
proc tool_palette_get_group_position*(`palette`: ptr ToolPalette; `group`: ptr ToolItemGroup): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_group_position".}
proc tool_palette_get_exclusive*(`palette`: ptr ToolPalette; `group`: ptr ToolItemGroup): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_exclusive".}
proc tool_palette_get_expand*(`palette`: ptr ToolPalette; `group`: ptr ToolItemGroup): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_expand".}
proc tool_palette_set_icon_size*(`palette`: ptr ToolPalette; `icon_size`: TIconSize) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_set_icon_size".}
proc tool_palette_unset_icon_size*(`palette`: ptr ToolPalette) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_unset_icon_size".}
proc tool_palette_set_style*(`palette`: ptr ToolPalette; `style`: TToolbarStyle) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_set_style".}
proc tool_palette_unset_style*(`palette`: ptr ToolPalette) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_unset_style".}
proc tool_palette_get_icon_size*(`palette`: ptr ToolPalette): TIconSize {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_icon_size".}
proc tool_palette_get_style*(`palette`: ptr ToolPalette): TToolbarStyle {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_style".}
proc tool_palette_get_drop_item*(`palette`: ptr ToolPalette; `x`: gint; `y`: gint): ptr ToolItem {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_drop_item".}
proc tool_palette_get_drop_group*(`palette`: ptr ToolPalette; `x`: gint; `y`: gint): ptr ToolItemGroup {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_drop_group".}
proc tool_palette_get_drag_item*(`palette`: ptr ToolPalette; `selection`: ptr TSelectionData): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_drag_item".}
proc tool_palette_set_drag_source*(`palette`: ptr ToolPalette; `targets`: ToolPaletteDragTargets) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_set_drag_source".}
proc tool_palette_add_drag_dest*(`palette`: ptr ToolPalette; `widget`: ptr TWidget; `flags`: TDestDefaults; `targets`: ToolPaletteDragTargets; `actions`: gdk2.TDragAction) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_add_drag_dest".}
proc tool_palette_get_hadjustment*(`palette`: ptr ToolPalette): ptr TAdjustment {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_hadjustment".}
proc tool_palette_get_vadjustment*(`palette`: ptr ToolPalette): ptr TAdjustment {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_vadjustment".}
proc tool_palette_get_drag_target_item*(): ptr TTargetEntry {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_drag_target_item".}
proc tool_palette_get_drag_target_group*(): ptr TTargetEntry {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_palette_get_drag_target_group".}
