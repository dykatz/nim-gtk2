# Included by headers/atk.nim; do not import directly.
proc TYPE_STATE_SET*(): GType =
  result = state_set_get_type()

proc STATE_SET*(obj: pointer): PStateSet =
  result = cast[PStateSet](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_STATE_SET()))

proc STATE_SET_CLASS*(klass: pointer): PStateSetClass =
  result = cast[PStateSetClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_STATE_SET()))

proc IS_STATE_SET*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_STATE_SET())

proc IS_STATE_SET_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_STATE_SET())

proc STATE_SET_GET_CLASS*(obj: pointer): PStateSetClass =
  result = cast[PStateSetClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_STATE_SET()))

