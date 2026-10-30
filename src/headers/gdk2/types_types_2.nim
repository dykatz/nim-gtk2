# Included by headers/gdk2.nim; do not import directly.
type
  TRegion*{.final, pure.} = object
    size*: int32
    numRects*: int32
    rects*: PRegionBox
    extents*: TRegionBox

  PRegion* = ptr TRegion
