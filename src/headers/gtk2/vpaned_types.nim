# Included by headers/gtk2.nim; do not import directly.
type
  TVPaned* = object of TPaned
  PVPaned* = ptr TVPaned
  TVPanedClass* = object of TPanedClass
  PVPanedClass* = ptr TVPanedClass
