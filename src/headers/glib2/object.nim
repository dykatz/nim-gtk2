# Included by headers/glib2.nim; do not import directly.
proc G_OBJECT*(anObject: pointer): PGObject
proc G_OBJECT_CLASS*(class: pointer): PGObjectClass
proc G_IS_OBJECT*(anObject: pointer): bool
proc G_IS_OBJECT_CLASS*(class: pointer): bool
proc G_OBJECT_GET_CLASS*(anObject: pointer): PGObjectClass
proc G_OBJECT_TYPE*(anObject: pointer): GType
proc G_OBJECT_TYPE_NAME*(anObject: pointer): cstring
proc G_OBJECT_CLASS_TYPE*(class: pointer): GType
proc G_OBJECT_CLASS_NAME*(class: pointer): cstring
proc G_VALUE_HOLDS_OBJECT*(value: pointer): bool
proc class_install_property*(oclass: PGObjectClass, property_id: guint,
                                      pspec: PGParamSpec){.cdecl,
    dynlib: gobjectlib, importc: "g_object_class_install_property".}
proc class_find_property*(oclass: PGObjectClass, property_name: cstring): PGParamSpec{.
    cdecl, dynlib: gobjectlib, importc: "g_object_class_find_property".}
proc class_list_properties*(oclass: PGObjectClass, n_properties: Pguint): PPGParamSpec{.
    cdecl, dynlib: gobjectlib, importc: "g_object_class_list_properties".}
proc set_property*(anObject: PGObject, property_name: cstring,
                            value: PGValue){.cdecl, dynlib: gobjectlib,
    importc: "g_object_set_property".}
proc get_property*(anObject: PGObject, property_name: cstring,
                            value: PGValue){.cdecl, dynlib: gobjectlib,
    importc: "g_object_get_property".}
proc freeze_notify*(anObject: PGObject){.cdecl, dynlib: gobjectlib,
    importc: "g_object_freeze_notify".}
proc notify*(anObject: PGObject, property_name: cstring){.cdecl,
    dynlib: gobjectlib, importc: "g_object_notify".}
proc thaw_notify*(anObject: PGObject){.cdecl, dynlib: gobjectlib,
    importc: "g_object_thaw_notify".}
proc g_object_ref_sink*(anObject: gpointer): gpointer {.cdecl,
    dynlib: gobjectlib, importc: "g_object_ref_sink".}
proc g_object_ref*(anObject: gpointer): gpointer{.cdecl, dynlib: gobjectlib,
    importc: "g_object_ref".}
proc g_object_unref*(anObject: gpointer){.cdecl, dynlib: gobjectlib,
    importc: "g_object_unref".}
proc weak_ref*(anObject: PGObject, notify: TGWeakNotify, data: gpointer){.
    cdecl, dynlib: gobjectlib, importc: "g_object_weak_ref".}
proc weak_unref*(anObject: PGObject, notify: TGWeakNotify,
                          data: gpointer){.cdecl, dynlib: gobjectlib,
    importc: "g_object_weak_unref".}
proc add_weak_pointer*(anObject: PGObject,
                                weak_pointer_location: Pgpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_object_add_weak_pointer".}
proc remove_weak_pointer*(anObject: PGObject,
                                   weak_pointer_location: Pgpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_object_remove_weak_pointer".}
proc get_qdata*(anObject: PGObject, quark: TGQuark): gpointer{.cdecl,
    dynlib: gobjectlib, importc: "g_object_get_qdata".}
proc set_qdata*(anObject: PGObject, quark: TGQuark, data: gpointer){.
    cdecl, dynlib: gobjectlib, importc: "g_object_set_qdata".}
proc set_qdata_full*(anObject: PGObject, quark: TGQuark,
                              data: gpointer, destroy: TGDestroyNotify){.cdecl,
    dynlib: gobjectlib, importc: "g_object_set_qdata_full".}
proc steal_qdata*(anObject: PGObject, quark: TGQuark): gpointer{.cdecl,
    dynlib: gobjectlib, importc: "g_object_steal_qdata".}
proc get_data*(anObject: PGObject, key: cstring): gpointer{.cdecl,
    dynlib: gobjectlib, importc: "g_object_get_data".}
proc set_data*(anObject: PGObject, key: cstring, data: gpointer){.
    cdecl, dynlib: gobjectlib, importc: "g_object_set_data".}
proc set_data_full*(anObject: PGObject, key: cstring, data: gpointer,
                             destroy: TGDestroyNotify){.cdecl,
    dynlib: gobjectlib, importc: "g_object_set_data_full".}
proc steal_data*(anObject: PGObject, key: cstring): gpointer{.cdecl,
    dynlib: gobjectlib, importc: "g_object_steal_data".}
proc watch_closure*(anObject: PGObject, closure: PGClosure){.cdecl,
    dynlib: gobjectlib, importc: "g_object_watch_closure".}
proc g_cclosure_new_object*(callback_func: TGCallback, anObject: PGObject): PGClosure{.
    cdecl, dynlib: gobjectlib, importc: "g_cclosure_new_object".}
proc g_cclosure_new_object_swap*(callback_func: TGCallback, anObject: PGObject): PGClosure{.
    cdecl, dynlib: gobjectlib, importc: "g_cclosure_new_object_swap".}
proc g_closure_new_object*(sizeof_closure: guint, anObject: PGObject): PGClosure{.
    cdecl, dynlib: gobjectlib, importc: "g_closure_new_object".}
proc set_object*(value: PGValue, v_object: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_value_set_object".}
proc get_object*(value: PGValue): gpointer{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_object".}
proc dup_object*(value: PGValue): PGObject{.cdecl, dynlib: gobjectlib,
    importc: "g_value_dup_object".}
proc g_signal_connect_object*(instance: gpointer, detailed_signal: cstring,
                              c_handler: TGCallback, gobject: gpointer,
                              connect_flags: TGConnectFlags): gulong{.cdecl,
    dynlib: gobjectlib, importc: "g_signal_connect_object".}
proc run_dispose*(anObject: PGObject){.cdecl, dynlib: gobjectlib,
    importc: "g_object_run_dispose".}
proc set_object_take_ownership*(value: PGValue, v_object: gpointer){.
    cdecl, dynlib: gobjectlib, importc: "g_value_set_object_take_ownership".}
proc G_OBJECT_WARN_INVALID_PSPEC*(anObject: gpointer, pname: cstring,
                                  property_id: gint, pspec: gpointer)
proc G_OBJECT_WARN_INVALID_PROPERTY_ID*(anObject: gpointer, property_id: gint,
                                        pspec: gpointer)
