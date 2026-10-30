# Included by headers/atk.nim; do not import directly.
proc state_type_register*(name: cstring): TStateType{.cdecl, dynlib: lib,
    importc: "atk_state_type_register".}
proc state_type_get_name*(`type`: TStateType): cstring{.cdecl, dynlib: lib,
    importc: "atk_state_type_get_name".}
proc state_type_for_name*(name: cstring): TStateType{.cdecl, dynlib: lib,
    importc: "atk_state_type_for_name".}
