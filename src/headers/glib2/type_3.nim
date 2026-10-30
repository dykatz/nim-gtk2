# Included by headers/glib2.nim; do not import directly.
proc g_type_qname*(theType: GType): TGQuark{.cdecl, dynlib: gobjectlib,
    importc: "g_type_qname".}
proc g_type_from_name*(name: cstring): GType{.cdecl, dynlib: gobjectlib,
    importc: "g_type_from_name".}
proc g_type_parent*(theType: GType): GType{.cdecl, dynlib: gobjectlib,
    importc: "g_type_parent".}
proc g_type_depth*(theType: GType): guint{.cdecl, dynlib: gobjectlib,
    importc: "g_type_depth".}
proc g_type_next_base*(leaf_type: GType, root_type: GType): GType{.cdecl,
    dynlib: gobjectlib, importc: "g_type_next_base".}
proc g_type_is_a*(theType: GType, is_a_type: GType): gboolean{.cdecl,
    dynlib: gobjectlib, importc: "g_type_is_a".}
proc g_type_class_ref*(theType: GType): gpointer{.cdecl, dynlib: gobjectlib,
    importc: "g_type_class_ref".}
proc g_type_class_peek*(theType: GType): gpointer{.cdecl, dynlib: gobjectlib,
    importc: "g_type_class_peek".}
proc g_type_class_unref*(g_class: gpointer){.cdecl, dynlib: gobjectlib,
    importc: "g_type_class_unref".}
proc g_type_class_peek_parent*(g_class: gpointer): gpointer{.cdecl,
    dynlib: gobjectlib, importc: "g_type_class_peek_parent".}
proc g_type_interface_peek*(instance_class: gpointer, iface_type: GType): gpointer{.
    cdecl, dynlib: gobjectlib, importc: "g_type_interface_peek".}
proc g_type_interface_peek_parent*(g_iface: gpointer): gpointer{.cdecl,
    dynlib: gobjectlib, importc: "g_type_interface_peek_parent".}
proc g_type_children*(theType: GType, n_children: Pguint): PGType{.cdecl,
    dynlib: gobjectlib, importc: "g_type_children".}
proc g_type_interfaces*(theType: GType, n_interfaces: Pguint): PGType{.cdecl,
    dynlib: gobjectlib, importc: "g_type_interfaces".}
proc g_type_set_qdata*(theType: GType, quark: TGQuark, data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_type_set_qdata".}
proc g_type_get_qdata*(theType: GType, quark: TGQuark): gpointer{.cdecl,
    dynlib: gobjectlib, importc: "g_type_get_qdata".}
proc g_type_query*(theType: GType, query: PGTypeQuery){.cdecl,
    dynlib: gobjectlib, importc: "g_type_query".}
