# Included by headers/pango.nim; do not import directly.
proc get_log_attrs*(text: cstring, length: int32, level: int32,
                    language: PLanguage, log_attrs: PLogAttr, attrs_len: int32){.
    cdecl, dynlib: lib, importc: "pango_get_log_attrs".}
proc TYPE_CONTEXT*(): GType
