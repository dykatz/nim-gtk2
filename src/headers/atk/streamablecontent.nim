# Included by headers/atk.nim; do not import directly.
proc TYPE_STREAMABLE_CONTENT*(): GType
proc IS_STREAMABLE_CONTENT*(obj: pointer): bool
proc STREAMABLE_CONTENT*(obj: pointer): PStreamableContent
proc STREAMABLE_CONTENT_GET_IFACE*(obj: pointer): PStreamableContentIface
proc streamable_content_get_type*(): GType{.cdecl, dynlib: lib,
    importc: "atk_streamable_content_get_type".}
proc get_n_mime_types*(streamable: PStreamableContent): gint{.
    cdecl, dynlib: lib, importc: "atk_streamable_content_get_n_mime_types".}
proc get_mime_type*(streamable: PStreamableContent, i: gint): cstring{.
    cdecl, dynlib: lib, importc: "atk_streamable_content_get_mime_type".}
proc get_stream*(streamable: PStreamableContent,
                                    mime_type: cstring): PGIOChannel{.cdecl,
    dynlib: lib, importc: "atk_streamable_content_get_stream".}
