# Included by headers/gtk2.nim; do not import directly.
proc TYPE_BIN*(): GType =
  result = bin_get_type()

proc BIN*(obj: pointer): PBin =
  result = cast[PBin](CHECK_CAST(obj, TYPE_BIN()))

proc BIN_CLASS*(klass: pointer): PBinClass =
  result = cast[PBinClass](CHECK_CLASS_CAST(klass, TYPE_BIN()))

proc IS_BIN*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_BIN())

proc IS_BIN_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_BIN())

proc BIN_GET_CLASS*(obj: pointer): PBinClass =
  result = cast[PBinClass](CHECK_GET_CLASS(obj, TYPE_BIN()))

