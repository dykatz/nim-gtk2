# Included by headers/gtk2.nim; do not import directly.
proc TYPE_VBOX*(): GType
proc VBOX*(obj: pointer): PVBox
proc VBOX_CLASS*(klass: pointer): PVBoxClass
proc IS_VBOX*(obj: pointer): bool
proc IS_VBOX_CLASS*(klass: pointer): bool
proc VBOX_GET_CLASS*(obj: pointer): PVBoxClass
proc vbox_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_vbox_get_type".}
proc vbox_new*(homogeneous: gboolean, spacing: gint): PVBox{.cdecl, dynlib: lib,
    importc: "gtk_vbox_new".}
proc TYPE_COLOR_SELECTION*(): GType
