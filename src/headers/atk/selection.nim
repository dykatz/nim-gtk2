# Included by headers/atk.nim; do not import directly.
proc TYPE_SELECTION*(): GType
proc IS_SELECTION*(obj: pointer): bool
proc SELECTION*(obj: pointer): PSelection
proc SELECTION_GET_IFACE*(obj: pointer): PSelectionIface
proc selection_get_type*(): GType{.cdecl, dynlib: lib,
                                   importc: "atk_selection_get_type".}
proc add_selection*(selection: PSelection, i: gint): gboolean{.cdecl,
    dynlib: lib, importc: "atk_selection_add_selection".}
proc clear_selection*(selection: PSelection): gboolean{.cdecl,
    dynlib: lib, importc: "atk_selection_clear_selection".}
proc ref_selection*(selection: PSelection, i: gint): PObject{.cdecl,
    dynlib: lib, importc: "atk_selection_ref_selection".}
proc get_selection_count*(selection: PSelection): gint{.cdecl,
    dynlib: lib, importc: "atk_selection_get_selection_count".}
proc is_child_selected*(selection: PSelection, i: gint): gboolean{.
    cdecl, dynlib: lib, importc: "atk_selection_is_child_selected".}
proc remove_selection*(selection: PSelection, i: gint): gboolean{.
    cdecl, dynlib: lib, importc: "atk_selection_remove_selection".}
proc select_all_selection*(selection: PSelection): gboolean{.cdecl,
    dynlib: lib, importc: "atk_selection_select_all_selection".}
