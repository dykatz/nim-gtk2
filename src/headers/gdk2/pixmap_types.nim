# Included by headers/gdk2.nim; do not import directly.
type
  TPixmapObject* = object of TDrawable
    impl*: PDrawable
    depth*: gint

  PPixmapObject* = ptr TPixmapObject
  TPixmapObjectClass* = object of TDrawableClass
  PPixmapObjectClass* = ptr TPixmapObjectClass
