# Included by headers/atk.nim; do not import directly.
proc TYPE_IMAGE*(): GType =
  result = image_get_type()

proc IS_IMAGE*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_IMAGE())

proc IMAGE*(obj: pointer): PImage =
  result = cast[PImage](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_IMAGE()))

proc IMAGE_GET_IFACE*(obj: pointer): PImageIface =
  result = cast[PImageIface](G_TYPE_INSTANCE_GET_INTERFACE(obj, TYPE_IMAGE()))

