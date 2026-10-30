# Generated from gtktoolbutton.h; included by headers/gtk2.nim.
proc tool_button_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_get_type".}
proc tool_button_new*(`icon_widget`: ptr TWidget; `label`: cstring): ptr ToolButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_new".}
proc tool_button_new_from_stock*(`stock_id`: cstring): ptr ToolButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_new_from_stock".}
proc tool_button_set_label*(`button`: ptr ToolButton; `label`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_set_label".}
proc tool_button_get_label*(`button`: ptr ToolButton): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_get_label".}
proc tool_button_set_use_underline*(`button`: ptr ToolButton; `use_underline`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_set_use_underline".}
proc tool_button_get_use_underline*(`button`: ptr ToolButton): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_get_use_underline".}
proc tool_button_set_stock_id*(`button`: ptr ToolButton; `stock_id`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_set_stock_id".}
proc tool_button_get_stock_id*(`button`: ptr ToolButton): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_get_stock_id".}
proc tool_button_set_icon_name*(`button`: ptr ToolButton; `icon_name`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_set_icon_name".}
proc tool_button_get_icon_name*(`button`: ptr ToolButton): cstring {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_get_icon_name".}
proc tool_button_set_icon_widget*(`button`: ptr ToolButton; `icon_widget`: ptr TWidget) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_set_icon_widget".}
proc tool_button_get_icon_widget*(`button`: ptr ToolButton): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_get_icon_widget".}
proc tool_button_set_label_widget*(`button`: ptr ToolButton; `label_widget`: ptr TWidget) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_set_label_widget".}
proc tool_button_get_label_widget*(`button`: ptr ToolButton): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_tool_button_get_label_widget".}
