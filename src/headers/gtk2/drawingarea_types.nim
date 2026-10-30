# Included by headers/gtk2.nim; do not import directly.
type
  TDrawingArea* = object of TWidget
    draw_data*: gpointer

  PDrawingArea* = ptr TDrawingArea
