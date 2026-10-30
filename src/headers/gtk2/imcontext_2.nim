# Included by headers/gtk2.nim; do not import directly.
proc TYPE_IM_CONTEXT*(): GType =
  result = im_context_get_type()

proc IM_CONTEXT*(obj: pointer): PIMContext =
  result = cast[PIMContext](CHECK_CAST(obj, TYPE_IM_CONTEXT()))

proc IM_CONTEXT_CLASS*(klass: pointer): PIMContextClass =
  result = cast[PIMContextClass](CHECK_CLASS_CAST(klass, TYPE_IM_CONTEXT()))

proc IS_IM_CONTEXT*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_IM_CONTEXT())

proc IS_IM_CONTEXT_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_IM_CONTEXT())

proc IM_CONTEXT_GET_CLASS*(obj: pointer): PIMContextClass =
  result = cast[PIMContextClass](CHECK_GET_CLASS(obj, TYPE_IM_CONTEXT()))

