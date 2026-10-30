# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEXT_LAYOUT*(): GType =
  result = text_layout_get_type()

proc TEXT_LAYOUT*(obj: pointer): PTextLayout =
  result = cast[PTextLayout](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_TEXT_LAYOUT()))

proc TEXT_LAYOUT_CLASS*(klass: pointer): PTextLayoutClass =
  result = cast[PTextLayoutClass](G_TYPE_CHECK_CLASS_CAST(klass,
      TYPE_TEXT_LAYOUT()))

proc IS_TEXT_LAYOUT*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_TEXT_LAYOUT())

proc IS_TEXT_LAYOUT_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_TEXT_LAYOUT())

proc TEXT_LAYOUT_GET_CLASS*(obj: pointer): PTextLayoutClass =
  result = cast[PTextLayoutClass](G_TYPE_INSTANCE_GET_CLASS(obj,
      TYPE_TEXT_LAYOUT()))

proc cursor_visible*(a: PTextLayout): guint =
  result = (a.TextLayoutflag0 and bm_TGtkTextLayout_cursor_visible) shr
      bp_TGtkTextLayout_cursor_visible

proc set_cursor_visible*(a: PTextLayout, `cursor_visible`: guint) =
  a.TextLayoutflag0 = a.TextLayoutflag0 or
      (uint16(`cursor_visible` shl bp_TGtkTextLayout_cursor_visible) and
      bm_TGtkTextLayout_cursor_visible)

proc cursor_direction*(a: PTextLayout): guint =
  result = (a.TextLayoutflag0 and bm_TGtkTextLayout_cursor_direction) shr
      bp_TGtkTextLayout_cursor_direction

