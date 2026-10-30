# Generated from gtktoggletoolbutton.h; included by headers/gtk2.nim.
proc toggle_tool_button_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toggle_tool_button_get_type".}
proc toggle_tool_button_new*(): ptr ToggleToolButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toggle_tool_button_new".}
proc toggle_tool_button_new_from_stock*(`stock_id`: cstring): ptr ToggleToolButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toggle_tool_button_new_from_stock".}
proc toggle_tool_button_set_active*(`button`: ptr ToggleToolButton; `is_active`: gboolean) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toggle_tool_button_set_active".}
proc toggle_tool_button_get_active*(`button`: ptr ToggleToolButton): gboolean {.cdecl, gcsafe, dynlib: lib, importc: "gtk_toggle_tool_button_get_active".}
