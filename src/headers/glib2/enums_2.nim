# Included by headers/glib2.nim; do not import directly.
proc G_ENUM_CLASS*(class: pointer): PGEnumClass
proc G_IS_ENUM_CLASS*(class: pointer): gboolean
proc G_ENUM_CLASS_TYPE*(class: pointer): GType
proc G_ENUM_CLASS_TYPE_NAME*(class: pointer): cstring
proc G_TYPE_IS_FLAGS*(theType: GType): gboolean
proc G_FLAGS_CLASS*(class: pointer): PGFlagsClass
proc G_IS_FLAGS_CLASS*(class: pointer): gboolean
proc G_FLAGS_CLASS_TYPE*(class: pointer): GType
proc G_FLAGS_CLASS_TYPE_NAME*(class: pointer): cstring
proc G_VALUE_HOLDS_ENUM*(value: pointer): gboolean
proc G_VALUE_HOLDS_FLAGS*(value: pointer): gboolean
proc get_value*(enum_class: PGEnumClass, value: gint): PGEnumValue{.
    cdecl, dynlib: gliblib, importc: "g_enum_get_value".}
proc get_value_by_name*(enum_class: PGEnumClass, name: cstring): PGEnumValue{.
    cdecl, dynlib: gliblib, importc: "g_enum_get_value_by_name".}
proc get_value_by_nick*(enum_class: PGEnumClass, nick: cstring): PGEnumValue{.
    cdecl, dynlib: gliblib, importc: "g_enum_get_value_by_nick".}
proc get_first_value*(flags_class: PGFlagsClass, value: guint): PGFlagsValue{.
    cdecl, dynlib: gliblib, importc: "g_flags_get_first_value".}
proc get_value_by_name*(flags_class: PGFlagsClass, name: cstring): PGFlagsValue{.
    cdecl, dynlib: gliblib, importc: "g_flags_get_value_by_name".}
proc get_value_by_nick*(flags_class: PGFlagsClass, nick: cstring): PGFlagsValue{.
    cdecl, dynlib: gliblib, importc: "g_flags_get_value_by_nick".}
proc set_enum*(value: PGValue, v_enum: gint){.cdecl, dynlib: gobjectlib,
    importc: "g_value_set_enum".}
proc get_enum*(value: PGValue): gint{.cdecl, dynlib: gobjectlib,
    importc: "g_value_get_enum".}
proc set_flags*(value: PGValue, v_flags: guint){.cdecl, dynlib: gliblib,
    importc: "g_value_set_flags".}
proc get_flags*(value: PGValue): guint{.cdecl, dynlib: gliblib,
    importc: "g_value_get_flags".}
proc g_enum_register_static*(name: cstring, const_static_values: PGEnumValue): GType{.
    cdecl, dynlib: gliblib, importc: "g_enum_register_static".}
proc g_flags_register_static*(name: cstring, const_static_values: PGFlagsValue): GType{.
    cdecl, dynlib: gliblib, importc: "g_flags_register_static".}
proc g_enum_complete_type_info*(g_enum_type: GType, info: PGTypeInfo,
                                const_values: PGEnumValue){.cdecl,
    dynlib: gliblib, importc: "g_enum_complete_type_info".}
proc g_flags_complete_type_info*(g_flags_type: GType, info: PGTypeInfo,
                                 const_values: PGFlagsValue){.cdecl,
    dynlib: gliblib, importc: "g_flags_complete_type_info".}
const
  G_MINFLOAT* = 0.00000
const
  G_MAXFLOAT* = 1.70000e+308
const
  G_MINDOUBLE* = G_MINFLOAT
const
  G_MAXDOUBLE* = G_MAXFLOAT
const
  G_MAXSHORT* = 32767
const
  G_MINSHORT* = - G_MAXSHORT - 1
const
  G_MAXUSHORT* = 2 * G_MAXSHORT + 1
const
  G_MAXINT* = 2147483647
const
  G_MININT* = - G_MAXINT - 1
const
  G_MAXUINT* = - 1
const
  G_MINLONG* = G_MININT
const
  G_MAXLONG* = G_MAXINT
const
  G_MAXULONG* = G_MAXUINT
const
  G_MAXINT64* = high(int64)
const
  G_MININT64* = low(int64)

const
  G_GINT16_FORMAT* = "hi"
const
  G_GUINT16_FORMAT* = "hu"
const
  G_GINT32_FORMAT* = 'i'
const
  G_GUINT32_FORMAT* = 'u'
const
  G_HAVE_GINT64* = 1
const
  G_GINT64_FORMAT* = "I64i"
const
  G_GUINT64_FORMAT* = "I64u"
const
  GLIB_SIZEOF_VOID_P* = sizeof(pointer)
const
  GLIB_SIZEOF_LONG* = sizeof(int32)
const
  GLIB_SIZEOF_SIZE_T* = sizeof(int32)

