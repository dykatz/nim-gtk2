# Included by headers/gtk2.nim; do not import directly.
proc TYPE_TEXT_TAG*(): GType
proc TEXT_TAG*(obj: pointer): PTextTag
proc TEXT_TAG_CLASS*(klass: pointer): PTextTagClass
proc IS_TEXT_TAG*(obj: pointer): bool
proc IS_TEXT_TAG_CLASS*(klass: pointer): bool
proc TEXT_TAG_GET_CLASS*(obj: pointer): PTextTagClass
proc TYPE_TEXT_ATTRIBUTES*(): GType
proc text_tag_get_type*(): GType{.cdecl, dynlib: lib,
                                  importc: "gtk_text_tag_get_type".}
proc text_tag_new*(name: cstring): PTextTag{.cdecl, dynlib: lib,
    importc: "gtk_text_tag_new".}
proc get_priority*(tag: PTextTag): gint{.cdecl, dynlib: lib,
    importc: "gtk_text_tag_get_priority".}
proc set_priority*(tag: PTextTag, priority: gint){.cdecl, dynlib: lib,
    importc: "gtk_text_tag_set_priority".}
proc event*(tag: PTextTag, event_object: PGObject, event: gdk2.PEvent,
                     iter: PTextIter): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_text_tag_event".}
proc text_attributes_new*(): PTextAttributes{.cdecl, dynlib: lib,
    importc: "gtk_text_attributes_new".}
proc copy*(src: PTextAttributes): PTextAttributes{.cdecl,
    dynlib: lib, importc: "gtk_text_attributes_copy".}
proc copy_values*(src: PTextAttributes, dest: PTextAttributes){.
    cdecl, dynlib: lib, importc: "gtk_text_attributes_copy_values".}
proc unref*(values: PTextAttributes){.cdecl, dynlib: lib,
    importc: "gtk_text_attributes_unref".}
proc reference*(values: PTextAttributes){.cdecl, dynlib: lib,
    importc: "gtk_text_attributes_ref".}
proc text_attributes_get_type*(): GType{.cdecl, dynlib: lib,
    importc: "gtk_text_attributes_get_type".}
const
  bm_TGtkTextTag_bg_color_set* = 0x00000001'u32
const
  bp_TGtkTextTag_bg_color_set* = 0'u32
const
  bm_TGtkTextTag_bg_stipple_set* = 0x00000002'u32
const
  bp_TGtkTextTag_bg_stipple_set* = 1'u32
const
  bm_TGtkTextTag_fg_color_set* = 0x00000004'u32
const
  bp_TGtkTextTag_fg_color_set* = 2'u32
const
  bm_TGtkTextTag_scale_set* = 0x00000008'u32
const
  bp_TGtkTextTag_scale_set* = 3'u32
const
  bm_TGtkTextTag_fg_stipple_set* = 0x00000010'u32
const
  bp_TGtkTextTag_fg_stipple_set* = 4'u32
const
  bm_TGtkTextTag_justification_set* = 0x00000020'u32
const
  bp_TGtkTextTag_justification_set* = 5'u32
const
  bm_TGtkTextTag_left_margin_set* = 0x00000040'u32
const
  bp_TGtkTextTag_left_margin_set* = 6'u32
const
  bm_TGtkTextTag_indent_set* = 0x00000080'u32
const
  bp_TGtkTextTag_indent_set* = 7'u32
const
  bm_TGtkTextTag_rise_set* = 0x00000100'u32
const
  bp_TGtkTextTag_rise_set* = 8'u32
const
  bm_TGtkTextTag_strikethrough_set* = 0x00000200'u32
const
  bp_TGtkTextTag_strikethrough_set* = 9'u32
const
  bm_TGtkTextTag_right_margin_set* = 0x00000400'u32
const
  bp_TGtkTextTag_right_margin_set* = 10'u32
const
  bm_TGtkTextTag_pixels_above_lines_set* = 0x00000800'u32
const
  bp_TGtkTextTag_pixels_above_lines_set* = 11'u32
const
  bm_TGtkTextTag_pixels_below_lines_set* = 0x00001000'u32
const
  bp_TGtkTextTag_pixels_below_lines_set* = 12'u32
const
  bm_TGtkTextTag_pixels_inside_wrap_set* = 0x00002000'u32
const
  bp_TGtkTextTag_pixels_inside_wrap_set* = 13'u32
const
  bm_TGtkTextTag_tabs_set* = 0x00004000'u32
const
  bp_TGtkTextTag_tabs_set* = 14'u32
const
  bm_TGtkTextTag_underline_set* = 0x00008000'u32
