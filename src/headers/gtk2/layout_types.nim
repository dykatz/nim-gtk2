# Included by headers/gtk2.nim; do not import directly.
type
  TLayout* = object of TContainer
    children*: PGList
    width*: guint
    height*: guint
    hadjustment*: PAdjustment
    vadjustment*: PAdjustment
    bin_window*: gdk2.PWindow
    visibility*: gdk2.TVisibilityState
    scroll_x*: gint
    scroll_y*: gint
    freeze_count*: guint

  PLayout* = ptr TLayout
