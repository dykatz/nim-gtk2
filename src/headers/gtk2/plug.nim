# Included by headers/gtk2.nim; do not import directly.
proc TYPE_PLUG*(): GType
proc PLUG*(obj: pointer): PPlug
proc PLUG_CLASS*(klass: pointer): PPlugClass
proc IS_PLUG*(obj: pointer): bool
proc IS_PLUG_CLASS*(klass: pointer): bool
proc PLUG_GET_CLASS*(obj: pointer): PPlugClass
proc same_app*(a: PPlug): guint
proc set_same_app*(a: PPlug, `same_app`: guint)
proc plug_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_plug_get_type".}
proc construct_for_display*(plug: PPlug, display: gdk2.PDisplay,
                                 socket_id: gdk2.TNativeWindow){.cdecl,
    dynlib: lib, importc: "gtk_plug_construct_for_display".}
proc plug_new_for_display*(display: gdk2.PDisplay, socket_id: gdk2.TNativeWindow): PPlug{.
    cdecl, dynlib: lib, importc: "gtk_plug_new_for_display".}
proc get_id*(plug: PPlug): gdk2.TNativeWindow{.cdecl, dynlib: lib,
    importc: "gtk_plug_get_id".}
proc add_to_socket*(plug: PPlug, socket: PSocket){.cdecl, dynlib: lib,
    importc: "_gtk_plug_add_to_socket".}
proc remove_from_socket*(plug: PPlug, socket: PSocket){.cdecl, dynlib: lib,
    importc: "_gtk_plug_remove_from_socket".}
const
  bm_TGtkProgressBar_activity_dir* = 0x0001'u16
const
  bp_TGtkProgressBar_activity_dir* = 0'u16

