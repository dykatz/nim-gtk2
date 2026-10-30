# Included by headers/gdk2.nim; do not import directly.
type
  TScreenClass* = object of TGObjectClass
    get_display*: proc (screen: PScreen): PDisplay{.cdecl.}
    get_width*: proc (screen: PScreen): gint{.cdecl.}
    get_height*: proc (screen: PScreen): gint{.cdecl.}
    get_width_mm*: proc (screen: PScreen): gint{.cdecl.}
    get_height_mm*: proc (screen: PScreen): gint{.cdecl.}
    get_root_depth*: proc (screen: PScreen): gint{.cdecl.}
    get_screen_num*: proc (screen: PScreen): gint{.cdecl.}
    get_root_window*: proc (screen: PScreen): PWindow{.cdecl.}
    get_default_colormap*: proc (screen: PScreen): PColormap{.cdecl.}
    set_default_colormap*: proc (screen: PScreen, colormap: PColormap){.cdecl.}
    get_window_at_pointer*: proc (screen: PScreen, win_x: Pgint, win_y: Pgint): PWindow{.
        cdecl.}
    get_n_monitors*: proc (screen: PScreen): gint{.cdecl.}
    get_monitor_geometry*: proc (screen: PScreen, monitor_num: gint,
                                 dest: PRectangle){.cdecl.}

  PScreenClass* = ptr TScreenClass
