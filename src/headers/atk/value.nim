# Included by headers/atk.nim; do not import directly.
proc TYPE_VALUE*(): GType
proc IS_VALUE*(obj: pointer): bool
proc VALUE*(obj: pointer): PValue
proc VALUE_GET_IFACE*(obj: pointer): PValueIface
proc value_get_type*(): GType{.cdecl, dynlib: lib, importc: "atk_value_get_type".}
proc get_current_value*(obj: PValue, value: PGValue){.cdecl, dynlib: lib,
    importc: "atk_value_get_current_value".}
proc get_maximum_value*(obj: PValue, value: PGValue){.cdecl, dynlib: lib,
    importc: "atk_value_get_maximum_value".}
proc get_minimum_value*(obj: PValue, value: PGValue){.cdecl, dynlib: lib,
    importc: "atk_value_get_minimum_value".}
proc set_current_value*(obj: PValue, value: PGValue): gboolean{.cdecl,
    dynlib: lib, importc: "atk_value_set_current_value".}
