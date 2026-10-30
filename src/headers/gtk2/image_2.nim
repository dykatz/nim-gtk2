# Included by headers/gtk2.nim; do not import directly.
proc TYPE_IMAGE*(): GType =
  result = gtk2.image_get_type()

proc IMAGE*(obj: pointer): PImage =
  result = cast[PImage](CHECK_CAST(obj, gtk2.TYPE_IMAGE()))

proc IMAGE_CLASS*(klass: pointer): PImageClass =
  result = cast[PImageClass](CHECK_CLASS_CAST(klass, gtk2.TYPE_IMAGE()))

proc IS_IMAGE*(obj: pointer): bool =
  result = CHECK_TYPE(obj, gtk2.TYPE_IMAGE())

proc IS_IMAGE_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, gtk2.TYPE_IMAGE())

proc IMAGE_GET_CLASS*(obj: pointer): PImageClass =
  result = cast[PImageClass](CHECK_GET_CLASS(obj, gtk2.TYPE_IMAGE()))

