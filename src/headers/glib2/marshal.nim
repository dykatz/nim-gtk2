# Included by headers/glib2.nim; do not import directly.
proc cclosure_marshal_VOID_VOID*(closure: PGClosure, return_value: PGValue,
                                    n_param_values: guint,
                                    param_values: PGValue,
                                    invocation_hint: gpointer,
                                    marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__VOID".}
proc cclosure_marshal_VOID_BOOLEAN*(closure: PGClosure,
                                       return_value: PGValue,
                                       n_param_values: guint,
                                       param_values: PGValue,
                                       invocation_hint: gpointer,
                                       marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__BOOLEAN".}
proc cclosure_marshal_VOID_CHAR*(closure: PGClosure, return_value: PGValue,
                                    n_param_values: guint,
                                    param_values: PGValue,
                                    invocation_hint: gpointer,
                                    marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__CHAR".}
proc cclosure_marshal_VOID_UCHAR*(closure: PGClosure, return_value: PGValue,
                                     n_param_values: guint,
                                     param_values: PGValue,
                                     invocation_hint: gpointer,
                                     marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__UCHAR".}
proc cclosure_marshal_VOID_INT*(closure: PGClosure, return_value: PGValue,
                                   n_param_values: guint, param_values: PGValue,
                                   invocation_hint: gpointer,
                                   marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__INT".}
proc cclosure_marshal_VOID_UINT*(closure: PGClosure, return_value: PGValue,
                                    n_param_values: guint,
                                    param_values: PGValue,
                                    invocation_hint: gpointer,
                                    marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__UINT".}
proc cclosure_marshal_VOID_LONG*(closure: PGClosure, return_value: PGValue,
                                    n_param_values: guint,
                                    param_values: PGValue,
                                    invocation_hint: gpointer,
                                    marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__LONG".}
proc cclosure_marshal_VOID_ULONG*(closure: PGClosure, return_value: PGValue,
                                     n_param_values: guint,
                                     param_values: PGValue,
                                     invocation_hint: gpointer,
                                     marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__ULONG".}
proc cclosure_marshal_VOID_ENUM*(closure: PGClosure, return_value: PGValue,
                                    n_param_values: guint,
                                    param_values: PGValue,
                                    invocation_hint: gpointer,
                                    marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__ENUM".}
proc cclosure_marshal_VOID_FLAGS*(closure: PGClosure, return_value: PGValue,
                                     n_param_values: guint,
                                     param_values: PGValue,
                                     invocation_hint: gpointer,
                                     marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__FLAGS".}
proc cclosure_marshal_VOID_FLOAT*(closure: PGClosure, return_value: PGValue,
                                     n_param_values: guint,
                                     param_values: PGValue,
                                     invocation_hint: gpointer,
                                     marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__FLOAT".}
proc cclosure_marshal_VOID_DOUBLE*(closure: PGClosure, return_value: PGValue,
                                      n_param_values: guint,
                                      param_values: PGValue,
                                      invocation_hint: gpointer,
                                      marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__DOUBLE".}
proc cclosure_marshal_VOID_STRING*(closure: PGClosure, return_value: PGValue,
                                      n_param_values: guint,
                                      param_values: PGValue,
                                      invocation_hint: gpointer,
                                      marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__STRING".}
proc cclosure_marshal_VOID_PARAM*(closure: PGClosure, return_value: PGValue,
                                     n_param_values: guint,
                                     param_values: PGValue,
                                     invocation_hint: gpointer,
                                     marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__PARAM".}
proc cclosure_marshal_VOID_BOXED*(closure: PGClosure, return_value: PGValue,
                                     n_param_values: guint,
                                     param_values: PGValue,
                                     invocation_hint: gpointer,
                                     marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__BOXED".}
proc cclosure_marshal_VOID_POINTER*(closure: PGClosure,
                                       return_value: PGValue,
                                       n_param_values: guint,
                                       param_values: PGValue,
                                       invocation_hint: gpointer,
                                       marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__POINTER".}
proc cclosure_marshal_VOID_OBJECT*(closure: PGClosure, return_value: PGValue,
                                      n_param_values: guint,
                                      param_values: PGValue,
                                      invocation_hint: gpointer,
                                      marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__OBJECT".}
proc cclosure_marshal_STRING_OBJECT_POINTER*(closure: PGClosure,
    return_value: PGValue, n_param_values: guint, param_values: PGValue,
    invocation_hint: gpointer, marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_STRING__OBJECT_POINTER".}
proc cclosure_marshal_VOID_UINT_POINTER*(closure: PGClosure,
    return_value: PGValue, n_param_values: guint, param_values: PGValue,
    invocation_hint: gpointer, marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_VOID__UINT_POINTER".}
proc cclosure_marshal_BOOLEAN_FLAGS*(closure: PGClosure,
                                        return_value: PGValue,
                                        n_param_values: guint,
                                        param_values: PGValue,
                                        invocation_hint: gpointer,
                                        marshal_data: gpointer){.cdecl,
    dynlib: gobjectlib, importc: "g_cclosure_marshal_BOOLEAN__FLAGS".}
proc cclosure_marshal_BOOL_FLAGS*(closure: PGClosure, return_value: PGValue,
                                     n_param_values: guint,
                                     param_values: PGValue,
                                     invocation_hint: gpointer,
                                     marshal_data: gpointer){.cdecl,
    dynlib: gliblib, importc: "g_cclosure_marshal_BOOLEAN__FLAGS".}
proc GUINT16_SWAP_LE_BE_CONSTANT*(val: guint16): guint16 =
  result = ((val and 0x00FF'u16) shl 8'u16) or
      ((val and 0xFF00'u16) shr 8'u16)

proc GUINT32_SWAP_LE_BE_CONSTANT*(val: guint32): guint32 =
  result = ((val and 0x000000FF'u32) shl 24'u32) or
      ((val and 0x0000FF00'u32) shl 8'u32) or
      ((val and 0x00FF0000'u32) shr 8'u32) or
      ((val and 0xFF000000'u32) shr 24'u32)

proc GUINT_TO_POINTER*(i: guint): pointer =
  result = cast[pointer](uint(i))

