# Included by headers/glib2.nim; do not import directly.
proc TGHookList_hook_size*(a: PGHookList): guint
proc TGHookList_set_hook_size*(a: PGHookList, `hook_size`: guint)
proc TGHookList_is_setup*(a: PGHookList): guint
proc TGHookList_set_is_setup*(a: PGHookList, `is_setup`: guint)
proc G_HOOK*(hook: pointer): PGHook
proc FLAGS*(hook: PGHook): guint
proc ACTIVE*(hook: PGHook): bool
proc IN_CALL*(hook: PGHook): bool
proc IS_VALID*(hook: PGHook): bool
proc IS_UNLINKED*(hook: PGHook): bool
proc list_init*(hook_list: PGHookList, hook_size: guint){.cdecl,
    dynlib: gliblib, importc: "g_hook_list_init".}
proc list_clear*(hook_list: PGHookList){.cdecl, dynlib: gliblib,
    importc: "g_hook_list_clear".}
proc alloc*(hook_list: PGHookList): PGHook{.cdecl, dynlib: gliblib,
    importc: "g_hook_alloc".}
proc free*(hook_list: PGHookList, hook: PGHook){.cdecl, dynlib: gliblib,
    importc: "g_hook_free".}
proc reference*(hook_list: PGHookList, hook: PGHook){.cdecl, dynlib: gliblib,
    importc: "g_hook_ref".}
proc unref*(hook_list: PGHookList, hook: PGHook){.cdecl, dynlib: gliblib,
    importc: "g_hook_unref".}
proc destroy*(hook_list: PGHookList, hook_id: gulong): gboolean{.cdecl,
    dynlib: gliblib, importc: "g_hook_destroy".}
proc destroy_link*(hook_list: PGHookList, hook: PGHook){.cdecl,
    dynlib: gliblib, importc: "g_hook_destroy_link".}
proc prepend*(hook_list: PGHookList, hook: PGHook){.cdecl,
    dynlib: gliblib, importc: "g_hook_prepend".}
proc insert_before*(hook_list: PGHookList, sibling: PGHook, hook: PGHook){.
    cdecl, dynlib: gliblib, importc: "g_hook_insert_before".}
proc insert_sorted*(hook_list: PGHookList, hook: PGHook,
                           fn: TGHookCompareFunc){.cdecl, dynlib: gliblib,
    importc: "g_hook_insert_sorted".}
proc get*(hook_list: PGHookList, hook_id: gulong): PGHook{.cdecl,
    dynlib: gliblib, importc: "g_hook_get".}
proc find*(hook_list: PGHookList, need_valids: gboolean,
                  fn: TGHookFindFunc, data: gpointer): PGHook{.cdecl,
    dynlib: gliblib, importc: "g_hook_find".}
proc find_data*(hook_list: PGHookList, need_valids: gboolean,
                       data: gpointer): PGHook{.cdecl, dynlib: gliblib,
    importc: "g_hook_find_data".}
proc find_func*(hook_list: PGHookList, need_valids: gboolean,
                       fn: gpointer): PGHook{.cdecl, dynlib: gliblib,
    importc: "g_hook_find_func".}
proc find_func_data*(hook_list: PGHookList, need_valids: gboolean,
                            fn: gpointer, data: gpointer): PGHook{.cdecl,
    dynlib: gliblib, importc: "g_hook_find_func_data".}
proc first_valid*(hook_list: PGHookList, may_be_in_call: gboolean): PGHook{.
    cdecl, dynlib: gliblib, importc: "g_hook_first_valid".}
proc next_valid*(hook_list: PGHookList, hook: PGHook,
                        may_be_in_call: gboolean): PGHook{.cdecl,
    dynlib: gliblib, importc: "g_hook_next_valid".}
proc compare_ids*(new_hook: PGHook, sibling: PGHook): gint{.cdecl,
    dynlib: gliblib, importc: "g_hook_compare_ids".}
proc append*(hook_list: PGHookList, hook: PGHook)
proc list_invoke_check*(hook_list: PGHookList, may_recurse: gboolean){.
    cdecl, dynlib: gliblib, importc: "g_hook_list_invoke_check".}
proc list_marshal*(hook_list: PGHookList, may_recurse: gboolean,
                          marshaller: TGHookMarshaller, marshal_data: gpointer){.
    cdecl, dynlib: gliblib, importc: "g_hook_list_marshal".}
proc list_marshal_check*(hook_list: PGHookList, may_recurse: gboolean,
                                marshaller: TGHookCheckMarshaller,
                                marshal_data: gpointer){.cdecl, dynlib: gliblib,
    importc: "g_hook_list_marshal_check".}
