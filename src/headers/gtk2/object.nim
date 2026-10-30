# Included by headers/gtk2.nim; do not import directly.
const
  IN_DESTRUCTION* = 1 shl 0
const
  FLOATING* = 1 shl 1
const
  RESERVED_1* = 1 shl 2
const
  RESERVED_2* = 1 shl 3
const
  ARG_READABLE* = G_PARAM_READABLE
const
  ARG_WRITABLE* = G_PARAM_WRITABLE
const
  ARG_CONSTRUCT* = G_PARAM_CONSTRUCT
const
  ARG_CONSTRUCT_ONLY* = G_PARAM_CONSTRUCT_ONLY
const
  ARG_CHILD_ARG* = 1 shl 4

proc TYPE_OBJECT*(): GType
proc `OBJECT`*(anObject: pointer): PObject
proc OBJECT_CLASS*(klass: pointer): PObjectClass
proc IS_OBJECT*(anObject: pointer): bool
proc IS_OBJECT_CLASS*(klass: pointer): bool
proc OBJECT_GET_CLASS*(anObject: pointer): PObjectClass
proc OBJECT_TYPE*(anObject: pointer): GType
proc OBJECT_TYPE_NAME*(anObject: pointer): cstring
proc OBJECT_FLAGS*(obj: pointer): guint32
proc OBJECT_FLOATING*(obj: pointer): gboolean
proc OBJECT_SET_FLAGS*(obj: pointer, flag: guint32)
proc OBJECT_UNSET_FLAGS*(obj: pointer, flag: guint32)
proc object_get_type*(): TType{.cdecl, dynlib: lib,
                                importc: "gtk_object_get_type".}
proc object_new*(thetype: TType, first_property_name: cstring): PObject{.cdecl,
    varargs, dynlib: lib, importc: "gtk_object_new".}
proc sink*(anObject: PObject){.cdecl, dynlib: lib,
                                      importc: "gtk_object_sink".}
proc destroy*(anObject: PObject){.cdecl, dynlib: lib,
    importc: "gtk_object_destroy".}
