# Included by headers/gtk2.nim; do not import directly.
type
  PMenu* = ptr TMenu
  TMenuPositionFunc* = proc (menu: PMenu, x: Pgint, y: Pgint,
                             push_in: Pgboolean, user_data: gpointer){.cdecl.}
  TMenu* = object of TMenuShell
    parent_menu_item*: PWidget
    old_active_menu_item*: PWidget
    accel_group*: PAccelGroup
    accel_path*: cstring
    position_func*: TMenuPositionFunc
    position_func_data*: gpointer
    toggle_size*: guint
    toplevel*: PWidget
    tearoff_window*: PWidget
    tearoff_hbox*: PWidget
    tearoff_scrollbar*: PWidget
    tearoff_adjustment*: PAdjustment
    view_window*: gdk2.PWindow
    bin_window*: gdk2.PWindow
    scroll_offset*: gint
    saved_scroll_offset*: gint
    scroll_step*: gint
    timeout_id*: guint
    navigation_region*: gdk2.PRegion
    navigation_timeout*: guint
    Menu_flag0*: guint16

  TMenuDetachFunc* = proc (attach_widget: PWidget, menu: PMenu){.cdecl.}
