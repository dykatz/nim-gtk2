# Included by headers/pango.nim; do not import directly.
proc LAYOUT*(anObject: pointer): PLayout
proc LAYOUT_CLASS*(klass: pointer): PLayoutClass
proc IS_LAYOUT*(anObject: pointer): bool
proc IS_LAYOUT_CLASS*(klass: pointer): bool
proc GET_CLASS*(obj: PLayout): PLayoutClass
proc layout_get_type*(): GType{.cdecl, dynlib: lib,
                                importc: "pango_layout_get_type".}
proc layout_new*(context: PContext): PLayout{.cdecl, dynlib: lib,
    importc: "pango_layout_new".}
proc copy*(src: PLayout): PLayout{.cdecl, dynlib: lib,
    importc: "pango_layout_copy".}
proc get_context*(layout: PLayout): PContext{.cdecl, dynlib: lib,
    importc: "pango_layout_get_context".}
proc set_attributes*(layout: PLayout, attrs: PAttrList){.cdecl,
    dynlib: lib, importc: "pango_layout_set_attributes".}
proc get_attributes*(layout: PLayout): PAttrList{.cdecl, dynlib: lib,
    importc: "pango_layout_get_attributes".}
proc set_text*(layout: PLayout, text: cstring, length: int32){.cdecl,
    dynlib: lib, importc: "pango_layout_set_text".}
proc get_text*(layout: PLayout): cstring{.cdecl, dynlib: lib,
    importc: "pango_layout_get_text".}
proc set_markup*(layout: PLayout, markup: cstring, length: int32){.cdecl,
    dynlib: lib, importc: "pango_layout_set_markup".}
proc set_markup*(layout: PLayout, markup: cstring,
                                   length: int32, accel_marker: gunichar,
                                   accel_char: Pgunichar){.cdecl, dynlib: lib,
    importc: "pango_layout_set_markup_with_accel".}
proc set_font_description*(layout: PLayout, desc: PFontDescription){.
    cdecl, dynlib: lib, importc: "pango_layout_set_font_description".}
proc set_width*(layout: PLayout, width: int32){.cdecl, dynlib: lib,
    importc: "pango_layout_set_width".}
proc get_width*(layout: PLayout): int32{.cdecl, dynlib: lib,
    importc: "pango_layout_get_width".}
proc set_wrap*(layout: PLayout, wrap: TWrapMode){.cdecl, dynlib: lib,
    importc: "pango_layout_set_wrap".}
proc get_wrap*(layout: PLayout): TWrapMode{.cdecl, dynlib: lib,
    importc: "pango_layout_get_wrap".}
proc set_indent*(layout: PLayout, indent: int32){.cdecl, dynlib: lib,
    importc: "pango_layout_set_indent".}
proc get_indent*(layout: PLayout): int32{.cdecl, dynlib: lib,
    importc: "pango_layout_get_indent".}
proc set_spacing*(layout: PLayout, spacing: int32){.cdecl, dynlib: lib,
    importc: "pango_layout_set_spacing".}
proc get_spacing*(layout: PLayout): int32{.cdecl, dynlib: lib,
    importc: "pango_layout_get_spacing".}
proc set_justify*(layout: PLayout, justify: gboolean){.cdecl,
    dynlib: lib, importc: "pango_layout_set_justify".}
proc get_justify*(layout: PLayout): gboolean{.cdecl, dynlib: lib,
    importc: "pango_layout_get_justify".}
proc set_alignment*(layout: PLayout, alignment: TAlignment){.cdecl,
    dynlib: lib, importc: "pango_layout_set_alignment".}
proc get_alignment*(layout: PLayout): TAlignment{.cdecl, dynlib: lib,
    importc: "pango_layout_get_alignment".}
proc set_tabs*(layout: PLayout, tabs: PTabArray){.cdecl, dynlib: lib,
    importc: "pango_layout_set_tabs".}
proc get_tabs*(layout: PLayout): PTabArray{.cdecl, dynlib: lib,
    importc: "pango_layout_get_tabs".}
proc set_single_paragraph_mode*(layout: PLayout, setting: gboolean){.
    cdecl, dynlib: lib, importc: "pango_layout_set_single_paragraph_mode".}
proc get_single_paragraph_mode*(layout: PLayout): gboolean{.cdecl,
    dynlib: lib, importc: "pango_layout_get_single_paragraph_mode".}
proc context_changed*(layout: PLayout){.cdecl, dynlib: lib,
    importc: "pango_layout_context_changed".}
proc get_log_attrs*(layout: PLayout, attrs: var PLogAttr, n_attrs: Pgint){.
    cdecl, dynlib: lib, importc: "pango_layout_get_log_attrs".}
proc index_to_pos*(layout: PLayout, index: int32, pos: PRectangle){.
    cdecl, dynlib: lib, importc: "pango_layout_index_to_pos".}
proc get_cursor_pos*(layout: PLayout, index: int32,
                            strong_pos: PRectangle, weak_pos: PRectangle){.
    cdecl, dynlib: lib, importc: "pango_layout_get_cursor_pos".}
proc move_cursor_visually*(layout: PLayout, strong: gboolean,
                                  old_index: int32, old_trailing: int32,
                                  direction: int32,
                                  new_index, new_trailing: var int32){.cdecl,
    dynlib: lib, importc: "pango_layout_move_cursor_visually".}
