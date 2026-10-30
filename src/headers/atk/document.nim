# Included by headers/atk.nim; do not import directly.
proc TYPE_DOCUMENT*(): GType
proc IS_DOCUMENT*(obj: pointer): bool
proc DOCUMENT*(obj: pointer): PDocument
proc DOCUMENT_GET_IFACE*(obj: pointer): PDocumentIface
proc document_get_type*(): GType{.cdecl, dynlib: lib,
                                  importc: "atk_document_get_type".}
proc get_document_type*(document: PDocument): cstring{.cdecl,
    dynlib: lib, importc: "atk_document_get_document_type".}
proc get_document*(document: PDocument): gpointer{.cdecl, dynlib: lib,
    importc: "atk_document_get_document".}
