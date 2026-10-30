# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEXT_TAG*(): GType =
  result = text_tag_get_type()

proc TEXT_TAG*(obj: pointer): PTextTag =
  result = cast[PTextTag](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_TEXT_TAG()))

proc TEXT_TAG_CLASS*(klass: pointer): PTextTagClass =
  result = cast[PTextTagClass](G_TYPE_CHECK_CLASS_CAST(klass, TYPE_TEXT_TAG()))

proc IS_TEXT_TAG*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_TEXT_TAG())

proc IS_TEXT_TAG_CLASS*(klass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(klass, TYPE_TEXT_TAG())

proc TEXT_TAG_GET_CLASS*(obj: pointer): PTextTagClass =
  result = cast[PTextTagClass](G_TYPE_INSTANCE_GET_CLASS(obj, TYPE_TEXT_TAG()))

proc TYPE_TEXT_ATTRIBUTES*(): GType =
  result = text_attributes_get_type()

proc bg_color_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_bg_color_set) shr
      bp_TGtkTextTag_bg_color_set

proc set_bg_color_set*(a: PTextTag, `bg_color_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`bg_color_set` shl bp_TGtkTextTag_bg_color_set) and
      bm_TGtkTextTag_bg_color_set)

proc bg_stipple_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_bg_stipple_set) shr
      bp_TGtkTextTag_bg_stipple_set

proc set_bg_stipple_set*(a: PTextTag, `bg_stipple_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`bg_stipple_set` shl bp_TGtkTextTag_bg_stipple_set) and
      bm_TGtkTextTag_bg_stipple_set)

proc fg_color_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_fg_color_set) shr
      bp_TGtkTextTag_fg_color_set

proc set_fg_color_set*(a: PTextTag, `fg_color_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`fg_color_set` shl bp_TGtkTextTag_fg_color_set) and
      bm_TGtkTextTag_fg_color_set)

proc scale_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_scale_set) shr
      bp_TGtkTextTag_scale_set

proc set_scale_set*(a: PTextTag, `scale_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`scale_set` shl bp_TGtkTextTag_scale_set) and
      bm_TGtkTextTag_scale_set)

proc fg_stipple_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_fg_stipple_set) shr
      bp_TGtkTextTag_fg_stipple_set

proc set_fg_stipple_set*(a: PTextTag, `fg_stipple_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`fg_stipple_set` shl bp_TGtkTextTag_fg_stipple_set) and
      bm_TGtkTextTag_fg_stipple_set)

proc justification_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_justification_set) shr
      bp_TGtkTextTag_justification_set

proc set_justification_set*(a: PTextTag, `justification_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`justification_set` shl bp_TGtkTextTag_justification_set) and
      bm_TGtkTextTag_justification_set)

proc left_margin_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_left_margin_set) shr
      bp_TGtkTextTag_left_margin_set

proc set_left_margin_set*(a: PTextTag, `left_margin_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`left_margin_set` shl bp_TGtkTextTag_left_margin_set) and
      bm_TGtkTextTag_left_margin_set)

proc indent_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_indent_set) shr
      bp_TGtkTextTag_indent_set

proc set_indent_set*(a: PTextTag, `indent_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`indent_set` shl bp_TGtkTextTag_indent_set) and
      bm_TGtkTextTag_indent_set)

proc rise_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_rise_set) shr
      bp_TGtkTextTag_rise_set

proc set_rise_set*(a: PTextTag, `rise_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`rise_set` shl bp_TGtkTextTag_rise_set) and bm_TGtkTextTag_rise_set)

proc strikethrough_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_strikethrough_set) shr
      bp_TGtkTextTag_strikethrough_set

proc set_strikethrough_set*(a: PTextTag, `strikethrough_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`strikethrough_set` shl bp_TGtkTextTag_strikethrough_set) and
      bm_TGtkTextTag_strikethrough_set)

proc right_margin_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_right_margin_set) shr
      bp_TGtkTextTag_right_margin_set

proc set_right_margin_set*(a: PTextTag, `right_margin_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`right_margin_set` shl bp_TGtkTextTag_right_margin_set) and
      bm_TGtkTextTag_right_margin_set)

proc pixels_above_lines_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_pixels_above_lines_set) shr
      bp_TGtkTextTag_pixels_above_lines_set

proc set_pixels_above_lines_set*(a: PTextTag,
                                 `pixels_above_lines_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`pixels_above_lines_set` shl bp_TGtkTextTag_pixels_above_lines_set) and
      bm_TGtkTextTag_pixels_above_lines_set)

proc pixels_below_lines_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_pixels_below_lines_set) shr
      bp_TGtkTextTag_pixels_below_lines_set

