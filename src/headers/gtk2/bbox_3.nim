# Included by headers/gtk2.nim; do not import directly.
proc BUTTON_BOX*(obj: pointer): PButtonBox
proc BUTTON_BOX_CLASS*(klass: pointer): PButtonBoxClass
proc IS_BUTTON_BOX*(obj: pointer): bool
proc IS_BUTTON_BOX_CLASS*(klass: pointer): bool
proc BUTTON_BOX_GET_CLASS*(obj: pointer): PButtonBoxClass
proc button_box_get_type*(): TType{.cdecl, dynlib: lib,
                                    importc: "gtk_button_box_get_type".}
proc get_layout*(widget: PButtonBox): TButtonBoxStyle{.cdecl,
    dynlib: lib, importc: "gtk_button_box_get_layout".}
proc set_layout*(widget: PButtonBox, layout_style: TButtonBoxStyle){.
    cdecl, dynlib: lib, importc: "gtk_button_box_set_layout".}
proc set_child_secondary*(widget: PButtonBox, child: PWidget,
                                     is_secondary: gboolean){.cdecl,
    dynlib: lib, importc: "gtk_button_box_set_child_secondary".}
