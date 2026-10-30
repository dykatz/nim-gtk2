# Included by headers/atk.nim; do not import directly.
proc TYPE_ACTION*(): GType
proc IS_ACTION*(obj: pointer): bool
proc ACTION*(obj: pointer): PAction
proc ACTION_GET_IFACE*(obj: pointer): PActionIface
proc action_get_type*(): GType{.cdecl, dynlib: lib,
                                importc: "atk_action_get_type".}
proc do_action*(action: PAction, i: gint): gboolean{.cdecl, dynlib: lib,
    importc: "atk_action_do_action".}
proc get_n_actions*(action: PAction): gint{.cdecl, dynlib: lib,
    importc: "atk_action_get_n_actions".}
proc get_description*(action: PAction, i: gint): cstring{.cdecl,
    dynlib: lib, importc: "atk_action_get_description".}
proc get_name*(action: PAction, i: gint): cstring{.cdecl, dynlib: lib,
    importc: "atk_action_get_name".}
proc get_keybinding*(action: PAction, i: gint): cstring{.cdecl,
    dynlib: lib, importc: "atk_action_get_keybinding".}
proc set_description*(action: PAction, i: gint, desc: cstring): gboolean{.
    cdecl, dynlib: lib, importc: "atk_action_set_description".}