proc set_pixels_below_lines_set*(a: PTextTag,
                                 `pixels_below_lines_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`pixels_below_lines_set` shl bp_TGtkTextTag_pixels_below_lines_set) and
      bm_TGtkTextTag_pixels_below_lines_set)

proc pixels_inside_wrap_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_pixels_inside_wrap_set) shr
      bp_TGtkTextTag_pixels_inside_wrap_set

proc set_pixels_inside_wrap_set*(a: PTextTag,
                                 `pixels_inside_wrap_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`pixels_inside_wrap_set` shl bp_TGtkTextTag_pixels_inside_wrap_set) and
      bm_TGtkTextTag_pixels_inside_wrap_set)

proc tabs_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_tabs_set) shr
      bp_TGtkTextTag_tabs_set

proc set_tabs_set*(a: PTextTag, `tabs_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`tabs_set` shl bp_TGtkTextTag_tabs_set) and bm_TGtkTextTag_tabs_set)

proc underline_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_underline_set) shr
      bp_TGtkTextTag_underline_set

proc set_underline_set*(a: PTextTag, `underline_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`underline_set` shl bp_TGtkTextTag_underline_set) and
      bm_TGtkTextTag_underline_set)

proc wrap_mode_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_wrap_mode_set) shr
      bp_TGtkTextTag_wrap_mode_set

proc set_wrap_mode_set*(a: PTextTag, `wrap_mode_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`wrap_mode_set` shl bp_TGtkTextTag_wrap_mode_set) and
      bm_TGtkTextTag_wrap_mode_set)

proc bg_full_height_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_bg_full_height_set) shr
      bp_TGtkTextTag_bg_full_height_set

proc set_bg_full_height_set*(a: PTextTag, `bg_full_height_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`bg_full_height_set` shl bp_TGtkTextTag_bg_full_height_set) and
      bm_TGtkTextTag_bg_full_height_set)

proc invisible_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_invisible_set) shr
      bp_TGtkTextTag_invisible_set

proc set_invisible_set*(a: PTextTag, `invisible_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`invisible_set` shl bp_TGtkTextTag_invisible_set) and
      bm_TGtkTextTag_invisible_set)

proc editable_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_editable_set) shr
      bp_TGtkTextTag_editable_set

proc set_editable_set*(a: PTextTag, `editable_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`editable_set` shl bp_TGtkTextTag_editable_set) and
      bm_TGtkTextTag_editable_set)

proc language_set*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_language_set) shr
      bp_TGtkTextTag_language_set

proc set_language_set*(a: PTextTag, `language_set`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`language_set` shl bp_TGtkTextTag_language_set) and
      bm_TGtkTextTag_language_set)

proc pad1*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_pad1) shr bp_TGtkTextTag_pad1

proc set_pad1*(a: PTextTag, `pad1`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`pad1` shl bp_TGtkTextTag_pad1) and bm_TGtkTextTag_pad1)

proc pad2*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_pad2) shr bp_TGtkTextTag_pad2

proc set_pad2*(a: PTextTag, `pad2`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`pad2` shl bp_TGtkTextTag_pad2) and bm_TGtkTextTag_pad2)

proc pad3*(a: PTextTag): guint =
  result = (a.TextTagflag0 and bm_TGtkTextTag_pad3) shr bp_TGtkTextTag_pad3

proc set_pad3*(a: PTextTag, `pad3`: guint) =
  a.TextTagflag0 = a.TextTagflag0 or
      ((`pad3` shl bp_TGtkTextTag_pad3) and bm_TGtkTextTag_pad3)

proc underline*(a: PTextAppearance): guint =
  result = (a.flag0 and bm_TGtkTextAppearance_underline) shr
      bp_TGtkTextAppearance_underline

proc set_underline*(a: PTextAppearance, `underline`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`underline` shl bp_TGtkTextAppearance_underline) and
      bm_TGtkTextAppearance_underline)

proc strikethrough*(a: PTextAppearance): guint =
  result = (a.flag0 and bm_TGtkTextAppearance_strikethrough) shr
      bp_TGtkTextAppearance_strikethrough

proc set_strikethrough*(a: PTextAppearance, `strikethrough`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`strikethrough` shl bp_TGtkTextAppearance_strikethrough) and
      bm_TGtkTextAppearance_strikethrough)

proc draw_bg*(a: PTextAppearance): guint =
  result = (a.flag0 and bm_TGtkTextAppearance_draw_bg) shr
      bp_TGtkTextAppearance_draw_bg

proc set_draw_bg*(a: PTextAppearance, `draw_bg`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`draw_bg` shl bp_TGtkTextAppearance_draw_bg) and
      bm_TGtkTextAppearance_draw_bg)

proc inside_selection*(a: PTextAppearance): guint =
  result = (a.flag0 and bm_TGtkTextAppearance_inside_selection) shr
      bp_TGtkTextAppearance_inside_selection

