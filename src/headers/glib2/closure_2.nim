# Included by headers/glib2.nim; do not import directly.
proc g_cclosure_new*(callback_func: TGCallback, user_data: gpointer,
                     destroy_data: TGClosureNotify): PGClosure{.cdecl,
    dynlib: gliblib, importc: "g_cclosure_new".}
proc g_cclosure_new_swap*(callback_func: TGCallback, user_data: gpointer,
                          destroy_data: TGClosureNotify): PGClosure{.cdecl,
    dynlib: gliblib, importc: "g_cclosure_new_swap".}
proc g_signal_type_cclosure_new*(itype: GType, struct_offset: guint): PGClosure{.
    cdecl, dynlib: gliblib, importc: "g_signal_type_cclosure_new".}
proc reference*(closure: PGClosure): PGClosure{.cdecl, dynlib: gliblib,
    importc: "g_closure_ref".}
proc sink*(closure: PGClosure){.cdecl, dynlib: gliblib,
    importc: "g_closure_sink".}
proc unref*(closure: PGClosure){.cdecl, dynlib: gliblib,
    importc: "g_closure_unref".}
proc g_closure_new_simple*(sizeof_closure: guint, data: gpointer): PGClosure{.
    cdecl, dynlib: gliblib, importc: "g_closure_new_simple".}
proc add_finalize_notifier*(closure: PGClosure, notify_data: gpointer,
                                      notify_func: TGClosureNotify){.cdecl,
    dynlib: gliblib, importc: "g_closure_add_finalize_notifier".}
proc remove_finalize_notifier*(closure: PGClosure,
    notify_data: gpointer, notify_func: TGClosureNotify){.cdecl,
    dynlib: gliblib, importc: "g_closure_remove_finalize_notifier".}
proc add_invalidate_notifier*(closure: PGClosure,
                                        notify_data: gpointer,
                                        notify_func: TGClosureNotify){.cdecl,
    dynlib: gliblib, importc: "g_closure_add_invalidate_notifier".}
proc remove_invalidate_notifier*(closure: PGClosure,
    notify_data: gpointer, notify_func: TGClosureNotify){.cdecl,
    dynlib: gliblib, importc: "g_closure_remove_invalidate_notifier".}
proc add_marshal_guards*(closure: PGClosure,
                                   pre_marshal_data: gpointer,
                                   pre_marshal_notify: TGClosureNotify,
                                   post_marshal_data: gpointer,
                                   post_marshal_notify: TGClosureNotify){.cdecl,
    dynlib: gliblib, importc: "g_closure_add_marshal_guards".}
proc set_marshal*(closure: PGClosure, marshal: TGClosureMarshal){.
    cdecl, dynlib: gliblib, importc: "g_closure_set_marshal".}
proc set_meta_marshal*(closure: PGClosure, marshal_data: gpointer,
                                 meta_marshal: TGClosureMarshal){.cdecl,
    dynlib: gliblib, importc: "g_closure_set_meta_marshal".}
proc invalidate*(closure: PGClosure){.cdecl, dynlib: gliblib,
    importc: "g_closure_invalidate".}
proc invoke*(closure: PGClosure, return_value: PGValue,
                       n_param_values: guint, param_values: PGValue,
                       invocation_hint: gpointer){.cdecl, dynlib: gliblib,
    importc: "g_closure_invoke".}
