# Included by headers/glib2.nim; do not import directly.
type
  TGObject*{.pure, inheritable.} = object
    g_type_instance*: TGTypeInstance
    ref_count*: guint
    qdata*: PGData

  PGObject* = ptr TGObject
  TGObjectConstructParam*{.final.} = object
    pspec*: PGParamSpec
    value*: PGValue


  PGObjectConstructParam* = ptr TGObjectConstructParam
  TGObjectClass*{.pure, inheritable.} = object
    g_type_class*: TGTypeClass
    construct_properties*: PGSList
    constructor*: proc (theType: GType, n_construct_properties: guint,
                        construct_properties: PGObjectConstructParam): PGObject{.
        cdecl.}
    set_property*: proc (anObject: PGObject, property_id: guint, value: PGValue,
                         pspec: PGParamSpec){.cdecl.}
    get_property*: proc (anObject: PGObject, property_id: guint, value: PGValue,
                         pspec: PGParamSpec){.cdecl.}
    dispose*: proc (anObject: PGObject){.cdecl.}
    finalize*: proc (anObject: PGObject){.cdecl.}
    dispatch_properties_changed*: proc (anObject: PGObject, n_pspecs: guint,
                                        pspecs: PPGParamSpec){.cdecl.}
    notify*: proc (anObject: PGObject, pspec: PGParamSpec){.cdecl.}
    pdummy*: array[0..7, gpointer]

  PGObjectClass* = ptr TGObjectClass
