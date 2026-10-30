# Included by headers/glib2.nim; do not import directly.
type
  TGTypeValueTable*{.final.} = object
    value_init*: proc (value: PGValue){.cdecl.}
    value_free*: proc (value: PGValue){.cdecl.}
    value_copy*: proc (src_value: PGValue, dest_value: PGValue){.cdecl.}
    value_peek_pointer*: proc (value: PGValue): gpointer{.cdecl.}
    collect_format*: cstring
    collect_value*: proc (value: PGValue, n_collect_values: guint,
                          collect_values: PGTypeCValue, collect_flags: guint): cstring{.
        cdecl.}
    lcopy_format*: cstring
    lcopy_value*: proc (value: PGValue, n_collect_values: guint,
                        collect_values: PGTypeCValue, collect_flags: guint): cstring{.
        cdecl.}

  PGTypeValueTable* = ptr TGTypeValueTable
  TGTypeInfo*{.final.} = object
    class_size*: guint16
    base_init*: TGBaseInitFunc
    base_finalize*: TGBaseFinalizeFunc
    class_init*: TGClassInitFunc
    class_finalize*: TGClassFinalizeFunc
    class_data*: gconstpointer
    instance_size*: guint16
    n_preallocs*: guint16
    instance_init*: TGInstanceInitFunc
    value_table*: PGTypeValueTable

  PGTypeInfo* = ptr TGTypeInfo
  TGTypeFundamentalInfo*{.final.} = object
    type_flags*: TGTypeFundamentalFlags

  PGTypeFundamentalInfo* = ptr TGTypeFundamentalInfo
  TGInterfaceInfo*{.final.} = object
    interface_init*: TGInterfaceInitFunc
    interface_finalize*: TGInterfaceFinalizeFunc
    interface_data*: gpointer


  PGInterfaceInfo* = ptr TGInterfaceInfo
