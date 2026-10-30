# Included by headers/atk.nim; do not import directly.
proc TYPE_DOCUMENT*(): GType =
  result = document_get_type()

proc IS_DOCUMENT*(obj: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(obj, TYPE_DOCUMENT())

proc DOCUMENT*(obj: pointer): PDocument =
  result = cast[PDocument](G_TYPE_CHECK_INSTANCE_CAST(obj, TYPE_DOCUMENT()))

proc DOCUMENT_GET_IFACE*(obj: pointer): PDocumentIface =
  result = cast[PDocumentIface](G_TYPE_INSTANCE_GET_INTERFACE(obj,
      TYPE_DOCUMENT()))

