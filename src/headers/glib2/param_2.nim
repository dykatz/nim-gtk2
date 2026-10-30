# Included by headers/glib2.nim; do not import directly.
proc g_param_type_register_static*(name: cstring,
                                   pspec_info: PGParamSpecTypeInfo): GType{.
    cdecl, dynlib: gliblib, importc: "g_param_type_register_static".}
proc g_param_type_register_static_constant*(name: cstring,
    pspec_info: PGParamSpecTypeInfo, opt_type: GType): GType{.cdecl,
    dynlib: gliblib, importc: "`g_param_type_register_static_constant`".}
proc g_param_spec_internal*(param_type: GType, name: cstring, nick: cstring,
                            blurb: cstring, flags: TGParamFlags): gpointer{.
    cdecl, dynlib: gliblib, importc: "g_param_spec_internal".}
proc g_param_spec_pool_new*(type_prefixing: gboolean): PGParamSpecPool{.cdecl,
    dynlib: gliblib, importc: "g_param_spec_pool_new".}
proc spec_pool_insert*(pool: PGParamSpecPool, pspec: PGParamSpec,
                               owner_type: GType){.cdecl, dynlib: gliblib,
    importc: "g_param_spec_pool_insert".}
proc spec_pool_remove*(pool: PGParamSpecPool, pspec: PGParamSpec){.
    cdecl, dynlib: gliblib, importc: "g_param_spec_pool_remove".}
proc spec_pool_lookup*(pool: PGParamSpecPool, param_name: cstring,
                               owner_type: GType, walk_ancestors: gboolean): PGParamSpec{.
    cdecl, dynlib: gliblib, importc: "g_param_spec_pool_lookup".}
proc spec_pool_list_owned*(pool: PGParamSpecPool, owner_type: GType): PGList{.
    cdecl, dynlib: gliblib, importc: "g_param_spec_pool_list_owned".}
proc spec_pool_list*(pool: PGParamSpecPool, owner_type: GType,
                             n_pspecs_p: Pguint): PPGParamSpec{.cdecl,
    dynlib: gliblib, importc: "g_param_spec_pool_list".}
