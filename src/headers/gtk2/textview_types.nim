# Included by headers/gtk2.nim; do not import directly.
type
  PTextWindow* = pointer
  PTextPendingScroll* = pointer
  TTextWindowType* = enum
    TEXT_WINDOW_PRIVATE, TEXT_WINDOW_WIDGET, TEXT_WINDOW_TEXT, TEXT_WINDOW_LEFT,
    TEXT_WINDOW_RIGHT, TEXT_WINDOW_TOP, TEXT_WINDOW_BOTTOM
  PTextWindowType* = ptr TTextWindowType
  TTextView* = object of TContainer
    layout*: PTextLayout
    buffer*: PTextBuffer
    selection_drag_handler*: guint
    scroll_timeout*: guint
    pixels_above_lines*: gint
    pixels_below_lines*: gint
    pixels_inside_wrap*: gint
    wrap_mode*: TWrapMode
    justify*: TJustification
    left_margin*: gint
    right_margin*: gint
    indent*: gint
    tabs*: pango.PTabArray
    TextView_flag0*: guint16
    text_window*: PTextWindow
    left_window*: PTextWindow
    right_window*: PTextWindow
    top_window*: PTextWindow
    bottom_window*: PTextWindow
    hadjustment*: PAdjustment
    vadjustment*: PAdjustment
    xoffset*: gint
    yoffset*: gint
    width*: gint
    height*: gint
    virtual_cursor_x*: gint
    virtual_cursor_y*: gint
    first_para_mark*: PTextMark
    first_para_pixels*: gint
    dnd_mark*: PTextMark
    blink_timeout*: guint
    first_validate_idle*: guint
    incremental_validate_idle*: guint
    im_context*: PIMContext
    popup_menu*: PWidget
    drag_start_x*: gint
    drag_start_y*: gint
    children*: PGSList
    pending_scroll*: PTextPendingScroll
    pending_place_cursor_button*: gint

  PTextView* = ptr TTextView
  TTextViewClass* = object of TContainerClass
    set_scroll_adjustments*: proc (text_view: PTextView,
                                   hadjustment: PAdjustment,
                                   vadjustment: PAdjustment){.cdecl.}
    populate_popup*: proc (text_view: PTextView, menu: PMenu){.cdecl.}
    move_cursor*: proc (text_view: PTextView, step: TMovementStep, count: gint,
                        extend_selection: gboolean){.cdecl.}
    page_horizontally*: proc (text_view: PTextView, count: gint,
                              extend_selection: gboolean){.cdecl.}
    set_anchor*: proc (text_view: PTextView){.cdecl.}
    insert_at_cursor*: proc (text_view: PTextView, str: cstring){.cdecl.}
    delete_from_cursor*: proc (text_view: PTextView, thetype: TDeleteType,
                               count: gint){.cdecl.}
    cut_clipboard*: proc (text_view: PTextView){.cdecl.}
    copy_clipboard*: proc (text_view: PTextView){.cdecl.}
    paste_clipboard*: proc (text_view: PTextView){.cdecl.}
    toggle_overwrite*: proc (text_view: PTextView){.cdecl.}
    move_focus*: proc (text_view: PTextView, direction: TDirectionType){.cdecl.}
    reserved711: proc (){.cdecl.}
    reserved712: proc (){.cdecl.}
    reserved713: proc (){.cdecl.}
    reserved714: proc (){.cdecl.}
    reserved715: proc (){.cdecl.}
    reserved716: proc (){.cdecl.}
    reserved717: proc (){.cdecl.}
    reserved718: proc (){.cdecl.}

  PTextViewClass* = ptr TTextViewClass
