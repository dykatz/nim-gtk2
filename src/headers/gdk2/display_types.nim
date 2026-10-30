# Included by headers/gdk2.nim; do not import directly.
type
  TDisplay* = object of TGObject
    queued_events*: PGList
    queued_tail*: PGList
    button_click_time*: array[0..1, guint32]
    button_window*: array[0..1, PWindow]
    button_number*: array[0..1, guint]
    double_click_time*: guint

  PDisplay* = ptr TDisplay
  TDisplayClass* = object of TGObjectClass
    get_display_name*: proc (display: PDisplay): cstring{.cdecl.}
    get_n_screens*: proc (display: PDisplay): gint{.cdecl.}
    get_screen*: proc (display: PDisplay, screen_num: gint): PScreen{.cdecl.}
    get_default_screen*: proc (display: PDisplay): PScreen{.cdecl.}

  PDisplayClass* = ptr TDisplayClass
