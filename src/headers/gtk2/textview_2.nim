# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEXT_VIEW*(): GType =
  result = text_view_get_type()

proc TEXT_VIEW*(obj: pointer): PTextView =
  result = cast[PTextView](CHECK_CAST(obj, TYPE_TEXT_VIEW()))

proc TEXT_VIEW_CLASS*(klass: pointer): PTextViewClass =
  result = cast[PTextViewClass](CHECK_CLASS_CAST(klass, TYPE_TEXT_VIEW()))

proc IS_TEXT_VIEW*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_TEXT_VIEW())

proc IS_TEXT_VIEW_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_TEXT_VIEW())

proc TEXT_VIEW_GET_CLASS*(obj: pointer): PTextViewClass =
  result = cast[PTextViewClass](CHECK_GET_CLASS(obj, TYPE_TEXT_VIEW()))

proc editable*(a: PTextView): guint =
  result = (a.TextViewflag0 and bm_TGtkTextView_editable) shr
      bp_TGtkTextView_editable

proc set_editable*(a: PTextView, `editable`: guint) =
  a.TextViewflag0 = a.TextViewflag0 or
      (uint16(`editable` shl bp_TGtkTextView_editable) and
      bm_TGtkTextView_editable)

proc overwrite_mode*(a: PTextView): guint =
  result = (a.TextViewflag0 and bm_TGtkTextView_overwrite_mode) shr
      bp_TGtkTextView_overwrite_mode

proc set_overwrite_mode*(a: PTextView, `overwrite_mode`: guint) =
  a.TextViewflag0 = a.TextViewflag0 or
      (uint16(`overwrite_mode` shl bp_TGtkTextView_overwrite_mode) and
      bm_TGtkTextView_overwrite_mode)

proc cursor_visible*(a: PTextView): guint =
  result = (a.TextViewflag0 and bm_TGtkTextView_cursor_visible) shr
      bp_TGtkTextView_cursor_visible

proc set_cursor_visible*(a: PTextView, `cursor_visible`: guint) =
  a.TextViewflag0 = a.TextViewflag0 or
      (uint16(`cursor_visible` shl bp_TGtkTextView_cursor_visible) and
      bm_TGtkTextView_cursor_visible)

proc need_im_reset*(a: PTextView): guint =
  result = (a.TextViewflag0 and bm_TGtkTextView_need_im_reset) shr
      bp_TGtkTextView_need_im_reset

proc set_need_im_reset*(a: PTextView, `need_im_reset`: guint) =
  a.TextViewflag0 = a.TextViewflag0 or
      (uint16(`need_im_reset` shl bp_TGtkTextView_need_im_reset) and
      bm_TGtkTextView_need_im_reset)

proc just_selected_element*(a: PTextView): guint =
  result = (a.TextViewflag0 and bm_TGtkTextView_just_selected_element) shr
      bp_TGtkTextView_just_selected_element

proc set_just_selected_element*(a: PTextView, `just_selected_element`: guint) =
  a.TextViewflag0 = a.TextViewflag0 or
      (uint16(`just_selected_element` shl
      bp_TGtkTextView_just_selected_element) and
      bm_TGtkTextView_just_selected_element)

proc disable_scroll_on_focus*(a: PTextView): guint =
  result = (a.TextViewflag0 and bm_TGtkTextView_disable_scroll_on_focus) shr
      bp_TGtkTextView_disable_scroll_on_focus

proc set_disable_scroll_on_focus*(a: PTextView,
                                  `disable_scroll_on_focus`: guint) =
  a.TextViewflag0 = a.TextViewflag0 or
      (uint16(`disable_scroll_on_focus` shl
      bp_TGtkTextView_disable_scroll_on_focus) and
      bm_TGtkTextView_disable_scroll_on_focus)

proc onscreen_validated*(a: PTextView): guint =
  result = (a.TextViewflag0 and bm_TGtkTextView_onscreen_validated) shr
      bp_TGtkTextView_onscreen_validated

proc set_onscreen_validated*(a: PTextView, `onscreen_validated`: guint) =
  a.TextViewflag0 = a.TextViewflag0 or
      (uint16(`onscreen_validated` shl bp_TGtkTextView_onscreen_validated) and
      bm_TGtkTextView_onscreen_validated)

proc mouse_cursor_obscured*(a: PTextView): guint =
  result = (a.TextViewflag0 and bm_TGtkTextView_mouse_cursor_obscured) shr
      bp_TGtkTextView_mouse_cursor_obscured

proc set_mouse_cursor_obscured*(a: PTextView, `mouse_cursor_obscured`: guint) =
  a.TextViewflag0 = a.TextViewflag0 or
      (uint16(`mouse_cursor_obscured` shl
      bp_TGtkTextView_mouse_cursor_obscured) and
      bm_TGtkTextView_mouse_cursor_obscured)

