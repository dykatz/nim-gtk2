# Included by headers/gtk2.nim; do not import directly.
type
  TColorSelectionDialog* = object of TDialog
    colorsel*: PWidget
    ok_button*: PWidget
    cancel_button*: PWidget
    help_button*: PWidget

  PColorSelectionDialog* = ptr TColorSelectionDialog
