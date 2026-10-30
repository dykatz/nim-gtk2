# Included by headers/gtk2.nim; do not import directly.
type
  THandleBox* = object of TBin
    bin_window*: gdk2.PWindow
    float_window*: gdk2.PWindow
    shadow_type*: TShadowType
    HandleBox_flag0*: guint16
    deskoff_x*: gint
    deskoff_y*: gint
    attach_allocation*: TAllocation
    float_allocation*: TAllocation

  PHandleBox* = ptr THandleBox
