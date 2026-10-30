# Included by headers/gtk2.nim; do not import directly.
type
  TPaned* = object of TContainer
    child1*: PWidget
    child2*: PWidget
    handle*: gdk2.PWindow
    xor_gc*: gdk2.PGC
    cursor_type*: gdk2.TCursorType
    handle_pos*: gdk2.TRectangle
    child1_size*: gint
    last_allocation*: gint
    min_position*: gint
    max_position*: gint
    Paned_flag0*: guint16
    last_child1_focus*: PWidget
    last_child2_focus*: PWidget
    saved_focus*: PWidget
    drag_pos*: gint
    original_position*: gint

  PPaned* = ptr TPaned
