# Included by headers/gtk2.nim; do not import directly.
proc TYPE_ACCEL_LABEL*(): GType
proc ACCEL_LABEL*(obj: pointer): PAccelLabel
proc ACCEL_LABEL_CLASS*(klass: pointer): PAccelLabelClass
proc IS_ACCEL_LABEL*(obj: pointer): bool
proc IS_ACCEL_LABEL_CLASS*(klass: pointer): bool
proc ACCEL_LABEL_GET_CLASS*(obj: pointer): PAccelLabelClass
proc latin1_to_char*(a: PAccelLabelClass): guint
proc set_latin1_to_char*(a: PAccelLabelClass, `latin1_to_char`: guint)
proc accel_label_get_type*(): TType{.cdecl, dynlib: lib,
                                     importc: "gtk_accel_label_get_type".}
proc accel_label_new*(`string`: cstring): PAccelLabel{.cdecl, dynlib: lib,
    importc: "gtk_accel_label_new".}
proc get_accel_widget*(accel_label: PAccelLabel): PWidget{.cdecl,
    dynlib: lib, importc: "gtk_accel_label_get_accel_widget".}
proc get_accel_width*(accel_label: PAccelLabel): guint{.cdecl,
    dynlib: lib, importc: "gtk_accel_label_get_accel_width".}
proc set_accel_widget*(accel_label: PAccelLabel,
                                   accel_widget: PWidget){.cdecl, dynlib: lib,
    importc: "gtk_accel_label_set_accel_widget".}
proc set_accel_closure*(accel_label: PAccelLabel,
                                    accel_closure: PGClosure){.cdecl,
    dynlib: lib, importc: "gtk_accel_label_set_accel_closure".}
proc refetch*(accel_label: PAccelLabel): gboolean{.cdecl,
    dynlib: lib, importc: "gtk_accel_label_refetch".}
