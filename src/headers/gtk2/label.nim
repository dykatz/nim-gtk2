# Included by headers/gtk2.nim; do not import directly.
proc TYPE_LABEL*(): GType
proc LABEL*(obj: pointer): PLabel
proc LABEL_CLASS*(klass: pointer): PLabelClass
proc IS_LABEL*(obj: pointer): bool
proc IS_LABEL_CLASS*(klass: pointer): bool
proc LABEL_GET_CLASS*(obj: pointer): PLabelClass
proc jtype*(a: PLabel): guint
proc set_jtype*(a: PLabel, `jtype`: guint)
proc wrap*(a: PLabel): guint
proc set_wrap*(a: PLabel, `wrap`: guint)
proc use_underline*(a: PLabel): guint
proc set_use_underline*(a: PLabel, `use_underline`: guint)
proc use_markup*(a: PLabel): guint
proc set_use_markup*(a: PLabel, `use_markup`: guint)
proc label_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_label_get_type".}
proc label_new*(str: cstring): PLabel{.cdecl, dynlib: lib,
                                       importc: "gtk_label_new".}
proc label_new_with_mnemonic*(str: cstring): PLabel{.cdecl, dynlib: lib,
    importc: "gtk_label_new_with_mnemonic".}
proc set_text*(`label`: PLabel, str: cstring){.cdecl, dynlib: lib,
    importc: "gtk_label_set_text".}
proc get_text*(`label`: PLabel): cstring{.cdecl, dynlib: lib,
    importc: "gtk_label_get_text".}
proc set_attributes*(`label`: PLabel, attrs: pango.PAttrList){.cdecl,
    dynlib: lib, importc: "gtk_label_set_attributes".}
proc get_attributes*(`label`: PLabel): pango.PAttrList{.cdecl, dynlib: lib,
    importc: "gtk_label_get_attributes".}
proc set_label*(`label`: PLabel, str: cstring){.cdecl, dynlib: lib,
    importc: "gtk_label_set_label".}
proc get_label*(`label`: PLabel): cstring{.cdecl, dynlib: lib,
    importc: "gtk_label_get_label".}
proc set_markup*(`label`: PLabel, str: cstring){.cdecl, dynlib: lib,
    importc: "gtk_label_set_markup".}
proc set_use_markup*(`label`: PLabel, setting: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_label_set_use_markup".}
proc get_use_markup*(`label`: PLabel): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_label_get_use_markup".}
proc set_use_underline*(`label`: PLabel, setting: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_label_set_use_underline".}
proc get_use_underline*(`label`: PLabel): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_label_get_use_underline".}
proc set_markup_with_mnemonic*(`label`: PLabel, str: cstring){.cdecl,
    dynlib: lib, importc: "gtk_label_set_markup_with_mnemonic".}
proc get_mnemonic_keyval*(`label`: PLabel): guint{.cdecl, dynlib: lib,
    importc: "gtk_label_get_mnemonic_keyval".}
proc set_mnemonic_widget*(`label`: PLabel, widget: PWidget){.cdecl,
    dynlib: lib, importc: "gtk_label_set_mnemonic_widget".}
proc get_mnemonic_widget*(`label`: PLabel): PWidget{.cdecl, dynlib: lib,
    importc: "gtk_label_get_mnemonic_widget".}
proc set_text_with_mnemonic*(`label`: PLabel, str: cstring){.cdecl,
    dynlib: lib, importc: "gtk_label_set_text_with_mnemonic".}
proc set_justify*(`label`: PLabel, jtype: TJustification){.cdecl,
    dynlib: lib, importc: "gtk_label_set_justify".}
proc get_justify*(`label`: PLabel): TJustification{.cdecl, dynlib: lib,
    importc: "gtk_label_get_justify".}
proc set_pattern*(`label`: PLabel, pattern: cstring){.cdecl, dynlib: lib,
    importc: "gtk_label_set_pattern".}
proc set_line_wrap*(`label`: PLabel, wrap: gboolean){.cdecl, dynlib: lib,
    importc: "gtk_label_set_line_wrap".}
proc get_line_wrap*(`label`: PLabel): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_label_get_line_wrap".}
proc set_selectable*(`label`: PLabel, setting: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_label_set_selectable".}
proc get_selectable*(`label`: PLabel): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_label_get_selectable".}
proc select_region*(`label`: PLabel, start_offset: gint, end_offset: gint){.
    cdecl, dynlib: lib, importc: "gtk_label_select_region".}
proc get_selection_bounds*(`label`: PLabel, start: Pgint, theEnd: Pgint): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_label_get_selection_bounds".}
proc get_layout*(`label`: PLabel): pango.PLayout{.cdecl, dynlib: lib,
    importc: "gtk_label_get_layout".}
proc get_layout_offsets*(`label`: PLabel, x: Pgint, y: Pgint){.cdecl,
    dynlib: lib, importc: "gtk_label_get_layout_offsets".}
const
  bm_TGtkAccelLabelClass_latin1_to_char* = 0x0001'u16
const
  bp_TGtkAccelLabelClass_latin1_to_char* = 0'u16

