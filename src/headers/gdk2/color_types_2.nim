# Included by headers/gdk2.nim; do not import directly.
type
  TColormap* = object of TGObject
    size*: gint
    colors*: PColor
    visual*: PVisual
    windowing_data*: gpointer
    screen*: PScreen

  PColormap* = ptr TColormap