const
  bp_TGtkTextTag_underline_set* = 15'u32
const
  bm_TGtkTextTag_wrap_mode_set* = 0x00010000'u32
const
  bp_TGtkTextTag_wrap_mode_set* = 16'u32
const
  bm_TGtkTextTag_bg_full_height_set* = 0x00020000'u32
const
  bp_TGtkTextTag_bg_full_height_set* = 17'u32
const
  bm_TGtkTextTag_invisible_set* = 0x00040000'u32
const
  bp_TGtkTextTag_invisible_set* = 18'u32
const
  bm_TGtkTextTag_editable_set* = 0x00080000'u32
const
  bp_TGtkTextTag_editable_set* = 19'u32
const
  bm_TGtkTextTag_language_set* = 0x00100000'u32
const
  bp_TGtkTextTag_language_set* = 20'u32
const
  bm_TGtkTextTag_pad1* = 0x00200000'u32
const
  bp_TGtkTextTag_pad1* = 21'u32
const
  bm_TGtkTextTag_pad2* = 0x00400000'u32
const
  bp_TGtkTextTag_pad2* = 22'u32
const
  bm_TGtkTextTag_pad3* = 0x00800000'u32
const
  bp_TGtkTextTag_pad3* = 23'u32

proc bg_color_set*(a: PTextTag): guint
proc set_bg_color_set*(a: PTextTag, `bg_color_set`: guint)
proc bg_stipple_set*(a: PTextTag): guint
proc set_bg_stipple_set*(a: PTextTag, `bg_stipple_set`: guint)
proc fg_color_set*(a: PTextTag): guint
proc set_fg_color_set*(a: PTextTag, `fg_color_set`: guint)
proc scale_set*(a: PTextTag): guint
proc set_scale_set*(a: PTextTag, `scale_set`: guint)
proc fg_stipple_set*(a: PTextTag): guint
proc set_fg_stipple_set*(a: PTextTag, `fg_stipple_set`: guint)
proc justification_set*(a: PTextTag): guint
proc set_justification_set*(a: PTextTag, `justification_set`: guint)
proc left_margin_set*(a: PTextTag): guint
proc set_left_margin_set*(a: PTextTag, `left_margin_set`: guint)
proc indent_set*(a: PTextTag): guint
proc set_indent_set*(a: PTextTag, `indent_set`: guint)
proc rise_set*(a: PTextTag): guint
proc set_rise_set*(a: PTextTag, `rise_set`: guint)
proc strikethrough_set*(a: PTextTag): guint
proc set_strikethrough_set*(a: PTextTag, `strikethrough_set`: guint)
proc right_margin_set*(a: PTextTag): guint
proc set_right_margin_set*(a: PTextTag, `right_margin_set`: guint)
proc pixels_above_lines_set*(a: PTextTag): guint
proc set_pixels_above_lines_set*(a: PTextTag,
                                 `pixels_above_lines_set`: guint)
proc pixels_below_lines_set*(a: PTextTag): guint
proc set_pixels_below_lines_set*(a: PTextTag,
                                 `pixels_below_lines_set`: guint)
proc pixels_inside_wrap_set*(a: PTextTag): guint
proc set_pixels_inside_wrap_set*(a: PTextTag,
                                 `pixels_inside_wrap_set`: guint)
proc tabs_set*(a: PTextTag): guint
proc set_tabs_set*(a: PTextTag, `tabs_set`: guint)
proc underline_set*(a: PTextTag): guint
proc set_underline_set*(a: PTextTag, `underline_set`: guint)
proc wrap_mode_set*(a: PTextTag): guint
proc set_wrap_mode_set*(a: PTextTag, `wrap_mode_set`: guint)
proc bg_full_height_set*(a: PTextTag): guint
proc set_bg_full_height_set*(a: PTextTag, `bg_full_height_set`: guint)
proc invisible_set*(a: PTextTag): guint
proc set_invisible_set*(a: PTextTag, `invisible_set`: guint)
proc editable_set*(a: PTextTag): guint
proc set_editable_set*(a: PTextTag, `editable_set`: guint)
proc language_set*(a: PTextTag): guint
proc set_language_set*(a: PTextTag, `language_set`: guint)
proc pad1*(a: PTextTag): guint
proc set_pad1*(a: PTextTag, `pad1`: guint)
proc pad2*(a: PTextTag): guint
proc set_pad2*(a: PTextTag, `pad2`: guint)
proc pad3*(a: PTextTag): guint
proc set_pad3*(a: PTextTag, `pad3`: guint)
const
  bm_TGtkTextAppearance_underline* = 0x000F'u16
