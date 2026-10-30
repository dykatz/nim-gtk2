# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ACCEL_GROUP*(): GType
proc ACCEL_GROUP*(anObject: pointer): PAccelGroup
proc ACCEL_GROUP_CLASS*(klass: pointer): PAccelGroupClass
proc IS_ACCEL_GROUP*(anObject: pointer): bool
proc IS_ACCEL_GROUP_CLASS*(klass: pointer): bool
proc ACCEL_GROUP_GET_CLASS*(obj: pointer): PAccelGroupClass
proc accel_flags*(a: PAccelKey): guint
proc set_accel_flags*(a: PAccelKey, `accel_flags`: guint)
proc accel_group_get_type*(): GType{.cdecl, dynlib: lib,
                                     importc: "gtk_accel_group_get_type".}
proc accel_group_new*(): PAccelGroup{.cdecl, dynlib: lib,
                                      importc: "gtk_accel_group_new".}
proc lock*(accel_group: PAccelGroup){.cdecl, dynlib: lib,
    importc: "gtk_accel_group_lock".}
proc unlock*(accel_group: PAccelGroup){.cdecl, dynlib: lib,
    importc: "gtk_accel_group_unlock".}
proc connect*(accel_group: PAccelGroup, accel_key: guint,
                          accel_mods: gdk2.TModifierType,
                          accel_flags: TAccelFlags, closure: PGClosure){.cdecl,
    dynlib: lib, importc: "gtk_accel_group_connect".}
proc connect_by_path*(accel_group: PAccelGroup, accel_path: cstring,
                                  closure: PGClosure){.cdecl, dynlib: lib,
    importc: "gtk_accel_group_connect_by_path".}
proc disconnect*(accel_group: PAccelGroup, closure: PGClosure): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_accel_group_disconnect".}
proc disconnect_key*(accel_group: PAccelGroup, accel_key: guint,
                                 accel_mods: gdk2.TModifierType): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_accel_group_disconnect_key".}
proc attach*(accel_group: PAccelGroup, anObject: PGObject){.cdecl,
    dynlib: lib, importc: "_gtk_accel_group_attach".}
proc detach*(accel_group: PAccelGroup, anObject: PGObject){.cdecl,
    dynlib: lib, importc: "_gtk_accel_group_detach".}
proc accel_groups_activate*(anObject: PGObject, accel_key: guint,
                            accel_mods: gdk2.TModifierType): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_accel_groups_activate".}
proc accel_groups_from_object*(anObject: PGObject): PGSList{.cdecl, dynlib: lib,
    importc: "gtk_accel_groups_from_object".}
proc find*(accel_group: PAccelGroup,
                       find_func: Taccel_group_find_func, data: gpointer): PAccelKey{.
    cdecl, dynlib: lib, importc: "gtk_accel_group_find".}
proc accel_group_from_accel_closure*(closure: PGClosure): PAccelGroup{.cdecl,
    dynlib: lib, importc: "gtk_accel_group_from_accel_closure".}
proc accelerator_valid*(keyval: guint, modifiers: gdk2.TModifierType): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_accelerator_valid".}
proc accelerator_parse*(accelerator: cstring, accelerator_key: Pguint,
                        accelerator_mods: gdk2.PModifierType){.cdecl, dynlib: lib,
    importc: "gtk_accelerator_parse".}
proc accelerator_name*(accelerator_key: guint,
                       accelerator_mods: gdk2.TModifierType): cstring{.cdecl,
    dynlib: lib, importc: "gtk_accelerator_name".}
proc accelerator_set_default_mod_mask*(default_mod_mask: gdk2.TModifierType){.
    cdecl, dynlib: lib, importc: "gtk_accelerator_set_default_mod_mask".}
proc accelerator_get_default_mod_mask*(): guint{.cdecl, dynlib: lib,
    importc: "gtk_accelerator_get_default_mod_mask".}
proc query*(accel_group: PAccelGroup, accel_key: guint,
                        accel_mods: gdk2.TModifierType, n_entries: Pguint): PAccelGroupEntry{.
    cdecl, dynlib: lib, importc: "gtk_accel_group_query".}
proc reconnect*(accel_group: PAccelGroup, accel_path_quark: TGQuark){.
    cdecl, dynlib: lib, importc: "_gtk_accel_group_reconnect".}
const
  bm_TGtkContainer_border_width* = 0x0000FFFF'u32
const
  bp_TGtkContainer_border_width* = 0'u32
const
  bm_TGtkContainer_need_resize* = 0x00010000'u32
const
  bp_TGtkContainer_need_resize* = 16'u32
const
  bm_TGtkContainer_resize_mode* = 0x00060000'u32
const
  bp_TGtkContainer_resize_mode* = 17'u32
const
  bm_TGtkContainer_reallocate_redraws* = 0x00080000'u32
const
  bp_TGtkContainer_reallocate_redraws* = 19'u32
const
  bm_TGtkContainer_has_focus_chain* = 0x00100000'u32
const
  bp_TGtkContainer_has_focus_chain* = 20'u32

