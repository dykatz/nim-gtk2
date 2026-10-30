# Included by headers/glib2.nim; do not import directly.
type
  TGParamSpecTypeInfo*{.final.} = object
    instance_size*: guint16
    n_preallocs*: guint16
    instance_init*: proc (pspec: PGParamSpec){.cdecl.}
    value_type*: GType
    finalize*: proc (pspec: PGParamSpec){.cdecl.}
    value_set_default*: proc (pspec: PGParamSpec, value: PGValue){.cdecl.}
    value_validate*: proc (pspec: PGParamSpec, value: PGValue): gboolean{.cdecl.}
    values_cmp*: proc (pspec: PGParamSpec, value1: PGValue, value2: PGValue): gint{.
        cdecl.}


  PGParamSpecTypeInfo* = ptr TGParamSpecTypeInfo
