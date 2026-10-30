# Included by headers/gtk2.nim; do not import directly.
type
  TColorSelection* = object of TVBox
    private_data*: gpointer

  PColorSelection* = ptr TColorSelection
