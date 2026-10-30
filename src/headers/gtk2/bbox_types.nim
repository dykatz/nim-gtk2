# Included by headers/gtk2.nim; do not import directly.
type
  TButtonBox* = object of TBox
    child_min_width*: gint
    child_min_height*: gint
    child_ipad_x*: gint
    child_ipad_y*: gint
    layout_style*: TButtonBoxStyle

  PButtonBox* = ptr TButtonBox
