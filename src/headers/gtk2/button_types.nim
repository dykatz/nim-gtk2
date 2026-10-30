# Included by headers/gtk2.nim; do not import directly.
type
  TButton* = object of TBin
    event_window*: gdk2.PWindow
    label_text*: cstring
    activate_timeout*: guint
    button_flag0*: guint16

  PButton* = ptr TButton
