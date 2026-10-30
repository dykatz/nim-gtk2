# Included by headers/gtk2.nim; do not import directly.
type
  TAspectFrame* = object of TFrame
    xalign*: gfloat
    yalign*: gfloat
    ratio*: gfloat
    obey_child*: gboolean
    center_allocation*: TAllocation

  PAspectFrame* = ptr TAspectFrame
