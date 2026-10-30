# Included by headers/gdk2.nim; do not import directly.
proc TYPE_IMAGE*(): GType =
  result = image_get_type()

proc IMAGE*(anObject: pointer): PImage =
  result = cast[PImage](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_IMAGE()))

proc IMAGE_CLASS*(klass: pointer): PImageClass =
  result = cast[PImageClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_IMAGE()))

proc IS_IMAGE*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_IMAGE())

proc IS_IMAGE_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_IMAGE())

proc IMAGE_GET_CLASS*(obj: pointer): PImageClass =
  result = cast[PImageClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_IMAGE()))

proc destroy*(image: PImage) =
  g_object_unref(G_OBJECT(image))

proc TYPE_DEVICE*(): GType =
  result = device_get_type()