proc set_inside_selection*(a: PTextAppearance, `inside_selection`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`inside_selection` shl bp_TGtkTextAppearance_inside_selection) and
      bm_TGtkTextAppearance_inside_selection)

proc set_is_text*(a: PTextAppearance, `is_text`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`is_text` shl bp_TGtkTextAppearance_is_text) and
      bm_TGtkTextAppearance_is_text)

proc pad1*(a: PTextAppearance): guint =
  result = (a.flag0 and bm_TGtkTextAppearance_pad1) shr
      bp_TGtkTextAppearance_pad1

proc set_pad1*(a: PTextAppearance, `pad1`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`pad1` shl bp_TGtkTextAppearance_pad1) and
      bm_TGtkTextAppearance_pad1)

proc pad2*(a: PTextAppearance): guint =
  result = (a.flag0 and bm_TGtkTextAppearance_pad2) shr
      bp_TGtkTextAppearance_pad2

proc set_pad2*(a: PTextAppearance, `pad2`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`pad2` shl bp_TGtkTextAppearance_pad2) and
      bm_TGtkTextAppearance_pad2)

proc pad3*(a: PTextAppearance): guint =
  result = (a.flag0 and bm_TGtkTextAppearance_pad3) shr
      bp_TGtkTextAppearance_pad3

proc set_pad3*(a: PTextAppearance, `pad3`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`pad3` shl bp_TGtkTextAppearance_pad3) and
      bm_TGtkTextAppearance_pad3)

proc pad4*(a: PTextAppearance): guint =
  result = (a.flag0 and bm_TGtkTextAppearance_pad4) shr
      bp_TGtkTextAppearance_pad4

proc set_pad4*(a: PTextAppearance, `pad4`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`pad4` shl bp_TGtkTextAppearance_pad4) and
      bm_TGtkTextAppearance_pad4)

proc invisible*(a: PTextAttributes): guint =
  result = (a.flag0 and bm_TGtkTextAttributes_invisible) shr
      bp_TGtkTextAttributes_invisible

proc set_invisible*(a: PTextAttributes, `invisible`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`invisible` shl bp_TGtkTextAttributes_invisible) and
      bm_TGtkTextAttributes_invisible)

proc bg_full_height*(a: PTextAttributes): guint =
  result = (a.flag0 and bm_TGtkTextAttributes_bg_full_height) shr
      bp_TGtkTextAttributes_bg_full_height

proc set_bg_full_height*(a: PTextAttributes, `bg_full_height`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`bg_full_height` shl bp_TGtkTextAttributes_bg_full_height) and
      bm_TGtkTextAttributes_bg_full_height)

proc editable*(a: PTextAttributes): guint =
  result = (a.flag0 and bm_TGtkTextAttributes_editable) shr
      bp_TGtkTextAttributes_editable

proc set_editable*(a: PTextAttributes, `editable`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`editable` shl bp_TGtkTextAttributes_editable) and
      bm_TGtkTextAttributes_editable)

proc realized*(a: PTextAttributes): guint =
  result = (a.flag0 and bm_TGtkTextAttributes_realized) shr
      bp_TGtkTextAttributes_realized

proc set_realized*(a: PTextAttributes, `realized`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`realized` shl bp_TGtkTextAttributes_realized) and
      bm_TGtkTextAttributes_realized)

proc pad1*(a: PTextAttributes): guint =
  result = (a.flag0 and bm_TGtkTextAttributes_pad1) shr
      bp_TGtkTextAttributes_pad1

proc set_pad1*(a: PTextAttributes, `pad1`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`pad1` shl bp_TGtkTextAttributes_pad1) and
      bm_TGtkTextAttributes_pad1)

proc pad2*(a: PTextAttributes): guint =
  result = (a.flag0 and bm_TGtkTextAttributes_pad2) shr
      bp_TGtkTextAttributes_pad2

proc set_pad2*(a: PTextAttributes, `pad2`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`pad2` shl bp_TGtkTextAttributes_pad2) and
      bm_TGtkTextAttributes_pad2)

proc pad3*(a: PTextAttributes): guint =
  result = (a.flag0 and bm_TGtkTextAttributes_pad3) shr
      bp_TGtkTextAttributes_pad3

proc set_pad3*(a: PTextAttributes, `pad3`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`pad3` shl bp_TGtkTextAttributes_pad3) and
      bm_TGtkTextAttributes_pad3)

proc pad4*(a: PTextAttributes): guint =
  result = (a.flag0 and bm_TGtkTextAttributes_pad4) shr
      bp_TGtkTextAttributes_pad4

proc set_pad4*(a: PTextAttributes, `pad4`: guint) =
  a.flag0 = a.flag0 or
      (uint16(`pad4` shl bp_TGtkTextAttributes_pad4) and
      bm_TGtkTextAttributes_pad4)

