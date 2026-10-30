# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ENTRY*(): GType =
  result = entry_get_type()

proc ENTRY*(obj: pointer): PEntry =
  result = cast[PEntry](CHECK_CAST(obj, TYPE_ENTRY()))

proc ENTRY_CLASS*(klass: pointer): PEntryClass =
  result = cast[PEntryClass](CHECK_CLASS_CAST(klass, TYPE_ENTRY()))

proc IS_ENTRY*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_ENTRY())

proc IS_ENTRY_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_ENTRY())

proc ENTRY_GET_CLASS*(obj: pointer): PEntryClass =
  result = cast[PEntryClass](CHECK_GET_CLASS(obj, TYPE_ENTRY()))

proc editable*(a: PEntry): guint =
  result = (a.Entryflag0 and bm_TGtkEntry_editable) shr bp_TGtkEntry_editable

proc set_editable*(a: PEntry, `editable`: guint) =
  a.Entryflag0 = a.Entryflag0 or
      (uint16(`editable` shl bp_TGtkEntry_editable) and bm_TGtkEntry_editable)

proc visible*(a: PEntry): guint =
  result = (a.Entryflag0 and bm_TGtkEntry_visible) shr bp_TGtkEntry_visible

proc set_visible*(a: PEntry, `visible`: guint) =
  a.Entryflag0 = a.Entryflag0 or
      (uint16(`visible` shl bp_TGtkEntry_visible) and bm_TGtkEntry_visible)

proc overwrite_mode*(a: PEntry): guint =
  result = (a.Entryflag0 and bm_TGtkEntry_overwrite_mode) shr
      bp_TGtkEntry_overwrite_mode

proc set_overwrite_mode*(a: PEntry, `overwrite_mode`: guint) =
  a.Entryflag0 = a.Entryflag0 or
      (uint16(`overwrite_mode` shl bp_TGtkEntry_overwrite_mode) and
      bm_TGtkEntry_overwrite_mode)

proc in_drag*(a: PEntry): guint =
  result = (a.Entryflag0 and bm_TGtkEntry_in_drag) shr bp_TGtkEntry_in_drag

proc set_in_drag*(a: PEntry, `in_drag`: guint) =
  a.Entryflag0 = a.Entryflag0 or
      (uint16(`in_drag` shl bp_TGtkEntry_in_drag) and bm_TGtkEntry_in_drag)

proc cache_includes_preedit*(a: PEntry): guint =
  result = (a.flag1 and bm_TGtkEntry_cache_includes_preedit) shr
      bp_TGtkEntry_cache_includes_preedit

proc set_cache_includes_preedit*(a: PEntry, `cache_includes_preedit`: guint) =
  a.flag1 = a.flag1 or
      (uint16(`cache_includes_preedit` shl bp_TGtkEntry_cache_includes_preedit) and
      bm_TGtkEntry_cache_includes_preedit)

proc need_im_reset*(a: PEntry): guint =
  result = (a.flag1 and bm_TGtkEntry_need_im_reset) shr
      bp_TGtkEntry_need_im_reset

proc set_need_im_reset*(a: PEntry, `need_im_reset`: guint) =
  a.flag1 = a.flag1 or
      (uint16(`need_im_reset` shl bp_TGtkEntry_need_im_reset) and
      bm_TGtkEntry_need_im_reset)

proc has_frame*(a: PEntry): guint =
  result = (a.flag1 and bm_TGtkEntry_has_frame) shr bp_TGtkEntry_has_frame

proc set_has_frame*(a: PEntry, `has_frame`: guint) =
  a.flag1 = a.flag1 or
      (uint16(`has_frame` shl bp_TGtkEntry_has_frame) and
      bm_TGtkEntry_has_frame)

proc activates_default*(a: PEntry): guint =
  result = (a.flag1 and bm_TGtkEntry_activates_default) shr
      bp_TGtkEntry_activates_default

proc set_activates_default*(a: PEntry, `activates_default`: guint) =
  a.flag1 = a.flag1 or
      (uint16(`activates_default` shl bp_TGtkEntry_activates_default) and
      bm_TGtkEntry_activates_default)

proc cursor_visible*(a: PEntry): guint =
  result = (a.flag1 and bm_TGtkEntry_cursor_visible) shr
      bp_TGtkEntry_cursor_visible

proc set_cursor_visible*(a: PEntry, `cursor_visible`: guint) =
  a.flag1 = a.flag1 or
      (uint16(`cursor_visible` shl bp_TGtkEntry_cursor_visible) and
      bm_TGtkEntry_cursor_visible)

proc in_click*(a: PEntry): guint =
  result = (a.flag1 and bm_TGtkEntry_in_click) shr bp_TGtkEntry_in_click

proc set_in_click*(a: PEntry, `in_click`: guint) =
  a.flag1 = a.flag1 or
      (uint16(`in_click` shl bp_TGtkEntry_in_click) and bm_TGtkEntry_in_click)

proc is_cell_renderer*(a: PEntry): guint =
  result = (a.flag1 and bm_TGtkEntry_is_cell_renderer) shr
      bp_TGtkEntry_is_cell_renderer

proc set_is_cell_renderer*(a: PEntry, `is_cell_renderer`: guint) =
  a.flag1 = a.flag1 or
      (uint16(`is_cell_renderer` shl bp_TGtkEntry_is_cell_renderer) and
      bm_TGtkEntry_is_cell_renderer)

proc editing_canceled*(a: PEntry): guint =
  result = (a.flag1 and bm_TGtkEntry_editing_canceled) shr
      bp_TGtkEntry_editing_canceled

proc set_editing_canceled*(a: PEntry, `editing_canceled`: guint) =
  a.flag1 = a.flag1 or
      (uint16(`editing_canceled` shl bp_TGtkEntry_editing_canceled) and
      bm_TGtkEntry_editing_canceled)

proc mouse_cursor_obscured*(a: PEntry): guint =
  result = (a.flag1 and bm_TGtkEntry_mouse_cursor_obscured) shr
      bp_TGtkEntry_mouse_cursor_obscured

proc set_mouse_cursor_obscured*(a: PEntry, `mouse_cursor_obscured`: guint) =
  a.flag1 = a.flag1 or
      (uint16(`mouse_cursor_obscured` shl bp_TGtkEntry_mouse_cursor_obscured) and
      bm_TGtkEntry_mouse_cursor_obscured)

