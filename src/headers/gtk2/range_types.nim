# Included by headers/gtk2.nim; do not import directly.
type
  PRangeLayout* = pointer
  PRangeStepTimer* = pointer
  TRange* = object of TWidget
    adjustment*: PAdjustment
    update_policy*: TUpdateType
    Range_flag0*: guint16
    min_slider_size*: gint
    orientation*: TOrientation
    range_rect*: gdk2.TRectangle
    slider_start*: gint
    slider_end*: gint
    round_digits*: gint
    flag1*: guint16
    layout*: PRangeLayout
    timer*: PRangeStepTimer
    slide_initial_slider_position*: gint
    slide_initial_coordinate*: gint
    update_timeout_id*: guint
    event_window*: gdk2.PWindow

  PRange* = ptr TRange
