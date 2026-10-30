# Included by headers/gtk2.nim; do not import directly.
type
  TButtonsType* {.size: sizeof(cint).} = enum
    BUTTONS_NONE, BUTTONS_OK, BUTTONS_CLOSE, BUTTONS_CANCEL, BUTTONS_YES_NO,
    BUTTONS_OK_CANCEL
  PButtonsType* = ptr TButtonsType
  TMessageDialog* = object of TDialog
    image*: PWidget
    label*: PWidget

  PMessageDialog* = ptr TMessageDialog
