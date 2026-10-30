# Generated from gtkmenutoolbutton.h; included by headers/gtk2.nim.
proc menu_tool_button_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_menu_tool_button_get_type".}
proc menu_tool_button_new*(`icon_widget`: ptr TWidget; `label`: cstring): ptr MenuToolButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_menu_tool_button_new".}
proc menu_tool_button_new_from_stock*(`stock_id`: cstring): ptr MenuToolButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_menu_tool_button_new_from_stock".}
proc menu_tool_button_set_menu*(`button`: ptr MenuToolButton; `menu`: ptr TWidget) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_menu_tool_button_set_menu".}
proc menu_tool_button_get_menu*(`button`: ptr MenuToolButton): ptr TWidget {.cdecl, gcsafe, dynlib: lib, importc: "gtk_menu_tool_button_get_menu".}
proc menu_tool_button_set_arrow_tooltip_text*(`button`: ptr MenuToolButton; `text`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_menu_tool_button_set_arrow_tooltip_text".}
proc menu_tool_button_set_arrow_tooltip_markup*(`button`: ptr MenuToolButton; `markup`: cstring) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_menu_tool_button_set_arrow_tooltip_markup".}
