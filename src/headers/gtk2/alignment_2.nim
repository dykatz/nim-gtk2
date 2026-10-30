# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ALIGNMENT*(): GType =
  result = alignment_get_type()

proc ALIGNMENT*(obj: pointer): PAlignment =
  result = cast[PAlignment](CHECK_CAST(obj, TYPE_ALIGNMENT()))

proc ALIGNMENT_CLASS*(klass: pointer): PAlignmentClass =
  result = cast[PAlignmentClass](CHECK_CLASS_CAST(klass, TYPE_ALIGNMENT()))

proc IS_ALIGNMENT*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_ALIGNMENT())

proc IS_ALIGNMENT_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_ALIGNMENT())

proc ALIGNMENT_GET_CLASS*(obj: pointer): PAlignmentClass =
  result = cast[PAlignmentClass](CHECK_GET_CLASS(obj, TYPE_ALIGNMENT()))