const
  bp_TGtkTextAppearance_underline* = 0'u16
const
  bm_TGtkTextAppearance_strikethrough* = 0x0010'u16
const
  bp_TGtkTextAppearance_strikethrough* = 4'u16
const
  bm_TGtkTextAppearance_draw_bg* = 0x0020'u16
const
  bp_TGtkTextAppearance_draw_bg* = 5'u16
const
  bm_TGtkTextAppearance_inside_selection* = 0x0040'u16
const
  bp_TGtkTextAppearance_inside_selection* = 6'u16
const
  bm_TGtkTextAppearance_is_text* = 0x0080'u16
const
  bp_TGtkTextAppearance_is_text* = 7'u16
const
  bm_TGtkTextAppearance_pad1* = 0x0100'u16
const
  bp_TGtkTextAppearance_pad1* = 8'u16
const
  bm_TGtkTextAppearance_pad2* = 0x0200'u16
const
  bp_TGtkTextAppearance_pad2* = 9'u16
const
  bm_TGtkTextAppearance_pad3* = 0x0400'u16
const
  bp_TGtkTextAppearance_pad3* = 10'u16
const
  bm_TGtkTextAppearance_pad4* = 0x0800'u16
const
  bp_TGtkTextAppearance_pad4* = 11'u16

proc underline*(a: PTextAppearance): guint
proc set_underline*(a: PTextAppearance, `underline`: guint)
proc strikethrough*(a: PTextAppearance): guint
proc set_strikethrough*(a: PTextAppearance, `strikethrough`: guint)
proc draw_bg*(a: PTextAppearance): guint
proc set_draw_bg*(a: PTextAppearance, `draw_bg`: guint)
proc inside_selection*(a: PTextAppearance): guint
proc set_inside_selection*(a: PTextAppearance, `inside_selection`: guint)
proc set_is_text*(a: PTextAppearance, `is_text`: guint)
proc pad1*(a: PTextAppearance): guint
proc set_pad1*(a: PTextAppearance, `pad1`: guint)
proc pad2*(a: PTextAppearance): guint
proc set_pad2*(a: PTextAppearance, `pad2`: guint)
proc pad3*(a: PTextAppearance): guint
proc set_pad3*(a: PTextAppearance, `pad3`: guint)
proc pad4*(a: PTextAppearance): guint
proc set_pad4*(a: PTextAppearance, `pad4`: guint)
const
  bm_TGtkTextAttributes_invisible* = 0x0001'u16
const
  bp_TGtkTextAttributes_invisible* = 0'u16
const
  bm_TGtkTextAttributes_bg_full_height* = 0x0002'u16
const
  bp_TGtkTextAttributes_bg_full_height* = 1'u16
const
  bm_TGtkTextAttributes_editable* = 0x0004'u16
const
  bp_TGtkTextAttributes_editable* = 2'u16
const
  bm_TGtkTextAttributes_realized* = 0x0008'u16
const
  bp_TGtkTextAttributes_realized* = 3'u16
const
  bm_TGtkTextAttributes_pad1* = 0x0010'u16
const
  bp_TGtkTextAttributes_pad1* = 4'u16
const
  bm_TGtkTextAttributes_pad2* = 0x0020'u16
const
  bp_TGtkTextAttributes_pad2* = 5'u16
const
  bm_TGtkTextAttributes_pad3* = 0x0040'u16
const
  bp_TGtkTextAttributes_pad3* = 6'u16
const
  bm_TGtkTextAttributes_pad4* = 0x0080'u16
const
  bp_TGtkTextAttributes_pad4* = 7'u16

proc invisible*(a: PTextAttributes): guint
proc set_invisible*(a: PTextAttributes, `invisible`: guint)
proc bg_full_height*(a: PTextAttributes): guint
proc set_bg_full_height*(a: PTextAttributes, `bg_full_height`: guint)
proc editable*(a: PTextAttributes): guint
proc set_editable*(a: PTextAttributes, `editable`: guint)
proc realized*(a: PTextAttributes): guint
proc set_realized*(a: PTextAttributes, `realized`: guint)
proc pad1*(a: PTextAttributes): guint
proc set_pad1*(a: PTextAttributes, `pad1`: guint)
proc pad2*(a: PTextAttributes): guint
proc set_pad2*(a: PTextAttributes, `pad2`: guint)
proc pad3*(a: PTextAttributes): guint
proc set_pad3*(a: PTextAttributes, `pad3`: guint)
proc pad4*(a: PTextAttributes): guint
proc set_pad4*(a: PTextAttributes, `pad4`: guint)
