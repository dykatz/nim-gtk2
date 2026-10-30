# Included by headers/gtk2.nim; do not import directly.
type
  TCellRendererToggle* = object of TCellRenderer
    CellRendererToggle_flag0*: guint16

  PCellRendererToggle* = ptr TCellRendererToggle
