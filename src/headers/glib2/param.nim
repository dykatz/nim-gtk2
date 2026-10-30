# Included by headers/glib2.nim; do not import directly.
proc G_PARAM_SPEC*(pspec: pointer): PGParamSpec
proc G_IS_PARAM_SPEC*(pspec: pointer): bool
proc G_PARAM_SPEC_CLASS*(pclass: pointer): PGParamSpecClass
proc G_IS_PARAM_SPEC_CLASS*(pclass: pointer): bool
proc G_PARAM_SPEC_GET_CLASS*(pspec: pointer): PGParamSpecClass
proc G_PARAM_SPEC_TYPE*(pspec: pointer): GType
proc G_PARAM_SPEC_TYPE_NAME*(pspec: pointer): cstring
proc G_PARAM_SPEC_VALUE_TYPE*(pspec: pointer): GType
proc G_VALUE_HOLDS_PARAM*(value: pointer): bool
const
  G_PARAM_READABLE* = 1 shl 0
const
  G_PARAM_WRITABLE* = 1 shl 1
const
  G_PARAM_CONSTRUCT* = 1 shl 2
const
  G_PARAM_CONSTRUCT_ONLY* = 1 shl 3
const
  G_PARAM_LAX_VALIDATION* = 1 shl 4
const
  G_PARAM_PRIVATE* = 1 shl 5
const
  G_PARAM_READWRITE* = G_PARAM_READABLE or G_PARAM_WRITABLE
const
  G_PARAM_MASK* = 0x000000FF
const
  G_PARAM_USER_SHIFT* = 8

proc spec_ref*(pspec: PGParamSpec): PGParamSpec{.cdecl, dynlib: gliblib,
    importc: "g_param_spec_ref".}
proc spec_unref*(pspec: PGParamSpec){.cdecl, dynlib: gliblib,
    importc: "g_param_spec_unref".}
proc spec_sink*(pspec: PGParamSpec){.cdecl, dynlib: gliblib,
    importc: "g_param_spec_sink".}
proc spec_get_qdata*(pspec: PGParamSpec, quark: TGQuark): gpointer{.
    cdecl, dynlib: gliblib, importc: "g_param_spec_get_qdata".}
proc spec_set_qdata*(pspec: PGParamSpec, quark: TGQuark, data: gpointer){.
    cdecl, dynlib: gliblib, importc: "g_param_spec_set_qdata".}
proc spec_set_qdata_full*(pspec: PGParamSpec, quark: TGQuark,
                                  data: gpointer, destroy: TGDestroyNotify){.
    cdecl, dynlib: gliblib, importc: "g_param_spec_set_qdata_full".}
proc spec_steal_qdata*(pspec: PGParamSpec, quark: TGQuark): gpointer{.
    cdecl, dynlib: gliblib, importc: "g_param_spec_steal_qdata".}
proc value_set_default*(pspec: PGParamSpec, value: PGValue){.cdecl,
    dynlib: gliblib, importc: "g_param_value_set_default".}
proc value_defaults*(pspec: PGParamSpec, value: PGValue): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_param_value_defaults".}
proc value_validate*(pspec: PGParamSpec, value: PGValue): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_param_value_validate".}
proc value_convert*(pspec: PGParamSpec, src_value: PGValue,
                            dest_value: PGValue, strict_validation: gboolean): gboolean{.
    cdecl, dynlib: gliblib, importc: "g_param_value_convert".}
proc values_cmp*(pspec: PGParamSpec, value1: PGValue, value2: PGValue): gint{.
    cdecl, dynlib: gliblib, importc: "g_param_values_cmp".}
proc spec_get_name*(pspec: PGParamSpec): cstring{.cdecl,
    dynlib: gliblib, importc: "g_param_spec_get_name".}
proc spec_get_nick*(pspec: PGParamSpec): cstring{.cdecl,
    dynlib: gliblib, importc: "g_param_spec_get_nick".}
proc spec_get_blurb*(pspec: PGParamSpec): cstring{.cdecl,
    dynlib: gliblib, importc: "g_param_spec_get_blurb".}
proc set_param*(value: PGValue, param: PGParamSpec){.cdecl,
    dynlib: gliblib, importc: "g_value_set_param".}
proc get_param*(value: PGValue): PGParamSpec{.cdecl, dynlib: gliblib,
    importc: "g_value_get_param".}
proc dup_param*(value: PGValue): PGParamSpec{.cdecl, dynlib: gliblib,
    importc: "g_value_dup_param".}
proc set_param_take_ownership*(value: PGValue, param: PGParamSpec){.
    cdecl, dynlib: gliblib, importc: "g_value_set_param_take_ownership".}
