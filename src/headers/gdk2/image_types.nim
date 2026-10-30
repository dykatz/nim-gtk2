# Included by headers/gdk2.nim; do not import directly.
type
  TImageType* = enum
    IMAGE_NORMAL, IMAGE_SHARED, IMAGE_FASTEST
  PImageType* = ptr TImageType
  TImageClass* = object of TGObjectClass
  PImageClass* = ptr TImageClass
