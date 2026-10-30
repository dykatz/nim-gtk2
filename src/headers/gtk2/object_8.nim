# Included by headers/gtk2.nim; do not import directly.
proc reference*(anObject: PObject): PObject{.cdecl, importc: "gtk_object_ref",
    dynlib: lib.}
proc unref*(anObject: PObject){.cdecl, importc: "gtk_object_unref",
                                       dynlib: lib.}
proc weakref*(anObject: PObject, notify: TDestroyNotify, data: gpointer){.
    cdecl, importc: "gtk_object_weakref", dynlib: lib.}
proc weakunref*(anObject: PObject, notify: TDestroyNotify, data: gpointer){.
    cdecl, importc: "gtk_object_weakunref", dynlib: lib.}
proc set_data*(anObject: PObject, key: cstring, data: gpointer){.cdecl,
    importc: "gtk_object_set_data", dynlib: lib.}
proc set_data_full*(anObject: PObject, key: cstring, data: gpointer,
                           destroy: TDestroyNotify){.
    importc: "gtk_object_set_data_full", cdecl, dynlib: lib.}
proc remove_data*(anObject: PObject, key: cstring){.cdecl,
    importc: "gtk_object_remove_data", dynlib: lib.}
proc get_data*(anObject: PObject, key: cstring): gpointer{.cdecl,
    importc: "gtk_object_get_data", dynlib: lib.}
proc remove_no_notify*(anObject: PObject, key: cstring){.cdecl,
    importc: "gtk_object_remove_no_notify", dynlib: lib.}
proc set_user_data*(anObject: PObject, data: gpointer){.cdecl,
    importc: "gtk_object_set_user_data", dynlib: lib.}
proc get_user_data*(anObject: PObject): gpointer{.cdecl,
    importc: "gtk_object_get_user_data", dynlib: lib.}
proc set_data_by_id*(anObject: PObject, data_id: TGQuark, data: gpointer){.
    cdecl, importc: "gtk_object_set_data_by_id", dynlib: lib.}
proc set_data_by_id_full*(anObject: PObject, data_id: TGQuark,
                                 data: gpointer, destroy: TDestroyNotify){.
    cdecl, importc: "gtk_object_set_data_by_id_full", dynlib: lib.}
proc get_data_by_id*(anObject: PObject, data_id: TGQuark): gpointer{.
    cdecl, importc: "gtk_object_get_data_by_id", dynlib: lib.}
proc remove_data_by_id*(anObject: PObject, data_id: TGQuark){.cdecl,
    importc: "gtk_object_remove_data_by_id", dynlib: lib.}
proc remove_no_notify_by_id*(anObject: PObject, key_id: TGQuark){.cdecl,
    importc: "gtk_object_remove_no_notify_by_id", dynlib: lib.}
proc object_data_try_key*(str: cstring): TGQuark{.cdecl,
    importc: "gtk_object_data_try_key", dynlib: lib.}
proc object_data_force_id*(str: cstring): TGQuark{.cdecl,
    importc: "gtk_object_data_force_id", dynlib: lib.}
proc get*(anObject: PObject, first_property_name: cstring){.cdecl,
    importc: "gtk_object_get", varargs, dynlib: lib.}
proc set*(anObject: PObject, first_property_name: cstring){.cdecl,
    importc: "gtk_object_set", varargs, dynlib: lib.}
proc object_add_arg_type*(arg_name: cstring, arg_type: TType, arg_flags: guint,
                          arg_id: guint){.cdecl,
    importc: "gtk_object_add_arg_type", dynlib: lib.}

