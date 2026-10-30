# Generated from gtktoolbar.h; included by headers/gtk2.nim.
proc toolbar_insert*(`toolbar`: ptr TToolbar; `item`: ptr ToolItem; `pos`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_insert".}
proc toolbar_get_item_index*(`toolbar`: ptr TToolbar; `item`: ptr ToolItem): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_get_item_index".}
proc toolbar_get_n_items*(`toolbar`: ptr TToolbar): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_get_n_items".}
proc toolbar_get_nth_item*(`toolbar`: ptr TToolbar; `n`: gint): ptr ToolItem {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_get_nth_item".}
proc toolbar_get_show_arrow*(`toolbar`: ptr TToolbar): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_get_show_arrow".}
proc toolbar_set_show_arrow*(`toolbar`: ptr TToolbar; `show_arrow`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_set_show_arrow".}
proc toolbar_get_style*(`toolbar`: ptr TToolbar): TToolbarStyle {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_get_style".}
proc toolbar_set_style*(`toolbar`: ptr TToolbar; `style`: TToolbarStyle) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_set_style".}
proc toolbar_unset_style*(`toolbar`: ptr TToolbar) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_unset_style".}
proc toolbar_get_icon_size*(`toolbar`: ptr TToolbar): TIconSize {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_get_icon_size".}
proc toolbar_set_icon_size*(`toolbar`: ptr TToolbar; `icon_size`: TIconSize) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_set_icon_size".}
proc toolbar_unset_icon_size*(`toolbar`: ptr TToolbar) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_unset_icon_size".}
proc toolbar_get_relief_style*(`toolbar`: ptr TToolbar): TReliefStyle {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_get_relief_style".}
proc toolbar_get_drop_index*(`toolbar`: ptr TToolbar; `x`: gint; `y`: gint): gint {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_get_drop_index".}
proc toolbar_set_drop_highlight_item*(`toolbar`: ptr TToolbar; `tool_item`: ptr ToolItem; `index`: gint) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toolbar_set_drop_highlight_item".}
