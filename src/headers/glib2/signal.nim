# Included by headers/glib2.nim; do not import directly.
proc g_signal_newv*(signal_name: cstring, itype: GType,
                    signal_flags: TGSignalFlags, class_closure: PGClosure,
                    accumulator: TGSignalAccumulator, accu_data: gpointer,
                    c_marshaller: TGSignalCMarshaller, return_type: GType,
                    n_params: guint, param_types: PGType): guint{.cdecl,
    dynlib: gobjectlib, importc: "g_signal_newv".}
proc signal_emitv*(instance_and_params: PGValue, signal_id: guint,
                     detail: TGQuark, return_value: PGValue){.cdecl,
    dynlib: gobjectlib, importc: "g_signal_emitv".}
proc g_signal_lookup*(name: cstring, itype: GType): guint{.cdecl,
    dynlib: gobjectlib, importc: "g_signal_lookup".}
proc g_signal_name*(signal_id: guint): cstring{.cdecl, dynlib: gobjectlib,
    importc: "g_signal_name".}
proc g_signal_query*(signal_id: guint, query: PGSignalQuery){.cdecl,
    dynlib: gobjectlib, importc: "g_signal_query".}
proc g_signal_list_ids*(itype: GType, n_ids: Pguint): Pguint{.cdecl,
    dynlib: gobjectlib, importc: "g_signal_list_ids".}
proc g_signal_parse_name*(detailed_signal: cstring, itype: GType,
                          signal_id_p: Pguint, detail_p: PGQuark,
                          force_detail_quark: gboolean): gboolean{.cdecl,
    dynlib: gobjectlib, importc: "g_signal_parse_name".}
proc g_signal_get_invocation_hint*(instance: gpointer): PGSignalInvocationHint{.
    cdecl, dynlib: gobjectlib, importc: "g_signal_get_invocation_hint".}
proc g_signal_stop_emission*(instance: gpointer, signal_id: guint,
                             detail: TGQuark){.cdecl, dynlib: gobjectlib,
    importc: "g_signal_stop_emission".}
proc g_signal_stop_emission_by_name*(instance: gpointer,
                                     detailed_signal: cstring){.cdecl,
    dynlib: gobjectlib, importc: "g_signal_stop_emission_by_name".}
proc g_signal_add_emission_hook*(signal_id: guint, quark: TGQuark,
                                 hook_func: TGSignalEmissionHook,
                                 hook_data: gpointer,
                                 data_destroy: TGDestroyNotify): gulong{.cdecl,
    dynlib: gobjectlib, importc: "g_signal_add_emission_hook".}
proc g_signal_remove_emission_hook*(signal_id: guint, hook_id: gulong){.cdecl,
    dynlib: gobjectlib, importc: "g_signal_remove_emission_hook".}
proc g_signal_has_handler_pending*(instance: gpointer, signal_id: guint,
                                   detail: TGQuark, may_be_blocked: gboolean): gboolean{.
    cdecl, dynlib: gobjectlib, importc: "g_signal_has_handler_pending".}
proc g_signal_connect_closure_by_id*(instance: gpointer, signal_id: guint,
                                     detail: TGQuark, closure: PGClosure,
                                     after: gboolean): gulong{.cdecl,
    dynlib: gobjectlib, importc: "g_signal_connect_closure_by_id".}
proc g_signal_connect_closure*(instance: gpointer, detailed_signal: cstring,
                               closure: PGClosure, after: gboolean): gulong{.
    cdecl, dynlib: gobjectlib, importc: "g_signal_connect_closure".}
proc g_signal_connect_data*(instance: gpointer, detailed_signal: cstring,
                            c_handler: TGCallback, data: gpointer,
                            destroy_data: TGClosureNotify,
                            connect_flags: TGConnectFlags): gulong{.cdecl,
    dynlib: gobjectlib, importc: "g_signal_connect_data".}
proc g_signal_handler_block*(instance: gpointer, handler_id: gulong){.cdecl,
    dynlib: gobjectlib, importc: "g_signal_handler_block".}
proc g_signal_handler_unblock*(instance: gpointer, handler_id: gulong){.cdecl,
    dynlib: gobjectlib, importc: "g_signal_handler_unblock".}
proc g_signal_handler_disconnect*(instance: gpointer, handler_id: gulong){.
    cdecl, dynlib: gobjectlib, importc: "g_signal_handler_disconnect".}
proc g_signal_handler_is_connected*(instance: gpointer, handler_id: gulong): gboolean{.
    cdecl, dynlib: gobjectlib, importc: "g_signal_handler_is_connected".}
proc g_signal_handler_find*(instance: gpointer, mask: TGSignalMatchType,
                            signal_id: guint, detail: TGQuark,
                            closure: PGClosure, fn: gpointer, data: gpointer): gulong{.
    cdecl, dynlib: gobjectlib, importc: "g_signal_handler_find".}
proc g_signal_handlers_block_matched*(instance: gpointer,
                                      mask: TGSignalMatchType, signal_id: guint,
                                      detail: TGQuark, closure: PGClosure,
                                      fn: gpointer, data: gpointer): guint{.
    cdecl, dynlib: gobjectlib, importc: "g_signal_handlers_block_matched".}
proc g_signal_handlers_unblock_matched*(instance: gpointer,
                                        mask: TGSignalMatchType,
                                        signal_id: guint, detail: TGQuark,
                                        closure: PGClosure, fn: gpointer,
                                        data: gpointer): guint{.cdecl,
    dynlib: gobjectlib, importc: "g_signal_handlers_unblock_matched".}
proc g_signal_handlers_disconnect_matched*(instance: gpointer,
    mask: TGSignalMatchType, signal_id: guint, detail: TGQuark,
    closure: PGClosure, fn: gpointer, data: gpointer): guint{.cdecl,
    dynlib: gobjectlib, importc: "g_signal_handlers_disconnect_matched".}
proc g_signal_override_class_closure*(signal_id: guint, instance_type: GType,
                                      class_closure: PGClosure){.cdecl,
    dynlib: gobjectlib, importc: "g_signal_override_class_closure".}
proc signal_chain_from_overridden*(instance_and_params: PGValue,
                                     return_value: PGValue){.cdecl,
    dynlib: gobjectlib, importc: "g_signal_chain_from_overridden".}
proc g_signal_connect*(instance: gpointer, detailed_signal: cstring,
                       c_handler: TGCallback, data: gpointer): gulong
proc g_signal_connect_after*(instance: gpointer, detailed_signal: cstring,
                             c_handler: TGCallback, data: gpointer): gulong
proc g_signal_connect_swapped*(instance: gpointer, detailed_signal: cstring,
                               c_handler: TGCallback, data: gpointer): gulong
proc g_signal_handlers_disconnect_by_func*(instance: gpointer,
    fn, data: gpointer): guint
proc g_signal_handlers_block_by_func*(instance: gpointer, fn, data: gpointer)
proc g_signal_handlers_unblock_by_func*(instance: gpointer, fn, data: gpointer)
proc g_signal_handlers_destroy*(instance: gpointer){.cdecl, dynlib: gobjectlib,
    importc: "g_signal_handlers_destroy".}
proc g_signals_destroy*(itype: GType){.cdecl, dynlib: gobjectlib,
                                       importc: "`g_signals_destroy`".}
