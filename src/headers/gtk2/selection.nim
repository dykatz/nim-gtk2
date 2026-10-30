# Included by headers/gtk2.nim; do not import directly.
proc list_new*(targets: PTargetEntry, ntargets: guint): PTargetList{.
    cdecl, dynlib: lib, importc: "gtk_target_list_new".}
proc reference*(list: PTargetList){.cdecl, dynlib: lib,
    importc: "gtk_target_list_ref".}
proc unref*(list: PTargetList){.cdecl, dynlib: lib,
    importc: "gtk_target_list_unref".}
proc add*(list: PTargetList, target: gdk2.TAtom, flags: guint,
                      info: guint){.cdecl, dynlib: lib,
                                    importc: "gtk_target_list_add".}
proc add_table*(list: PTargetList, targets: PTargetEntry,
                            ntargets: guint){.cdecl, dynlib: lib,
    importc: "gtk_target_list_add_table".}
proc remove*(list: PTargetList, target: gdk2.TAtom){.cdecl,
    dynlib: lib, importc: "gtk_target_list_remove".}
proc find*(list: PTargetList, target: gdk2.TAtom, info: Pguint): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_target_list_find".}
proc selection_owner_set*(widget: PWidget, selection: gdk2.TAtom, time: guint32): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_selection_owner_set".}
proc selection_owner_set_for_display*(display: gdk2.PDisplay, widget: PWidget,
                                      selection: gdk2.TAtom, time: guint32): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_selection_owner_set_for_display".}
proc selection_add_target*(widget: PWidget, selection: gdk2.TAtom,
                           target: gdk2.TAtom, info: guint){.cdecl, dynlib: lib,
    importc: "gtk_selection_add_target".}
proc selection_add_targets*(widget: PWidget, selection: gdk2.TAtom,
                            targets: PTargetEntry, ntargets: guint){.cdecl,
    dynlib: lib, importc: "gtk_selection_add_targets".}
proc selection_clear_targets*(widget: PWidget, selection: gdk2.TAtom){.cdecl,
    dynlib: lib, importc: "gtk_selection_clear_targets".}
proc selection_convert*(widget: PWidget, selection: gdk2.TAtom, target: gdk2.TAtom,
                        time: guint32): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_selection_convert".}
proc set*(selection_data: PSelectionData, thetype: gdk2.TAtom,
                         format: gint, data: Pguchar, length: gint){.cdecl,
    dynlib: lib, importc: "gtk_selection_data_set".}
proc set_text*(selection_data: PSelectionData, str: cstring,
                              len: gint): gboolean{.cdecl, dynlib: lib,
    importc: "gtk_selection_data_set_text".}
proc get_text*(selection_data: PSelectionData): Pguchar{.cdecl,
    dynlib: lib, importc: "gtk_selection_data_get_text".}
proc targets_include_text*(selection_data: PSelectionData): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_selection_data_targets_include_text".}
proc selection_remove_all*(widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_selection_remove_all".}
proc selection_clear*(widget: PWidget, event: gdk2.PEventSelection): gboolean{.
    cdecl, dynlib: lib, importc: "gtk_selection_clear".}
