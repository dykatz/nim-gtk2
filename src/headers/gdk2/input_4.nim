# Included by headers/gdk2.nim; do not import directly.
proc DEVICE*(anObject: pointer): PDevice =
  result = cast[PDevice](G_TYPE_CHECK_INSTANCE_CAST(anObject, TYPE_DEVICE()))

proc DEVICE_CLASS*(klass: pointer): PDeviceClass =
  result = cast[PDeviceClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_DEVICE()))

proc IS_DEVICE*(anObject: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(anObject, TYPE_DEVICE())

proc IS_DEVICE_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_DEVICE())

proc DEVICE_GET_CLASS*(obj: pointer): PDeviceClass =
  result = cast[PDeviceClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_DEVICE()))

proc TYPE_KEYMAP*(): GType =
  result = keymap_get_type()

