# Included by headers/glib2.nim; do not import directly.
type
  TGParamSpec*{.final.} = object
    g_type_instance*: TGTypeInstance
    name*: cstring
    flags*: TGParamFlags
    value_type*: GType
    owner_type*: GType
    nick*: cstring
    blurb*: cstring
    qdata*: PGData
    ref_count*: guint
    param_id*: guint

  PGParamSpec* = ptr TGParamSpec
  PPGParamSpec* = ptr PGParamSpec
  TGParamSpecClass*{.final.} = object
    g_type_class*: TGTypeClass
    value_type*: GType
    finalize*: proc (pspec: PGParamSpec){.cdecl.}
    value_set_default*: proc (pspec: PGParamSpec, value: PGValue){.cdecl.}
    value_validate*: proc (pspec: PGParamSpec, value: PGValue): gboolean{.cdecl.}
    values_cmp*: proc (pspec: PGParamSpec, value1: PGValue, value2: PGValue): gint{.
        cdecl.}
    dummy*: array[0..3, gpointer]

  PGParamSpecClass* = ptr TGParamSpecClass
  TGParameter*{.final.} = object
    name*: cstring
    value*: TGValue

  PGParameter* = ptr TGParameter
