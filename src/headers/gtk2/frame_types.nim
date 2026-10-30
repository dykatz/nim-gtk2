# Included by headers/gtk2.nim; do not import directly.
type
  TFrame* = object of TBin
    label_widget*: PWidget
    shadow_type*: gint16
    label_xalign*: gfloat
    label_yalign*: gfloat
    child_allocation*: TAllocation

  PFrame* = ptr TFrame
