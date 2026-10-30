# Included by headers/gtk2.nim; do not import directly.
type
  TToggleButton* = object of TButton
    ToggleButton_flag0*: guint16

  PToggleButton* = ptr TToggleButton
