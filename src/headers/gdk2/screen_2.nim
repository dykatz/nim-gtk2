# Included by headers/gdk2.nim; do not import directly.
proc TYPE_SCREEN*(): GType
proc SCREEN*(anObject: pointer): PScreen
proc SCREEN_CLASS*(klass: pointer): PScreenClass
proc IS_SCREEN*(anObject: pointer): bool
proc IS_SCREEN_CLASS*(klass: pointer): bool
proc SCREEN_GET_CLASS*(obj: pointer): PScreenClass
proc get_default_colormap*(screen: PScreen): PColormap{.cdecl,
    dynlib: lib, importc: "gdk_screen_get_default_colormap".}
proc set_default_colormap*(screen: PScreen, colormap: PColormap){.cdecl,
    dynlib: lib, importc: "gdk_screen_set_default_colormap".}
proc get_system_colormap*(screen: PScreen): PColormap{.cdecl,
    dynlib: lib, importc: "gdk_screen_get_system_colormap".}
proc get_system_visual*(screen: PScreen): PVisual{.cdecl, dynlib: lib,
    importc: "gdk_screen_get_system_visual".}
proc get_rgb_colormap*(screen: PScreen): PColormap{.cdecl, dynlib: lib,
    importc: "gdk_screen_get_rgb_colormap".}
proc get_rgb_visual*(screen: PScreen): PVisual{.cdecl, dynlib: lib,
    importc: "gdk_screen_get_rgb_visual".}
proc get_root_window*(screen: PScreen): PWindow{.cdecl, dynlib: lib,
    importc: "gdk_screen_get_root_window".}
proc get_display*(screen: PScreen): PDisplay{.cdecl, dynlib: lib,
    importc: "gdk_screen_get_display".}
proc get_number*(screen: PScreen): gint{.cdecl, dynlib: lib,
    importc: "gdk_screen_get_number".}
proc get_window_at_pointer*(screen: PScreen, win_x: Pgint, win_y: Pgint): PWindow{.
    cdecl, dynlib: lib, importc: "gdk_screen_get_window_at_pointer".}
proc get_width*(screen: PScreen): gint{.cdecl, dynlib: lib,
    importc: "gdk_screen_get_width".}
proc get_height*(screen: PScreen): gint{.cdecl, dynlib: lib,
    importc: "gdk_screen_get_height".}
proc get_width_mm*(screen: PScreen): gint{.cdecl, dynlib: lib,
    importc: "gdk_screen_get_width_mm".}
proc get_height_mm*(screen: PScreen): gint{.cdecl, dynlib: lib,
    importc: "gdk_screen_get_height_mm".}
proc close*(screen: PScreen){.cdecl, dynlib: lib,
                                     importc: "gdk_screen_close".}
proc list_visuals*(screen: PScreen): PGList{.cdecl, dynlib: lib,
    importc: "gdk_screen_list_visuals".}
proc get_toplevel_windows*(screen: PScreen): PGList{.cdecl, dynlib: lib,
    importc: "gdk_screen_get_toplevel_windows".}
proc get_n_monitors*(screen: PScreen): gint{.cdecl, dynlib: lib,
    importc: "gdk_screen_get_n_monitors".}
proc get_monitor_geometry*(screen: PScreen, monitor_num: gint,
                                  dest: PRectangle){.cdecl, dynlib: lib,
    importc: "gdk_screen_get_monitor_geometry".}
proc get_monitor_at_point*(screen: PScreen, x: gint, y: gint): gint{.
    cdecl, dynlib: lib, importc: "gdk_screen_get_monitor_at_point".}
proc get_monitor_at_window*(screen: PScreen, window: PWindow): gint{.
    cdecl, dynlib: lib, importc: "gdk_screen_get_monitor_at_window".}
proc broadcast_client_message*(screen: PScreen, event: PEvent){.cdecl,
    dynlib: lib, importc: "gdk_screen_broadcast_client_message".}
proc get_default_screen*(): PScreen{.cdecl, dynlib: lib,
                                     importc: "gdk_screen_get_default".}
proc get_setting*(screen: PScreen, name: cstring, value: PGValue): gboolean{.
    cdecl, dynlib: lib, importc: "gdk_screen_get_setting".}
proc SELECTION_PRIMARY*(): TAtom
proc SELECTION_SECONDARY*(): TAtom
proc SELECTION_CLIPBOARD*(): TAtom
proc TARGET_BITMAP*(): TAtom
proc TARGET_COLORMAP*(): TAtom
proc TARGET_DRAWABLE*(): TAtom
proc TARGET_PIXMAP*(): TAtom
proc TARGET_STRING*(): TAtom
proc SELECTION_TYPE_ATOM*(): TAtom
proc SELECTION_TYPE_BITMAP*(): TAtom
proc SELECTION_TYPE_COLORMAP*(): TAtom
proc SELECTION_TYPE_DRAWABLE*(): TAtom
proc SELECTION_TYPE_INTEGER*(): TAtom
proc SELECTION_TYPE_PIXMAP*(): TAtom
proc SELECTION_TYPE_WINDOW*(): TAtom
proc SELECTION_TYPE_STRING*(): TAtom
