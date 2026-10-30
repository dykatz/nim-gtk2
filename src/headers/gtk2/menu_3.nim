# Included by headers/gtk2.nim; do not import directly.
proc TYPE_MENU*(): GType =
  result = menu_get_type()

proc MENU*(obj: pointer): PMenu =
  result = cast[PMenu](CHECK_CAST(obj, TYPE_MENU()))

proc MENU_CLASS*(klass: pointer): PMenuClass =
  result = cast[PMenuClass](CHECK_CLASS_CAST(klass, TYPE_MENU()))

proc IS_MENU*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_MENU())

proc IS_MENU_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_MENU())

proc MENU_GET_CLASS*(obj: pointer): PMenuClass =
  result = cast[PMenuClass](CHECK_GET_CLASS(obj, TYPE_MENU()))

proc needs_destruction_ref_count*(a: PMenu): guint =
  result = (a.Menuflag0 and bm_TGtkMenu_needs_destruction_ref_count) shr
      bp_TGtkMenu_needs_destruction_ref_count

proc set_needs_destruction_ref_count*(a: PMenu,
                                      `needs_destruction_ref_count`: guint) =
  a.Menuflag0 = a.Menuflag0 or
      (uint16(`needs_destruction_ref_count` shl
      bp_TGtkMenu_needs_destruction_ref_count) and
      bm_TGtkMenu_needs_destruction_ref_count)

proc torn_off*(a: PMenu): guint =
  result = (a.Menuflag0 and bm_TGtkMenu_torn_off) shr bp_TGtkMenu_torn_off

proc set_torn_off*(a: PMenu, `torn_off`: guint) =
  a.Menuflag0 = a.Menuflag0 or
      (uint16(`torn_off` shl bp_TGtkMenu_torn_off) and bm_TGtkMenu_torn_off)

proc tearoff_active*(a: PMenu): guint =
  result = (a.Menuflag0 and bm_TGtkMenu_tearoff_active) shr
      bp_TGtkMenu_tearoff_active

proc set_tearoff_active*(a: PMenu, `tearoff_active`: guint) =
  a.Menuflag0 = a.Menuflag0 or
      (uint16(`tearoff_active` shl bp_TGtkMenu_tearoff_active) and
      bm_TGtkMenu_tearoff_active)

proc scroll_fast*(a: PMenu): guint =
  result = (a.Menuflag0 and bm_TGtkMenu_scroll_fast) shr
      bp_TGtkMenu_scroll_fast

proc set_scroll_fast*(a: PMenu, `scroll_fast`: guint) =
  a.Menuflag0 = a.Menuflag0 or
      (uint16(`scroll_fast` shl bp_TGtkMenu_scroll_fast) and
      bm_TGtkMenu_scroll_fast)

proc upper_arrow_visible*(a: PMenu): guint =
  result = (a.Menuflag0 and bm_TGtkMenu_upper_arrow_visible) shr
      bp_TGtkMenu_upper_arrow_visible

proc set_upper_arrow_visible*(a: PMenu, `upper_arrow_visible`: guint) =
  a.Menuflag0 = a.Menuflag0 or
      (uint16(`upper_arrow_visible` shl bp_TGtkMenu_upper_arrow_visible) and
      bm_TGtkMenu_upper_arrow_visible)

proc lower_arrow_visible*(a: PMenu): guint =
  result = (a.Menuflag0 and bm_TGtkMenu_lower_arrow_visible) shr
      bp_TGtkMenu_lower_arrow_visible

proc set_lower_arrow_visible*(a: PMenu, `lower_arrow_visible`: guint) =
  a.Menuflag0 = a.Menuflag0 or
      (uint16(`lower_arrow_visible` shl bp_TGtkMenu_lower_arrow_visible) and
      bm_TGtkMenu_lower_arrow_visible)

proc upper_arrow_prelight*(a: PMenu): guint =
  result = (a.Menuflag0 and bm_TGtkMenu_upper_arrow_prelight) shr
      bp_TGtkMenu_upper_arrow_prelight

proc set_upper_arrow_prelight*(a: PMenu, `upper_arrow_prelight`: guint) =
  a.Menuflag0 = a.Menuflag0 or
      (uint16(`upper_arrow_prelight` shl bp_TGtkMenu_upper_arrow_prelight) and
      bm_TGtkMenu_upper_arrow_prelight)

proc lower_arrow_prelight*(a: PMenu): guint =
  result = (a.Menuflag0 and bm_TGtkMenu_lower_arrow_prelight) shr
      bp_TGtkMenu_lower_arrow_prelight

proc set_lower_arrow_prelight*(a: PMenu, `lower_arrow_prelight`: guint) =
  a.Menuflag0 = a.Menuflag0 or
      (uint16(`lower_arrow_prelight` shl bp_TGtkMenu_lower_arrow_prelight) and
      bm_TGtkMenu_lower_arrow_prelight)

