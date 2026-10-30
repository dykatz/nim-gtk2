# Included by headers/gtk2.nim; do not import directly.
type
  TScrolledWindow* = object of TBin
    hscrollbar*: PWidget
    vscrollbar*: PWidget
    Scrolledwindow_flag0*: guint16
    shadow_type*: guint16

  PScrolledWindow* = ptr TScrolledWindow
