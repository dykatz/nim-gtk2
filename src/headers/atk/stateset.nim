# Included by headers/atk.nim; do not import directly.
proc TYPE_STATE_SET*(): GType
proc STATE_SET*(obj: pointer): PStateSet
proc STATE_SET_CLASS*(klass: pointer): PStateSetClass
proc IS_STATE_SET*(obj: pointer): bool
proc IS_STATE_SET_CLASS*(klass: pointer): bool
proc STATE_SET_GET_CLASS*(obj: pointer): PStateSetClass
proc state_set_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "atk_state_set_get_type".}
proc state_set_new*(): PStateSet{.cdecl, dynlib: lib,
                                  importc: "atk_state_set_new".}
proc is_empty*(StateSet: PStateSet): gboolean{.cdecl, dynlib: lib,
    importc: "atk_state_set_is_empty".}
proc add_state*(StateSet: PStateSet, `type`: TStateType): gboolean{.
    cdecl, dynlib: lib, importc: "atk_state_set_add_state".}
proc add_states*(StateSet: PStateSet, types: PStateType, n_types: gint){.
    cdecl, dynlib: lib, importc: "atk_state_set_add_states".}
proc clear_states*(StateSet: PStateSet){.cdecl, dynlib: lib,
    importc: "atk_state_set_clear_states".}
proc contains_state*(StateSet: PStateSet, `type`: TStateType): gboolean{.
    cdecl, dynlib: lib, importc: "atk_state_set_contains_state".}
proc contains_states*(StateSet: PStateSet, types: PStateType,
                                n_types: gint): gboolean{.cdecl, dynlib: lib,
    importc: "atk_state_set_contains_states".}
proc remove_state*(StateSet: PStateSet, `type`: TStateType): gboolean{.
    cdecl, dynlib: lib, importc: "atk_state_set_remove_state".}
proc and_sets*(StateSet: PStateSet, compare_set: PStateSet): PStateSet{.
    cdecl, dynlib: lib, importc: "atk_state_set_and_sets".}
proc or_sets*(StateSet: PStateSet, compare_set: PStateSet): PStateSet{.
    cdecl, dynlib: lib, importc: "atk_state_set_or_sets".}
proc xor_sets*(StateSet: PStateSet, compare_set: PStateSet): PStateSet{.
    cdecl, dynlib: lib, importc: "atk_state_set_xor_sets".}
