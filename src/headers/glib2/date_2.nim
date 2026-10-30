# Included by headers/glib2.nim; do not import directly.
proc g_date_new*(): PGDate{.cdecl, dynlib: gliblib, importc: "g_date_new".}
proc g_date_new_dmy*(day: TGDateDay, month: TGDateMonth, year: TGDateYear): PGDate{.
    cdecl, dynlib: gliblib, importc: "g_date_new_dmy".}
proc g_date_new_julian*(julian_day: guint32): PGDate{.cdecl, dynlib: gliblib,
    importc: "g_date_new_julian".}
proc free*(date: PGDate){.cdecl, dynlib: gliblib, importc: "g_date_free".}
proc valid*(date: PGDate): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_date_valid".}
proc g_date_valid_month*(month: TGDateMonth): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_date_valid_month".}
proc g_date_valid_year*(year: TGDateYear): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_date_valid_year".}
proc g_date_valid_weekday*(weekday: TGDateWeekday): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_date_valid_weekday".}
proc g_date_valid_julian*(julian_date: guint32): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_date_valid_julian".}
proc get_weekday*(date: PGDate): TGDateWeekday{.cdecl, dynlib: gliblib,
    importc: "g_date_get_weekday".}
proc get_month*(date: PGDate): TGDateMonth{.cdecl, dynlib: gliblib,
    importc: "g_date_get_month".}
proc get_year*(date: PGDate): TGDateYear{.cdecl, dynlib: gliblib,
    importc: "g_date_get_year".}
proc get_day*(date: PGDate): TGDateDay{.cdecl, dynlib: gliblib,
    importc: "g_date_get_day".}
proc get_julian*(date: PGDate): guint32{.cdecl, dynlib: gliblib,
    importc: "g_date_get_julian".}
proc get_day_of_year*(date: PGDate): guint{.cdecl, dynlib: gliblib,
    importc: "g_date_get_day_of_year".}
proc get_monday_week_of_year*(date: PGDate): guint{.cdecl,
    dynlib: gliblib, importc: "g_date_get_monday_week_of_year".}
proc get_sunday_week_of_year*(date: PGDate): guint{.cdecl,
    dynlib: gliblib, importc: "g_date_get_sunday_week_of_year".}
proc clear*(date: PGDate, n_dates: guint){.cdecl, dynlib: gliblib,
    importc: "g_date_clear".}
proc set_parse*(date: PGDate, str: cstring){.cdecl, dynlib: gliblib,
    importc: "g_date_set_parse".}
proc set_time*(date: PGDate, time: TGTime){.cdecl, dynlib: gliblib,
    importc: "g_date_set_time".}
proc set_month*(date: PGDate, month: TGDateMonth){.cdecl,
    dynlib: gliblib, importc: "g_date_set_month".}
proc set_day*(date: PGDate, day: TGDateDay){.cdecl, dynlib: gliblib,
    importc: "g_date_set_day".}
proc set_year*(date: PGDate, year: TGDateYear){.cdecl, dynlib: gliblib,
    importc: "g_date_set_year".}
proc set_dmy*(date: PGDate, day: TGDateDay, month: TGDateMonth,
                     y: TGDateYear){.cdecl, dynlib: gliblib,
                                     importc: "g_date_set_dmy".}
proc set_julian*(date: PGDate, julian_date: guint32){.cdecl,
    dynlib: gliblib, importc: "g_date_set_julian".}
proc is_first_of_month*(date: PGDate): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_date_is_first_of_month".}
proc is_last_of_month*(date: PGDate): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_date_is_last_of_month".}
proc add_days*(date: PGDate, n_days: guint){.cdecl, dynlib: gliblib,
    importc: "g_date_add_days".}
proc subtract_days*(date: PGDate, n_days: guint){.cdecl, dynlib: gliblib,
    importc: "g_date_subtract_days".}
proc add_months*(date: PGDate, n_months: guint){.cdecl, dynlib: gliblib,
    importc: "g_date_add_months".}
proc subtract_months*(date: PGDate, n_months: guint){.cdecl,
    dynlib: gliblib, importc: "g_date_subtract_months".}
proc add_years*(date: PGDate, n_years: guint){.cdecl, dynlib: gliblib,
    importc: "g_date_add_years".}
proc subtract_years*(date: PGDate, n_years: guint){.cdecl,
    dynlib: gliblib, importc: "g_date_subtract_years".}
proc g_date_is_leap_year*(year: TGDateYear): gboolean{.cdecl, dynlib: gliblib,
    importc: "g_date_is_leap_year".}
proc g_date_get_days_in_month*(month: TGDateMonth, year: TGDateYear): guint8{.
    cdecl, dynlib: gliblib, importc: "g_date_get_days_in_month".}
proc g_date_get_monday_weeks_in_year*(year: TGDateYear): guint8{.cdecl,
    dynlib: gliblib, importc: "g_date_get_monday_weeks_in_year".}
proc g_date_get_sunday_weeks_in_year*(year: TGDateYear): guint8{.cdecl,
    dynlib: gliblib, importc: "g_date_get_sunday_weeks_in_year".}
proc days_between*(date1: PGDate, date2: PGDate): gint{.cdecl,
    dynlib: gliblib, importc: "g_date_days_between".}
proc compare*(lhs: PGDate, rhs: PGDate): gint{.cdecl, dynlib: gliblib,
    importc: "g_date_compare".}
proc to_struct_tm*(date: PGDate, tm: Ptm){.cdecl, dynlib: gliblib,
    importc: "g_date_to_struct_tm".}
proc clamp*(date: PGDate, min_date: PGDate, max_date: PGDate){.cdecl,
    dynlib: gliblib, importc: "g_date_clamp".}
proc order*(date1: PGDate, date2: PGDate){.cdecl, dynlib: gliblib,
    importc: "g_date_order".}
proc g_date_strftime*(s: cstring, slen: gsize, format: cstring, date: PGDate): gsize{.
    cdecl, dynlib: gliblib, importc: "g_date_strftime".}
