# Included by headers/gtk2.nim; do not import directly.
type
  TMenuItem* = object of TItem
    submenu*: PWidget
    event_window*: gdk2.PWindow
    toggle_size*: guint16
    accelerator_width*: guint16
    accel_path*: cstring
    MenuItem_flag0*: guint16
    timer*: guint

  PMenuItem* = ptr TMenuItem
