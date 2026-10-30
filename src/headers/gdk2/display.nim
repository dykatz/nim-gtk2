# Included by headers/gdk2.nim; do not import directly.
proc TYPE_DISPLAY*(): GType
proc DISPLAY_OBJECT*(anObject: pointer): PDisplay
proc DISPLAY_CLASS*(klass: pointer): PDisplayClass
proc IS_DISPLAY*(anObject: pointer): bool
proc IS_DISPLAY_CLASS*(klass: pointer): bool
proc DISPLAY_GET_CLASS*(obj: pointer): PDisplayClass
proc display_open*(display_name: cstring): PDisplay{.cdecl, dynlib: lib,
    importc: "gdk_display_open".}
proc get_name*(display: PDisplay): cstring{.cdecl, dynlib: lib,
    importc: "gdk_display_get_name".}
proc get_n_screens*(display: PDisplay): gint{.cdecl, dynlib: lib,
    importc: "gdk_display_get_n_screens".}
proc get_screen*(display: PDisplay, screen_num: gint): PScreen{.cdecl,
    dynlib: lib, importc: "gdk_display_get_screen".}
proc get_default_screen*(display: PDisplay): PScreen{.cdecl,
    dynlib: lib, importc: "gdk_display_get_default_screen".}
proc pointer_ungrab*(display: PDisplay, time: guint32){.cdecl,
    dynlib: lib, importc: "gdk_display_pointer_ungrab".}
proc keyboard_ungrab*(display: PDisplay, time: guint32){.cdecl,
    dynlib: lib, importc: "gdk_display_keyboard_ungrab".}
proc pointer_is_grabbed*(display: PDisplay): gboolean{.cdecl,
    dynlib: lib, importc: "gdk_display_pointer_is_grabbed".}
proc beep*(display: PDisplay){.cdecl, dynlib: lib,
                                       importc: "gdk_display_beep".}
proc sync*(display: PDisplay){.cdecl, dynlib: lib,
                                       importc: "gdk_display_sync".}
proc close*(display: PDisplay){.cdecl, dynlib: lib,
                                        importc: "gdk_display_close".}
proc list_devices*(display: PDisplay): PGList{.cdecl, dynlib: lib,
    importc: "gdk_display_list_devices".}
proc get_event*(display: PDisplay): PEvent{.cdecl, dynlib: lib,
    importc: "gdk_display_get_event".}
proc peek_event*(display: PDisplay): PEvent{.cdecl, dynlib: lib,
    importc: "gdk_display_peek_event".}
proc put_event*(display: PDisplay, event: PEvent){.cdecl, dynlib: lib,
    importc: "gdk_display_put_event".}
proc add_client_message_filter*(display: PDisplay, message_type: TAtom,
                                        fn: TFilterFunc, data: gpointer){.
    cdecl, dynlib: lib, importc: "gdk_display_add_client_message_filter".}
proc set_double_click_time*(display: PDisplay, msec: guint){.cdecl,
    dynlib: lib, importc: "gdk_display_set_double_click_time".}
proc set_sm_client_id*(display: PDisplay, sm_client_id: cstring){.cdecl,
    dynlib: lib, importc: "gdk_display_set_sm_client_id".}
proc set_default_display*(display: PDisplay){.cdecl, dynlib: lib,
    importc: "gdk_set_default_display".}
proc get_default_display*(): PDisplay{.cdecl, dynlib: lib,
                                       importc: "gdk_display_get_default".}
