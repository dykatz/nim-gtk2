# Included by headers/gtk2.nim; do not import directly.
proc TYPE_CALENDAR*(): GType =
  result = calendar_get_type()

proc CALENDAR*(obj: pointer): PCalendar =
  result = cast[PCalendar](CHECK_CAST(obj, TYPE_CALENDAR()))

proc CALENDAR_CLASS*(klass: pointer): PCalendarClass =
  result = cast[PCalendarClass](CHECK_CLASS_CAST(klass, TYPE_CALENDAR()))

proc IS_CALENDAR*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_CALENDAR())

proc IS_CALENDAR_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_CALENDAR())

proc CALENDAR_GET_CLASS*(obj: pointer): PCalendarClass =
  result = cast[PCalendarClass](CHECK_GET_CLASS(obj, TYPE_CALENDAR()))

