# Included by headers/gtk2.nim; do not import directly.
proc TYPE_EVENT_BOX*(): GType =
  result = event_box_get_type()

proc EVENT_BOX*(obj: pointer): PEventBox =
  result = cast[PEventBox](CHECK_CAST(obj, TYPE_EVENT_BOX()))

proc EVENT_BOX_CLASS*(klass: pointer): PEventBoxClass =
  result = cast[PEventBoxClass](CHECK_CLASS_CAST(klass, TYPE_EVENT_BOX()))

proc IS_EVENT_BOX*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_EVENT_BOX())

proc IS_EVENT_BOX_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_EVENT_BOX())

proc EVENT_BOX_GET_CLASS*(obj: pointer): PEventBoxClass =
  result = cast[PEventBoxClass](CHECK_GET_CLASS(obj, TYPE_EVENT_BOX()))

