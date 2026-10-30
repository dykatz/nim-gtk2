# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SCROLLED_WINDOW*(): GType =
  result = scrolled_window_get_type()

proc SCROLLED_WINDOW*(obj: pointer): PScrolledWindow =
  result = cast[PScrolledWindow](CHECK_CAST(obj, TYPE_SCROLLED_WINDOW()))

proc SCROLLED_WINDOW_CLASS*(klass: pointer): PScrolledWindowClass =
  result = cast[PScrolledWindowClass](CHECK_CLASS_CAST(klass,
      TYPE_SCROLLED_WINDOW()))

proc IS_SCROLLED_WINDOW*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_SCROLLED_WINDOW())

proc IS_SCROLLED_WINDOW_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_SCROLLED_WINDOW())

proc SCROLLED_WINDOW_GET_CLASS*(obj: pointer): PScrolledWindowClass =
  result = cast[PScrolledWindowClass](CHECK_GET_CLASS(obj,
      TYPE_SCROLLED_WINDOW()))

proc hscrollbar_policy*(a: PScrolledWindow): guint =
  result = (a.Scrolledwindow_flag0 and bm_TGtkScrolledWindow_hscrollbar_policy) shr
      bp_TGtkScrolledWindow_hscrollbar_policy

proc set_hscrollbar_policy*(a: PScrolledWindow, `hscrollbar_policy`: guint) =
  a.Scrolledwindow_flag0 = a.Scrolledwindow_flag0 or
      (uint16(`hscrollbar_policy` shl bp_TGtkScrolledWindow_hscrollbar_policy) and
      bm_TGtkScrolledWindow_hscrollbar_policy)

proc vscrollbar_policy*(a: PScrolledWindow): guint =
  result = (a.Scrolledwindow_flag0 and bm_TGtkScrolledWindow_vscrollbar_policy) shr
      bp_TGtkScrolledWindow_vscrollbar_policy

proc set_vscrollbar_policy*(a: PScrolledWindow, `vscrollbar_policy`: guint) =
  a.Scrolledwindow_flag0 = a.Scrolledwindow_flag0 or
      (uint16(`vscrollbar_policy` shl bp_TGtkScrolledWindow_vscrollbar_policy) and
      bm_TGtkScrolledWindow_vscrollbar_policy)

proc hscrollbar_visible*(a: PScrolledWindow): guint =
  result = (a.Scrolledwindow_flag0 and
      bm_TGtkScrolledWindow_hscrollbar_visible) shr
      bp_TGtkScrolledWindow_hscrollbar_visible

proc set_hscrollbar_visible*(a: PScrolledWindow, `hscrollbar_visible`: guint) =
  a.Scrolledwindow_flag0 = a.Scrolledwindow_flag0 or
      (uint16(`hscrollbar_visible` shl
      bp_TGtkScrolledWindow_hscrollbar_visible) and
      bm_TGtkScrolledWindow_hscrollbar_visible)

proc vscrollbar_visible*(a: PScrolledWindow): guint =
  result = (a.Scrolledwindow_flag0 and
      bm_TGtkScrolledWindow_vscrollbar_visible) shr
      bp_TGtkScrolledWindow_vscrollbar_visible

proc set_vscrollbar_visible*(a: PScrolledWindow, `vscrollbar_visible`: guint) =
  a.Scrolledwindow_flag0 = a.Scrolledwindow_flag0 or
      uint16((`vscrollbar_visible` shl
      bp_TGtkScrolledWindow_vscrollbar_visible) and
      bm_TGtkScrolledWindow_vscrollbar_visible)

proc window_placement*(a: PScrolledWindow): guint =
  result = (a.Scrolledwindow_flag0 and bm_TGtkScrolledWindow_window_placement) shr
      bp_TGtkScrolledWindow_window_placement

proc set_window_placement*(a: PScrolledWindow, `window_placement`: guint) =
  a.Scrolledwindow_flag0 = a.Scrolledwindow_flag0 or
      (uint16(`window_placement` shl bp_TGtkScrolledWindow_window_placement) and
      bm_TGtkScrolledWindow_window_placement)

proc focus_out*(a: PScrolledWindow): guint =
  result = (a.Scrolledwindow_flag0 and bm_TGtkScrolledWindow_focus_out) shr
      bp_TGtkScrolledWindow_focus_out

proc set_focus_out*(a: PScrolledWindow, `focus_out`: guint) =
  a.Scrolledwindow_flag0 = a.Scrolledwindow_flag0 or
      (uint16(`focus_out` shl bp_TGtkScrolledWindow_focus_out) and
      bm_TGtkScrolledWindow_focus_out)

proc TYPE_SELECTION_DATA*(): GType =
  result = selection_data_get_type()

