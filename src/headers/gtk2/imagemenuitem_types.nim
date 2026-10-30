# Included by headers/gtk2.nim; do not import directly.
type
  TImageMenuItem* = object of TMenuItem
    image*: PWidget

  PImageMenuItem* = ptr TImageMenuItem
