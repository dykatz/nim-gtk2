# Included by headers/pango.nim; do not import directly.
proc attr_type_register*(name: cstring): TAttrType{.cdecl, dynlib: lib,
    importc: "pango_attr_type_register".}
proc copy*(attr: PAttribute): PAttribute{.cdecl, dynlib: lib,
    importc: "pango_attribute_copy".}
proc destroy*(attr: PAttribute){.cdecl, dynlib: lib,
    importc: "pango_attribute_destroy".}
proc equal*(attr1: PAttribute, attr2: PAttribute): gboolean{.cdecl,
    dynlib: lib, importc: "pango_attribute_equal".}
proc attr_language_new*(language: PLanguage): PAttribute{.cdecl, dynlib: lib,
    importc: "pango_attr_language_new".}
proc attr_family_new*(family: cstring): PAttribute{.cdecl, dynlib: lib,
    importc: "pango_attr_family_new".}
proc attr_foreground_new*(red: guint16, green: guint16, blue: guint16): PAttribute{.
    cdecl, dynlib: lib, importc: "pango_attr_foreground_new".}
proc attr_background_new*(red: guint16, green: guint16, blue: guint16): PAttribute{.
    cdecl, dynlib: lib, importc: "pango_attr_background_new".}
proc attr_size_new*(size: int32): PAttribute{.cdecl, dynlib: lib,
    importc: "pango_attr_size_new".}
proc attr_style_new*(style: TStyle): PAttribute{.cdecl, dynlib: lib,
    importc: "pango_attr_style_new".}
proc attr_weight_new*(weight: TWeight): PAttribute{.cdecl, dynlib: lib,
    importc: "pango_attr_weight_new".}
proc attr_variant_new*(variant: TVariant): PAttribute{.cdecl, dynlib: lib,
    importc: "pango_attr_variant_new".}
proc attr_stretch_new*(stretch: TStretch): PAttribute{.cdecl, dynlib: lib,
    importc: "pango_attr_stretch_new".}
proc attr_font_desc_new*(desc: PFontDescription): PAttribute{.cdecl,
    dynlib: lib, importc: "pango_attr_font_desc_new".}
proc attr_underline_new*(underline: TUnderline): PAttribute{.cdecl, dynlib: lib,
    importc: "pango_attr_underline_new".}
proc attr_strikethrough_new*(strikethrough: gboolean): PAttribute{.cdecl,
    dynlib: lib, importc: "pango_attr_strikethrough_new".}
proc attr_rise_new*(rise: int32): PAttribute{.cdecl, dynlib: lib,
    importc: "pango_attr_rise_new".}
proc attr_shape_new*(ink_rect: PRectangle, logical_rect: PRectangle): PAttribute{.
    cdecl, dynlib: lib, importc: "pango_attr_shape_new".}
proc attr_scale_new*(scale_factor: gdouble): PAttribute{.cdecl, dynlib: lib,
    importc: "pango_attr_scale_new".}
proc attr_list_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "pango_attr_list_get_type".}
proc attr_list_new*(): PAttrList{.cdecl, dynlib: lib,
                                  importc: "pango_attr_list_new".}
proc reference*(list: PAttrList){.cdecl, dynlib: lib,
                                      importc: "pango_attr_list_ref".}
proc unref*(list: PAttrList){.cdecl, dynlib: lib,
                                        importc: "pango_attr_list_unref".}
proc copy*(list: PAttrList): PAttrList{.cdecl, dynlib: lib,
    importc: "pango_attr_list_copy".}
proc insert*(list: PAttrList, attr: PAttribute){.cdecl, dynlib: lib,
    importc: "pango_attr_list_insert".}
proc insert_before*(list: PAttrList, attr: PAttribute){.cdecl,
    dynlib: lib, importc: "pango_attr_list_insert_before".}
proc change*(list: PAttrList, attr: PAttribute){.cdecl, dynlib: lib,
    importc: "pango_attr_list_change".}
proc splice*(list: PAttrList, other: PAttrList, pos: gint, len: gint){.
    cdecl, dynlib: lib, importc: "pango_attr_list_splice".}
proc get_iterator*(list: PAttrList): PAttrIterator{.cdecl,
    dynlib: lib, importc: "pango_attr_list_get_iterator".}
proc attr_iterator_range*(`iterator`: PAttrIterator, start: Pgint, theEnd: Pgint){.
    cdecl, dynlib: lib, importc: "pango_attr_iterator_range".}
proc attr_iterator_next*(`iterator`: PAttrIterator): gboolean{.cdecl,
    dynlib: lib, importc: "pango_attr_iterator_next".}
proc attr_iterator_copy*(`iterator`: PAttrIterator): PAttrIterator{.cdecl,
    dynlib: lib, importc: "pango_attr_iterator_copy".}
proc attr_iterator_destroy*(`iterator`: PAttrIterator){.cdecl, dynlib: lib,
    importc: "pango_attr_iterator_destroy".}
proc attr_iterator_get*(`iterator`: PAttrIterator, `type`: TAttrType): PAttribute{.
    cdecl, dynlib: lib, importc: "pango_attr_iterator_get".}
proc attr_iterator_get_font*(`iterator`: PAttrIterator, desc: PFontDescription,
                             language: var PLanguage, extra_attrs: PPGSList){.
    cdecl, dynlib: lib, importc: "pango_attr_iterator_get_font".}
