# Included by headers/gtk2.nim; do not import directly.
type
  TCalendarClass* = object of TWidgetClass
    month_changed*: proc (calendar: PCalendar){.cdecl.}
    day_selected*: proc (calendar: PCalendar){.cdecl.}
    day_selected_double_click*: proc (calendar: PCalendar){.cdecl.}
    prev_month*: proc (calendar: PCalendar){.cdecl.}
    next_month*: proc (calendar: PCalendar){.cdecl.}
    prev_year*: proc (calendar: PCalendar){.cdecl.}
    next_year*: proc (calendar: PCalendar){.cdecl.}

  PCalendarClass* = ptr TCalendarClass
