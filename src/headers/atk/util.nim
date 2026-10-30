# Included by headers/atk.nim; do not import directly.
proc TYPE_UTIL*(): GType
proc IS_UTIL*(obj: pointer): bool
proc UTIL*(obj: pointer): PUtil
proc UTIL_CLASS*(klass: pointer): PUtilClass
proc IS_UTIL_CLASS*(klass: pointer): bool
proc UTIL_GET_CLASS*(obj: pointer): PUtilClass
proc util_get_type*(): GType{.cdecl, dynlib: lib, importc: "atk_util_get_type".}
proc add_focus_tracker*(focus_tracker: TEventListener): guint{.cdecl,
    dynlib: lib, importc: "atk_add_focus_tracker".}
proc remove_focus_tracker*(tracker_id: guint){.cdecl, dynlib: lib,
    importc: "atk_remove_focus_tracker".}
proc focus_tracker_init*(add_function: TEventListenerInit){.cdecl, dynlib: lib,
    importc: "atk_focus_tracker_init".}
proc focus_tracker_notify*(anObject: PObject){.cdecl, dynlib: lib,
    importc: "atk_focus_tracker_notify".}
proc add_global_event_listener*(listener: TGSignalEmissionHook,
                                event_type: cstring): guint{.cdecl, dynlib: lib,
    importc: "atk_add_global_event_listener".}
proc remove_global_event_listener*(listener_id: guint){.cdecl, dynlib: lib,
    importc: "atk_remove_global_event_listener".}
proc add_key_event_listener*(listener: TKeySnoopFunc, data: gpointer): guint{.
    cdecl, dynlib: lib, importc: "atk_add_key_event_listener".}
proc remove_key_event_listener*(listener_id: guint){.cdecl, dynlib: lib,
    importc: "atk_remove_key_event_listener".}
proc get_root*(): PObject{.cdecl, dynlib: lib, importc: "atk_get_root".}
proc get_toolkit_name*(): cstring{.cdecl, dynlib: lib,
                                   importc: "atk_get_toolkit_name".}
proc get_toolkit_version*(): cstring{.cdecl, dynlib: lib,
                                      importc: "atk_get_toolkit_version".}
