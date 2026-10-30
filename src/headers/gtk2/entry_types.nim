# Included by headers/gtk2.nim; do not import directly.
type
  TEntry* = object of TWidget
    text*: cstring
    Entry_flag0*: guint16
    text_length*: guint16
    text_max_length*: guint16
    text_area*: gdk2.PWindow
    im_context*: PIMContext
    popup_menu*: PWidget
    current_pos*: gint
    selection_bound*: gint
    cached_layout*: pango.PLayout
    flag1*: guint16
    button*: guint
    blink_timeout*: guint
    recompute_idle*: guint
    scroll_offset*: gint
    ascent*: gint
    descent*: gint
    text_size*: guint16
    n_bytes*: guint16
    preedit_length*: guint16
    preedit_cursor*: guint16
    dnd_position*: gint
    drag_start_x*: gint
    drag_start_y*: gint
    invisible_char*: gunichar
    width_chars*: gint

  PEntry* = ptr TEntry
