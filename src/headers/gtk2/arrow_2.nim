# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ARROW*(): GType =
  result = arrow_get_type()

proc ARROW*(obj: pointer): PArrow =
  result = cast[PArrow](CHECK_CAST(obj, TYPE_ARROW()))

proc ARROW_CLASS*(klass: pointer): PArrowClass =
  result = cast[PArrowClass](CHECK_CLASS_CAST(klass, TYPE_ARROW()))

proc IS_ARROW*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_ARROW())

proc IS_ARROW_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_ARROW())

proc ARROW_GET_CLASS*(obj: pointer): PArrowClass =
  result = cast[PArrowClass](CHECK_GET_CLASS(obj, TYPE_ARROW()))

