# Included by headers/gtk2.nim; do not import directly.
proc info_bar_new*(): PInfoBar{.cdecl, dynlib: lib, importc: "gtk_info_bar_new".}
proc info_bar_new_with_buttons*(first_button_text: cstring): PInfoBar {.cdecl, dynlib:lib,
    varargs, importc: "gtk_info_bar_new_with_buttons".}
proc add_action_widget*(infobar: PInfoBar, child: PWidget, respID: gint) {.
    cdecl, dynlib: lib, importc: "gtk_info_bar_add_action_widget".}
proc add_button*(infobar: PInfoBar, btnText: cstring, respID: gint): PWidget{.
    cdecl, dynlib: lib, importc: "gtk_info_bar_add_button".}
proc set_response_sensitive*(infobar: PInfoBar, respID: gint, setting: gboolean){.
    cdecl, dynlib: lib, importc: "gtk_info_bar_set_response_sensitive".}
proc set_default_response*(infobar: PInfoBar, respID: gint){.cdecl,
    dynlib: lib, importc: "gtk_info_bar_set_default_response".}
proc response*(infobar: PInfoBar, respID: gint){.cdecl, dynlib: lib,
    importc: "gtk_info_bar_response".}
proc set_message_type*(infobar: PInfoBar, messageType: TMessageType){.cdecl,
    dynlib: lib, importc: "gtk_info_bar_set_message_type".}
proc get_message_type*(infobar: PInfoBar): TMessageType{.cdecl, dynlib: lib,
    importc: "gtk_info_bar_get_message_type".}
proc get_action_area*(infobar: PInfoBar): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_info_bar_get_action_area".}
proc get_content_area*(infobar: PInfoBar): PContainer{.cdecl, dynlib: lib,
    importc: "gtk_info_bar_get_content_area".}

