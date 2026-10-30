# Included by headers/gtk2.nim; do not import directly.
proc TYPE_HBOX*(): GType
proc HBOX*(obj: pointer): PHBox
proc HBOX_CLASS*(klass: pointer): PHBoxClass
proc IS_HBOX*(obj: pointer): bool
proc IS_HBOX_CLASS*(klass: pointer): bool
proc HBOX_GET_CLASS*(obj: pointer): PHBoxClass
proc hbox_get_type*(): TType{.cdecl, dynlib: lib, importc: "gtk_hbox_get_type".}
proc hbox_new*(homogeneous: gboolean, spacing: gint): PHBox{.cdecl, dynlib: lib,
    importc: "gtk_hbox_new".}
