# Included by headers/gtk2.nim; do not import directly.
type
  TCalendar* = object of TWidget
    header_style*: PStyle
    label_style*: PStyle
    month*: gint
    year*: gint
    selected_day*: gint
    day_month*: array[0..5, array[0..6, gint]]
    day*: array[0..5, array[0..6, gint]]
    num_marked_dates*: gint
    marked_date*: array[0..30, gint]
    display_flags*: TCalendarDisplayOptions
    marked_date_color*: array[0..30, gdk2.TColor]
    gc*: gdk2.PGC
    xor_gc*: gdk2.PGC
    focus_row*: gint
    focus_col*: gint
    highlight_row*: gint
    highlight_col*: gint
    private_data*: gpointer
    grow_space*: array[0..31, gchar]
    reserved111: proc (){.cdecl.}
    reserved112: proc (){.cdecl.}
    reserved113: proc (){.cdecl.}
    reserved114: proc (){.cdecl.}

  PCalendar* = ptr TCalendar
