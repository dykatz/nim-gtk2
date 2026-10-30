# Included by headers/glib2.nim; do not import directly.
proc G_PARAM_SPEC*(pspec: pointer): PGParamSpec =
  result = cast[PGParamSpec](G_TYPE_CHECK_INSTANCE_CAST(pspec, G_TYPE_PARAM))

proc G_IS_PARAM_SPEC*(pspec: pointer): bool =
  result = G_TYPE_CHECK_INSTANCE_TYPE(pspec, G_TYPE_PARAM)

proc G_PARAM_SPEC_CLASS*(pclass: pointer): PGParamSpecClass =
  result = cast[PGParamSpecClass](G_TYPE_CHECK_CLASS_CAST(pclass, G_TYPE_PARAM))

proc G_IS_PARAM_SPEC_CLASS*(pclass: pointer): bool =
  result = G_TYPE_CHECK_CLASS_TYPE(pclass, G_TYPE_PARAM)

proc G_PARAM_SPEC_GET_CLASS*(pspec: pointer): PGParamSpecClass =
  result = cast[PGParamSpecClass](G_TYPE_INSTANCE_GET_CLASS(pspec, G_TYPE_PARAM))

proc G_PARAM_SPEC_TYPE*(pspec: pointer): GType =
  result = G_TYPE_FROM_INSTANCE(pspec)

proc G_PARAM_SPEC_TYPE_NAME*(pspec: pointer): cstring =
  result = g_type_name(G_PARAM_SPEC_TYPE(pspec))

proc G_PARAM_SPEC_VALUE_TYPE*(pspec: pointer): GType =
  result = (G_PARAM_SPEC(pspec)).value_type

proc G_VALUE_HOLDS_PARAM*(value: pointer): bool =
  result = G_TYPE_CHECK_VALUE_TYPE(value, G_TYPE_PARAM)

proc G_CLOSURE_NEEDS_MARSHAL*(closure: pointer): bool =
  result = cast[PGClosure](closure).marshal == nil

