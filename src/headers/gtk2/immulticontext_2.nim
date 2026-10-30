# Included by headers/gtk2.nim; do not import directly.
proc TYPE_IM_MULTICONTEXT*(): GType =
  result = im_multicontext_get_type()

proc IM_MULTICONTEXT*(obj: pointer): PIMMulticontext =
  result = cast[PIMMulticontext](CHECK_CAST(obj, TYPE_IM_MULTICONTEXT()))

proc IM_MULTICONTEXT_CLASS*(klass: pointer): PIMMulticontextClass =
  result = cast[PIMMulticontextClass](CHECK_CLASS_CAST(klass,
      TYPE_IM_MULTICONTEXT()))

proc IS_IM_MULTICONTEXT*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_IM_MULTICONTEXT())

proc IS_IM_MULTICONTEXT_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_IM_MULTICONTEXT())

proc IM_MULTICONTEXT_GET_CLASS*(obj: pointer): PIMMulticontextClass =
  result = cast[PIMMulticontextClass](CHECK_GET_CLASS(obj,
      TYPE_IM_MULTICONTEXT()))

