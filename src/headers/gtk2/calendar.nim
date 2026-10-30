# Included by headers/gtk2.nim; do not import directly.
const
  CALENDAR_SHOW_HEADING* = 1 shl 0
const
  CALENDAR_SHOW_DAY_NAMES* = 1 shl 1
const
  CALENDAR_NO_MONTH_CHANGE* = 1 shl 2
const
  CALENDAR_SHOW_WEEK_NUMBERS* = 1 shl 3
const
  CALENDAR_WEEK_START_MONDAY* = 1 shl 4

proc TYPE_CALENDAR*(): GType
proc CALENDAR*(obj: pointer): PCalendar
proc CALENDAR_CLASS*(klass: pointer): PCalendarClass
proc IS_CALENDAR*(obj: pointer): bool
proc IS_CALENDAR_CLASS*(klass: pointer): bool
proc CALENDAR_GET_CLASS*(obj: pointer): PCalendarClass
proc calendar_get_type*(): TType{.cdecl, dynlib: lib,
                                  importc: "gtk_calendar_get_type".}
proc calendar_new*(): PCalendar{.cdecl, dynlib: lib, importc: "gtk_calendar_new".}
proc select_month*(calendar: PCalendar, month: guint, year: guint): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_calendar_select_month".}
proc select_day*(calendar: PCalendar, day: guint){.cdecl, dynlib: lib,
    importc: "gtk_calendar_select_day".}
proc mark_day*(calendar: PCalendar, day: guint): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_calendar_mark_day".}
proc unmark_day*(calendar: PCalendar, day: guint): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_calendar_unmark_day".}
proc clear_marks*(calendar: PCalendar){.cdecl, dynlib: lib,
    importc: "gtk_calendar_clear_marks".}
proc display_options*(calendar: PCalendar,
                               flags: TCalendarDisplayOptions){.cdecl,
    dynlib: lib, importc: "gtk_calendar_display_options".}
proc get_date*(calendar: PCalendar, year: Pguint, month: Pguint,
                        day: Pguint){.cdecl, dynlib: lib,
                                      importc: "gtk_calendar_get_date".}
proc freeze*(calendar: PCalendar){.cdecl, dynlib: lib,
    importc: "gtk_calendar_freeze".}
proc thaw*(calendar: PCalendar){.cdecl, dynlib: lib,
    importc: "gtk_calendar_thaw".}
