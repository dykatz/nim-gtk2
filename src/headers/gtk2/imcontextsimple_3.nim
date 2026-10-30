# Included by headers/gtk2.nim; do not import directly.
proc TYPE_IM_CONTEXT_SIMPLE*(): GType =
  result = im_context_simple_get_type()

proc IM_CONTEXT_SIMPLE*(obj: pointer): PIMContextSimple =
  result = cast[PIMContextSimple](CHECK_CAST(obj, TYPE_IM_CONTEXT_SIMPLE()))

proc IM_CONTEXT_SIMPLE_CLASS*(klass: pointer): PIMContextSimpleClass =
  result = cast[PIMContextSimpleClass](CHECK_CLASS_CAST(klass,
      TYPE_IM_CONTEXT_SIMPLE()))

proc IS_IM_CONTEXT_SIMPLE*(obj: pointer): bool =
  result = CHECK_TYPE(obj, TYPE_IM_CONTEXT_SIMPLE())

proc IS_IM_CONTEXT_SIMPLE_CLASS*(klass: pointer): bool =
  result = CHECK_CLASS_TYPE(klass, TYPE_IM_CONTEXT_SIMPLE())

proc IM_CONTEXT_SIMPLE_GET_CLASS*(obj: pointer): PIMContextSimpleClass =
  result = cast[PIMContextSimpleClass](CHECK_GET_CLASS(obj,
      TYPE_IM_CONTEXT_SIMPLE()))

proc in_hex_sequence*(a: PIMContextSimple): guint =
  result = (a.IMContextSimpleflag0 and bm_TGtkIMContextSimple_in_hex_sequence) shr
      bp_TGtkIMContextSimple_in_hex_sequence

proc set_in_hex_sequence*(a: PIMContextSimple, `in_hex_sequence`: guint) =
  a.IMContextSimpleflag0 = a.IMContextSimpleflag0 or
      (uint16(`in_hex_sequence` shl bp_TGtkIMContextSimple_in_hex_sequence) and
      bm_TGtkIMContextSimple_in_hex_sequence)

