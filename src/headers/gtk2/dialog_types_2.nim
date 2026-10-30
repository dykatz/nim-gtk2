# Included by headers/gtk2.nim; do not import directly.
type
  TDialog* = object of TWindow
    vbox*: PBox
    action_area*: PWidget
    separator*: PWidget

  PDialog* = ptr TDialog