proc xy_to_index*(layout: PLayout, x: int32, y: int32,
                         index, trailing: var int32): gboolean{.cdecl,
    dynlib: lib, importc: "pango_layout_xy_to_index".}
proc get_extents*(layout: PLayout, ink_rect: PRectangle,
                         logical_rect: PRectangle){.cdecl, dynlib: lib,
    importc: "pango_layout_get_extents".}
proc get_pixel_extents*(layout: PLayout, ink_rect: PRectangle,
                               logical_rect: PRectangle){.cdecl, dynlib: lib,
    importc: "pango_layout_get_pixel_extents".}
proc get_size*(layout: PLayout, width: var int32, height: var int32){.
    cdecl, dynlib: lib, importc: "pango_layout_get_size".}
proc get_pixel_size*(layout: PLayout, width: var int32, height: var int32){.
    cdecl, dynlib: lib, importc: "pango_layout_get_pixel_size".}
proc get_line_count*(layout: PLayout): int32{.cdecl, dynlib: lib,
    importc: "pango_layout_get_line_count".}
proc get_line*(layout: PLayout, line: int32): PLayoutLine{.cdecl,
    dynlib: lib, importc: "pango_layout_get_line".}
proc get_lines*(layout: PLayout): PGSList{.cdecl, dynlib: lib,
    importc: "pango_layout_get_lines".}
proc reference*(line: PLayoutLine){.cdecl, dynlib: lib,
    importc: "pango_layout_line_ref".}
proc unref*(line: PLayoutLine){.cdecl, dynlib: lib,
    importc: "pango_layout_line_unref".}
proc x_to_index*(line: PLayoutLine, x_pos: int32, index: var int32,
                             trailing: var int32): gboolean{.cdecl, dynlib: lib,
    importc: "pango_layout_line_x_to_index".}
proc index_to_x*(line: PLayoutLine, index: int32,
                             trailing: gboolean, x_pos: var int32){.cdecl,
    dynlib: lib, importc: "pango_layout_line_index_to_x".}
proc get_extents*(line: PLayoutLine, ink_rect: PRectangle,
                              logical_rect: PRectangle){.cdecl, dynlib: lib,
    importc: "pango_layout_line_get_extents".}
proc get_pixel_extents*(layout_line: PLayoutLine,
                                    ink_rect: PRectangle,
                                    logical_rect: PRectangle){.cdecl,
    dynlib: lib, importc: "pango_layout_line_get_pixel_extents".}
proc get_iter*(layout: PLayout): PLayoutIter{.cdecl, dynlib: lib,
    importc: "pango_layout_get_iter".}
proc free*(iter: PLayoutIter){.cdecl, dynlib: lib,
    importc: "pango_layout_iter_free".}
proc get_index*(iter: PLayoutIter): int32{.cdecl, dynlib: lib,
    importc: "pango_layout_iter_get_index".}
proc get_run*(iter: PLayoutIter): PLayoutRun{.cdecl, dynlib: lib,
    importc: "pango_layout_iter_get_run".}
proc get_line*(iter: PLayoutIter): PLayoutLine{.cdecl, dynlib: lib,
    importc: "pango_layout_iter_get_line".}
proc at_last_line*(iter: PLayoutIter): gboolean{.cdecl, dynlib: lib,
    importc: "pango_layout_iter_at_last_line".}
proc next_char*(iter: PLayoutIter): gboolean{.cdecl, dynlib: lib,
    importc: "pango_layout_iter_next_char".}
proc next_cluster*(iter: PLayoutIter): gboolean{.cdecl, dynlib: lib,
    importc: "pango_layout_iter_next_cluster".}
proc next_run*(iter: PLayoutIter): gboolean{.cdecl, dynlib: lib,
    importc: "pango_layout_iter_next_run".}
proc next_line*(iter: PLayoutIter): gboolean{.cdecl, dynlib: lib,
    importc: "pango_layout_iter_next_line".}
proc get_char_extents*(iter: PLayoutIter, logical_rect: PRectangle){.
    cdecl, dynlib: lib, importc: "pango_layout_iter_get_char_extents".}
proc get_cluster_extents*(iter: PLayoutIter, ink_rect: PRectangle,
                                      logical_rect: PRectangle){.cdecl,
    dynlib: lib, importc: "pango_layout_iter_get_cluster_extents".}
proc get_run_extents*(iter: PLayoutIter, ink_rect: PRectangle,
                                  logical_rect: PRectangle){.cdecl, dynlib: lib,
    importc: "pango_layout_iter_get_run_extents".}
proc get_line_extents*(iter: PLayoutIter, ink_rect: PRectangle,
                                   logical_rect: PRectangle){.cdecl,
    dynlib: lib, importc: "pango_layout_iter_get_line_extents".}
proc get_line_yrange*(iter: PLayoutIter, y0: var int32,
                                  y1: var int32){.cdecl, dynlib: lib,
    importc: "pango_layout_iter_get_line_yrange".}
proc get_layout_extents*(iter: PLayoutIter, ink_rect: PRectangle,
                                     logical_rect: PRectangle){.cdecl,
    dynlib: lib, importc: "pango_layout_iter_get_layout_extents".}
proc get_baseline*(iter: PLayoutIter): int32{.cdecl, dynlib: lib,
    importc: "pango_layout_iter_get_baseline".}
proc TYPE_TAB_ARRAY*(): GType
