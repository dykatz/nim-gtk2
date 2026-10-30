# Included by headers/gtk2.nim; do not import directly.
proc entry_add*(binding_set: PBindingSet, keyval: guint,
                        modifiers: gdk2.TModifierType)
proc parsed*(a: PBindingSet): guint
proc set_parsed*(a: PBindingSet, `parsed`: guint)
proc destroyed*(a: PBindingEntry): guint
proc set_destroyed*(a: PBindingEntry, `destroyed`: guint)
proc in_emission*(a: PBindingEntry): guint
proc set_in_emission*(a: PBindingEntry, `in_emission`: guint)
proc binding_set_new*(set_name: cstring): PBindingSet{.cdecl, dynlib: lib,
    importc: "gtk_binding_set_new".}
proc binding_set_by_class*(object_class: gpointer): PBindingSet{.cdecl,
    dynlib: lib, importc: "gtk_binding_set_by_class".}
proc binding_set_find*(set_name: cstring): PBindingSet{.cdecl, dynlib: lib,
    importc: "gtk_binding_set_find".}
proc bindings_activate*(anObject: PObject, keyval: guint,
                        modifiers: gdk2.TModifierType): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_bindings_activate".}
proc activate*(binding_set: PBindingSet, keyval: guint,
                           modifiers: gdk2.TModifierType, anObject: PObject): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_binding_set_activate".}
proc entry_clear*(binding_set: PBindingSet, keyval: guint,
                          modifiers: gdk2.TModifierType){.cdecl, dynlib: lib,
    importc: "gtk_binding_entry_clear".}
proc add_path*(binding_set: PBindingSet, path_type: TPathType,
                           path_pattern: cstring, priority: TPathPriorityType){.
    cdecl, dynlib: lib, importc: "gtk_binding_set_add_path".}
proc entry_remove*(binding_set: PBindingSet, keyval: guint,
                           modifiers: gdk2.TModifierType){.cdecl, dynlib: lib,
    importc: "gtk_binding_entry_remove".}
proc entry_add_signall*(binding_set: PBindingSet, keyval: guint,
                                modifiers: gdk2.TModifierType,
                                signal_name: cstring, binding_args: PGSList){.
    cdecl, dynlib: lib, importc: "gtk_binding_entry_add_signall".}
proc binding_parse_binding*(scanner: PGScanner): guint{.cdecl, dynlib: lib,
    importc: "gtk_binding_parse_binding".}
