# Included by headers/gtk2.nim; do not import directly.
proc TYPE_SIZE_GROUP*(): GType
proc SIZE_GROUP*(obj: pointer): PSizeGroup
proc SIZE_GROUP_CLASS*(klass: pointer): PSizeGroupClass
proc IS_SIZE_GROUP*(obj: pointer): bool
proc IS_SIZE_GROUP_CLASS*(klass: pointer): bool
proc SIZE_GROUP_GET_CLASS*(obj: pointer): PSizeGroupClass
proc have_width*(a: PSizeGroup): guint
proc set_have_width*(a: PSizeGroup, `have_width`: guint)
proc have_height*(a: PSizeGroup): guint
proc set_have_height*(a: PSizeGroup, `have_height`: guint)
proc size_group_get_type*(): GType{.cdecl, dynlib: lib,
                                    importc: "gtk_size_group_get_type".}
proc size_group_new*(mode: TSizeGroupMode): PSizeGroup{.cdecl, dynlib: lib,
    importc: "gtk_size_group_new".}
proc set_mode*(size_group: PSizeGroup, mode: TSizeGroupMode){.cdecl,
    dynlib: lib, importc: "gtk_size_group_set_mode".}
proc get_mode*(size_group: PSizeGroup): TSizeGroupMode{.cdecl,
    dynlib: lib, importc: "gtk_size_group_get_mode".}
proc add_widget*(size_group: PSizeGroup, widget: PWidget){.cdecl,
    dynlib: lib, importc: "gtk_size_group_add_widget".}
proc remove_widget*(size_group: PSizeGroup, widget: PWidget){.cdecl,
    dynlib: lib, importc: "gtk_size_group_remove_widget".}
