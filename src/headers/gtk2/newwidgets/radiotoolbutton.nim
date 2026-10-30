# Generated from gtkradiotoolbutton.h; included by headers/gtk2.nim.
proc radio_tool_button_get_type*(): GType {.cdecl, gcsafe, dynlib: lib, importc: "gtk_radio_tool_button_get_type".}
proc radio_tool_button_new*(`group`: ptr TGSList): ptr RadioToolButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_radio_tool_button_new".}
proc radio_tool_button_new_from_stock*(`group`: ptr TGSList; `stock_id`: cstring): ptr RadioToolButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_radio_tool_button_new_from_stock".}
proc radio_tool_button_new_from_widget*(`group`: ptr RadioToolButton): ptr RadioToolButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_radio_tool_button_new_from_widget".}
proc radio_tool_button_new_with_stock_from_widget*(`group`: ptr RadioToolButton; `stock_id`: cstring): ptr RadioToolButton {.cdecl, gcsafe, dynlib: lib, importc: "gtk_radio_tool_button_new_with_stock_from_widget".}
proc radio_tool_button_get_group*(`button`: ptr RadioToolButton): ptr TGSList {.cdecl, gcsafe, dynlib: lib, importc: "gtk_radio_tool_button_get_group".}
proc radio_tool_button_set_group*(`button`: ptr RadioToolButton; `group`: ptr TGSList) {.cdecl, gcsafe, dynlib: lib, importc: "gtk_radio_tool_button_set_group".}
