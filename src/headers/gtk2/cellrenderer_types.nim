# Included by headers/gtk2.nim; do not import directly.
type
  TCellRendererState* = int32
  PCellRendererState* = ptr TCellRendererState
  TCellRendererMode* = enum
    CELL_RENDERER_MODE_INERT, CELL_RENDERER_MODE_ACTIVATABLE,
    CELL_RENDERER_MODE_EDITABLE
  PCellRendererMode* = ptr TCellRendererMode
  TCellRenderer* = object of TObject
    xalign*: gfloat
    yalign*: gfloat
    width*: gint
    height*: gint
    xpad*: guint16
    ypad*: guint16
    CellRenderer_flag0*: guint16

  PCellRenderer* = ptr TCellRenderer
